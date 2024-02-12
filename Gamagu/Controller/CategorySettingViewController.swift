//
//  CategorySettingViewController.swift
//  Gamagu
//
//  Created by yona on 2/6/24.
//

import UIKit

class CategorySettingViewController: UIViewController {
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
                CoreDataManager.shared.setCategory(name: text)
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
        tableView.register(CategorySettingAlarmActivationTableViewCell.self, forCellReuseIdentifier: CategorySettingAlarmActivationTableViewCell.identifier)
        tableView.register(CategorySettingAlarmCountTableViewCell.self, forCellReuseIdentifier: CategorySettingAlarmCountTableViewCell.identifier)
        tableView.register(CategorySettingPositionTableViewCell.self, forCellReuseIdentifier: CategorySettingPositionTableViewCell.identifier)
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
        return CoreDataManager.shared.getAllCategories().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CategorySettingNameTableViewCell.identifier, for: indexPath
            ) as? CategorySettingNameTableViewCell else { fatalError() }
            cell.delegate = self
            cell.data = (
                labelText: "이름",
                category: CoreDataManager.shared.getAllCategories()[indexPath.section]
            )
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CategorySettingAlarmActivationTableViewCell.identifier, for: indexPath
            ) as? CategorySettingAlarmActivationTableViewCell else { fatalError() }
            cell.delegate = self
            cell.data = (
                labelText: "알림 활성화",
                category: CoreDataManager.shared.getAllCategories()[indexPath.section],
                section: indexPath.section
            )
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CategorySettingAlarmCountTableViewCell.identifier, for: indexPath
            ) as? CategorySettingAlarmCountTableViewCell else { fatalError() }
            cell.delegate = self
            cell.data = (
                labelText: "알림 사이클",
                category: CoreDataManager.shared.getAllCategories()[indexPath.section]
            )
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CategorySettingPositionTableViewCell.identifier, for: indexPath
            ) as? CategorySettingPositionTableViewCell else { fatalError() }
            cell.delegate = self
            cell.data = (
                labelText: "위치",
                category: CoreDataManager.shared.getAllCategories()[indexPath.section],
                section: indexPath.section
            )
            return cell
        case 4:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CategorySettingDeleteTableViewCell.identifier, for: indexPath
            ) as? CategorySettingDeleteTableViewCell else { fatalError() }
            return cell
        default: fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 4 {
            let alert = UIAlertController(
                title: "카테고리 삭제", message: "해당 카테고리에 속한\n모든 아이템이 삭제됩니다.\n\n정말 삭제하시겠습니까?", preferredStyle: .alert
            )
            let yes = UIAlertAction(title: "삭제", style: .destructive, handler: { [weak self] _ in
                let category = CoreDataManager.shared.getAllCategories()[indexPath.section]
                CoreDataManager.shared.deleteCategory(deleteCategory: category)
                self?.tableView.reloadData()
            })
            let no = UIAlertAction(title: "취소", style: .cancel)
            alert.addAction(yes)
            alert.addAction(no)
            
            present(alert, animated: true)
        }
    }
}

extension CategorySettingViewController: CategorySettingButtonDelegate {
    func categorySettingActivationToggleValueChanged(section: Int, isActive: Bool) {
        guard let cell = tableView.cellForRow(at: IndexPath(row: 2, section: section)) as? CategorySettingAlarmCountTableViewCell else { return }
        cell.toggleButtonState(isActive: isActive)
        
        // tableView.reloadData()
    }
    
    func categorySettingNameChanged() {
        tableView.reloadData()
    }
    
    func categorySettingAlarmCycleButtonTapped() {
        tableView.reloadData()
    }
    
    func categorySettingAlarmCountButtonTapped() {
        tableView.reloadData()
    }
    
    func categorySettingPositionUpButtonTapped(section: Int) {
        guard let sourceCell = tableView.cellForRow(at: IndexPath(row: 2, section: section))
                as? CategorySettingAlarmCountTableViewCell else { return }
        guard let targetCell = tableView.cellForRow(at: IndexPath(row: 2, section: section - 1))
                as? CategorySettingAlarmCountTableViewCell else { return }
        
        let temp = sourceCell.data?.category.orderNumber
        sourceCell.data?.category.orderNumber = targetCell.data?.category.orderNumber ?? 0
        targetCell.data?.category.orderNumber = temp ?? 0
        
        CoreDataManager.shared.save()
        CoreDataManager.shared.fetchCategories()
        
        tableView.reloadData()
    }
    
    func categorySettingPositionDownButtonTapped(section: Int) {
        guard let sourceCell = tableView.cellForRow(at: IndexPath(row: 2, section: section))
                as? CategorySettingAlarmCountTableViewCell else { return }
        guard let targetCell = tableView.cellForRow(at: IndexPath(row: 2, section: section + 1))
                as? CategorySettingAlarmCountTableViewCell else { return }
        
        let temp = sourceCell.data?.category.orderNumber
        sourceCell.data?.category.orderNumber = targetCell.data?.category.orderNumber ?? 0
        targetCell.data?.category.orderNumber = temp ?? 0
        
        CoreDataManager.shared.save()
        CoreDataManager.shared.fetchCategories()
        
        tableView.reloadData()
    }
}

extension CategorySettingViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        return (text.count + string.count - range.length) <= 10
    }
}
