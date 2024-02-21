//
//  ImageTableViewCell.swift
//  AssignmentReminders
//
//  Created by Jaehui Yu on 2/19/24.
//

import UIKit

class ImageTableViewCell: BaseTableViewCell {
    // MARK: - Properties
    let iconImageView = UIImageView()
    let targetLabel = UILabel()
    let settingImageView = UIImageView()
    let settingButton = UIButton()
    var buttonAction: (() -> Void)?
    
    // MARK: - pprepareForReuse
    override func prepareForReuse() {
        super.prepareForReuse()
        buttonAction = nil
    }

    // MARK: - configure
    override func configureHierarchy() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(targetLabel)
        contentView.addSubview(settingImageView)
        contentView.addSubview(settingButton)
    }
    
    override func configureView() {
        settingImageView.layer.cornerRadius = 10
        settingImageView.clipsToBounds = true
        settingButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        settingButton.contentHorizontalAlignment = .trailing
        settingButton.addTarget(self, action: #selector(settingButtonClicked), for: .touchUpInside)
    }
    
    @objc func settingButtonClicked() {
        buttonAction?()
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
        
        settingImageView.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView).inset(10)
            make.leading.equalTo(targetLabel.snp.trailing).offset(10)
            make.trailing.equalTo(contentView).inset(30)
            make.size.equalTo(30)
        }
        
        settingButton.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView).inset(10)
            make.horizontalEdges.equalTo(contentView).inset(10)
            make.height.equalTo(30)
        }
    }
}
