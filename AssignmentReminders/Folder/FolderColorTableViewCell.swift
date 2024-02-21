//
//  FolderColorTableViewCell.swift
//  AssignmentReminders
//
//  Created by Jaehui Yu on 2/20/24.
//

import UIKit
import SnapKit

enum FolderColor: Int, CaseIterable {
    case Red
    case Orange
    case Yellow
    case Green
    case Cyan
    case Blue
    case Indigo
    case Purple
    case Pink
    case Brown
    case Gray
    case Black
    
    var color: UIColor {
        switch self {
        case .Red: UIColor.systemRed
        case .Orange: UIColor.systemOrange
        case .Yellow: UIColor.systemYellow
        case .Green: UIColor.systemGreen
        case .Cyan: UIColor.systemCyan
        case .Blue: UIColor.systemBlue
        case .Indigo: UIColor.systemIndigo
        case .Purple: UIColor.systemPurple
        case .Pink: UIColor.systemPink
        case .Brown: UIColor.systemBrown
        case .Gray: UIColor.systemGray
        case .Black: UIColor.black
        }
    }
}

class FolderColorTableViewCell: BaseTableViewCell {
    // MARK: - Properties
    let colorCollectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
    var userSelect = 0 {
        didSet {
            colorCollectionView.reloadData()
        }
    }
    var folderColor: ((Int) -> Void)?
    
    // MARK:  - configrue
    override func configureHierarchy() {
        contentView.addSubview(colorCollectionView)
    }
    
    override func configureView() {
        colorCollectionView.dataSource = self
        colorCollectionView.delegate = self
        colorCollectionView.register(FolderColorCollectionViewCell.self, forCellWithReuseIdentifier: FolderColorCollectionViewCell.identifier)
    }
    
    override func configureConstraints() {
        colorCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
            make.height.equalTo(125)
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension FolderColorTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    private static func configureCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 16
        let cellWidth = UIScreen.main.bounds.width - (spacing * 7)
        layout.itemSize = CGSize(width: cellWidth / 7, height: cellWidth / 7)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FolderColor.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FolderColorCollectionViewCell.identifier, for: indexPath) as! FolderColorCollectionViewCell
        let row = indexPath.row
        cell.colorImageView.backgroundColor = FolderColor.allCases[row].color
        if userSelect != indexPath.row {
            cell.colorImageView.layer.borderWidth = 0
        } else { // 내가 고른 컬러 항목일 경우 boreder 효과
            cell.colorImageView.layer.borderWidth = 4
            cell.colorImageView.layer.borderColor = UIColor.gray.cgColor
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row
        userSelect = row // 내가 고른 항목이 뭔지 알기 위해서
        folderColor?(row) // FolderViewController로 값 전달
        
    }
    
}
