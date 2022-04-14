//
//  ListViewController.swift
//  Notes(Internship)
//
//  Created by Снытин Ростислав on 12.04.2022.
//

import UIKit

class ListViewController: UIViewController {
    private var scrollView = UIScrollView()
    private var stackView = UIStackView()
    private var containerView = UIView()
    private var addNoteButton = UIButton()
    private var backItem = UIBarButtonItem()

    private let navigationTitle = "Заметки"
    private let emptyValue = ""
    private let noteDateFormatter = "dd.MM.YYYY EEEE HH:mm"
    var notes: [Note] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .secondarySystemBackground
        navigationController?.navigationBar.barTintColor = .secondarySystemBackground
        navigationItem.title = navigationTitle
        backItem.title = emptyValue
        navigationItem.backBarButtonItem = backItem

        setupScrollView()
        setupContainer()
        setupStackView()
        setupAddButton()
    }

    private func setupScrollView() {
        self.view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupContainer() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }

    private func setupStackView() {
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        uploadStackView()

        containerView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }

    private func setupAddButton() {
        addNoteButton.layer.cornerRadius = 25
        addNoteButton.clipsToBounds = true
        addNoteButton.contentVerticalAlignment = .bottom
        addNoteButton.setTitle("+", for: .normal)
        addNoteButton.titleLabel?.font = UIFont.systemFont(ofSize: 36, weight: .regular)
        addNoteButton.backgroundColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 1)
        addNoteButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        addNoteButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(addNoteButton)
        NSLayoutConstraint.activate([
            addNoteButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -19),
            addNoteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            addNoteButton.widthAnchor.constraint(equalToConstant: 50.0),
            addNoteButton.heightAnchor.constraint(equalToConstant: 50.0)
        ])
    }

    @objc private func buttonTapped(_ sender: Any) {
        let newNote = NoteInfoViewController()
        newNote.delegate = self
        self.navigationController?.pushViewController(newNote, animated: true)
    }
}

extension ListViewController: NoteInfoViewControllerDelegate {
    func saveNote(_ note: Note) {
        self.notes.append(note)
        uploadStackView()
    }

    private func uploadStackView() {
        stackView.subviews.forEach { view in
            view.removeFromSuperview()
        }
        for (index, note) in notes.enumerated() {
            let view = NoteView(frame: CGRect(x: 0, y: 0, width: 358, height: 90), note: note) { [weak self] (note) in
                guard let self = self else { return }
                let editNote = NoteInfoViewController()
                editNote.noteInfo = note
                editNote.noteInfo.date = DateFormat.formatterDate(
                    day: note.date ?? "",
                    formatter: self.noteDateFormatter
                )
                editNote.delegate = self
                self.navigationController?.show(editNote, sender: nil)
                self.notes.remove(at: index)
            }
            stackView.addArrangedSubview(view)
        }
    }
}
