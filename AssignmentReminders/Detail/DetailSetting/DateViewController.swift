//
//  DateViewController.swift
//  AssignmentReminders
//
//  Created by Jaehui Yu on 2/14/24.
//

import UIKit
import SnapKit

class DateViewController: BaseViewController {
    let datePicker = UIDatePicker()
    var date: ((Date) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        setNavigationBar()
        print("date")
    }
    
    override func configureHierarchy() {
        view.addSubview(datePicker)
    }
    
    override func configureView() {
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.timeZone = .autoupdatingCurrent
        datePicker.minimumDate = Date()
    }
    
    override func configureConstraints() {
        datePicker.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
    
    func setNavigationBar() {
        navigationItem.title = "Date"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(leftBarButtonClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(rightBarButtonClicked))
    }
    
    @objc func leftBarButtonClicked() {
        dismiss(animated: true)
    }
    
    @objc func rightBarButtonClicked() {
        date?(datePicker.date)
        dismiss(animated: true)
    }
}
