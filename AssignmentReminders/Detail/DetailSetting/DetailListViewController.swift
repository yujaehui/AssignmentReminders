//
//  DetailListViewController.swift
//  AssignmentReminders
//
//  Created by Jaehui Yu on 2/20/24.
//

import UIKit
import SnapKit
import RealmSwift

class DetailListViewController: BaseViewController {
    // MARK: - Properties
    let tableView = UITableView()
    var folderRepository = FolderRepository()
    var folderList: Results<Folder>!
    var folder: Folder!
    var list: ((Folder) -> Void)?

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        folderList = folderRepository.fetchAllFolder()
    }
    
    // MARK: - configure
    override func configureHierarchy() {
        view.addSubview(tableView)
    }
    
    override func configureView() {
        tableView.backgroundColor = .systemGroupedBackground
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MyDetailListsTableViewCell.self, forCellReuseIdentifier: MyDetailListsTableViewCell.identifier)
    }
    
    override func configureConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Naviagtion
extension DetailListViewController {
    func setNavigationBar() {
        navigationItem.title = "목록"
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension DetailListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyDetailListsTableViewCell.identifier, for: indexPath) as! MyDetailListsTableViewCell
        let row = indexPath.row
        let currentCell = folderList[row]
        cell.iconImageView.tintColor = FolderColor.allCases[currentCell.color].color
        cell.targetLabel.text = folderList[row].name
        if folder.id == currentCell.id {
            cell.checkImaggeView.isHidden = false
        } else {
            cell.checkImaggeView.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        list?(folderList[row])
        navigationController?.popViewController(animated: true)
    }
    
    
}
