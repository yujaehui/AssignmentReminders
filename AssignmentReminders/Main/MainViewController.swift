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
    
    var reminderList: Results<Reminder>!
    var mainReminderList: [Results<Reminder>?] = []
    var reminderCountList: [Int] = []
    let realm = try! Realm()
    
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
        setNavigationBar()
        setToolBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        reminderList = realm.objects(Reminder.self)
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let today = realm.objects(Reminder.self).where{ $0.date >= startOfDay && $0.date <= endOfDay }
        let scheduled = realm.objects(Reminder.self).where{ $0.date > Date() }
        let all = realm.objects(Reminder.self)
        let flagged = realm.objects(Reminder.self).where{ $0.flag == true }
        let completed = realm.objects(Reminder.self).where{ $0.isCompleted == true }
        mainReminderList = [today, scheduled, all, flagged, completed]
        reminderCountList = [today.count, scheduled.count, all.count, flagged.count, completed.count]
        collectionView.reloadData()
    }

    override func configureHierarchy() {
        view.addSubview(collectionView)
    }
    
    override func configureView() {
        view.backgroundColor = .systemGroupedBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemGroupedBackground

    }
    
    override func configureConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setNavigationBar() {
        let searchController = UISearchController()
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), menu: menu)
        navigationItem.backButtonTitle = "Lists"
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
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MainCellType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identifier, for: indexPath) as! MainCollectionViewCell
        cell.iconimageView.image = MainCellType.allCases[indexPath.row].image
        cell.iconimageView.tintColor = MainCellType.allCases[indexPath.row].color
        cell.countLabel.text = "\(reminderCountList[indexPath.row])"
        cell.titleLabel.text = MainCellType.allCases[indexPath.row].rawValue
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
