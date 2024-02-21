//
//  MyDetailListsTableViewCell.swift
//  AssignmentReminders
//
//  Created by Jaehui Yu on 2/21/24.
//

import UIKit
import SnapKit

class MyDetailListsTableViewCell: BaseTableViewCell {
    // MARK: - Properties
    let iconImageView = UIImageView()
    let targetLabel = UILabel()
    let checkImaggeView = UIImageView()

    // MARK: - configure
    override func configureHierarchy() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(targetLabel)
        contentView.addSubview(checkImaggeView)
    }
    
    override func configureView() {
        backgroundColor = .systemGroupedBackground
        iconImageView.image = UIImage(systemName: "list.bullet.circle.fill")
        checkImaggeView.image = UIImage(systemName: "checkmark")
    }
    
    override func configureConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView).inset(10)
            make.leading.equalTo(contentView).inset(10)
            make.size.equalTo(30)
        }
        
        targetLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView).inset(10)
            make.leading.equalTo(iconImageView.snp.trailing).offset(10)
            make.height.equalTo(30)
        }
        
        checkImaggeView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(targetLabel.snp.trailing).offset(10)
            make.trailing.equalTo(contentView).inset(10)
            make.size.equalTo(20)
        }
    }
}
