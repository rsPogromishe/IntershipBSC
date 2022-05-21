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

    var savedNotes: [Note] = [] {
        didSet {
            savedNotes = savedNotes.sorted(by: { $0.date ?? Date() > $1.date ?? Date() })
           }
    }

    private var indices: [Int] = [] {
        didSet {
            indices = indices.sorted(by: { $0 > $1 })
        }
    }

    private var firstButtonConst: NSLayoutConstraint?
    private var secondButtonConst: NSLayoutConstraint?

    private var manager = NetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        savedNotes = NoteStorage().loadNotes()
        fetchNotes()

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
        buttonAppearAnimation()
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
        indices.removeAll()
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
            if indices.isEmpty {
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
                deleteRowsButtonAnimation()
                NoteStorage().saveNotes(savedNotes)
            }
        } else {
            pushVCButtonAnimation()
        }
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        savedNotes.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: NoteCell.cellIdentifier,
            for: indexPath
        ) as? NoteCell {
            cell.configure(note: savedNotes[indexPath.row])
            cell.selectionStyle = .none
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
            savedNotes.remove(at: indexPath.row)
            NoteStorage().saveNotes(savedNotes)
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

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            indices.append(indexPath.row)
            tableView.cellForRow(at: indexPath)?.setSelected(true, animated: true)
        } else {
            let noteVC = NoteInfoViewController()
            noteVC.delegate = self
            noteVC.noteInfo = savedNotes[indexPath.row]
            noteVC.noteIndex = indexPath.row
            savedNotes.remove(at: indexPath.row)
            self.navigationController?.pushViewController(noteVC, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        indices.removeAll(where: { $0 == indexPath.row })
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
    }
}

extension ListViewController: NoteInfoViewControllerDelegate {
    func saveNote(_ note: Note, index: Int) {
        self.savedNotes.insert(note, at: index)
        self.tableView.reloadData()
        NoteStorage().saveNotes(savedNotes)
    }
}

extension ListViewController {
    private func buttonAppearAnimation() {
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
            }
        )
    }

    private func pushVCButtonAnimation() {
        UIView.animateKeyframes(
            withDuration: 1,
            delay: 0,
            options: [.layoutSubviews],
            animations: { [weak self] in
                guard let self = self else { return }
                self.pushVCButtonAnimationKeyFrames()
            },
            completion: { [weak self] _ in
                guard let self = self else { return }
                let newNote = NoteInfoViewController()
                newNote.delegate = self
                self.navigationController?.pushViewController(newNote, animated: true)
            }
        )
    }

    private func pushVCButtonAnimationKeyFrames() {
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
            }
        )
    }

    private func deleteRowsButtonAnimation() {
        UIView.animate(
            withDuration: 0.5,
            animations: { [weak self] in
                guard let self = self else { return }
                self.indices.forEach({
                    self.savedNotes.remove(at: $0)
                    let index = IndexPath(row: $0, section: 0)
                    self.tableView.deleteRows(at: [index], with: .right)
                })
            },
            completion: { [weak self] _ in
                guard let self = self else { return }
                self.tableView.reloadData()
                self.tableView.isEditing = false
                self.changeButtonFunctionAnimation()
            }
        )
    }
}

extension ListViewController {
    private func fetchNotes() {
        manager.fetchData { response in
            switch response {
            case .onSuccess(let uploadNotes):
                DispatchQueue.main.async {
                    uploadNotes.forEach({ note in
                        if !self.savedNotes.contains(where: {
                            $0.mainText == note.mainText &&
                            $0.titleText == note.titleText &&
                            $0.date == note.date
                        }) {
                            self.savedNotes.append(note)
                        }
                    })
                    self.tableView.reloadData()
                }
            case .onError(let error):
                print(error)
            }
        }
    }
}
