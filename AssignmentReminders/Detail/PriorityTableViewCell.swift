//
//  PriorityTableViewCell.swift
//  AssignmentReminders
//
//  Created by Jaehui Yu on 2/14/24.
//

import UIKit

enum PriorityMenu: String, CaseIterable {
    case None
    case Low
    case Medium
    case High
    
    var exclamationMark: String {
        switch self {
        case .None: return ""
        case .Low: return "!"
        case .Medium: return "!!"
        case .High: return "!!!"
        }
    }
}

class PriorityTableViewCell: BaseTableViewCell {
    // MARK: - Properties
    let iconImageView = UIImageView()
    let targetLabel = UILabel()
    let settingLabel = UILabel()
    let settingButton = UIButton()
    var priority: ((String) -> Void)?
    var selectedOption: PriorityMenu = .None {
        didSet {
            settingButtonClicked()
        }
    }
    
    // MARK: - configure
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
        let actions = PriorityMenu.allCases.map { option in
            UIAction(title: option.rawValue, state: option == self.selectedOption ? .on : .off) { action in
                self.selectedOption = option
                self.settingLabel.text = option.rawValue
                self.priority?(option.exclamationMark)
            }
        }
        let menu = UIMenu(title: "", children: actions)
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

/*
 menu 설정시 경험한 문제 = state가 변하지 않고 항상 초기값을 뜨는 문제
 원인은 버튼을 눌렀을 당시에 selector로 설정한 settingButtonClicked()가 딱 한 번만 실행됨!!! (print문으로 확인)
 난 당연히 버튼을 누를 때마다 실행되는 줄...
 menu에 대한 설정도 이 메서드 안에서 처리하기 때문에 딱 한 번만 실행되는 것이었음
 그래서 아무리 값을 바꿔준다 해도 달라질 일이 없었던 것임
 
 이를 해결하기 위해서 state 변수인 selectedOption에 didSet으로 settingButtonClicked() 실행
 selectedOption 값이 변할 때마다 저 메서드도 실행될 수 있도록!
 */
