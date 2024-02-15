//
//  ListViewController.swift
//  AssignmentReminders
//
//  Created by Jaehui Yu on 2/14/24.
//

import UIKit
import SnapKit
import RealmSwift
 
/*
 셀을 각각 만들었는데 하나로 통합하는 것이 좋을 듯?
 근데 이 경우에는 데이터 처리를 어떻게 할 수 있지...
 type을 전달해야 하나?
 
 날짜는 오늘 이전 날짜 선택 가능하게 해도 ㄱㅊ을듯
 아이폰 미리알림도 가능한 거 보면...
 대신 지난 날짜인 경우 빨간색으로 표시해야징
 
 편집 가능하게 해야 함
 정렬 기능
 - 태그별로 볼 수 있게도 해야 함
 */

class ListViewController: BaseViewController {
    let listTableView = UITableView()
    let emptyLabel = UILabel()
    
    var reminderList: Results<Reminder>!
    let realm = try! Realm()
    
    var navigationTilte = ""
    var color: UIColor = .white
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
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

        var items: [UIAction] {
            let deadline = UIAction(title: "마감일") { [self] _ in
                reminderList = realm.objects(Reminder.self).sorted(byKeyPath: "date", ascending: true)
                listTableView.reloadData()
            }
            let date = UIAction(title: "생성일") { [self] _ in
                reminderList = realm.objects(Reminder.self).sorted(byKeyPath: "CreationDate", ascending: true)
                listTableView.reloadData()
            }
            let priority = UIAction(title: "우선 순위") { [self] _ in
                reminderList = realm.objects(Reminder.self).sorted(byKeyPath: "priority", ascending: false)
                listTableView.reloadData()
            }
            let title = UIAction(title: "제목") { [self] _ in
                reminderList = realm.objects(Reminder.self).sorted(byKeyPath: "title", ascending: true)
                listTableView.reloadData()
            }
            let Items = [deadline, date, priority, title]
            return Items
        }
        let menu = UIMenu(title: "다음으로 정렬", children: items)
        let mainMenu = UIMenu(title: "", children: [menu])
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), menu: mainMenu)
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
        
        if let priority = row.priority {
            cell.titleLabel.text = priority + row.title
        } else {
            cell.titleLabel.text = row.title
        }
        
        cell.notesLabel.text = row.notes

        if let date = row.date, let tag = row.tag {
            cell.descriptionLabel.text = dateFormatter(date: date) + (tag)
        } else {
            cell.descriptionLabel.text = ""
        }
        
        if row.flag {
            cell.flagImageView.isHidden = false
        } else {
            cell.flagImageView.isHidden = true
        }
        
        return cell
    }
    
    func dateFormatter(date: Date) -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy. MM. dd a h:mm"
        format.locale = Locale(identifier: "ko-KR")
        let result = format.string(from: date)
        return result
    }
}
