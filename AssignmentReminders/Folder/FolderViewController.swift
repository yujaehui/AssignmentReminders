//
//  FolderViewController.swift
//  AssignmentReminders
//
//  Created by Jaehui Yu on 2/20/24.
//

import UIKit
import SnapKit
import RealmSwift
import Toast

enum NewFolderSectionType: String, CaseIterable {
    case main
    case color
}

protocol FolderViewControllerDelegate: AnyObject {
    func done()
}

class FolderViewController: BaseViewController {
    weak var delegate: FolderViewControllerDelegate?
    let realm = try! Realm()
    
    let folderTableView = UITableView(frame: .zero, style: .insetGrouped)
    var folderName: String = ""
    var folderColor: Int = 0 {
        didSet {
            folderTableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
    }
    
    override func configureHierarchy() {
        view.addSubview(folderTableView)
    }
    
    override func configureView() {
        folderTableView.dataSource = self
        folderTableView.delegate = self
        folderTableView.register(FolderMainTableViewCell.self, forCellReuseIdentifier: FolderMainTableViewCell.identifier)
        folderTableView.register(FolderColorTableViewCell.self, forCellReuseIdentifier: FolderColorTableViewCell.identifier)
    }
    
    override func configureConstraints() {
        folderTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setNavigationBar() {
        navigationItem.title = "New List"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(doneButtonClicked))
    }
    
    @objc func cancelButtonClicked() {
        dismiss(animated: true)
    }
    
    @objc func doneButtonClicked() {
        if folderName.isEmpty {
            view.makeToast("List Name을 입력해주세요", position: .bottom)
        } else {
            let data = Folder(folderName: folderName, folderColor: folderColor, regDate: Date())
            do {
                try realm.write {
                    realm.add(data)
                }
            } catch {
                print(error)
            }
            delegate?.done()
            dismiss(animated: true)
        }
    }
}

extension FolderViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return NewFolderSectionType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch NewFolderSectionType.allCases[indexPath.section] {
        case .main:
            let cell = tableView.dequeueReusableCell(withIdentifier: FolderMainTableViewCell.identifier, for: indexPath) as! FolderMainTableViewCell
            cell.folderName = { value in
                self.folderName = value
            }
            cell.folderImageView.tintColor = FolderColor.allCases[folderColor].color
            return cell
        case .color:
            let cell = tableView.dequeueReusableCell(withIdentifier: FolderColorTableViewCell.identifier, for: indexPath) as! FolderColorTableViewCell
            cell.folderColor = { value in
                self.folderColor = value
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch NewFolderSectionType.allCases[indexPath.section] {
        case .main:
            return UITableView.automaticDimension
        case .color:
            return UITableView.automaticDimension
        }
    }
    
    
}
