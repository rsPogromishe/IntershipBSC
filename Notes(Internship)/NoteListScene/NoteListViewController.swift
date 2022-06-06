//
//  ListViewController.swift
//  Notes(Internship)
//
//  Created by Снытин Ростислав on 12.04.2022.
//

import UIKit

class NoteListViewController: UIViewController {
    var interactor: NoteListBusinessLogic?
    var router: (NoteListRoutingLogic & NoteListDataPassing)?

    var tableView = UITableView()
    private var addNoteButton = UIButton()
    private var backItem = UIBarButtonItem()
    private var rightBarButton = UIBarButtonItem()

    private let navigationTitle = "Заметки"
    private let chooseRightButtonTitle = "Выбрать"
    private let doneRightButtonTitle = "Готово"
    private let emptyValue = ""

    var arrayOfNotes: [NoteList.NoteData.ViewModel.DisplayedNote] = [] {
        didSet {
            arrayOfNotes = arrayOfNotes.sorted(by: { $0.date ?? Date() > $1.date ?? Date() })
           }
    }
    private var localNotes: [NoteList.NoteData.ViewModel.DisplayedNote] = []
    private var uploadNotes: [NoteList.NoteData.ViewModel.DisplayedNote] = []

    private var indices: [Int] = [] {
        didSet {
            indices = indices.sorted(by: { $0 > $1 })
        }
    }

    private var firstButtonConst: NSLayoutConstraint?
    private var secondButtonConst: NSLayoutConstraint?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
        print("NoteList inited")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("NoteListVC deinited")
    }

    private func setup() {
        let viewController = self
        let interactor = NoteListInteractor()
        let presenter = NoteListPresenter()
        let router = NoteListRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicatorView()

        fetchNote()

        view.backgroundColor = UIColor(named: Constant.screenBackgroundColor)

        setupNavigationBar()
        setupTableView()
        setupAddButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadLocalNotes()
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
                animations: {
                    self.addNoteButton.setImage(UIImage(named: Constant.deleteButtonImage), for: .normal)
                }
            )
        } else {
            changeButtonFunctionAnimation()
        }
    }

    private func setupTableView() {
        tableView.register(NoteListCellView.self, forCellReuseIdentifier: NoteListCellView.cellIdentifier)
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
            }
        } else {
            pushVCButtonAnimation()
        }
    }
}

extension NoteListViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        arrayOfNotes.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: NoteListCellView.cellIdentifier,
            for: indexPath
        ) as? NoteListCellView {
            cell.configure(note: arrayOfNotes[indexPath.row])
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
            let deleteNote = arrayOfNotes[indexPath.row]
            let request = NoteList.DeleteNote.Request(note: [deleteNote])
            interactor?.deleteLocalNotes(request: request)
            let note = arrayOfNotes.remove(at: indexPath.row)
            localNotes.removeAll(where: {
                $0.mainText == note.mainText &&
                $0.titleText == note.titleText &&
                $0.date == note.date
            })
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

extension NoteListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            indices.append(indexPath.row)
            tableView.cellForRow(at: indexPath)?.setSelected(true, animated: true)
        } else {
            router?.routeToViewNote()
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        indices.removeAll(where: { $0 == indexPath.row })
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
    }
}

extension NoteListViewController {
//    анимации не приводят к утечки памяти
    private func buttonAppearAnimation() {
        UIView.animate(
            withDuration: 1,
            delay: 0,
            usingSpringWithDamping: 0.1,
            initialSpringVelocity: 10,
            options: [.layoutSubviews],
            animations: {
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
            animations: {
                self.pushVCButtonAnimationKeyFrames()
            },
            completion: { _ in
                self.router?.routeToAddNote()
            }
        )
    }

    private func pushVCButtonAnimationKeyFrames() {
        UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.25) {
            self.addNoteButton.layer.position.y -= 75
        }
        UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25) {
            self.addNoteButton.layer.position.y += 500
        }
    }

    private func changeButtonFunctionAnimation() {
        rightBarButton.title = chooseRightButtonTitle
        UIView.transition(
            with: addNoteButton,
            duration: 0.5,
            options: [.transitionFlipFromRight],
            animations: {
                self.addNoteButton.setImage(UIImage(named: Constant.addButtonImage), for: .normal)
            }
        )
    }

    private func deleteRowsButtonAnimation() {
        UIView.animate(
            withDuration: 0.5,
            animations: {
                self.indices.forEach({
                    let note = self.arrayOfNotes.remove(at: $0)
                    let index = IndexPath(row: $0, section: 0)
                    self.tableView.deleteRows(at: [index], with: .right)
                    self.localNotes.removeAll(where: {
                        $0.mainText == note.mainText &&
                        $0.titleText == note.titleText &&
                        $0.date == note.date
                    })
                    let request = NoteList.DeleteNote.Request(note: [note])
                    self.interactor?.deleteLocalNotes(request: request)
                })
            },
            completion: { _ in
                self.tableView.reloadData()
                self.tableView.isEditing = false
                self.changeButtonFunctionAnimation()
            }
        )
    }
    private func loadingIndicatorView() {
        LoadingView.startAnimating(mainView: self.view)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            LoadingView.stopAnimating()
        }
    }
}

extension NoteListViewController: NoteListDisplayLogic {
    func displayLocalNotes(viewModel: NoteList.NoteData.ViewModel) {
        localNotes = viewModel.displayedNotes
        arrayOfNotes.forEach { note in
            localNotes.removeAll(where: {
                $0.mainText == note.mainText &&
                $0.titleText == note.titleText &&
                $0.date == note.date
            })
        }
        arrayOfNotes += localNotes
        tableView.reloadData()
    }

    func displayUploadNotes(viewModel: NoteList.NoteData.ViewModel) {
        uploadNotes = viewModel.displayedNotes
        arrayOfNotes += uploadNotes
        tableView.reloadData()
    }

    private func fetchNote() {
        let request = NoteList.NoteData.Request()
        interactor?.showUploadNotes(request: request)
    }

    private func loadLocalNotes() {
        let request = NoteList.NoteData.Request()
        interactor?.showLocalNotes(request: request)
    }
}
