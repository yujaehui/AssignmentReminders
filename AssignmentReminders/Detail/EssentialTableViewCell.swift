//
//  EssentialTableViewCell.swift
//  AssignmentReminders
//
//  Created by Jaehui Yu on 2/17/24.
//

import UIKit

class EssentialTableViewCell: BaseTableViewCell {
    let userTextField = UITextField()
    var type: EssentialCellType = .Title
    var listTitle: ((String) -> Void)?
    var listNotes: ((String) -> Void)?
    
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
        switch type {
        case .Title:
            listTitle?(text)
        case .Notes:
            listNotes?(text)
        }
    }
}
