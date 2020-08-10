//
//  HomeViewController.swift
//  Transformers
//
//  Created by Suneeth on 8/6/20.
//  Copyright © 2020 Suneeth. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var mainTableView: UITableView!
    var leftHamburgerButton: UIBarButtonItem?
    var rightHamburgerButton: UIBarButtonItem?
    // MARK: - Parameters
    var viewModel: HomeViewModel? {
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
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addLeftNavigationBarButton()
        addRightNavigationBarButton()
        viewModel?.fetchTokenIfNeeded()
    }
    // MARK: - Private Methods
    private func registerCells() {
        let textNib = UINib.init(nibName: "DetailTextTableViewCell", bundle: nil)
        mainTableView.register(textNib, forCellReuseIdentifier: viewModel?.cellIdentifier ?? "")
    }
    private func addRightNavigationBarButton() {
        if rightHamburgerButton == nil {
            rightHamburgerButton = UIBarButtonItem(title: "New", style: .plain, target: self, action: #selector(addButtonClicked))
            rightHamburgerButton?.tintColor = UIColor.navigationBarbuttonTextColor
            rightHamburgerButton?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.navigationBarbuttonFont], for: .normal)
        }
        navigationItem.rightBarButtonItem = rightHamburgerButton
    }
    private func addLeftNavigationBarButton() {
        if leftHamburgerButton == nil {
            leftHamburgerButton = UIBarButtonItem(title: "War", style: .plain, target: self, action: #selector(warButtonClicked))
            leftHamburgerButton?.tintColor = UIColor.navigationBarbuttonTextColor
            leftHamburgerButton?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.navigationBarbuttonFont], for: .normal)
        }
        navigationItem.leftBarButtonItem = leftHamburgerButton
    }
}
extension HomeViewController {
    @objc private func warButtonClicked() {
        viewModel?.goToWarScreen()
    }
    @objc private func addButtonClicked() {
        viewModel?.goToAddScreen()
    }
}
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSections() ?? 0
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(viewModel?.sectionHeaderViewHeight ?? 0.01)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(viewModel?.rowHeight ?? 44.0)
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: Double(tableView.frame.width), height: viewModel?.sectionHeaderViewHeight ?? 0.0))
        
        // team icon image
        let iconHeightWidth = (viewModel?.sectionHeaderViewHeight ?? 0.0) - 20.0
        let teamIcon = UIImageView(frame: CGRect(x: 20.0, y: 10.0, width: iconHeightWidth, height: iconHeightWidth))
        if let viewModel = viewModel {
            if let url = URL(string: viewModel.getSectionImageName(for: section)) { teamIcon.load(url: url) }
        }
        headerView.addSubview(teamIcon)
        
        // team name
        let teamNameLabel = UILabel(frame: CGRect(x: Double(teamIcon.frame.maxX + 20.0), y: 0.0, width: 300.0, height: viewModel?.sectionHeaderViewHeight ?? 0.0))
        teamNameLabel.text = viewModel?.getSectionName(for: section)
        teamNameLabel.textColor = .black
        teamNameLabel.textAlignment = .left
        teamNameLabel.font = .boldSystemFont(ofSize: 18.0)
        headerView.addSubview(teamNameLabel)
        return headerView
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel?.delete(indexPath: indexPath, completion: { [weak self] in
                DispatchQueue.main.async {
                self?.viewModel?.transformersArray[indexPath.section].remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    if self?.viewModel?.transformersArray[indexPath.section].count == 0 {
                        self?.viewModel?.transformersArray.remove(at: indexPath.section)
                        let indices: IndexSet = [indexPath.section]
                            tableView.deleteSections(indices, with: .automatic)
                    }
                }
            })
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(viewModel?.sectionFooterViewHeight ?? 0.01)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows(for: section) ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:DetailTextTableViewCell? = tableView.dequeueReusableCell(withIdentifier: viewModel?.cellIdentifier ?? "") as? DetailTextTableViewCell
        cell?.cellViewModel = viewModel?.getCellViewModel(section: indexPath.section, row: indexPath.row)
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.goToViewDetailsScreen(indexPath: indexPath)
    }
}
    // MARK: - Bind ViewModel
extension HomeViewController {
        private func reloadMainTable() {
            DispatchQueue.main.async { [weak self] in
                if let tableView = self?.mainTableView {
                    UIView.animate(withDuration: 0.01, animations: {
                                tableView.reloadData()
                    }) { [weak self] _ in
                            if self?.viewModel?.numberOfSections() == 0 {
                                tableView.isHidden = true
                                self?.errorLabel.isHidden = false
                            } else {
                                tableView.isHidden = false
                                self?.errorLabel.isHidden = true
                            }
                    }
                }
            }
        }
}
extension HomeViewController {
    private func bindViewModel() {
        viewModel?.didItemsLoad.bind{[weak self]  in
            guard $0 else { return }
            self?.reloadMainTable()
        }
    }
    private func bindAlertModel() {
        viewModel?.alertModel.bindAndFire({ [weak self] alertModel in
            guard let alertModel = alertModel else { return }
            self?.present(alertModel: alertModel, presentationState: self?.viewModel?.errorAlertPresentation)
        })
    }
}
