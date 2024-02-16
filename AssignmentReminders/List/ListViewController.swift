//
//  ListViewController.swift
//  AssignmentReminders
//
//  Created by Jaehui Yu on 2/14/24.
//

import UIKit
import SnapKit
import RealmSwift

class ListViewController: BaseViewController {
    let listTableView = UITableView()
    let emptyLabel = UILabel()
    
    let repository = ReminderRepository()
    var reminderList: Results<Reminder>!
    
    var navigationTilte = ""
    var color: UIColor = .white
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listTableView.reloadData()
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
        navigationItem.title = navigationTilte
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: color]
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), menu: setMenu())
    }
    
    func setMenu() -> UIMenu {
        var items: [UIAction] {
            let deadline = UIAction(title: "마감일") { [self] _ in
                reminderList = reminderList.sorted(byKeyPath: "date", ascending: true)
                listTableView.reloadData()
            }
            let date = UIAction(title: "생성일") { [self] _ in
                reminderList = reminderList.sorted(byKeyPath: "CreationDate", ascending: true)
                listTableView.reloadData()
            }
            let priority = UIAction(title: "우선 순위") { [self] _ in
                reminderList = reminderList.sorted(byKeyPath: "priority", ascending: false)
                listTableView.reloadData()
            }
            let title = UIAction(title: "제목") { [self] _ in
                reminderList = reminderList.sorted(byKeyPath: "title", ascending: true)
                listTableView.reloadData()
            }
            let Items = [deadline, date, priority, title]
            return Items
        }
        let menu = UIMenu(title: "다음으로 정렬", children: items)
        let mainMenu = UIMenu(title: "", children: [menu])
        return mainMenu
    }
    
    @objc func completeButtonClicked(sender: UIButton) {
        repository.updateIsCreated(index: sender.tag)
        listTableView.reloadData()
    }
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if reminderList.count > 0 {
            emptyLabel.isHidden = true
            tableView.isHidden = false
            return reminderList.count
        } else {
            emptyLabel.isHidden = false
            tableView.isHidden = true
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as! ListTableViewCell
        let row = reminderList[indexPath.row]
        cell.configureCell(row: row)
        cell.completeButton.tag = indexPath.row
        cell.completeButton.addTarget(self, action: #selector(completeButtonClicked), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let title = reminderList[indexPath.row].flag ? "깃발 제거" : "깃발"
        let flag = UIContextualAction(style: .normal, title: title) { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            self.repository.updateFlag(index: indexPath.row)
            self.listTableView.reloadData()
            success(true)
        }
        flag.backgroundColor = .systemOrange
        
        let delete = UIContextualAction(style: .normal, title: "삭제") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            self.repository.deleteItem(list: self.reminderList, index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            success(true)
        }
        delete.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions:[delete, flag])
    }
}
