//
//  ResultsViewController.swift
//  Transformers
//
//  Created by Suneeth on 8/7/20.
//  Copyright © 2020 Suneeth. All rights reserved.
//

import UIKit

class ResultsViewController: BaseViewController {
    @IBOutlet weak var mainTableView: UITableView!
    var rightHamburgerButton: UIBarButtonItem?
    
    // MARK: - Parameters
    var viewModel: ResultsViewModel? {
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
        tableHeader()
        viewModel?.startWar()
    }
    // MARK: - Private Methods
    private func registerCells() {
        let textNib = UINib.init(nibName: "DetailTextTableViewCell", bundle: nil)
        mainTableView.register(textNib, forCellReuseIdentifier: viewModel?.cellIdentifier ?? "")
        mainTableView.register(UINib(nibName: "CustomFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: CustomFooterView.reuseIdentifier)
    }
    private func tableHeader() {
        let headerView: UIView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: mainTableView.frame.width, height: 60.0))
        headerView.backgroundColor = .black
        let headerTextLabel: UILabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: headerView.frame.width, height: headerView.frame.height))
        headerTextLabel.textAlignment = .center
        headerTextLabel.textColor = UIColor.navigationBarbuttonTextColor
        headerTextLabel.font = UIFont.boldSystemFont(ofSize: 22.0)
        headerTextLabel.text = viewModel?.getWinnerTeamName()
        headerView.addSubview(headerTextLabel)
        mainTableView.tableHeaderView = headerView
    }
    private func addRightNavigationBarButton() {
        if rightHamburgerButton == nil {
            rightHamburgerButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonClicked))
            rightHamburgerButton?.tintColor = UIColor.navigationBarbuttonTextColor
            rightHamburgerButton?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.navigationBarbuttonFont], for: .normal)
        }
        navigationItem.rightBarButtonItem = rightHamburgerButton
    }
    @objc private func doneButtonClicked() {
        navigationController?.popToRootViewController(animated: true)
    }
}
extension ResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSections() ?? 0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(viewModel?.sectionFooterViewHeight ?? 0.01)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(viewModel?.sectionHeaderViewHeight ?? 0.01)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(viewModel?.rowHeight ?? 44.0)
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: Double(tableView.frame.width), height: viewModel?.sectionHeaderViewHeight ?? 0.0))
        
        // team name
        let teamNameLabel = UILabel(frame: CGRect(x: 20.0, y: 0.0, width: 400.0, height: viewModel?.sectionHeaderViewHeight ?? 0.0))
        teamNameLabel.text = viewModel?.getSectionName(for: section)
        teamNameLabel.textColor = .black
        teamNameLabel.textAlignment = .left
        teamNameLabel.font = .boldSystemFont(ofSize: 18.0)
        headerView.addSubview(teamNameLabel)
        return headerView
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows(for: section) ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:DetailTextTableViewCell? = tableView.dequeueReusableCell(withIdentifier: viewModel?.cellIdentifier ?? "") as? DetailTextTableViewCell
        cell?.cellViewModel = viewModel?.getCellViewModel(section: indexPath.section, row: indexPath.row)
        return cell!
    }
}
    // MARK: - Bind ViewModel
extension ResultsViewController {
        private func bindViewModel() {
            viewModel?.didItemsLoad.bind{[weak self] in
                guard $0 else { return }
                DispatchQueue.main.async {
                    self?.mainTableView.reloadData()
                    self?.tableHeader()
                }
            }
        }
}
