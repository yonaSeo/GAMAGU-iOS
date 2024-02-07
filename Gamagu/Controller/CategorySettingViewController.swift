//
//  CategorySettingViewController.swift
//  Gamagu
//
//  Created by yona on 2/6/24.
//

import UIKit

class CategorySettingViewController: UIViewController {
    private var dummyItemCategories = [
        ItemCategory(name: "카테고리 1", alarmCycleDay: 7, alarmCount: 3),
        ItemCategory(name: "카테고리 2", alarmCycleDay: 1, alarmCount: 1),
        ItemCategory(name: "카테고리 3", alarmCycleDay: 30, alarmCount: 9),
    ]
    
    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.separatorColor = .primary20
        tv.rowHeight = 56
        tv.backgroundColor = .clear
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupTableView()
        setupUI()
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .accent100
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: UIAction(handler: { [weak self] _ in
            let alert = UIAlertController(title: "카테고리 추가", message: "카테고리 이름을 입력하세요", preferredStyle: .alert)
            let yes = UIAlertAction(title: "확인", style: .default, handler: { [weak alert, self] _ in
                guard let text = alert?.textFields?[0].text else { return }
                self?.dummyItemCategories.append(ItemCategory(name: text, alarmCycleDay: 1, alarmCount: 1))
                self?.tableView.reloadData()
            })
            let no = UIAlertAction(title: "취소", style: .cancel)
            
            alert.addTextField { [weak self] tf in
                tf.placeholder = "ex) D-Day3, 영단어"
                tf.delegate = self
            }
            alert.addAction(yes)
            alert.addAction(no)
            
            self?.present(alert, animated: true)
        }))
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CategorySettingNameTableViewCell.self, forCellReuseIdentifier: CategorySettingNameTableViewCell.identifier)
        tableView.register(CategorySettingAlarmCountTableViewCell.self, forCellReuseIdentifier: CategorySettingAlarmCountTableViewCell.identifier)
        tableView.register(CategorySettingDeleteTableViewCell.self, forCellReuseIdentifier: CategorySettingDeleteTableViewCell.identifier)
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

extension CategorySettingViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dummyItemCategories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CategorySettingNameTableViewCell.identifier, for: indexPath
            ) as? CategorySettingNameTableViewCell else { fatalError() }
            cell.delegate = self
            cell.data = (labelText: "이름", categoryName: dummyItemCategories[indexPath.section].name)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CategorySettingAlarmCountTableViewCell.identifier, for: indexPath
            ) as? CategorySettingAlarmCountTableViewCell else { fatalError() }
            cell.delegate = self
            cell.data = (
                labelText: "알림 사이클",
                cycle: dummyItemCategories[indexPath.section].alarmCycleString,
                count: dummyItemCategories[indexPath.section].alarmCount.description
            )
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CategorySettingDeleteTableViewCell.identifier, for: indexPath
            ) as? CategorySettingDeleteTableViewCell else { fatalError() }
            return cell
        default: fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            let alert = UIAlertController(
                title: "카테고리 삭제", message: "해당 카테고리에 속한\n모든 아이템이 삭제됩니다.\n\n정말 삭제하시겠습니까?", preferredStyle: .alert
            )
            let yes = UIAlertAction(title: "삭제", style: .destructive, handler: { [weak self] _ in
                self?.dummyItemCategories.remove(at: indexPath.section)
                tableView.reloadData()
            })
            let no = UIAlertAction(title: "취소", style: .cancel)
            alert.addAction(yes)
            alert.addAction(no)
            
            present(alert, animated: true)
        }
    }
}

extension CategorySettingViewController: CategorySettingButtonDelegate {
    func categorySettingNameChanged() {
        print("name button tapped")
    }
    
    func categorySettingAlarmCountButtonTapped() {
        print("alarm count button tapped")
    }
    
    func categorySettingAlarmCycleButtonTapped() {
        print("alarm cycle button tapped")
    }
}

extension CategorySettingViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        return (text.count + string.count - range.length) <= 10
    }
}
