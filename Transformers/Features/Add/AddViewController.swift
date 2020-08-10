//
//  AddViewController.swift
//  Transformers
//
//  Created by Suneeth on 8/7/20.
//  Copyright © 2020 Suneeth. All rights reserved.
//

import UIKit

class AddViewController: BaseViewController {
    @IBOutlet weak var mainTableView: UITableView!
    
    // MARK: - Parameters
    var viewModel: AddViewModel? {
        didSet {
            configureView(with: viewModel)
            bindViewModel()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = viewModel?.screenName
        bindAlertModel()
        registerCells()
        addTapGesture()
    }
    @objc func closeKeyboard() {
        view.endEditing(true)
    }
    @objc func createButtonClicked() {
        closeKeyboard()
        viewModel?.createTransformer()
    }
    // MARK: - Private Methods
    private func registerCells() {
        let textNib = UINib.init(nibName: "TextFieldTableViewCell", bundle: nil)
        mainTableView.register(textNib, forCellReuseIdentifier: viewModel?.cellIdentifier ?? "")
        mainTableView.register(UINib(nibName: "CustomFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: CustomFooterView.reuseIdentifier)
    }
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
}
// MARK: - Bind ViewModel
extension AddViewController {
        private func bindViewModel() {
            viewModel?.didItemCreate.bind{[weak self]  in
                guard $0 else { return }
                DispatchQueue.main.async {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
        private func bindAlertModel() {
            viewModel?.alertModel.bindAndFire({ [weak self] alertModel in
                guard let alertModel = alertModel else { return }
                DispatchQueue.main.async {
                    self?.present(alertModel: alertModel, presentationState: self?.viewModel?.errorAlertPresentation)
                }
            })
        }
}
// MARK: - UITableViewDelegate, UITableViewDataSource methods
extension AddViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSections ?? 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows() ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(viewModel?.rowHeight ?? 44.0)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TextFieldTableViewCell? = tableView.dequeueReusableCell(withIdentifier: viewModel?.cellIdentifier ?? "") as? TextFieldTableViewCell
        cell?.cellViewModel = viewModel?.getCellViewModel(row: indexPath.row)
        
        switch viewModel?.getFieldType(row: indexPath.row) ?? .text {
            case .text:
                cell?.textField.delegate = self
                cell?.textField.tag = indexPath.row
            case .picker:
                cell?.picker.delegate = self
                cell?.picker.tag = indexPath.row
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(viewModel?.sectionFooterViewHeight ?? 0.01)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(viewModel?.sectionHeaderViewHeight ?? 0.01)
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: Double(tableView.frame.width), height: viewModel?.sectionHeaderViewHeight ?? 0.0))
        
        // section name
        let sectionNameLabel = UILabel(frame: CGRect(x: 20.0, y: 0.0, width: 300.0, height: viewModel?.sectionHeaderViewHeight ?? 0.0))
        sectionNameLabel.text = viewModel?.sectionName
        sectionNameLabel.textColor = .black
        sectionNameLabel.textAlignment = .left
        sectionNameLabel.font = .boldSystemFont(ofSize: 18.0)
        headerView.addSubview(sectionNameLabel)
        return headerView
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomFooterView") as! CustomFooterView
        footerView.customButton.setTitle("Create", for: .normal)
        footerView.delegate = self
        return footerView
    }
}
extension AddViewController: CustomHeaderDelegate {
    func buttonTapped() {
        viewModel?.createTransformer()
    }
}
// MARK: - UITextFieldDelegate methods
extension AddViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        viewModel?.saveEditedField(with: textField.tag, value: textField.text ?? "")
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= textFieldMaxLength
    }
}
// MARK: - UIPickerViewDelegate methods
extension AddViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return viewModel?.numberOfPickerComponents ?? 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel?.numberOfPickerItems(for: pickerView.tag) ?? 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel?.pickerText(for: pickerView.tag, row: row)
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return CGFloat(viewModel?.pickerRowHeight ?? 44.0)
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel?.saveEditedField(with: pickerView.tag, value: viewModel?.pickerText(for: pickerView.tag, row: row) ?? "")
        view.endEditing(true)
        DispatchQueue.main.async { [weak self] in
            self?.mainTableView.reloadData()
        }
    }
}
