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
    private var rightBarButton = UIBarButtonItem()

    private let navigationTitle = "Заметки"
    private let chooseRightButtonTitle = "Выбрать"
    private let doneRightButtonTitle = "Готово"
    private let emptyValue = ""

    var notes: [Note] = [] {
        didSet {
            notes = notes.sorted(by: { $0.date ?? Date() > $1.date ?? Date() })
           }
    }
    var indecis: [Int] = [] {
        didSet {
            indecis = indecis.sorted(by: { $0 > $1 })
        }
    }

    private var firstButtonConst: NSLayoutConstraint?
    private var secondButtonConst: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        notes = NoteStorage().loadNotes()

        self.view.backgroundColor = UIColor(named: Constant.screenBackgroundColor)

        setupNavigationBar()
        setupTableView()
        setupAddButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        secondButtonConst?.isActive = false
        firstButtonConst = addNoteButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 60)
        firstButtonConst?.isActive = true
        view.layoutSubviews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupAnimation()
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor(named: Constant.screenBackgroundColor)
        navigationItem.title = navigationTitle
        backItem.title?.removeAll()
        navigationItem.backBarButtonItem = backItem

        navigationItem.rightBarButtonItem = rightBarButton
        rightBarButton.title = chooseRightButtonTitle
        rightBarButton.target = self
        rightBarButton.style = .plain
        rightBarButton.action = #selector(didRightBarButtonTapped(_:))
    }

    @objc private func didRightBarButtonTapped(_ sender: Any) {
        indecis.removeAll()
        tableView.setEditing(!tableView.isEditing, animated: true)
        if tableView.isEditing {
            rightBarButton.title = doneRightButtonTitle
            UIView.transition(
                with: addNoteButton,
                duration: 0.5,
                options: [.transitionFlipFromLeft],
                animations: { [weak self] in
                    guard let self = self else { return }
                    self.addNoteButton.setImage(UIImage(named: Constant.deleteButtonImage), for: .normal)
                }, completion: nil
            )
        } else {
            changeButtonFunctionAnimation()
        }
    }

    private func setupTableView() {
        tableView.register(NoteCell.self, forCellReuseIdentifier: NoteCell.cellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.isEditing = false

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
        addNoteButton.setImage(UIImage(named: Constant.addButtonImage), for: .normal)
        addNoteButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        addNoteButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(addNoteButton)
        NSLayoutConstraint.activate([
            addNoteButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -19),
            addNoteButton.widthAnchor.constraint(equalToConstant: 50.0),
            addNoteButton.heightAnchor.constraint(equalToConstant: 50.0)
        ])
    }

    @objc private func buttonTapped(_ sender: Any) {
        if tableView.isEditing {
            if indecis.isEmpty {
                let action = UIAlertController(
                    title: "Ошибка",
                    message: "Вы не выбрали ни одной заметки",
                    preferredStyle: .alert
                )
                let okAction = UIAlertAction(
                    title: "OK",
                    style: .default
                )
                action.addAction(okAction)
                present(action, animated: true)
            } else {
                UIView.animate(
                    withDuration: 0.5,
                    animations: { [weak self] in
                        guard let self = self else { return }
                        self.indecis.forEach({
                            self.notes.remove(
                                at: $0
                            ); let index = IndexPath(
                                row: $0,
                                section: 0
                            ); self.tableView.deleteRows(
                                at: [index],
                                with: .right
                            )
                        })
                    }, completion: { [weak self] _ in
                        guard let self = self else { return }
                        self.tableView.reloadData()
                        self.tableView.isEditing = false
                        self.changeButtonFunctionAnimation()
                    }
                )
                NoteStorage().saveNotes(notes)
            }
        } else {
            UIView.animateKeyframes(
                withDuration: 1,
                delay: 0,
                options: [.layoutSubviews],
                animations: { [weak self] in
                    guard let self = self else { return }
                    self.addButtonKeyFrames()
                }, completion: { [weak self] _ in
                    guard let self = self else { return }
                    let newNote = NoteInfoViewController()
                    newNote.delegate = self
                    self.navigationController?.pushViewController(newNote, animated: true)
                }
            )
        }
    }

    private func setupAnimation() {
        UIView.animate(
            withDuration: 1,
            delay: 0,
            usingSpringWithDamping: 0.1,
            initialSpringVelocity: 10,
            options: [.layoutSubviews],
            animations: { [weak self] in
                guard let self = self else { return }
                self.firstButtonConst?.isActive = false
                self.secondButtonConst = self.addNoteButton.bottomAnchor.constraint(
                    equalTo: self.view.bottomAnchor,
                    constant: -60
                )
                self.secondButtonConst?.isActive = true
                self.view.layoutSubviews()
            }, completion: nil
        )
    }

    private func addButtonKeyFrames() {
        UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.addNoteButton.layer.position.y -= 75
        }
        UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.addNoteButton.layer.position.y += 500
        }
    }

    private func changeButtonFunctionAnimation() {
        rightBarButton.title = chooseRightButtonTitle
        UIView.transition(
            with: addNoteButton,
            duration: 0.5,
            options: [.transitionFlipFromRight],
            animations: { [weak self] in
                guard let self = self else { return }
                self.addNoteButton.setImage(UIImage(named: Constant.addButtonImage), for: .normal)
            }, completion: nil
        )
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        notes.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
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
            tableView.deleteRows(at: [indexPath], with: .right)
            tableView.reloadData()
        }
    }

    func tableView(
        _ tableView: UITableView,
        shouldIndentWhileEditingRowAt indexPath: IndexPath
    ) -> Bool {
        return false
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            indecis.append(indexPath.row)
        } else {
            let noteVC = NoteInfoViewController()
            noteVC.delegate = self
            noteVC.noteInfo = notes[indexPath.row]
            noteVC.noteIndex = indexPath.row
            notes.remove(at: indexPath.row)
            self.navigationController?.pushViewController(noteVC, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        indecis.removeAll(where: { $0 == indexPath.row })
    }
}

extension ListViewController: NoteInfoViewControllerDelegate {
    func saveNote(_ note: Note, index: Int) {
        self.notes.insert(note, at: index)
        self.tableView.reloadData()
        NoteStorage().saveNotes(notes)
    }
}
