//
//  TimeViewController.swift
//  AssignmentReminders
//
//  Created by Jaehui Yu on 2/14/24.
//

import UIKit
import SnapKit

class TimeViewController: BaseViewController {
    let timePicker = UIDatePicker()
    var delegate: passDataDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        setNavigationBar()
    }
    
    override func configureHierarchy() {
        view.addSubview(timePicker)
    }
    
    override func configureView() {
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.datePickerMode = .time
        timePicker.locale = Locale(identifier: "ko-KR")
        timePicker.timeZone = .autoupdatingCurrent
        timePicker.minimumDate = Date()
    }
    
    override func configureConstraints() {
        timePicker.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
    
    func setNavigationBar() {
        navigationItem.title = "Time"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(leftBarButtonClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(rightBarButtonClicked))
    }
    
    @objc func leftBarButtonClicked() {
        dismiss(animated: true)
    }
    
    @objc func rightBarButtonClicked() {
        delegate?.passTimeData(time: timePicker.date)
        dismiss(animated: true)
    }
}
