//
//  MyListsTableViewCell.swift
//  AssignmentReminders
//
//  Created by Jaehui Yu on 2/20/24.
//

import UIKit
import RealmSwift

class MyListsTableViewCell: BaseTableViewCell {
    // MARK: - Properties
    let folderImageView = UIImageView()
    let folderNameLabel = UILabel()
    let listCountLabel = UILabel()
    let goListButton = UIButton()
    var buttonAction: (() -> Void)?

    // MARK: - configure
    override func configureHierarchy() {
        contentView.addSubview(folderImageView)
        contentView.addSubview(folderNameLabel)
        contentView.addSubview(listCountLabel)
        contentView.addSubview(goListButton)
    }

    override func configureView() {
        folderImageView.image = UIImage(systemName: "list.bullet.circle.fill")
        folderNameLabel.text = "Reminders"
        listCountLabel.text = "0"
        listCountLabel.textAlignment = .right
        goListButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        goListButton.contentHorizontalAlignment = .trailing
        goListButton.addTarget(self, action: #selector(goListButtonClicked), for: .touchUpInside)
    }
    
    @objc func goListButtonClicked() {
        buttonAction?()
    }

    override func configureConstraints() {
        folderImageView.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView).inset(10)
            make.leading.equalTo(contentView).inset(10)
            make.size.equalTo(30)
        }

        folderNameLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView).inset(10)
            make.leading.equalTo(folderImageView.snp.trailing).offset(10)
            make.height.equalTo(30)
        }

        listCountLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView).inset(10)
            make.leading.equalTo(folderNameLabel.snp.trailing).offset(10)
            make.trailing.equalTo(contentView).inset(30)
            make.size.equalTo(30)
        }

        goListButton.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView).inset(10)
            make.horizontalEdges.equalTo(contentView).inset(10)
            make.height.equalTo(30)
        }
    }
    
    func configureCell(cell: Folder) {
        folderImageView.tintColor = FolderColor.allCases[cell.color].color
        folderNameLabel.text = cell.name
        listCountLabel.text = "\(cell.reminder.count)"
    }
}
