//
//  DetailViewController.swift
//  AssignmentReminders
//
//  Created by Jaehui Yu on 2/14/24.
//

import UIKit
import SnapKit
import RealmSwift
import Toast
import PhotosUI

enum SectionType: String, CaseIterable {
    case Essential
    case Additional
}

enum EssentialCellType: String, CaseIterable {
    case Title
    case Notes
}

enum AdditionalCellType: String, CaseIterable {
    case Date
    case Tag
    case Flag
    case Priority
    case Image
    case List
    
    var image: UIImage? {
        switch self {
        case .Date:
            UIImage(systemName: "calendar.circle.fill")!.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        case .Tag:
            UIImage(systemName: "number.circle.fill")!.withTintColor(.darkGray, renderingMode: .alwaysOriginal)
        case .Flag:
            UIImage(systemName: "flag.circle.fill")!.withTintColor(.systemOrange, renderingMode: .alwaysOriginal)
        case .Priority:
            UIImage(systemName: "exclamationmark.circle.fill")!.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        case .Image:
            UIImage(systemName: "photo.circle.fill")!.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
        case .List:
            UIImage(systemName: "list.bullet.circle.fill")!.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)
        }
    }
}

enum AccessType {
    case Main
    case List
}

class DetailViewController: BaseViewController {
    let detailTableView = UITableView(frame: .zero, style: .insetGrouped)
    
    var folder: Folder!
    var listTitle = ""
    var listNotes: String?
    var date: Date?
    var dateString = ""
    var tag: String?
    var flag = false
    var priority: String?
    var photoImage: UIImage? {
        didSet {
            detailTableView.reloadData()
        }
    }
    
    let realm = try! Realm()
    let repository = ReminderRepository()
    
    var type: AccessType = .Main
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        NotificationCenter.default.addObserver(self, selector: #selector(tagNotification), name: NSNotification.Name("Tag"), object: nil)
        PHAsset.fetchAssets(with: nil)
    }
    
    override func configureHierarchy() {
        view.addSubview(detailTableView)
    }
    
    override func configureView() {
        detailTableView.dataSource = self
        detailTableView.delegate = self
        detailTableView.register(EssentialTableViewCell.self, forCellReuseIdentifier: EssentialTableViewCell.identifier)
        detailTableView.register(DateTableViewCell.self, forCellReuseIdentifier: DateTableViewCell.identifier)
        detailTableView.register(FlagTableViewCell.self, forCellReuseIdentifier: FlagTableViewCell.identifier)
        detailTableView.register(TagTableViewCell.self, forCellReuseIdentifier: TagTableViewCell.identifier)
        detailTableView.register(PriorityTableViewCell.self, forCellReuseIdentifier: PriorityTableViewCell.identifier)
        detailTableView.register(ImageTableViewCell.self, forCellReuseIdentifier: ImageTableViewCell.identifier)
        detailTableView.register(DetailListTableViewCell.self, forCellReuseIdentifier: DetailListTableViewCell.identifier)
        detailTableView.rowHeight = UITableView.automaticDimension
    }
    
