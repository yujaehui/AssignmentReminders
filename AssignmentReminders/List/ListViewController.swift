//
//  ListViewController.swift
//  AssignmentReminders
//
//  Created by Jaehui Yu on 2/14/24.
//

import UIKit
import SnapKit
import RealmSwift

enum ListMenu: String, CaseIterable {
    case Manual
    case DueDate = "Due Date"
    case CreationDate = "Creation Date"
    case Priority
    case Title
    
    var byKeyPath: String {
        switch self {
        case .Manual: return "CreationDate"
        case .DueDate: return "date"
        case .CreationDate: return "CreationDate"
        case .Priority: return "priority"
        case .Title: return "title"
        }
    }
}

class ListViewController: BaseViewController {
    // MARK: - Properties
    weak var delegate: TableViewReloadDelegate?
    let listTableView = UITableView()
    let emptyLabel = UILabel()
    let reminderRepository = ReminderRepository()
    var reminderList: Results<Reminder>!
    var folder: Folder!
    var navigationTilte = ""
    var color: UIColor = .white
    var type: MainSectionType = .Basic
    var selectedOption: ListMenu = .Manual {
        didSet {
            setNavigationBar()
        }
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        view.backgroundColor = .white
        if type == .MyLists {
            setToolBar()
        }
    }
    
    // MARK: - configure
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
}

// MARK: - Navigation
extension ListViewController {
    func setNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = navigationTilte
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: color]
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), menu: setMenu())
    }
    
    func setMenu() -> UIMenu {
        let actions = ListMenu.allCases.map { option in
            UIAction(title: option.rawValue, state: option == self.selectedOption ? .on : .off) { action in
                self.selectedOption = option
                self.reminderList = self.reminderList.sorted(byKeyPath: option.byKeyPath, ascending: true)
                self.listTableView.reloadData()
            }
        }
        let menu = UIMenu(title: "Sort By", subtitle: self.selectedOption.rawValue, children: actions)
        let mainMenu = UIMenu(title: "", children: [menu])
        return mainMenu
    }
}

// MARK: - ToolBar
extension ListViewController {
    func setToolBar() {
        navigationController?.isToolbarHidden = false
        let addButton = UIBarButtonItem(title: "New Reminder", image: UIImage(systemName: "plus"), target: self, action: #selector(newReminderButtonClicked))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barItems = [addButton, flexibleSpace]
        self.toolbarItems = barItems
    }
    
    @objc func newReminderButtonClicked() {
        let vc = DetailViewController()
        vc.delegate = self
        vc.type = .List
        vc.folder = folder
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
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
        cell.buttonAction = { self.completeButtonClicked(id: row.id) }
        if loadImageToDocument(fileName: "\(row.id)") != nil {
            cell.photoImageView.image = loadImageToDocument(fileName: "\(row.id)")
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func completeButtonClicked(id: ObjectId) {
        reminderRepository.updateIsCompleted(id: id)
        listTableView.reloadData()
        delegate?.tableViewReload()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let row = indexPath.row
        let title = reminderList[row].flag ? "깃발 제거" : "깃발"
        let flag = UIContextualAction(style: .normal, title: title) { [self] (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            reminderRepository.updateFlag(id: reminderList[row].id)
            listTableView.reloadData()
            delegate?.tableViewReload()
            success(true)
        }
        flag.backgroundColor = .systemOrange
        
        let delete = UIContextualAction(style: .normal, title: "삭제") { [self] (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            let row = reminderList[indexPath.row]
            removeImageFromDocument(fileName: "\(row.id)")
            reminderRepository.deleteItem(list: reminderList, id: row.id)
            tableView.deleteRows(at: [indexPath], with: .fade)
            delegate?.tableViewReload()
            success(true)
        }
        delete.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions:[delete, flag])
    }
}

// MARK: - TableViewReloadDelegate
extension ListViewController: TableViewReloadDelegate {
    func tableViewReload() {
        print("kkk")
        listTableView.reloadData()
        delegate?.tableViewReload()
    }
}
