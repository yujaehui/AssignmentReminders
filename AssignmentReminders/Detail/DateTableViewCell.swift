//
//  DateTableViewCell.swift
//  AssignmentReminders
//
//  Created by Jaehui Yu on 2/14/24.
//

import UIKit

class DateTableViewCell: BaseTableViewCell {
    let iconImageView = UIImageView()
    let targetLabel = UILabel()
    let settingLabel = UILabel()
    let settingButton = UIButton()
    
    override func configureHierarchy() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(targetLabel)
        contentView.addSubview(settingLabel)
        contentView.addSubview(settingButton)
    }
    
    override func configureView() {
        settingLabel.textAlignment = .right
        settingLabel.textColor = .systemBlue
        settingLabel.font = .systemFont(ofSize: 15)
        settingButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        settingButton.contentHorizontalAlignment = .trailing
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
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
        
        settingLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView).inset(10)
            make.leading.equalTo(targetLabel.snp.trailing).offset(10)
            make.trailing.equalTo(contentView).inset(30)
            make.height.equalTo(30)
        }
        
        settingButton.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView).inset(10)
            make.horizontalEdges.equalTo(contentView).inset(10)
            make.height.equalTo(30)
        }
    }
}
