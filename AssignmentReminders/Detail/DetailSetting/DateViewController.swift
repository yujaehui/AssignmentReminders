//
//  DateViewController.swift
//  AssignmentReminders
//
//  Created by Jaehui Yu on 2/14/24.
//

import UIKit
import SnapKit

class DateViewController: BaseViewController {
    // MARK: - Properties
    let datePicker = UIDatePicker()
    var date: ((Date) -> Void)?

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
    }
    
    // MARK: - configure
    override func configureHierarchy() {
        view.addSubview(datePicker)
    }
    
    override func configureView() {
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .dateAndTime
        datePicker.locale = Locale(identifier: "ko_KR")
        datePicker.timeZone = TimeZone(identifier: "Asia/Seoul")!
    }
    
    override func configureConstraints() {
        datePicker.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
}

// MARK: - Navigation
extension DateViewController {
    func setNavigationBar() {
        navigationItem.title = "Date"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonClicked))
    }
    
    @objc func cancelButtonClicked() {
        dismiss(animated: true)
    }
    
    @objc func saveButtonClicked() {
        date?(datePicker.date)
        dismiss(animated: true)
    }
}
