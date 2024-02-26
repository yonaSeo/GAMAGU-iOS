//
//  SettingViewController.swift
//  Gamagu
//
//  Created by yona on 1/29/24.
//

import UIKit
import AVFoundation
import AudioToolbox

final class SettingViewController: UIViewController {
    
    private var audioPlayer: AVAudioPlayer?
    
    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.separatorColor = .primary40
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
                    date: CoreDataManager.shared.getUserSetting().alarmStartTime ?? Date()
                )
                return cell
            case 1:
                cell.delegate = self
                cell.data = (
                    labelText: "알림 종료 시간",
                    date: CoreDataManager.shared.getUserSetting().alarmEndTime ?? Date()
                )
                return cell
            default: fatalError()
            }
        case 1:
            switch indexPath.row {
            case 0:
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: SettingToggleSwitchTableViewCell.identifier, for: indexPath
                ) as? SettingToggleSwitchTableViewCell else { fatalError() }
                cell.delegate = self
                cell.data = (
                    labelText: "알림음 여부",
                    isActive: CoreDataManager.shared.getUserSetting().isAlarmSoundActive
                )
                return cell
            case 1:
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: SettingOptionMenuButtonTableViewCell.identifier, for: indexPath
                ) as? SettingOptionMenuButtonTableViewCell else { fatalError() }
                cell.delegate = self
                cell.data = (
                    labelText: "알림음 종류",
                    selectedOption: CoreDataManager.shared.getUserSetting().alarmSoundType ?? "",
                    options: AlarmSoundType.allCases.map { $0.rawValue },
                    isActive: CoreDataManager.shared.getUserSetting().isAlarmSoundActive
                )
                return cell
            case 2:
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: SettingOptionMenuButtonTableViewCell.identifier, for: indexPath
                ) as? SettingOptionMenuButtonTableViewCell else { fatalError() }
                cell.delegate = self
                cell.data = (
                    labelText: "알림 형식",
                    selectedOption: CoreDataManager.shared.getUserSetting().alarmContentType ?? "",
                    options: AlarmContentType.allCases.map { $0.rawValue },
                    isActive: nil
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
        guard let startTimecell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? SettingDatePickerTableViewCell else { return }
        guard let endTimecell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? SettingDatePickerTableViewCell else { return }
        let transition: CATransition = CATransition()
        
        HapticManager.shared.selectionChanged()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .fade
        transition.subtype = .none
        self.view.window!.layer.add(transition, forKey: nil)
        
        dismiss(animated: false)
        
        // print(startTimecell.datePicker.date.convertedDate)
        // print(endTimecell.datePicker.date.convertedDate)
        
        let start = Calendar.current.dateComponents([.hour, .minute], from: startTimecell.datePicker.date)
        let end = Calendar.current.dateComponents([.hour, .minute], from: endTimecell.datePicker.date)
        
        if start.hour! > end.hour! || (start.hour! == end.hour! && start.minute! >= end.minute!) {
            let alert = UIAlertController(
                title: "알람 시간 입력 에러", message: "종료 시간이 시작 시간보다 앞서거나 같을 수 없습니다.", preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            present(alert, animated: true)
            
            switch type {
            case "알림 시작 시간":
                let initialDate = Calendar.current.date(from: DateComponents(hour: 0, minute: 0))!
                startTimecell.datePicker.date = initialDate
                CoreDataManager.shared.getUserSetting().alarmStartTime = initialDate
            case "알림 종료 시간":
                let initialDate = Calendar.current.date(from: DateComponents(hour: 23, minute: 45))!
                endTimecell.datePicker.date = initialDate
                CoreDataManager.shared.getUserSetting().alarmEndTime = initialDate;
            default: break
            }
        } else {
            switch type {
            case "알림 시작 시간": CoreDataManager.shared.getUserSetting().alarmStartTime = date;
            case "알림 종료 시간": CoreDataManager.shared.getUserSetting().alarmEndTime = date;
            default: break
            }
        }
        
        CoreDataManager.shared.save()
        CoreDataManager.shared.fetchUserSetting()
        
        PushNotificationManager.shared.refreshAllPushNotifications()
    }
    
    func toggleValueChanged(isActive: Bool) {
        guard let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as? SettingOptionMenuButtonTableViewCell else { return }
        
        HapticManager.shared.selectionChanged()
        cell.toggleButtonState(isActive: isActive)
        
        CoreDataManager.shared.getUserSetting().isAlarmSoundActive = isActive
        CoreDataManager.shared.save()
        CoreDataManager.shared.fetchUserSetting()
        
        PushNotificationManager.shared.refreshAllPushNotifications()
    }
    
    func optionMenuValueChnaged(type: String, selectedOption: String) {
        HapticManager.shared.selectionChanged()
        
        switch type {
        case "알림 형식": CoreDataManager.shared.getUserSetting().alarmContentType = selectedOption
        case "알림음 종류": CoreDataManager.shared.getUserSetting().alarmSoundType = selectedOption
        default: break
        }
        CoreDataManager.shared.save()
        CoreDataManager.shared.fetchUserSetting()
        
        
        PushNotificationManager.shared.refreshAllPushNotifications()
        
        if type == "알림음 종류" {
            if selectedOption != "기본음" {
                let url = Bundle.main.url(forResource: AlarmSoundType.makeSoundName(type: selectedOption), withExtension: "wav")
                if let url = url {
                    do {
                        audioPlayer = try AVAudioPlayer(contentsOf: url)
                        audioPlayer?.prepareToPlay()
                        audioPlayer?.play()
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    func categoryButtonTapped() {
        HapticManager.shared.hapticImpact(style: .light)
        navigationController?.pushViewController(CategorySettingViewController(), animated: true)
    }
}