    override func configureConstraints() {
        detailTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setNavigationBar() {
        navigationItem.title = "Detail"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonClicked))
    }
    
    @objc func cancelButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func saveButtonClicked() {
        if listTitle.isEmpty {
            view.makeToast("Title을 입력해주세요", position: .bottom)
        } else {
            let data = Reminder(title: listTitle, notes: listNotes, date: date, tag: tag, flag: flag, priority: priority, isCompleted: false, isClosed: nil, CreationDate: Date())
            do {
                try realm.write {
                    folder.reminder.append(data)
                }
            } catch {
                print(error)
            }
            if let image = photoImage {
                saveImageToDocument(image: image, fileName: "\(data.id)")
            }
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func tagNotification(notification: NSNotification) {
        guard let tagList = notification.userInfo?["tagList"] as? [String] else { return }
        if tagList.count == 1 {
            tag = "#" + (tagList.first ?? "")
        } else {
            tag = "#" + (tagList.first ?? "") + "외 \(String(describing: tagList.count-1))개의 tag"
        }
        detailTableView.reloadData()
    }
    
    @objc func dateSetting() {
        let vc = DateViewController()
        vc.date = { [self] value in
            date = value
            dateString = Utility.shared.dateFormatter(date: value)
            detailTableView.reloadData()
        }
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
    
    @objc func tagSetting() {
        let vc = TagViewController()
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
    
    @objc func imageSetting() {
//        let vc = UIImagePickerController()
//        vc.allowsEditing = true
//        vc.delegate = self
//        present(vc, animated: true)
        
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 3
        configuration.filter = .any(of: [.images, .videos])
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc func listSetting() {
        print(#function)
        let vc = DetailListViewController()
        vc.list = { [self] value in
            folder = value
            detailTableView.reloadData()
        }
        present(vc, animated: true)
    }
}

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch SectionType.allCases[section] {
        case .Essential: return EssentialCellType.allCases.count
        case .Additional: return AdditionalCellType.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch SectionType.allCases[indexPath.section] {
        case .Essential:
            switch EssentialCellType.allCases[indexPath.row] {
            case .Title:
                let cell = tableView.dequeueReusableCell(withIdentifier: EssentialTableViewCell.identifier, for: indexPath) as! EssentialTableViewCell
                cell.userTextField.placeholder = EssentialCellType.Title.rawValue
                cell.type = EssentialCellType.Title
                cell.listTitle = { value in
                    self.listTitle = value
                }                
                cell.selectionStyle = .none
                return cell
            case .Notes:
                let cell = tableView.dequeueReusableCell(withIdentifier: EssentialTableViewCell.identifier, for: indexPath) as! EssentialTableViewCell
                cell.userTextField.placeholder = EssentialCellType.Notes.rawValue
                cell.type = EssentialCellType.Notes
                cell.listNotes = { value in
                    self.listNotes = value
                }
                cell.selectionStyle = .none
                return cell
            }
        case .Additional:
            switch AdditionalCellType.allCases[indexPath.row] {
            case .Date:
                let cell = tableView.dequeueReusableCell(withIdentifier: DateTableViewCell.identifier, for: indexPath) as! DateTableViewCell
                cell.iconImageView.image = AdditionalCellType.Date.image
                cell.targetLabel.text = AdditionalCellType.Date.rawValue
                cell.settingButton.addTarget(self, action: #selector(dateSetting), for: .touchUpInside)
                cell.settingLabel.text = dateString
                cell.selectionStyle = .none
                return cell
            case .Tag:
                let cell = tableView.dequeueReusableCell(withIdentifier: TagTableViewCell.identifier, for: indexPath) as! TagTableViewCell
                cell.iconImageView.image = AdditionalCellType.Tag.image
                cell.targetLabel.text = AdditionalCellType.Tag.rawValue
                cell.settingButton.addTarget(self, action: #selector(tagSetting), for: .touchUpInside)
                cell.settingLabel.text = tag
                cell.selectionStyle = .none
                return cell
            case .Flag:
                let cell = tableView.dequeueReusableCell(withIdentifier: FlagTableViewCell.identifier, for: indexPath) as! FlagTableViewCell
                cell.iconImageView.image = AdditionalCellType.Flag.image
                cell.targetLabel.text = AdditionalCellType.Flag.rawValue
                cell.flag = { value in
                    self.flag = value
                }
                cell.selectionStyle = .none
                return cell
            case .Priority:
                let cell = tableView.dequeueReusableCell(withIdentifier: PriorityTableViewCell.identifier, for: indexPath) as! PriorityTableViewCell
                cell.iconImageView.image = AdditionalCellType.Priority.image
                cell.targetLabel.text = AdditionalCellType.Priority.rawValue
                cell.settingLabel.text = PriorityMenu.None.rawValue
                cell.priority = { value in
                    self.priority = value
                }
                cell.selectionStyle = .none
                return cell
            case .Image:
                let cell = tableView.dequeueReusableCell(withIdentifier: ImageTableViewCell.identifier, for: indexPath) as! ImageTableViewCell
                cell.iconImageView.image = AdditionalCellType.Image.image
                cell.targetLabel.text = AdditionalCellType.Image.rawValue
                cell.settingImageView.image = photoImage
                cell.settingButton.addTarget(self, action: #selector(imageSetting), for: .touchUpInside)
                cell.selectionStyle = .none
                return cell
            case .List:
                let cell = tableView.dequeueReusableCell(withIdentifier: DetailListTableViewCell.identifier, for: indexPath) as! DetailListTableViewCell
                cell.iconImageView.image = AdditionalCellType.List.image
                cell.targetLabel.text = AdditionalCellType.List.rawValue
                cell.settingLabel.text = folder?.folderName
                cell.settingButton.addTarget(self, action: #selector(listSetting), for: .touchUpInside)
                if type == .Main {
                    cell.isHidden = false
                } else {
                    cell.isHidden = true
                }
                return cell
            }
        }
    }
}

extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            photoImage = pickedImage
        }
        dismiss(animated: true)
    }
}

extension DetailViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                DispatchQueue.main.async {
                    self.photoImage = image as? UIImage
                }
            }
        }
        picker.dismiss(animated: true)
    }
}
