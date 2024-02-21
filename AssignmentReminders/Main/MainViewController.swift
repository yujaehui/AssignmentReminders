//
//  MainViewController.swift
//  AssignmentReminders
//
//  Created by Jaehui Yu on 2/15/24.
//

import UIKit
import SnapKit
import RealmSwift

protocol TableViewReloadDelegate: AnyObject {
    func tableViewReload()
}

enum MainSectionType: String, CaseIterable {
    case Basic
    case MyLists = "My Lists"
}

enum BasicCellType: String, CaseIterable {
    case Today
    case Scheduled
    case All
    case Flagged
    case Completed
    
    var image: UIImage {
        switch self {
        case .Today: UIImage(systemName: "15.circle.fill")!
        case .Scheduled: UIImage(systemName: "calendar.circle.fill")!
        case .All: UIImage(systemName: "tray.circle.fill")!
        case .Flagged: UIImage(systemName: "flag.circle.fill")!
        case .Completed: UIImage(systemName: "checkmark.circle.fill")!
        }
    }
    
    var color: UIColor {
        switch self {
        case .Today: UIColor.systemBlue
        case .Scheduled: UIColor.systemRed
        case .All: UIColor.black
        case .Flagged: UIColor.systemOrange
        case .Completed: UIColor.systemGray
        }
    }
}

enum MainMenu: String, CaseIterable {
    case EditLists = "Edit Lists"
    case Templates
    
    var image: String {
        switch self {
        case .EditLists: return "pencil"
        case .Templates: return "square.on.square"
        }
    }
}

class MainViewController: BaseViewController {
    // MARK: - Properties
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    let searchTableView = UITableView()
    let folderRepository = FolderRepository()
    let reminderRepository = ReminderRepository()
    var folderList: Results<Folder>!
    var filterdReminderList: Results<Reminder>!
    var reminderList: Results<Reminder>!
    var mainReminderList: [Results<Reminder>?] = []
    
    //let realm = try! Realm()

    // MARK: - viewDidLoad, viewDidAppear
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(realm.configuration.fileURL)
        tableView.isHidden = false
        searchTableView.isHidden = true
        
        folderList = folderRepository.fetchAllFolder()
        let today = reminderRepository.fetchToday()
        let scheduled = reminderRepository.fetchScheduled()
        let all = reminderRepository.fetchAll()
        let flagged = reminderRepository.fetchFlagged()
        let completed = reminderRepository.fetchCompleted()
        reminderList = all
        mainReminderList = [today, scheduled, all, flagged, completed]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        setNavigationBar()
        setToolBar()
    }

    // MARK: - configure
    override func configureHierarchy() {
        view.addSubview(tableView)
        view.addSubview(searchTableView)
    }
    
    override func configureView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(BasicTableViewCell.self, forCellReuseIdentifier: BasicTableViewCell.identifier)
        tableView.register(MyListsTableViewCell.self, forCellReuseIdentifier: MyListsTableViewCell.identifier)
        tableView.backgroundColor = .systemGroupedBackground
        tableView.rowHeight = UITableView.automaticDimension
        
        searchTableView.dataSource = self
        searchTableView.delegate = self
        searchTableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.identifier)
        searchTableView.rowHeight = UITableView.automaticDimension
    }
    
    override func configureConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        searchTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Navigation
extension MainViewController {
    func setNavigationBar() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), menu: setMenu())
        navigationItem.backButtonTitle = "Lists"
    }
    
    func setMenu() -> UIMenu {
        let actions = MainMenu.allCases.map { option in
            UIAction(title: option.rawValue, image: UIImage(systemName: option.image)) { action in
                print(option)
            }
        }
        let menu = UIMenu(title: "", children: actions)
        return menu
    }
}

