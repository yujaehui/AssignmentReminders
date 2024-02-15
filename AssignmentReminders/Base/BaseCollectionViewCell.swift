//
//  BaseCollectionViewCell.swift
//  AssignmentReminders
//
//  Created by Jaehui Yu on 2/15/24.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        configureHierarchy()
        configureView()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {}
    func configureView() {}
    func configureConstraints() {}
}
