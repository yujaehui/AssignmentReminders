//
//  FlagTableViewCell.swift
//  AssignmentReminders
//
//  Created by Jaehui Yu on 2/15/24.
//

import UIKit

class FlagTableViewCell: BaseTableViewCell {
    let iconImageView = UIImageView()
    let targetLabel = UILabel()
    let flagSwitch = UISwitch()
    
    var flag: ((Bool) -> Void)?

    override func configureHierarchy() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(targetLabel)
        contentView.addSubview(flagSwitch)
    }
    
    override func configureView() {
        flagSwitch.addTarget(self, action: #selector(flagSwitchChanged), for: .valueChanged)
    }
    
    @objc func flagSwitchChanged() {
        if flagSwitch.isOn {
            flag?(true)
        } else {
            flag?(false)
        }
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
        
        flagSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(contentView).inset(10)
        }
    }
}
