//
//  MainViewController.swift
//  AssignmentReminders
//
//  Created by Jaehui Yu on 2/15/24.
//

import UIKit
import SnapKit
import RealmSwift

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
        case .Today:
            return UIImage(systemName: "15.circle.fill")!
        case .Scheduled:
            return UIImage(systemName: "calendar.circle.fill")!
        case .All:
            return UIImage(systemName: "tray.circle.fill")!
        case .Flagged:
            return UIImage(systemName: "flag.circle.fill")!
        case .Completed:
            return UIImage(systemName: "checkmark.circle.fill")!
        }
    }
    
    var color: UIColor {
        switch self {
        case .Today:
            return UIColor.systemBlue
        case .Scheduled:
            return UIColor.systemRed
        case .All:
            return UIColor.black
        case .Flagged:
            return UIColor.systemOrange
        case .Completed:
            return UIColor.systemGray
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
    let realm = try! Realm()
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    let searchTableView = UITableView()
    
    let repository = ReminderRepository()
    var mainReminderList: [Results<Reminder>?] = []
    var reminderCountList: [Int] = []
    var filterdReminderList: Results<Reminder>!
    var folder: Results<Folder>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(realm.configuration.fileURL)
        tableView.isHidden = false
        searchTableView.isHidden = true
        setNavigationBar()
        setToolBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        let today = repository.fetchToday()
        let scheduled = repository.fetchScheduled()
        let all = repository.fetchAll()
        let flagged = repository.fetchFlagged()
        let completed = repository.fetchCompleted()
        mainReminderList = [today, scheduled, all, flagged, completed]
        reminderCountList = [today.count, scheduled.count, all.count, flagged.count, completed.count]
        folder = realm.objects(Folder.self)
        tableView.reloadData()
    }

    
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
    
    func setToolBar() {
        navigationController?.isToolbarHidden = false
        let addButton = UIBarButtonItem(title: "New Reminder", image: UIImage(systemName: "plus"), target: self, action: #selector(newReminderButtonClicked))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let folderAddButton = UIBarButtonItem(title: "Add List", style: .plain, target: self, action: #selector(folderAddButtonClicked))
        let barItems = [addButton, flexibleSpace, folderAddButton]
        self.toolbarItems = barItems
    }
    
    @objc func newReminderButtonClicked() {
        let vc = DetailViewController()
        vc.type = .Main
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func folderAddButtonClicked() {
        let vc = FolderViewController()
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
    
    @objc func completeButtonClicked(sender: UIButton) {
        repository.updateIsCreated(index: sender.tag)
        searchTableView.reloadData()
    }
    
    @objc func goListButtonClicked(sender: UIButton) {
        let vc = ListViewController()
        vc.navigationTilte = folder[sender.tag].folderName
        vc.color = FolderColor.allCases[folder[sender.tag].folderColor].color
        vc.type = MainSectionType.MyLists
        vc.folder = folder[sender.tag]
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.tableView {
            return MainSectionType.allCases.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == self.tableView {
            switch MainSectionType.allCases[section] {
            case .Basic:
                return nil
            case .MyLists:
                return MainSectionType.allCases[section].rawValue
            }
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            switch MainSectionType.allCases[section] {
            case .Basic:
                return 1
            case .MyLists:
                return folder.count
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
                cell.reminderCountList = reminderCountList
                cell.mainReminderList = mainReminderList
                return cell
            case .MyLists:
                let cell = tableView.dequeueReusableCell(withIdentifier: MyListsTableViewCell.identifier, for: indexPath) as! MyListsTableViewCell
                let row = folder[indexPath.row]
                cell.folderImageView.tintColor = FolderColor.allCases[row.folderColor].color
                cell.folderNameLabel.text = row.folderName
                cell.listCountLabel.text = "\(row.reminder.count)"
                cell.goListButton.tag = indexPath.row
                cell.goListButton.addTarget(self, action: #selector(goListButtonClicked), for: .touchUpInside)
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as! ListTableViewCell
            let row = filterdReminderList[indexPath.row]
            cell.configureCell(row: row)
            cell.completeButton.tag = indexPath.row
            cell.completeButton.addTarget(self, action: #selector(completeButtonClicked), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if tableView == self.tableView {
            return UISwipeActionsConfiguration(actions: [])
        } else {
            let title = filterdReminderList[indexPath.row].flag ? "깃발 제거" : "깃발"
            let flag = UIContextualAction(style: .normal, title: title) { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
                self.repository.updateFlag(index: indexPath.row)
                self.searchTableView.reloadData()
                success(true)
            }
            flag.backgroundColor = .systemOrange
            
            let delete = UIContextualAction(style: .normal, title: "삭제") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
                self.repository.deleteItem(list: self.filterdReminderList, index: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                success(true)
            }
            delete.backgroundColor = .systemRed
            
            return UISwipeActionsConfiguration(actions:[delete, flag])
        }
        
    }
}

extension MainViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.isActive {
            view.backgroundColor = .white
            tableView.isHidden = true
            searchTableView.isHidden = false
            guard let text = searchController.searchBar.text else { return }
            filterdReminderList = repository.fetchSearch(text: text)
            searchTableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.backgroundColor = .systemGroupedBackground
        searchTableView.isHidden = true
        tableView.isHidden = false
    }
}

extension MainViewController: BasicTableViewCellDelegate, FolderViewControllerDelegate {
    func didSelectBasicItem(row: Int) {
        let vc = ListViewController()
        vc.navigationTilte = BasicCellType.allCases[row].rawValue
        vc.type = .Basic
        vc.color = BasicCellType.allCases[row].color
        vc.reminderList = mainReminderList[row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func done() {
        tableView.reloadData()
    }
}
