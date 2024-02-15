//
//  TagViewController.swift
//  AssignmentReminders
//
//  Created by Jaehui Yu on 2/14/24.
//

import UIKit
import SnapKit
import TagListView
import Toast

class TagViewController: BaseViewController, UITextFieldDelegate, TagListViewDelegate {
    let tagListView = TagListView()
    let tagTextField = UITextField()
    
    var tagList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        setNavigationBar()
    }
    
    override func configureHierarchy() {
        view.addSubview(tagListView)
        view.addSubview(tagTextField)
    }
    
    override func configureView() {
        tagListView.delegate = self
        tagListView.tagBackgroundColor = .systemBlue
        tagListView.textColor = .white
        tagListView.textFont = .systemFont(ofSize: 20)
        tagListView.cornerRadius = 10
        tagListView.paddingX = 10
        tagListView.paddingY = 5
        tagListView.enableRemoveButton = true
        tagListView.removeButtonIconSize = 10
        
        tagTextField.delegate = self
        tagTextField.placeholder = "Add New Tag..."
        tagTextField.becomeFirstResponder()
    }
    
    override func configureConstraints() {
        tagTextField.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(50)
        }
        
        tagListView.snp.makeConstraints { make in
            make.top.equalTo(tagTextField.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(200)
        }
    }
    
    func setNavigationBar() {
        navigationItem.title = "Tag"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(leftBarButtonClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(rightBarButtonClicked))
        if tagListView.tagViews.count == 0 {
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    @objc func leftBarButtonClicked() {
        dismiss(animated: true)
    }
    
    @objc func rightBarButtonClicked() {
        NotificationCenter.default.post(name: NSNotification.Name("Tag"), object: nil, userInfo: ["tagList":tagList])
        dismiss(animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        if string == " " || string == "\n" {
            if tagListView.tagViews.count >= 10 {
                view.makeToast("태그는 최대 10개까지만 가능합니다.", position: .center)
            } else if text.isEmpty == false {
                tagListView.removeTag(text)
                tagListView.insertTag(text, at: 0)
                tagList.removeAll { $0 == text }
                tagList.insert(text, at: 0)
            }
            textField.text = nil
            navigationItem.rightBarButtonItem?.isEnabled = true
            return false
        } else if text.count > 9 {
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            let trimmedString = String(newString.prefix(9))
            textField.text = trimmedString
            view.makeToast("태그는 10글자 이내로 작성해주세요.", position: .center)
        }
        return true
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        sender.removeTag(title)
        if tagListView.tagViews.count == 0 {
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
}
