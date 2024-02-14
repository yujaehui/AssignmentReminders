//
//  ListTableViewCell.swift
//  AssignmentReminders
//
//  Created by Jaehui Yu on 2/14/24.
//

import UIKit
import SnapKit

class ListTableViewCell: BaseTableViewCell {
    let titleLabel = UILabel()
    let notesLabel = UILabel()
    let descriptionLabel = UILabel()
    
    override func configureHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(notesLabel)
        contentView.addSubview(descriptionLabel)
    }
    
    override func configureView() {
        notesLabel.textColor = .gray
        notesLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textColor = .gray
        descriptionLabel.font = .systemFont(ofSize: 14)
    }
    
    override func configureConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView).inset(10)
        }
        
        notesLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalTo(contentView).inset(10)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(notesLabel.snp.bottom).offset(5)
            make.leading.equalTo(contentView).inset(10)
            make.bottom.equalTo(contentView).inset(10)
        }
    }

}
