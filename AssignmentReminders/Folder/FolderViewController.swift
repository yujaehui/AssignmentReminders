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

class FolderViewController: BaseViewController {
    // MARK: - Properties
    weak var delegate: TableViewReloadDelegate?
    let folderTableView = UITableView(frame: .zero, style: .insetGrouped)
    var folderName: String = ""
    var folderColor: Int = 0 {
        didSet {
            // FolderColorTableViewCell에 있는 컬러들을 누를 때마다 FolderMainTableViewCell의 이미지 컬러도 변경되어야 해서
            folderTableView.reloadData()
        }
    }
    var folderRepository = FolderRepository()

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
    }
    
    // MARK: - configure
    override func configureHierarchy() {
        view.addSubview(folderTableView)
    }
    
    override func configureView() {
        folderTableView.dataSource = self
        folderTableView.delegate = self
        folderTableView.register(FolderMainTableViewCell.self, forCellReuseIdentifier: FolderMainTableViewCell.identifier)
        folderTableView.register(FolderColorTableViewCell.self, forCellReuseIdentifier: FolderColorTableViewCell.identifier)
        folderTableView.rowHeight = UITableView.automaticDimension
    }
    
    override func configureConstraints() {
        folderTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Navigation
extension FolderViewController {
    func setNavigationBar() {
        navigationItem.title = "New List"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(doneButtonClicked))
    }
    
    @objc func cancelButtonClicked() {
        dismiss(animated: true)
    }
    
    @objc func doneButtonClicked() {
        // 폴더 이름을 입력하지 않은 경우 toast 띄우기
        if folderName.isEmpty {
            view.makeToast("List Name을 입력해주세요", position: .bottom)
        } else {
            let data = Folder(folderName: folderName, folderColor: folderColor, regDate: Date())
            folderRepository.createFolder(data) // 폴더 저장
            delegate?.tableViewReload() // MainViewController의 tableView reload를 위해서 연결
            dismiss(animated: true)
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension FolderViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return NewFolderSectionType.allCases.count // 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch NewFolderSectionType.allCases[indexPath.section] {
        case .main:
            let cell = tableView.dequeueReusableCell(withIdentifier: FolderMainTableViewCell.identifier, for: indexPath) as! FolderMainTableViewCell
            cell.folderName = { value in
                self.folderName = value // 셀에서 클로저를 통한 값전달
            }
            cell.folderImageView.tintColor = FolderColor.allCases[folderColor].color
            return cell
        case .color:
            let cell = tableView.dequeueReusableCell(withIdentifier: FolderColorTableViewCell.identifier, for: indexPath) as! FolderColorTableViewCell
            cell.folderColor = { value in
                self.folderColor = value // 셀에서 클로저를 통한 값전달
            }
            return cell
        }
        
    }
}
