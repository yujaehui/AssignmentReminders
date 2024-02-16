//
//  ListTableViewCell.swift
//  AssignmentReminders
//
//  Created by Jaehui Yu on 2/14/24.
//

import UIKit
import SnapKit

class ListTableViewCell: BaseTableViewCell {
    let completeButton = UIButton()
    let titleLabel = UILabel()
    let notesLabel = UILabel()
    let descriptionLabel = UILabel()
    let flagImageView = UIImageView()
    
    override func configureHierarchy() {
        contentView.addSubview(completeButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(notesLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(flagImageView)
    }
    
    override func configureView() {
        notesLabel.textColor = .gray
        notesLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textColor = .gray
        descriptionLabel.font = .systemFont(ofSize: 14)
        flagImageView.image = UIImage(systemName: "flag.fill")
        flagImageView.tintColor = .systemOrange
    }
    
    override func configureConstraints() {
        completeButton.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView).inset(10)
            make.size.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(10)
            make.leading.equalTo(completeButton.snp.trailing).offset(10)
        }
        
        notesLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalTo(completeButton.snp.trailing).offset(10)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(notesLabel.snp.bottom).offset(5)
            make.leading.equalTo(completeButton.snp.trailing).offset(10)
            make.bottom.equalTo(contentView).inset(10)
        }
        
        flagImageView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(contentView).inset(10)
            make.size.equalTo(20)
        }
    }
    
    func configureCell(row: Reminder) {
        if row.isCompleted {
            completeButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            completeButton.tintColor = .systemBlue
        } else {
            completeButton.setImage(UIImage(systemName: "circle"), for: .normal)
            completeButton.tintColor = .gray
        }
        
        if let priority = row.priority {
            titleLabel.text = priority + row.title
        } else {
            titleLabel.text = row.title
        }
        
        notesLabel.text = row.notes

        if let date = row.date, let tag = row.tag {
            descriptionLabel.text = Utility.shared.dateFormatter(date: date) + (tag)
        } else {
            descriptionLabel.text = ""
        }
        
        if row.flag {
            flagImageView.isHidden = false
        } else {
            flagImageView.isHidden = true
        }
    }

}
