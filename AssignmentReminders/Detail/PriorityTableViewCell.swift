//
//  PriorityTableViewCell.swift
//  AssignmentReminders
//
//  Created by Jaehui Yu on 2/14/24.
//

import UIKit

class PriorityTableViewCell: BaseTableViewCell {
    let iconImageView = UIImageView()
    let targetLabel = UILabel()
    let settingLabel = UILabel()
    let settingButton = UIButton()
    
    var priority: ((String) -> Void)?

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
        settingButton.setImage(UIImage(systemName: "chevron.up.chevron.down"), for: .normal)
        settingButton.contentHorizontalAlignment = .trailing
        settingButton.addTarget(self, action: #selector(settingButtonClicked), for: .touchUpInside)
    }
    
    @objc func settingButtonClicked() {
        settingButton.menu = setMenu()
        settingButton.showsMenuAsPrimaryAction = true
    }
    
    func setMenu() -> UIMenu {
        let noneButton = UIAction(title: "없음") { _ in
            self.settingLabel.text = "없음"
            self.priority?("")
        }
        let highButton = UIAction(title: "높음") { _ in
            self.settingLabel.text = "높음"
            self.priority?("!!!")
        }
        let middleButton = UIAction(title: "중간") { _ in
            self.settingLabel.text = "중간"
            self.priority?("!!")
        }
        let lowButton = UIAction(title: "낮음") { _ in
            self.settingLabel.text = "낮음"
            self.priority?("!")

        }
        let items = [noneButton, highButton, middleButton, lowButton]
        let menu = UIMenu(title: "", children: items)
        return menu
    }
    
    override func configureConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView).inset(10)
            make.size.equalTo(30)
        }
        
        targetLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(iconImageView.snp.trailing).offset(10)
            make.width.equalTo(80)
            make.height.equalTo(30)
        }
        
        settingLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(targetLabel.snp.trailing).offset(10)
            make.trailing.equalTo(contentView).inset(30)
            make.height.equalTo(30)
        }
        
        settingButton.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.horizontalEdges.equalTo(contentView).inset(10)
            make.height.equalTo(50)
        }
    }
}