// MARK: - ToolBar
extension MainViewController {
    func setToolBar() {
        navigationController?.isToolbarHidden = false
        let addButton = UIBarButtonItem(title: "New Reminder", image: UIImage(systemName: "plus"), target: self, action: #selector(newReminderButtonClicked))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let folderAddButton = UIBarButtonItem(title: "Add List", style: .plain, target: self, action: #selector(folderAddButtonClicked))
        let barItems = [addButton, flexibleSpace, folderAddButton]
        self.toolbarItems = barItems
        if folderList.count == 0 {
            addButton.isHidden = true
        } else {
            addButton.isHidden = false
        }
    }
    
    @objc func newReminderButtonClicked() {
        let vc = DetailViewController()
        vc.delegate = self
        vc.type = .Main
        vc.folder = folderList.first
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
    
    @objc func folderAddButtonClicked() {
        let vc = FolderViewController()
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        tableView == self.tableView ? MainSectionType.allCases.count : 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == self.tableView {
            switch MainSectionType.allCases[section] {
            case .Basic: return nil
            case .MyLists: return MainSectionType.allCases[section].rawValue
            }
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            switch MainSectionType.allCases[section] {
            case .Basic: return 1
            case .MyLists: return folderList.count
            }
        } else {
            return filterdReminderList?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.separatorStyle = .none
        if tableView == self.tableView {
            switch MainSectionType.allCases[indexPath.section] {
            case .Basic:
                let cell = tableView.dequeueReusableCell(withIdentifier: BasicTableViewCell.identifier, for: indexPath) as! BasicTableViewCell
                cell.delegate = self
                cell.mainReminderList = mainReminderList
                return cell
            case .MyLists:
                let cell = tableView.dequeueReusableCell(withIdentifier: MyListsTableViewCell.identifier, for: indexPath) as! MyListsTableViewCell
                let row = indexPath.row
                let currentCell = folderList[row]
                cell.configureCell(cell: currentCell)
                cell.buttonAction = { self.goListButtonClicked(row: row)}
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as! ListTableViewCell
            let row = indexPath.row
            let currentCell = filterdReminderList[row]
            cell.configureCell(row: currentCell)
            cell.buttonAction = { self.completeButtonClicked(id: currentCell.id)}
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func goListButtonClicked(row: Int) {
        let vc = ListViewController()
        vc.delegate = self
        vc.navigationTilte = folderList[row].name
        vc.color = FolderColor.allCases[folderList[row].color].color
        vc.type = MainSectionType.MyLists
        vc.folder = folderList[row]
        vc.reminderList = reminderList.where({$0.folder == folderList[row]})
        navigationController?.pushViewController(vc, animated: true)
    }

    func completeButtonClicked(id: ObjectId) {
        reminderRepository.updateIsCompleted(id: id)
        searchTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if tableView == self.tableView {
            switch MainSectionType.allCases[indexPath.section] {
            case .Basic: return UISwipeActionsConfiguration(actions: [])
            case .MyLists:
                let row = indexPath.row
                let delete = UIContextualAction(style: .normal, title: "삭제") { [self] (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
                    folderRepository.deleteItem(list: folderList, id: folderList[row].id)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    setToolBar()
                    success(true)
                }
                delete.backgroundColor = .systemRed
                return UISwipeActionsConfiguration(actions:[delete])
            }
        } else {
            let row = indexPath.row
            let title = filterdReminderList[row].flag ? "깃발 제거" : "깃발"
            let flag = UIContextualAction(style: .normal, title: title) { [self] (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
                reminderRepository.updateFlag(id: filterdReminderList[row].id)
                searchTableView.reloadData()
                success(true)
            }
            flag.backgroundColor = .systemOrange
            
            let delete = UIContextualAction(style: .normal, title: "삭제") { [self] (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
                reminderRepository.deleteItem(list: filterdReminderList, id: filterdReminderList[row].id)
                tableView.deleteRows(at: [indexPath], with: .fade)
                success(true)
            }
            delete.backgroundColor = .systemRed
            return UISwipeActionsConfiguration(actions:[delete, flag])
        }
        
    }
}

// MARK: - UISearchResultsUpdating, UISearchBarDelegate
extension MainViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.isActive {
            view.backgroundColor = .white
            tableView.isHidden = true
            searchTableView.isHidden = false
            
            guard let text = searchController.searchBar.text else { return }
            filterdReminderList = reminderRepository.fetchSearch(text: text)
            searchTableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.backgroundColor = .systemGroupedBackground
        searchTableView.isHidden = true
        tableView.isHidden = false
    }
}

// MARK: - BasicTableViewCellDelegate, TableViewReloadDelegate
extension MainViewController: BasicTableViewCellDelegate, TableViewReloadDelegate {
    func didSelectBasicItem(row: Int) {
        let vc = ListViewController()
        vc.delegate = self
        vc.navigationTilte = BasicCellType.allCases[row].rawValue
        vc.type = .Basic
        vc.color = BasicCellType.allCases[row].color
        vc.reminderList = mainReminderList[row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableViewReload() {
        setToolBar()
        tableView.reloadData()
    }
}
