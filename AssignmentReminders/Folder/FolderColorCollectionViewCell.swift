//
//  FolderColorCollectionViewCell.swift
//  AssignmentReminders
//
//  Created by Jaehui Yu on 2/20/24.
//

import UIKit
import SnapKit

class FolderColorCollectionViewCell: BaseCollectionViewCell {
    // MARK: - Properties
    let colorImageView = UIImageView()
    
    // MARK: - configure
    override func configureHierarchy() {
        contentView.addSubview(colorImageView)
    }
    
    override func configureView() {
        colorImageView.clipsToBounds = true
        colorImageView.layer.cornerRadius = 20
    }
        
    override func configureConstraints() {
        colorImageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
}
