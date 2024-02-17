//
//  InputFormViewController.swift
//  Gamagu
//
//  Created by yona on 2/2/24.
//

import UIKit

final class AddFormViewController: UIViewController {
    weak var delegate: AddFormButtonDelegate?
    
    var item: Item? {
        didSet { setupData() }
    }
    
    private let labelMaker = { (text: String) in
        let label = UILabel()
        label.font = UIFont(name: "BlackHanSans-Regular", size: 28)
        label.textColor = .font75
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private lazy var labelTuple = (
        title: labelMaker("제목"),
        category: labelMaker("카테고리"),
        content: labelMaker("내용")
    )
    
    private let innerStackMaker = { (spacing: CGFloat) in
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fill
        sv.spacing = spacing
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }
    
    private lazy var innerStackTuple = (
        title: innerStackMaker(4),
        category: innerStackMaker(4),
        content: innerStackMaker(4),
        buttons: innerStackMaker(12)
    )
    
    private let categoryButton: UIButton = {
        let button = UIButton()
        if #available(iOS 15.0, *) {
            button.configuration = UIButton.Configuration.filled()
            button.configuration?.imagePadding = 8
            button.configuration?.image = UIImage(systemName: "chevron.down")?.applyingSymbolConfiguration(.init(scale: .medium))
            button.configuration?.imagePlacement = .trailing
            button.configuration?.baseForegroundColor = .font25
            button.configuration?.baseBackgroundColor = .primary40
        } else {
            button.imageEdgeInsets = .init(top: 0, left: 8, bottom: 0, right: 0)
            button.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            button.semanticContentAttribute = .forceRightToLeft
            button.tintColor = .font25
            button.setBackgroundColor(.primary40, for: .normal)
        }
        button.setTitle("카테고리를 선택하세요", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .thin)
        button.setTitleColor(.font25, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var titleTextField: UITextField = { [weak self] in
        let tf = UITextField()
        tf.delegate = self
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        
        tf.attributedPlaceholder = .init(
            string: "제목을 입력하세요",
            attributes: [
                .font: UIFont.systemFont(ofSize: 20, weight: .thin),
                .foregroundColor: UIColor.font25
            ]
        )
        tf.addLeftPadding()
        tf.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        tf.backgroundColor = .primary40
        tf.textColor = .font100
        tf.layer.cornerRadius = 10
        tf.layer.masksToBounds = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private lazy var contentTextView: UITextView = { [weak self] in
        let tv = UITextView()
        tv.delegate = self
        tv.autocorrectionType = .default
        tv.spellCheckingType = .no
        
        tv.text = "내용을 입력하세요"
        tv.font = UIFont.systemFont(ofSize: 20, weight: .thin)
        tv.textColor = .font25
        tv.textContainerInset = .init(top: 16, left: 12, bottom: 16, right: 12)
        tv.backgroundColor = .primary40
        tv.layer.cornerRadius = 10
        tv.layer.masksToBounds = true
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let letterCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0/200"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .font25
        label.textAlignment = .right
        return label
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("저장", for: .normal)
        button.titleLabel?.font = UIFont(name: "BlackHanSans-Regular", size: 24)
        button.setTitleColor(.font100, for: .normal)
        button.backgroundColor = .accent100
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addAction(UIAction(identifier: UIAction.Identifier("add"), handler: { [weak self] _ in
            guard let self else { return }
            guard self.checkValidation() else { return }
            
            HapticManager.shared.hapticImpact(style: .rigid)
            let category = CoreDataManager.shared.getCategory(name: self.categoryButton.titleLabel?.text ?? "")
            CoreDataManager.shared.setItem(
                title: self.titleTextField.text ?? "",
                content: self.contentTextView.text ?? "",
                category: category
            )
            CoreDataManager.shared.fetchItems()
            CoreDataManager.shared.fetchCategories()
            PushNotificationManager.shared.setPushNotificationsOfCategory(category: category)
            self.delegate?.saveButtonTapped()
            self.dismiss(animated: true)
        }), for: .touchUpInside)
        return button
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("삭제", for: .normal)
        button.titleLabel?.font = UIFont(name: "BlackHanSans-Regular", size: 24)
        button.setTitleColor(.font50, for: .normal)
        button.backgroundColor = .primary60
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.isEnabled = false
        button.addAction(UIAction(handler: { [weak self] _ in
            let alert = UIAlertController(
                title: "삭제", message: "정말 삭제하시겠습니까?", preferredStyle: .alert
            )
            let yes = UIAlertAction(title: "삭제", style: .destructive, handler: { [weak self] _ in
                HapticManager.shared.selectionChanged()
                let category = CoreDataManager.shared.getCategory(name: self?.item?.category?.name ?? "")
                CoreDataManager.shared.deleteItem(
                    deleteItem: CoreDataManager.shared.getItem(title: self?.item?.title ?? "")
                )
                CoreDataManager.shared.fetchItems()
                CoreDataManager.shared.fetchCategories()
                PushNotificationManager.shared.removePushNotificationOfItem(
                    itemTitle: self?.item?.title ?? "", category: category
                )
                self?.delegate?.deleteButtonTapped()
                self?.dismiss(animated: true)
            })
            let no = UIAlertAction(title: "취소", style: .cancel)
            alert.addAction(yes)
            alert.addAction(no)
            
            HapticManager.shared.hapticImpact(style: .heavy)
            self?.present(alert, animated: true)
        }), for: .touchUpInside)
        return button
    }()
    
    private let outerStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fill
        sv.spacing = 24
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCategoryButton()
        setupUI()
    }
    
    func setupData() {
        categoryButton.setTitle(item?.category?.name, for: .normal)
        categoryButton.setTitleColor(.font100, for: .normal)
        
        titleTextField.text = item?.title
        
        contentTextView.text = item?.content
        contentTextView.textColor = .font100
        contentTextView.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        
        let attributedString = setAttributedString(textView: contentTextView)
        letterCountLabel.attributedText = attributedString
        
        saveButton.setTitle("수정", for: .normal)
        saveButton.removeAction(identifiedBy: UIAction.Identifier("add"), for: .touchUpInside)
        saveButton.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            guard self.checkValidation() else { return }
            
            HapticManager.shared.hapticImpact(style: .rigid)
            let prevCategory = CoreDataManager.shared.getCategory(name: self.item?.category?.name ?? "")
            let newCategory = CoreDataManager.shared.getCategory(name: self.categoryButton.titleLabel?.text ?? "")
            
            PushNotificationManager.shared.removePushNotificationsOfCategory(category: prevCategory)
            PushNotificationManager.shared.removePushNotificationsOfCategory(category: newCategory)
            
            self.item?.title = self.titleTextField.text
            self.item?.content = self.contentTextView.text
            self.item?.category = newCategory
            self.item?.createdDate = Date()

            CoreDataManager.shared.save()
            CoreDataManager.shared.fetchItems()
            CoreDataManager.shared.fetchCategories()
            
            PushNotificationManager.shared.setPushNotificationsOfCategory(category: prevCategory)
            PushNotificationManager.shared.setPushNotificationsOfCategory(category: newCategory)
            
            self.delegate?.deleteButtonTapped()
            self.dismiss(animated: true)
        }), for: .touchUpInside)
        
