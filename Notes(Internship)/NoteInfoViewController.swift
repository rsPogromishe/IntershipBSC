//
//  ViewController.swift
//  Notes(Internship)
//
//  Created by Снытин Ростислав on 26.03.2022.
//

import UIKit

class NoteInfoViewController: UIViewController {
    private let interactor: NoteInfoBusinessLogic
    var router: (NoteInfoRoutingLogic & NoteInfoDataPassing)?

    var noteInfo = Note(titleText: "", mainText: "", date: Date(), userShareIcon: nil)
    var noteIsInSaved = true

    private var mainTextField = UITextView()
    private var titleTextField = UITextField()
    private var rightBarButton = UIBarButtonItem()
    private var mainContainer = UIView()
    private var dateLabel = UILabel()

    private let doneRightButtonTitle = "Готово"
    private let placeholderTitleTextField = "Введите название"
    private let emptyValue = ""

    private var editDate: Date?

    init(interactor: NoteInfoBusinessLogic) {
        self.interactor = interactor
        print("NoteInfoVC inited")
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        print("NoteInfoVC inited")
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("NoteInfoVC deinited")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: Constant.screenBackgroundColor)

        setupBarButtons()
        setupViewContainer()
        setupDateButton()
        setupTitleTextField()
        setupMainTextView()

        addObservers()

        showNoteInfo()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if noteIsInSaved {
            if !noteInfo.isEmpty {
                let request = NoteInfo.SaveNote.Request(
                    titleText: noteInfo.titleText,
                    mainText: noteInfo.mainText,
                    date: noteInfo.date
                )
                interactor.saveNoteInfo(request: request)
            }
        }
    }

    private func addObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(showKeyboard),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationWillTerminate(notification:)),
            name: UIApplication.willTerminateNotification,
            object: nil
        )
    }

    @objc private func showKeyboard() {
        noteIsInSaved = true
        rightBarButton.isEnabled = true
        rightBarButton.title = doneRightButtonTitle
        let nowDate = Date()
        editDate = nowDate
        dateLabel.text = DateFormat.dateToday(day: nowDate, formatter: Constant.noteDateFormatter)
        noteInfo = Note(
            titleText: titleTextField.text ?? emptyValue,
            mainText: mainTextField.text,
            date: nowDate,
            userShareIcon: nil
        )
    }

    @objc private func applicationWillTerminate(notification: Notification) {
        if noteIsInSaved {
            if !noteInfo.isEmpty {
                let request = NoteInfo.SaveNote.Request(
                    titleText: titleTextField.text ?? "",
                    mainText: mainTextField.text,
                    date: Date()
                )
                interactor.saveNoteInfo(request: request)
            }
        }
    }

    private func setupBarButtons() {
        navigationItem.rightBarButtonItem = rightBarButton
        rightBarButton.title = emptyValue
        rightBarButton.isEnabled = false
        rightBarButton.target = self
        rightBarButton.style = .plain
        rightBarButton.action = #selector(didRightBarButtonTapped(_:))
    }

    @objc private func didRightBarButtonTapped(_ sender: Any) {
        noteInfo.titleText = titleTextField.text ?? emptyValue
        noteInfo.mainText = mainTextField.text
        if !checkEmptyStroke() {
            self.view.endEditing(true)
            rightBarButton.isEnabled = false
            rightBarButton.title?.removeAll()
        }
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
            titleTextField.topAnchor.constraint(equalTo: dateLabel.bottomAnchor),
            titleTextField.leftAnchor.constraint(equalTo: mainContainer.leftAnchor, constant: 3.5),
            titleTextField.rightAnchor.constraint(equalTo: mainContainer.rightAnchor),
            titleTextField.heightAnchor.constraint(equalToConstant: 44.0)
        ])
        titleTextField.adjustsFontSizeToFitWidth = false
        titleTextField.font = .systemFont(ofSize: 24.0, weight: .medium)
        titleTextField.placeholder = placeholderTitleTextField
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
        mainTextField.font = .systemFont(ofSize: 16.0, weight: .regular)
        mainTextField.backgroundColor = UIColor(named: Constant.screenBackgroundColor)
        mainTextField.adjustableForKeyboard()

        let tap = UITapGestureRecognizer(target: self, action: #selector(tapToMainText(_:)))
        mainTextField.addGestureRecognizer(tap)
    }

    @objc func tapToMainText(_ sender: UITapGestureRecognizer) {
        mainTextField.becomeFirstResponder()
        let endOfDocument = mainTextField.endOfDocument
        mainTextField.selectedTextRange = mainTextField.textRange(from: endOfDocument, to: endOfDocument)
    }

    private func setupDateButton() {
        mainContainer.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.leftAnchor.constraint(equalTo: mainContainer.leftAnchor),
            dateLabel.rightAnchor.constraint(equalTo: mainContainer.rightAnchor),
            dateLabel.topAnchor.constraint(equalTo: mainContainer.topAnchor),
            dateLabel.heightAnchor.constraint(equalToConstant: 40.0)
        ])
        dateLabel.textAlignment = .center
        dateLabel.font = .systemFont(ofSize: 14, weight: .medium)
        dateLabel.textColor = UIColor(red: 172 / 255, green: 172 / 255, blue: 172 / 255, alpha: 1)
    }
}

extension NoteInfoViewController {
    private func checkEmptyStroke() -> Bool {
        if noteInfo.isEmpty {
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
            return true
        } else {
            return false
        }
    }
}

extension NoteInfoViewController: NoteInfoDisplayLogic {
    func displayNoteInfo(viewModel: NoteInfo.ShowNote.ViewModel) {
        titleTextField.text = viewModel.titleText
        mainTextField.text = viewModel.mainText
        dateLabel.text = "\(DateFormat.dateToday(day: viewModel.date ?? Date(), formatter: Constant.noteDateFormatter))"
        editDate = viewModel.date

        noteInfo.titleText = viewModel.titleText
        noteInfo.mainText = viewModel.mainText
        noteInfo.date = viewModel.date
    }

    func displaySaveNote(viewModel: NoteInfo.SaveNote.ViewModel) {
        router?.routeToNoteList()
    }

    private func showNoteInfo() {
        let request = NoteInfo.ShowNote.Request()
        interactor.showNoteInfo(request: request)
    }
}
