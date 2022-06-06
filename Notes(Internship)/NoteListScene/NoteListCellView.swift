//
//  NoteView.swift
//  Notes(Internship)
//
//  Created by Снытин Ростислав on 12.04.2022.
//

import UIKit

class NoteListCellView: UITableViewCell {
    static let cellIdentifier = "cell"

    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let textNoteLabel = UILabel()
    private let dateLabel = UILabel()
    private let editControlImage = UIImageView()
    lazy var shareIconImage = UIImageView()

    private var editingMode: Bool = false

    private var containerLeftConstraint: NSLayoutConstraint?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        print("NoteCell inited")

        setupCell()
    }

    required init?(coder: NSCoder) {
        print("NoteCell inited")
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("Note cell deinited")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0))
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 14
        sendSubviewToBack(contentView)

        containerView.layer.cornerRadius = 14
        containerView.backgroundColor = .white
    }

    private func setupCell() {
        self.backgroundColor = UIColor(named: Constant.screenBackgroundColor)
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        textNoteLabel.font = .systemFont(ofSize: 10, weight: .medium)
        textNoteLabel.textColor = UIColor(red: 0.675, green: 0.675, blue: 0.675, alpha: 1)
        dateLabel.font = .systemFont(ofSize: 10, weight: .medium)
        editControlImage.image = UIImage(named: Constant.deselectCellCheckbox)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        textNoteLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        editControlImage.translatesAutoresizingMaskIntoConstraints = false
        shareIconImage.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(titleLabel)
        containerView.addSubview(textNoteLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(shareIconImage)
        contentView.addSubview(containerView)
        contentView.addSubview(editControlImage)

        containerLeftConstraint = containerView.leftAnchor.constraint(equalTo: contentView.leftAnchor)
        containerLeftConstraint?.isActive = true

        NSLayoutConstraint.activate([
            containerView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            titleLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 16),
            titleLabel.heightAnchor.constraint(equalToConstant: 18.0),

            textNoteLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 3),
            textNoteLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 16),
            textNoteLabel.heightAnchor.constraint(equalToConstant: 14.0),

            dateLabel.topAnchor.constraint(equalTo: textNoteLabel.bottomAnchor, constant: 26),
            dateLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 16),
            dateLabel.heightAnchor.constraint(equalToConstant: 10.0),

            editControlImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 24),
            editControlImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 37),
            editControlImage.heightAnchor.constraint(equalToConstant: 16),
            editControlImage.widthAnchor.constraint(equalToConstant: 16),

            shareIconImage.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -16),
            shareIconImage.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            shareIconImage.heightAnchor.constraint(equalToConstant: 24),
            shareIconImage.widthAnchor.constraint(equalToConstant: 24)
        ])
    }

    func configure(note: NoteList.NoteData.ViewModel.DisplayedNote) {
        titleLabel.text = note.titleText
        textNoteLabel.text = note.mainText
        dateLabel.text = DateFormat.dateToday(day: note.date ?? Date(), formatter: Constant.listDateFormatter)
        if note.userShareIcon != nil && note.userShareIcon != "" {
//            clousure, где данные модели могут быть nil
            DispatchQueue.global().async {
                guard let imageURL = URL(string: note.userShareIcon ?? "") else { return }
                guard let imageData = try? Data(contentsOf: imageURL) else { return }
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.shareIconImage.image = UIImage(data: imageData)
                }
            }
        } else {
            shareIconImage.image = .none
        }
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        self.editingMode = editing
            self.containerLeftConstraint?.constant = editing ? 44.0 : 0.0
            UIView.animate(withDuration: 0.25) {
                self.editControlImage.alpha = editing ? 1.0 : 0.0
                self.contentView.layoutIfNeeded()
            }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if editingMode {
            self.editControlImage.image =
            selected ? UIImage(named: Constant.selectCellCheckbox) : UIImage(named: Constant.deselectCellCheckbox)
        }
    }
}
