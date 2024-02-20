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
    let tableView = UITableView()
    let realm = try! Realm()
    var folder: Results<Folder>!
    var list: ((Folder) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        folder = realm.objects(Folder.self)
    }
    
    override func configureHierarchy() {
        view.addSubview(tableView)
    }
    
    override func configureView() {
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

extension DetailListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyDetailListsTableViewCell.identifier, for: indexPath) as! MyDetailListsTableViewCell
        let row = folder[indexPath.row]
        cell.iconImageView.tintColor = FolderColor.allCases[row.folderColor].color
        cell.targetLabel.text = folder[indexPath.row].folderName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        list?(folder[indexPath.row])
        dismiss(animated: true)
    }
    
    
}
