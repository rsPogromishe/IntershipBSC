//
//  ViewController.swift
//  Notes(Internship)
//
//  Created by Снытин Ростислав on 26.03.2022.
//

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIApplicationDelegate {
    
    private var mainTextField = UITextView()
    private var titleTextField = UITextField()
    private var rightBarButton = UIBarButtonItem()
    private var mainContainer = UIView()
    
    private var textIsEditing = true

    override func viewDidLoad() {
        super.viewDidLoad()
        //
        navigationItem.title = "Заметки"
        setupRightBarButton()
        setupViewContainer()
        setupTitleTextField()
        setupMainTextView()
    
        NotificationCenter.default.addObserver(self,
              selector: #selector(applicationWillTerminate(notification:)),
              name: UIApplication.willTerminateNotification,
              object: nil)
    }
    
    @objc private func didRightBarButtonTapped(_ sender: Any) {
        textIsEditing.toggle()
        if textIsEditing {
            rightBarButton.title = "Готово"
            titleTextField.isUserInteractionEnabled = true
            mainTextField.isUserInteractionEnabled = true
            mainTextField.isEditable = true
            mainTextField.becomeFirstResponder()
        } else {
            rightBarButton.title = "Изменить"
            mainTextField.resignFirstResponder()
            titleTextField.isUserInteractionEnabled = false
            mainTextField.isEditable = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UserDefaults.standard.set(titleTextField.text, forKey: "title")
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        UserDefaults.standard.set(mainTextField.text, forKey: "note")
    }
    
    @objc private func applicationWillTerminate(notification: Notification) {
        UserDefaults.standard.set(mainTextField.text, forKey: "note")
        UserDefaults.standard.set(titleTextField.text, forKey: "title")
    }
    
    private func setupRightBarButton() {
        navigationItem.rightBarButtonItem = rightBarButton
        rightBarButton.title = "Готово"
        rightBarButton.target = self
        rightBarButton.action = #selector(didRightBarButtonTapped(_:))
    }
    
    private func setupViewContainer() {
        mainContainer.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mainContainer)
        mainContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mainContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        mainContainer.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        mainContainer.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
    }
    
    private func setupTitleTextField() {
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        mainContainer.addSubview(titleTextField)
        titleTextField.topAnchor.constraint(equalTo: mainContainer.topAnchor).isActive = true
        titleTextField.leftAnchor.constraint(equalTo: mainContainer.leftAnchor, constant: 3.5).isActive = true
        titleTextField.rightAnchor.constraint(equalTo: mainContainer.rightAnchor).isActive = true
        titleTextField.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        titleTextField.adjustsFontSizeToFitWidth = false
        titleTextField.font = .systemFont(ofSize: 22.0, weight: .bold)
        titleTextField.placeholder = "Заголовок страницы"
        titleTextField.delegate = self
        titleTextField.text = UserDefaults.standard.string(forKey: "title") ?? ""
    }
    
    private func setupMainTextView() {
        mainTextField.translatesAutoresizingMaskIntoConstraints = false
        mainContainer.addSubview(mainTextField)
        mainTextField.leftAnchor.constraint(equalTo: mainContainer.leftAnchor).isActive = true
        mainTextField.rightAnchor.constraint(equalTo: mainContainer.rightAnchor).isActive = true
        mainTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor).isActive = true
        mainTextField.bottomAnchor.constraint(equalTo: mainContainer.bottomAnchor).isActive = true
        mainTextField.font = .systemFont(ofSize: 14.0, weight: .regular)
        mainTextField.becomeFirstResponder()
        mainTextField.delegate = self
        mainTextField.text = UserDefaults.standard.string(forKey: "note") ?? ""
    }
}

