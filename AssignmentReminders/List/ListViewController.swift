//
//  ListViewController.swift
//  AssignmentReminders
//
//  Created by Jaehui Yu on 2/14/24.
//

import UIKit
import SnapKit

struct List {
    var title: String = ""
    var notes: String = ""
    var date: String = ""
    var time: String = ""
    var tag: String = ""
    var priority: String = ""
}

class ListViewController: BaseViewController {
    let listTableView = UITableView()
    let emptyLabel = UILabel()
    var userList: [List] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setToolBar()
    }
    
    override func configureHierarchy() {
        view.addSubview(listTableView)
        view.addSubview(emptyLabel)
    }
    
    override func configureView() {
        listTableView.dataSource = self
        listTableView.delegate = self
        listTableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.identifier)
        listTableView.rowHeight = UITableView.automaticDimension
        
        emptyLabel.text = "미리 알림 없음"
        emptyLabel.textColor = .gray
    }
    
    override func configureConstraints() {
        emptyLabel.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
        
        listTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "전체"
    }
    
    func setToolBar() {
        navigationController?.isToolbarHidden = false
        let addButton = UIBarButtonItem(title: "새로운 미리 알림", image: UIImage(systemName: "plus"), target: self, action: #selector(newReminderButtonClicked))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barItems = [addButton, flexibleSpace]
        self.toolbarItems = barItems
    }
    
    @objc func newReminderButtonClicked() {
        let vc = DetailViewController()
        vc.list = { [self] value in
            userList.append(value)
            listTableView.reloadData()
        }
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if userList.count > 0 {
            emptyLabel.isHidden = true
            tableView.isHidden = false
            return userList.count
        } else {
            tableView.isHidden = true
            emptyLabel.isHidden = false
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as! ListTableViewCell
        let row = userList[indexPath.row]
        cell.titleLabel.text = row.priority + row.title
        cell.notesLabel.text = row.notes
        cell.descriptionLabel.text = row.date + " " + row.time + " " + row.tag
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            userList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