        deleteButton.isEnabled = true
        deleteButton.backgroundColor = .primary100
    }
    
    func setupCategoryButton() {
        let popUpButtonAction = { [weak self] (action: UIAction) in
            HapticManager.shared.selectionChanged()
            self?.categoryButton.setTitle(action.title, for: .normal)
            self?.categoryButton.setTitleColor(.font100, for: .normal)
        }
        
        categoryButton.showsMenuAsPrimaryAction = true
        categoryButton.menu = UIMenu(title: "카테고리 종류", children:
            CoreDataManager.shared.getAllCategories().map {
                UIAction(title: $0.name ?? "", handler: popUpButtonAction)
            }
        )
    }
    
    func setupUI() {
        view.backgroundColor = .primary80
        view.addSubview(outerStackView)
        
        outerStackView.addArrangedSubview(innerStackTuple.category)
        outerStackView.addArrangedSubview(innerStackTuple.title)
        outerStackView.addArrangedSubview(innerStackTuple.content)
        outerStackView.addArrangedSubview(innerStackTuple.buttons)
        
        innerStackTuple.category.addArrangedSubview(labelTuple.category)
        innerStackTuple.category.addArrangedSubview(categoryButton)

        innerStackTuple.title.addArrangedSubview(labelTuple.title)
        innerStackTuple.title.addArrangedSubview(titleTextField)
        
        innerStackTuple.content.addArrangedSubview(labelTuple.content)
        innerStackTuple.content.addArrangedSubview(contentTextView)
        innerStackTuple.content.addArrangedSubview(letterCountLabel)
        
        innerStackTuple.buttons.addArrangedSubview(saveButton)
        innerStackTuple.buttons.addArrangedSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            outerStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 44),
            outerStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -44),
            outerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 44),
            outerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -44),
            
            labelTuple.category.heightAnchor.constraint(equalToConstant: 28),
            categoryButton.heightAnchor.constraint(equalToConstant: 44),
            
            labelTuple.title.heightAnchor.constraint(equalToConstant: 28),
            titleTextField.heightAnchor.constraint(equalToConstant: 44),
            
            labelTuple.content.heightAnchor.constraint(equalToConstant: 28),
            contentTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
            
            saveButton.heightAnchor.constraint(equalToConstant: 52),
            deleteButton.heightAnchor.constraint(equalToConstant: 52),
        ])
    }
    
    func checkValidation() -> Bool {
        if let categoryName = categoryButton.titleLabel?.text, categoryName == "카테고리를 선택하세요" {
            let alert = UIAlertController(
                title: "카테고리 입력 에러", message: "카테고리를 선택하세요", preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            present(alert, animated: true)
            return false
        } else if let titleText = titleTextField.text,
                  titleText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            let alert = UIAlertController(
                title: "제목 입력 에러", message: "제목을 입력하세요", preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            present(alert, animated: true)
            return false
        } else if let contentText = contentTextView.text, contentText == "내용을 입력하세요" {
            let alert = UIAlertController(
                title: "내용 입력 에러", message: "내용을 입력하세요", preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            present(alert, animated: true)
            return false
        }
        
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension AddFormViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        textField.backgroundColor = .primary20
        textField.textColor = .primary100
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.backgroundColor = .primary40
        textField.textColor = .font100
        if textField.text!.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textField.font = UIFont.systemFont(ofSize: 20, weight: .thin)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        return (text.count + string.count - range.length) <= 20
    }
}

extension AddFormViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "내용을 입력하세요" {
            textView.font = UIFont.systemFont(ofSize: 20, weight: .regular)
            textView.text = nil
        }
        textView.backgroundColor = .primary20
        textView.textColor = .primary100
        
        UIView.animate(withDuration: 0.5) {
            self.view.window?.frame.origin.y -= 160
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.backgroundColor = .primary40
        textView.textColor = .font100
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.font = UIFont.systemFont(ofSize: 20, weight: .thin)
            textView.text = "내용을 입력하세요"
            textView.textColor = .font25
        }
        
        if self.view.window?.frame.origin.y != 0 {
            UIView.animate(withDuration: 0.3) {
                self.view.window?.frame.origin.y += 160
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 200 {
            textView.deleteBackward()
        }
        
        let attributedString = setAttributedString(textView: textView)
        letterCountLabel.attributedText = attributedString
    }
    
    func setAttributedString(textView: UITextView) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: "\(textView.text.count)/200")
        attributedString.addAttribute(
            .foregroundColor,
            value: UIColor.accent100,
            range: ("\(textView.text.count)/200" as NSString).range(of:"\(textView.text.count)"))
        return attributedString
    }

}
