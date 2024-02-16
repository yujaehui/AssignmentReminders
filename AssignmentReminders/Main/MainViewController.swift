//
//  MainViewController.swift
//  AssignmentReminders
//
//  Created by Jaehui Yu on 2/15/24.
//

import UIKit
import SnapKit
import RealmSwift

enum MainCellType: String, CaseIterable {
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

class MainViewController: BaseViewController {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
    let tableView = UITableView()
    
    let repository = ReminderRepository()
    var mainReminderList: [Results<Reminder>?] = []
    var reminderCountList: [Int] = []
    var filterdReminderList: Results<Reminder>!
    
    private static func configureCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 16
        let cellWidth = UIScreen.main.bounds.width - (spacing * 3)
        layout.itemSize = CGSize(width: cellWidth / 2, height: cellWidth / 4)
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        return layout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.isHidden = false
        tableView.isHidden = true
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
        collectionView.reloadData()
    }

    override func configureHierarchy() {
        view.addSubview(collectionView)
        view.addSubview(tableView)
    }
    
    override func configureView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemGroupedBackground
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func configureConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableView.snp.makeConstraints { make in
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
        var items: [UIAction] {
            let editLists = UIAction(title: "Edit Lists", image: UIImage(systemName: "pencil")) {  _ in
                print("Edit Lists")
            }
            let templates = UIAction(title: "Templates", image: UIImage(systemName: "square.on.square")) {  _ in
                print("Templates")
            }
            let Items = [editLists, templates]
            return Items
        }
        let menu = UIMenu(children: items)
        return menu
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
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func completeButtonClicked(sender: UIButton) {
        repository.updateIsCreated(index: sender.tag)
        tableView.reloadData()
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MainCellType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identifier, for: indexPath) as! MainCollectionViewCell
        let row = MainCellType.allCases[indexPath.row]
        cell.configureCell(row: row)
        cell.countLabel.text = "\(reminderCountList[indexPath.row])"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ListViewController()
        vc.navigationTilte = MainCellType.allCases[indexPath.row].rawValue
        vc.color = MainCellType.allCases[indexPath.row].color
        vc.reminderList = mainReminderList[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterdReminderList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as! ListTableViewCell
        let row = filterdReminderList[indexPath.row]
        cell.configureCell(row: row)
        cell.completeButton.tag = indexPath.row
        cell.completeButton.addTarget(self, action: #selector(completeButtonClicked), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let title = filterdReminderList[indexPath.row].flag ? "깃발 제거" : "깃발"
        let flag = UIContextualAction(style: .normal, title: title) { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            self.repository.updateFlag(index: indexPath.row)
            self.tableView.reloadData()
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


extension MainViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.isActive {
            view.backgroundColor = .white
            collectionView.isHidden = true
            tableView.isHidden = false
            guard let text = searchController.searchBar.text else { return }
            filterdReminderList = repository.fetchSearch(text: text)
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.backgroundColor = .systemGroupedBackground
        tableView.isHidden = true
        collectionView.isHidden = false
    }
}
