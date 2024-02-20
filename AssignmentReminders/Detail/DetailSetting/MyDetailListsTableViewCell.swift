//
//  MyDetailListsTableViewCell.swift
//  AssignmentReminders
//
//  Created by Jaehui Yu on 2/21/24.
//

import UIKit
import SnapKit

class MyDetailListsTableViewCell: BaseTableViewCell {
    let iconImageView = UIImageView()
    let targetLabel = UILabel()

    override func configureHierarchy() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(targetLabel)
    }
    
    override func configureView() {
        iconImageView.image = UIImage(systemName: "list.bullet.circle.fill")

    }
    
    override func configureConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView).inset(10)
            make.leading.equalTo(contentView).inset(10)
            make.size.equalTo(30)
        }
        
        targetLabel.snp.makeConstraints { make in
            make.top.bottom.trailing.equalTo(contentView).inset(10)
            make.leading.equalTo(iconImageView.snp.trailing).offset(10)
            make.height.equalTo(30)
        }
    }
}
