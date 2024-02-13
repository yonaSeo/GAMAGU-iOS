//
//  SettingViewController.swift
//  Gamagu
//
//  Created by yona on 1/29/24.
//

import UIKit

final class SettingViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.separatorColor = .primary20
        tv.rowHeight = 56
        tv.sectionHeaderHeight = 48
        tv.backgroundColor = .clear
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        setupTableView()
        setupNavigationBar()
        setupUI()
    }
    
    func setupData() {
        CoreDataManager.shared.fetchUserSetting()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(
            SettingDatePickerTableViewCell.self, forCellReuseIdentifier: SettingDatePickerTableViewCell.identifier
        )
        tableView.register(
            SettingToggleSwitchTableViewCell.self, forCellReuseIdentifier: SettingToggleSwitchTableViewCell.identifier
        )
        tableView.register(
            SettingOptionMenuButtonTableViewCell.self,
            forCellReuseIdentifier: SettingOptionMenuButtonTableViewCell.identifier
        )
        tableView.register(
            SettingCategoryTableViewCell.self, forCellReuseIdentifier: SettingCategoryTableViewCell.identifier
        )
    }
    
    func setupNavigationBar() {
        navigationController?.setNavigationBarAppearce()
        navigationItem.title = "SETTING"
        navigationItem.largeTitleDisplayMode = .never
        
    }
    
    func setupUI() {
        view.backgroundColor = .primary60
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "시간 범위 설정"
        case 1: return "알림 설정"
        case 2: return "카테고리 설정"
        default: return ""
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = UIColor.font25
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 2
        case 1: return 3
        case 2: return 1
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingDatePickerTableViewCell.identifier, for: indexPath
            ) as? SettingDatePickerTableViewCell else { fatalError() }
            switch indexPath.row {
            case 0:
                cell.delegate = self
                cell.data = (
                    labelText: "알림 시작 시간",
                    date: CoreDataManager.shared.userSetting?.alarmStartTime ?? Date()
                )
                return cell
            case 1:
                cell.delegate = self
                cell.data = (
                    labelText: "알림 종료 시간",
                    date: CoreDataManager.shared.userSetting?.alarmEndTime ?? Date()
                )
                return cell
            default: fatalError()
            }
        case 1:
            switch indexPath.row {
            case 0:
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: SettingOptionMenuButtonTableViewCell.identifier, for: indexPath
                ) as? SettingOptionMenuButtonTableViewCell else { fatalError() }
                cell.delegate = self
                cell.data = (
                    labelText: "알림 타입",
                    selectedOption: CoreDataManager.shared.userSetting?.alarmContentType ?? "",
                    options: AlarmContentType.allCases.map { $0.rawValue },
                    isActive: nil
                )
                return cell
            case 1:
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: SettingToggleSwitchTableViewCell.identifier, for: indexPath
                ) as? SettingToggleSwitchTableViewCell else { fatalError() }
                cell.delegate = self
                cell.data = (
                    labelText: "알림음 여부",
                    isActive: CoreDataManager.shared.userSetting?.isAlarmSoundActive ?? true
                )
                return cell
            case 2:
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: SettingOptionMenuButtonTableViewCell.identifier, for: indexPath
                ) as? SettingOptionMenuButtonTableViewCell else { fatalError() }
                cell.delegate = self
                cell.data = (
                    labelText: "알림음 타입",
                    selectedOption: CoreDataManager.shared.userSetting?.alarmSoundType ?? "",
                    options: AlarmSoundType.allCases.map { $0.rawValue },
                    isActive: CoreDataManager.shared.userSetting?.isAlarmSoundActive
                )
                return cell
            default: fatalError()
            }
        case 2:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingCategoryTableViewCell.identifier, for: indexPath
            ) as? SettingCategoryTableViewCell else { fatalError() }
            cell.delegate = self
            cell.labelText = "카테고리 관리"; return cell
        default: fatalError()
        }
    }
}

extension SettingViewController: SettingButtonDelegate {
    func dateValueChanged(type: String, date: Date) {
        switch type {
        case "알림 시작 시간": CoreDataManager.shared.userSetting?.alarmStartTime = date;
        case "알림 종료 시간": CoreDataManager.shared.userSetting?.alarmEndTime = date;
        default: break
        }
        CoreDataManager.shared.save()
        CoreDataManager.shared.fetchUserSetting()
    }
    
    func toggleValueChanged(isActive: Bool) {
        guard let cell = tableView.cellForRow(at: IndexPath(row: 2, section: 1)) as? SettingOptionMenuButtonTableViewCell else { return }
        cell.toggleButtonState(isActive: isActive)
        
        CoreDataManager.shared.userSetting?.isAlarmSoundActive = isActive
        CoreDataManager.shared.save()
        CoreDataManager.shared.fetchUserSetting()
    }
    
    func optionMenuValueChnaged(type: String, selectedOption: String) {
        switch type {
        case "알림 타입": CoreDataManager.shared.userSetting?.alarmContentType = selectedOption
        case "알림음 종류": CoreDataManager.shared.userSetting?.alarmSoundType = selectedOption
        default: break
        }
        CoreDataManager.shared.save()
        CoreDataManager.shared.fetchUserSetting()
    }
    
    func categoryButtonTapped() {
        navigationController?.pushViewController(CategorySettingViewController(), animated: true)
    }
}

