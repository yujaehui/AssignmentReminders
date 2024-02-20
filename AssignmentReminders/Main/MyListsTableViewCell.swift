//
//  MyListsTableViewCell.swift
//  AssignmentReminders
//
//  Created by Jaehui Yu on 2/20/24.
//

import UIKit
import RealmSwift

class MyListsTableViewCell: BaseTableViewCell {
    let folderImageView = UIImageView()
    let folderNameLabel = UILabel()
    let listCountLabel = UILabel()
    let goListButton = UIButton()

    override func configureHierarchy() {
        contentView.addSubview(folderImageView)
        contentView.addSubview(folderNameLabel)
        contentView.addSubview(listCountLabel)
        contentView.addSubview(goListButton)
    }

    override func configureView() {
        folderImageView.image = UIImage(systemName: "list.bullet.circle.fill")
        folderNameLabel.text = "Reminders"
        listCountLabel.text = "0"
        listCountLabel.textAlignment = .right
        goListButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        goListButton.contentHorizontalAlignment = .trailing

    }

    override func configureConstraints() {
        folderImageView.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView).inset(10)
            make.leading.equalTo(contentView).inset(10)
            make.size.equalTo(30)
        }

        folderNameLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView).inset(10)
            make.leading.equalTo(folderImageView.snp.trailing).offset(10)
            make.height.equalTo(30)
        }

        listCountLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView).inset(10)
            make.leading.equalTo(folderNameLabel.snp.trailing).offset(10)
            make.trailing.equalTo(contentView).inset(30)
            make.size.equalTo(30)
        }

        goListButton.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView).inset(10)
            make.horizontalEdges.equalTo(contentView).inset(10)
            make.height.equalTo(30)
        }
    }
}

//protocol MyListsTableViewCellDelegate: AnyObject {
//    func didSelectMyListsItem(row: Int)
//}
//
//class MyListsTableViewCell: BaseTableViewCell {
//    weak var delegate: MyListsTableViewCellDelegate?
//    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewLayout())
//    var folder: Results<Folder>!
//    
//    override func configureHierarchy() {
//        contentView.addSubview(collectionView)
//    }
//    
//    override func configureView() {
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        collectionView.register(MyListsCollectionViewCell.self, forCellWithReuseIdentifier: MyListsCollectionViewCell.identifier)
//        
//    }
//    
//    override func configureConstraints() {
//        collectionView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//    }
//}
//
//extension MyListsTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
//    private static func configureCollectionViewLayout() -> UICollectionViewLayout {
//        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
//        let layout = UICollectionViewCompositionalLayout.list(using: config)
//        return layout
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return folder.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyListsCollectionViewCell.identifier, for: indexPath) as! MyListsCollectionViewCell
//        let row = folder[indexPath.row]
//        cell.folderImageView.tintColor = FolderColor.allCases[row.folderColor].color
//        cell.folderNameLabel.text = row.folderName
//        cell.listCountLabel.text = "\(row.reminder.count)"
//        cell.goListButton.tag = indexPath.row
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let row = indexPath.row
//        delegate?.didSelectMyListsItem(row: row)
//    }
//}
