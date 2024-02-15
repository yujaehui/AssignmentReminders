//
//  MainCollectionViewCell.swift
//  AssignmentReminders
//
//  Created by Jaehui Yu on 2/15/24.
//

import UIKit
import SnapKit

class MainCollectionViewCell: BaseCollectionViewCell {
    let iconimageView = UIImageView()
    let countLabel = UILabel()
    let titleLabel = UILabel()
    
    override func configureHierarchy() {
        contentView.addSubview(iconimageView)
        contentView.addSubview(countLabel)
        contentView.addSubview(titleLabel)
    }
    
    override func configureView() {
        layer.cornerRadius = 15
        backgroundColor = .white
        iconimageView.image = UIImage(systemName: "tray.circle.fill")
        countLabel.text = "0"
        countLabel.textAlignment = .center
        countLabel.font = .boldSystemFont(ofSize: 25)
        titleLabel.text = "전체"
        titleLabel.textColor = .gray
        titleLabel.font = .boldSystemFont(ofSize: 16)
    }
    
    override func configureConstraints() {
        iconimageView.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView).inset(10)
            make.size.equalTo(40)
        }
        
        countLabel.snp.makeConstraints { make in
            make.top.trailing.equalTo(contentView).inset(10)
            make.size.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconimageView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentView).inset(10)
        }
    }
    
}
