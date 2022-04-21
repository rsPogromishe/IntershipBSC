//
//  NoteView.swift
//  Notes(Internship)
//
//  Created by Снытин Ростислав on 12.04.2022.
//

import UIKit

class NoteCell: UITableViewCell {
    static let cellIdentifier = "cell"

    private let titleLabel = UILabel()
    private let textNoteLabel = UILabel()
    private let dateLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0))
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 14
        sendSubviewToBack(contentView)
    }

    private func setupCell() {
        self.backgroundColor = UIColor(named: Constant.screenBackgroundColor)
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        textNoteLabel.font = .systemFont(ofSize: 10, weight: .medium)
        textNoteLabel.textColor = UIColor(red: 0.675, green: 0.675, blue: 0.675, alpha: 1)
        dateLabel.font = .systemFont(ofSize: 10, weight: .medium)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        textNoteLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        addSubview(textNoteLabel)
        addSubview(dateLabel)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 94.0),

            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            titleLabel.heightAnchor.constraint(equalToConstant: 18.0),

            textNoteLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 3),
            textNoteLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            textNoteLabel.heightAnchor.constraint(equalToConstant: 14.0),

            dateLabel.topAnchor.constraint(equalTo: textNoteLabel.bottomAnchor, constant: 26),
            dateLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            dateLabel.heightAnchor.constraint(equalToConstant: 10.0)
        ])
    }

    func configure(note: Note) {
        titleLabel.text = note.titleText
        textNoteLabel.text = note.mainText
        dateLabel.text = DateFormat.dateToday(day: note.date ?? Date(), formatter: Constant.listDateFormatter)
    }
}