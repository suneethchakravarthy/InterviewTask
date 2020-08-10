//
//  WarViewController.swift
//  Transformers
//
//  Created by Suneeth on 8/7/20.
//  Copyright © 2020 Suneeth. All rights reserved.
//

import UIKit

class WarViewController: BaseViewController {
    @IBOutlet weak var mainTableView: UITableView!
    // MARK: - Parameters
    var viewModel: WarViewModel? {
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
    }
    // MARK: - Private Methods
    private func registerCells() {
        let textNib = UINib.init(nibName: "DetailTextTableViewCell", bundle: nil)
        mainTableView.register(textNib, forCellReuseIdentifier: viewModel?.cellIdentifier ?? "")
        mainTableView.register(UINib(nibName: "CustomFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: CustomFooterView.reuseIdentifier)
    }
}
extension WarViewController: UITableViewDelegate, UITableViewDataSource {
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
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 { return nil }
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CustomFooterView") as! CustomFooterView
        footerView.customButton.setTitle("War", for: .normal)
        footerView.delegate = self
        return footerView
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(viewModel?.sectionFooterViewHeight(for: section) ?? 0.01)
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
extension WarViewController: CustomHeaderDelegate {
    func buttonTapped() {
        viewModel?.goToResultsScreen()
    }
}
    // MARK: - Bind ViewModel
extension WarViewController {
        private func bindViewModel() {
        }
}
