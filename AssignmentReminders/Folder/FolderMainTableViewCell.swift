//
//  FolderMainTableViewCell.swift
//  AssignmentReminders
//
//  Created by Jaehui Yu on 2/20/24.
//

import UIKit
import SnapKit

class FolderMainTableViewCell: BaseTableViewCell {
    let folderImageView = UIImageView()
    let folderNameTextField = UITextField()
    var folderName: ((String) -> Void)?
    
    override func configureHierarchy() {
        contentView.addSubview(folderImageView)
        contentView.addSubview(folderNameTextField)
    }
    
    override func configureView() {
        folderImageView.image = UIImage(systemName: "list.bullet.circle.fill")
        
        folderNameTextField.placeholder = "List Name"
        folderNameTextField.textAlignment = .center
        folderNameTextField.backgroundColor = .systemGroupedBackground
        folderNameTextField.layer.cornerRadius = 10
        folderNameTextField.clipsToBounds = true
        folderNameTextField.clearButtonMode = .whileEditing
        if let clearButton = folderNameTextField.value(forKey: "_clearButton") as? UIButton {
            let templateImage = clearButton.imageView?.image?.withRenderingMode(.automatic)
            clearButton.setImage(templateImage, for: .normal)
            clearButton.tintColor = .lightGray
        }
        folderNameTextField.addTarget(self, action: #selector(folderNameTextFieldEditingChanged), for: .editingChanged)
    }
    
    override func configureConstraints() {
        folderImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(10)
            make.centerX.equalTo(contentView)
            make.size.equalTo(80)
        }
        
        folderNameTextField.snp.makeConstraints { make in
            make.top.equalTo(folderImageView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentView).inset(10)
            make.height.equalTo(50)
            make.bottom.equalTo(contentView).inset(10)
        }
    }
    
    @objc func folderNameTextFieldEditingChanged() {
        guard let text = folderNameTextField.text else { return }
        folderName?(text)
    }

}
