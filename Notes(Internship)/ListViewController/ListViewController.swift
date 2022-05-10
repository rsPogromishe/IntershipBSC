//
//  ListViewController.swift
//  Notes(Internship)
//
//  Created by Снытин Ростислав on 12.04.2022.
//

import UIKit

class ListViewController: UIViewController {
    private var tableView = UITableView()
    private var addNoteButton = UIButton()
    private var backItem = UIBarButtonItem()

    private let navigationTitle = "Заметки"
    private let emptyValue = ""
    var notes: [Note] = [] {
        didSet {
            notes = notes.sorted(by: { $0.date ?? Date() > $1.date ?? Date() })
           }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        notes = NoteStorage().loadNotes()

        self.view.backgroundColor = UIColor(named: Constant.screenBackgroundColor)
        navigationController?.navigationBar.barTintColor = UIColor(named: Constant.screenBackgroundColor)
        navigationItem.title = navigationTitle
        backItem.title?.removeAll()
        navigationItem.backBarButtonItem = backItem

        setupTableView()
        setupAddButton()
    }

    private func setupTableView() {
        tableView.register(NoteCell.self, forCellReuseIdentifier: NoteCell.cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self

        tableView.backgroundColor = UIColor(named: Constant.screenBackgroundColor)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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
            addNoteButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
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

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: NoteCell.cellIdentifier,
            for: indexPath
        ) as? NoteCell {
            cell.configure(note: notes[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }

    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            notes.remove(at: indexPath.row)
            NoteStorage().saveNotes(notes)
            self.tableView.reloadData()
        }
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noteVC = NoteInfoViewController()
        noteVC.delegate = self
        noteVC.noteInfo = notes[indexPath.row]
        noteVC.noteIndex = indexPath.row
        notes.remove(at: indexPath.row)
        self.navigationController?.pushViewController(noteVC, animated: true)
    }
}

extension ListViewController: NoteInfoViewControllerDelegate {
    func saveNote(_ note: Note, index: Int) {
        self.notes.insert(note, at: index)
        self.tableView.reloadData()
        NoteStorage().saveNotes(notes)
    }
}
