//
//  SettingViewController.swift
//  Gamagu
//
//  Created by yona on 1/29/24.
//

import UIKit

final class SettingViewController: UIViewController {
    private var dummyItems = [
        Item(category: "카테고리 1", title: "첫 번째 제목", content: "첫 번째 내용입니다."),
        Item(category: "카테고리 1", title: "두 번째 제목", content: "두 번째 내용입니다."),
        Item(category: "카테고리 1", title: "세 번째 제목", content: "세 번째 내용입니다."),
        Item(category: "카테고리 2", title: "첫 번째 제목", content: "첫 번째 내용입니다."),
        Item(category: "카테고리 2", title: "두 번째 제목", content: "두 번째 내용입니다."),
        Item(category: "카테고리 2", title: "세 번째 제목", content: "세 번째 내용입니다."),
        Item(category: "카테고리 2", title: "네 번째 제목", content: "네 번째 내용입니다."),
        Item(category: "카테고리 3", title: "첫 번째 제목", content: "첫 번째 내용입니다."),
        Item(category: "카테고리 3", title: "두 번째 제목", content: "두 번째 내용입니다."),
        Item(category: "카테고리 3", title: "세 번째 제목", content: "세 번째 내용입니다."),
    ]
    
    private lazy var categories: [(name: String, items: [Item])] = {
        var arr: [(name: String, items: [Item])] = []
        dummyItems.forEach { item in
            var idx = 0
            arr.enumerated().contains {
                idx = $0.offset;
                return $0.element.name.contains(item.category)
            }
            ? arr[idx].items.append(item)
            : arr.append((name: item.category, items: [item]))
        }
        return arr
    }()
    
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
        
        setupTableView()
        setupNavigationBar()
        setupUI()
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
                cell.text = "알림 시작 시간"; return cell
            case 1:
                cell.delegate = self
                cell.text = "알림 종료 시간"; return cell
            default: fatalError()
            }
        case 1:
            switch indexPath.row {
            case 0:
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: SettingOptionMenuButtonTableViewCell.identifier, for: indexPath
                ) as? SettingOptionMenuButtonTableViewCell else { fatalError() }
                cell.delegate = self
                cell.data = (text: "알림 타입", options: ["제목 내용 모두", "제목만", "내용만"]); return cell
            case 1:
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: SettingToggleSwitchTableViewCell.identifier, for: indexPath
                ) as? SettingToggleSwitchTableViewCell else { fatalError() }
                cell.delegate = self
                cell.text = "알림음 여부"; return cell
            case 2:
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: SettingOptionMenuButtonTableViewCell.identifier, for: indexPath
                ) as? SettingOptionMenuButtonTableViewCell else { fatalError() }
                cell.delegate = self
                cell.data = (text: "알림음 종류", options: ["까마귀 1", "까마귀 2", "까마귀 3"]); return cell
            default: fatalError()
            }
        case 2:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingCategoryTableViewCell.identifier, for: indexPath
            ) as? SettingCategoryTableViewCell else { fatalError() }
            cell.delegate = self
            cell.text = "카테고리 관리"; return cell
        default: fatalError()
        }
    }
}

extension SettingViewController: SettingButtonDelegate {
    func dateValueChanged() {
        print("date changed")
    }
    
    func toggleValueChanged() {
        print("toggle tapped")
        guard let cell = tableView.cellForRow(at: IndexPath(row: 2, section: 1)) as? SettingOptionMenuButtonTableViewCell else { return }
        cell.toggleButtonState()
    }
    
    func optionMenuValueChnaged() {
        print("option changed")
    }
    
    func categoryButtonTapped() {
        print("category button tapped")
        navigationController?.pushViewController(CategorySettingViewController(), animated: true)
    }
}

