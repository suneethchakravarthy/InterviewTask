//
//  ViewDetailsViewController.swift
//  Transformers
//
//  Created by Suneeth on 8/7/20.
//  Copyright © 2020 Suneeth. All rights reserved.
//

import UIKit

class ViewDetailsViewController: BaseViewController {
    @IBOutlet weak var mainTableView: UITableView!
    var rightHamburgerButton: UIBarButtonItem?
    // MARK: - Parameters
    var viewModel: ViewDetailsViewModel? {
        didSet {
            configureView(with: viewModel)
            bindViewModel()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = viewModel?.screenName
        registerCells()
        addRightNavigationBarButton()
    }
    // MARK: - Private Methods
    private func registerCells() {
        let textNib = UINib.init(nibName: "DetailTextTableViewCell", bundle: nil)
        mainTableView.register(textNib, forCellReuseIdentifier: viewModel?.cellIdentifier ?? "")
    }
    private func addRightNavigationBarButton() {
        if rightHamburgerButton == nil {
            rightHamburgerButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editButtonClicked))
            rightHamburgerButton?.tintColor = UIColor.navigationBarbuttonTextColor
            rightHamburgerButton?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.navigationBarbuttonFont], for: .normal)
        }
        navigationItem.rightBarButtonItem = rightHamburgerButton
    }
    @objc private func editButtonClicked() {
        viewModel?.goToEditScreen()
    }
}
extension ViewDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSections ?? 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(viewModel?.sectionHeaderViewHeight ?? 0.01)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(viewModel?.rowHeight ?? 44.0)
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
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(viewModel?.sectionFooterViewHeight ?? 0.01)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows() ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:DetailTextTableViewCell? = tableView.dequeueReusableCell(withIdentifier: viewModel?.cellIdentifier ?? "") as? DetailTextTableViewCell
        cell?.cellViewModel = viewModel?.getCellViewModel(row: indexPath.row)
        return cell!
    }
}
    // MARK: - Bind ViewModel
extension ViewDetailsViewController {
        private func bindViewModel() {
            viewModel?.didItemsLoad.bind{[weak self]  in
                guard $0 else { return }
                DispatchQueue.main.async { [weak self] in
                    if let tableView = self?.mainTableView {
                        tableView.reloadData()
                    }
                }
            }
        }
}
