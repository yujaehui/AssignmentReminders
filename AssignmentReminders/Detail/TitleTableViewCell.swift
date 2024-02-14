//
//  TitleTableViewCell.swift
//  AssignmentReminders
//
//  Created by Jaehui Yu on 2/14/24.
//

import UIKit

class TitleTableViewCell: BaseTableViewCell, UITextFieldDelegate {
    let userTextField = UITextField()
    var listTitle: ((String) -> Void)?
    
    override func configureHierarchy() {
        contentView.addSubview(userTextField)
    }
    
    override func configureView() {
        userTextField.delegate = self
    }
    
    override func configureConstraints() {
        userTextField.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(10)
            make.height.equalTo(30)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        listTitle?(text)
        return true
    }
}
