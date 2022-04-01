//
//  ViewController.swift
//  Notes(Internship)
//
//  Created by Снытин Ростислав on 26.03.2022.
//

import UIKit

class MainViewController: UIViewController {
    private var mainTextField = UITextView()
    private var titleTextField = UITextField()
    private var rightBarButton = UIBarButtonItem()
    private var mainContainer = UIView()

    private var textIsEditing = true
    private let keyForNote = "note"
    private let keyForTitle = "title"
    private let navigationTitle = "Заметки"
    private let doneRightButtonTitle = "Готово"
    private let changeRightButtonTitle = "Изменить"
    private let placeholderTitleTextField = "Заголовок страницы"
    private let emptyValue = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = navigationTitle

        setupRightBarButton()
        setupViewContainer()
        setupTitleTextField()
        setupMainTextView()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationWillTerminate(notification:)),
            name: UIApplication.willTerminateNotification,
            object: nil
        )
    }

    @objc private func didRightBarButtonTapped(_ sender: Any) {
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
            UserDefaults.standard.set(mainTextField.text, forKey: keyForNote)
            UserDefaults.standard.set(titleTextField.text, forKey: keyForTitle)
        }
    }

    @objc private func applicationWillTerminate(notification: Notification) {
        UserDefaults.standard.set(mainTextField.text, forKey: keyForNote)
        UserDefaults.standard.set(titleTextField.text, forKey: keyForTitle)
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
        titleTextField.text = UserDefaults.standard.string(forKey: keyForTitle) ?? emptyValue
    }

    private func setupMainTextView() {
        mainContainer.addSubview(mainTextField)
        mainTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainTextField.leftAnchor.constraint(equalTo: mainContainer.leftAnchor),
            mainTextField.rightAnchor.constraint(equalTo: mainContainer.rightAnchor),
            mainTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor),
            mainTextField.bottomAnchor.constraint(equalTo: mainContainer.bottomAnchor)
        ])
        mainTextField.font = .systemFont(ofSize: 14.0, weight: .regular)
        mainTextField.becomeFirstResponder()
        mainTextField.text = UserDefaults.standard.string(forKey: keyForNote) ?? emptyValue
    }
}
