//
//  BasicTableViewCell.swift
//  AssignmentReminders
//
//  Created by Jaehui Yu on 2/20/24.
//

import UIKit
import SnapKit
import RealmSwift

protocol BasicTableViewCellDelegate: AnyObject {
    func didSelectBasicItem(row: Int)
}

class BasicTableViewCell: BaseTableViewCell {
    // MARK: - Properties
    weak var delegate: BasicTableViewCellDelegate?
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
    var mainReminderList: [Results<Reminder>?] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    // MARK: - configure
    override func configureHierarchy() {
        contentView.addSubview(collectionView)
    }
    
    override func configureView() {
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(BasicCollectionViewCell.self, forCellWithReuseIdentifier: BasicCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemGroupedBackground
    }
    
    override func configureConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
            make.height.equalTo(300)
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension BasicTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    private static func configureCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 16
        let cellWidth = UIScreen.main.bounds.width - 8 - (spacing * 3)
        layout.itemSize = CGSize(width: cellWidth / 2, height: cellWidth / 4)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return BasicCellType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BasicCollectionViewCell.identifier, for: indexPath) as! BasicCollectionViewCell
        let row = indexPath.row
        let currentCell = BasicCellType.allCases[row]
        cell.configureCell(cell: currentCell)
        cell.countLabel.text = "\(mainReminderList[row]?.count ?? 0)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row
        delegate?.didSelectBasicItem(row: row)
    }
}
