//
//  ViewController.swift
//  Notes(Internship)
//
//  Created by Снытин Ростислав on 26.03.2022.
//

import UIKit

class MainViewController: UIViewController {
    private var note = Note(
        titleText: UserDefaults.standard.string(forKey: Constant.keyForTitle) ?? "",
        mainText: UserDefaults.standard.string(forKey: Constant.keyForNote) ?? "",
        date: UserDefaults.standard.string(forKey: Constant.keyForDate) ?? ""
    )

    private var mainTextField = UITextView()
    private var titleTextField = UITextField()
    private var rightBarButton = UIBarButtonItem()
    private var mainContainer = UIView()
    private var dateTextField = UITextField()
    private var datePicker = UIDatePicker()

    private var textIsEditing = true
    private let navigationTitle = "Заметки"
    private let doneRightButtonTitle = "Готово"
    private let changeRightButtonTitle = "Изменить"
    private let placeholderTitleTextField = "Заголовок страницы"
    private let emptyValue = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        navigationItem.title = navigationTitle

        setupRightBarButton()
        setupViewContainer()
        setupTitleTextField()
        setupDateButton()
        setupMainTextView()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationWillTerminate(notification:)),
            name: UIApplication.willTerminateNotification,
            object: nil
        )
    }

    @objc private func didRightBarButtonTapped(_ sender: Any) {
        note.titleText = titleTextField.text ?? emptyValue
        note.mainText = mainTextField.text
        if note.isEmpty {
            checkEmptyStroke()
        } else {
            textIsEditing.toggle()
            if textIsEditing {
                rightBarButton.title = doneRightButtonTitle
                titleTextField.isUserInteractionEnabled = true
                mainTextField.isUserInteractionEnabled = true
                mainTextField.isEditable = true
                mainTextField.becomeFirstResponder()
            } else {
                rightBarButton.title = changeRightButtonTitle
                mainTextField.resignFirstResponder()
                titleTextField.isUserInteractionEnabled = false
                mainTextField.isEditable = false
                UserDefaults.standard.set(mainTextField.text, forKey: Constant.keyForNote)
                UserDefaults.standard.set(titleTextField.text, forKey: Constant.keyForTitle)
                UserDefaults.standard.set(dateTextField.text, forKey: Constant.keyForDate)
                self.view.endEditing(true)
            }
        }
    }

    @objc private func applicationWillTerminate(notification: Notification) {
        UserDefaults.standard.set(mainTextField.text, forKey: Constant.keyForNote)
        UserDefaults.standard.set(titleTextField.text, forKey: Constant.keyForTitle)
        UserDefaults.standard.set(dateTextField.text, forKey: Constant.keyForDate)
    }

    private func setupRightBarButton() {
        navigationItem.rightBarButtonItem = rightBarButton
        rightBarButton.title = doneRightButtonTitle
        rightBarButton.target = self
        rightBarButton.action = #selector(didRightBarButtonTapped(_:))
    }

    private func setupViewContainer() {
        self.view.addSubview(mainContainer)
        mainContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainContainer.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -20
            ),
            mainContainer.leftAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leftAnchor,
                constant: 20
            ),
            mainContainer.rightAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.rightAnchor,
                constant: -20
            )
        ])
    }

    private func setupTitleTextField() {
        mainContainer.addSubview(titleTextField)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: mainContainer.topAnchor),
            titleTextField.leftAnchor.constraint(equalTo: mainContainer.leftAnchor, constant: 3.5),
            titleTextField.rightAnchor.constraint(equalTo: mainContainer.rightAnchor),
            titleTextField.heightAnchor.constraint(equalToConstant: 40.0)
        ])
        titleTextField.adjustsFontSizeToFitWidth = false
        titleTextField.font = .systemFont(ofSize: 22.0, weight: .bold)
        titleTextField.placeholder = placeholderTitleTextField
        titleTextField.text = note.titleText
    }

    private func setupMainTextView() {
        mainContainer.addSubview(mainTextField)
        mainTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainTextField.leftAnchor.constraint(equalTo: mainContainer.leftAnchor),
            mainTextField.rightAnchor.constraint(equalTo: mainContainer.rightAnchor),
            mainTextField.topAnchor.constraint(equalTo: dateTextField.bottomAnchor),
            mainTextField.bottomAnchor.constraint(equalTo: mainContainer.bottomAnchor)
        ])
        mainTextField.font = .systemFont(ofSize: 14.0, weight: .regular)
        mainTextField.becomeFirstResponder()
        mainTextField.text = note.mainText
    }

    private func setupDateButton() {
        mainContainer.addSubview(dateTextField)
        dateTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateTextField.leftAnchor.constraint(equalTo: mainContainer.leftAnchor),
            dateTextField.rightAnchor.constraint(equalTo: mainContainer.rightAnchor),
            dateTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor),
            dateTextField.heightAnchor.constraint(equalToConstant: 30.0)
        ])
        dateTextField.placeholder = "Дата: \(DateFormat.dateToday(day: Date(), formatter: "dd MMMM YYYY"))"
        dateTextField.text = note.date
        dateTextField.textAlignment = .center
        dateTextField.inputView = datePicker
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(changeDate(_:)), for: .valueChanged)
    }

    @objc private func changeDate(_ sender: UIDatePicker) {
        let changedDate = DateFormat.changeDateTextField(sender: sender)
        self.dateTextField.text = "Дата: \(changedDate)"
    }
}

extension MainViewController {
    private func checkEmptyStroke() {
        let action = UIAlertController(
            title: "Ошибка",
            message: "Заполните поля",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(
            title: "OK",
            style: .default
        )
        action.addAction(okAction)
        present(action, animated: true)
    }
}
