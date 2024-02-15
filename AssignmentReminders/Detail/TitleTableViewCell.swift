//
//  TitleTableViewCell.swift
//  AssignmentReminders
//
//  Created by Jaehui Yu on 2/14/24.
//

import UIKit

class TitleTableViewCell: BaseTableViewCell {
    let userTextField = UITextField()
    var listTitle: ((String) -> Void)?
    
    override func configureHierarchy() {
        contentView.addSubview(userTextField)
    }
    
    override func configureView() {
        userTextField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
    }
    
    override func configureConstraints() {
        userTextField.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(10)
            make.height.equalTo(30)
        }
    }
    
    @objc func textFieldEditingChanged() {
        guard let text = userTextField.text else { return }
        listTitle?(text)
    }
}
