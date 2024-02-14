//
//  DetailViewController.swift
//  AssignmentReminders
//
//  Created by Jaehui Yu on 2/14/24.
//

import UIKit
import SnapKit

enum SectionType: String, CaseIterable {
    case Essential
    case Additional
}

enum EssentialCellType: String, CaseIterable {
    case Title
    case Notes
}

enum AdditionalCellType: String, CaseIterable {
    case Date
    case Time
    case Tag
    case Priority
    
    var image: UIImage {
        switch self {
        case .Date:
            UIImage(systemName: "calendar.circle.fill")!.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        case .Time:
            UIImage(systemName: "clock.circle.fill")!.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
        case .Tag:
            UIImage(systemName: "number.circle.fill")!.withTintColor(.darkGray, renderingMode: .alwaysOriginal)
        
        case .Priority:
            UIImage(systemName: "exclamationmark.circle.fill")!.withTintColor(.systemOrange, renderingMode: .alwaysOriginal)
        }
    }
}

protocol passDataDelegate {
    func passTimeData(time: Date)
}

class DetailViewController: BaseViewController {
    let detailTableView = UITableView(frame: .zero, style: .insetGrouped)
    
    var listTitle = ""
    var listNotes = ""
    var date = ""
    var time = ""
    var tag = ""
    var priority = ""
    
    var list: ((List) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        setNavigationBar()
        NotificationCenter.default.addObserver(self, selector: #selector(tagNotification), name: NSNotification.Name("Tag"), object: nil)
    }
    
    override func configureHierarchy() {
        view.addSubview(detailTableView)
    }
    
    override func configureView() {
        detailTableView.dataSource = self
        detailTableView.delegate = self
        detailTableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        detailTableView.register(NotesTableViewCell.self, forCellReuseIdentifier: NotesTableViewCell.identifier)
        detailTableView.register(DateTableViewCell.self, forCellReuseIdentifier: DateTableViewCell.identifier)
        detailTableView.register(TimeTableViewCell.self, forCellReuseIdentifier: TimeTableViewCell.identifier)
        detailTableView.register(TagTableViewCell.self, forCellReuseIdentifier: TagTableViewCell.identifier)
        detailTableView.register(PriorityTableViewCell.self, forCellReuseIdentifier: PriorityTableViewCell.identifier)
        detailTableView.rowHeight = UITableView.automaticDimension
    }
    
    override func configureConstraints() {
        detailTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setNavigationBar() {
        navigationItem.title = "Detail"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(leftBarButtonClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(rightBarButtonClicked))
    }
    
    @objc func leftBarButtonClicked() {
        dismiss(animated: true)
    }
    
    @objc func rightBarButtonClicked() {
        list?(List(title: listTitle, notes: listNotes, date: date, time: time, tag: tag, priority: priority))
        dismiss(animated: true)
    }
    
    @objc func tagNotification(notification: NSNotification) {
        let firstTag = notification.userInfo?["tag"] as? String
        guard let tagCount = notification.userInfo?["count"] as? Int else { return }
        if tagCount == 0 {
            tag = "#" + (firstTag ?? "")
        } else {
            tag = "#" + (firstTag ?? "") + "외 \(String(describing: tagCount))개의 tag"
        }
        detailTableView.reloadData()
    }
    
    @objc func dateSetting() {
        print(#function)
        let vc = DateViewController()
        vc.date = { [self] value in
            let format = DateFormatter()
            format.dateFormat = "yyyy년 MM월 dd일 E요일"
            format.locale = Locale(identifier: "ko-KR")
            let result = format.string(from: value)
            date = result
            detailTableView.reloadData()
        }
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
    
    @objc func timeSetting() {
        print(#function)
        let vc = TimeViewController()
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
    
    @objc func tagSetting() {
        let vc = TagViewController()
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
}

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch SectionType.allCases[section] {
        case .Essential: return EssentialCellType.allCases.count
        case .Additional: return AdditionalCellType.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch SectionType.allCases[indexPath.section] {
        case .Essential:
            switch EssentialCellType.allCases[indexPath.row] {
            case .Title:
                let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as! TitleTableViewCell
                cell.userTextField.placeholder = EssentialCellType.Title.rawValue
                cell.listTitle = { value in
                    self.listTitle = value
                }                
                return cell
            case .Notes:
                let cell = tableView.dequeueReusableCell(withIdentifier: NotesTableViewCell.identifier, for: indexPath) as! NotesTableViewCell
                cell.userTextField.placeholder = EssentialCellType.Notes.rawValue
                cell.listNotes = { value in
                    self.listNotes = value
                }
                return cell
            }
        case .Additional:
            switch AdditionalCellType.allCases[indexPath.row] {
            case .Date:
                let cell = tableView.dequeueReusableCell(withIdentifier: DateTableViewCell.identifier, for: indexPath) as! DateTableViewCell
                cell.iconImageView.image = AdditionalCellType.Date.image
                cell.targetLabel.text = AdditionalCellType.Date.rawValue
                cell.settingLabel.text = date
                cell.settingButton.addTarget(self, action: #selector(dateSetting), for: .touchUpInside)
                return cell
            case .Time:
                let cell = tableView.dequeueReusableCell(withIdentifier: TimeTableViewCell.identifier, for: indexPath) as! TimeTableViewCell
                cell.iconImageView.image = AdditionalCellType.Time.image
                cell.targetLabel.text = AdditionalCellType.Time.rawValue
                cell.settingLabel.text = time
                cell.settingButton.addTarget(self, action: #selector(timeSetting), for: .touchUpInside)
                return cell
            case .Tag:
                let cell = tableView.dequeueReusableCell(withIdentifier: TagTableViewCell.identifier, for: indexPath) as! TagTableViewCell
                cell.iconImageView.image = AdditionalCellType.Tag.image
                cell.targetLabel.text = AdditionalCellType.Tag.rawValue
                cell.settingButton.addTarget(self, action: #selector(tagSetting), for: .touchUpInside)
                cell.settingLabel.text = tag
                return cell
            case .Priority:
                let cell = tableView.dequeueReusableCell(withIdentifier: PriorityTableViewCell.identifier, for: indexPath) as! PriorityTableViewCell
                cell.iconImageView.image = AdditionalCellType.Priority.image
                cell.targetLabel.text = AdditionalCellType.Priority.rawValue
                cell.priority = { value in
                    self.priority = value
                }
                return cell
            }
        }
    }
}

extension DetailViewController: passDataDelegate {
    func passTimeData(time: Date) {
        let format = DateFormatter()
        format.dateFormat = "a h:mm"
        format.locale = Locale(identifier: "ko-KR")
        let result = format.string(from: time)
        self.time = result
        self.detailTableView.reloadData()
    }
}

