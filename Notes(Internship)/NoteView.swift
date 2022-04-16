//
//  NoteView.swift
//  Notes(Internship)
//
//  Created by Снытин Ростислав on 12.04.2022.
//

import Foundation
import UIKit

class NoteView: UIView {
    private var note: Note
    private var onCompletion: (Note) -> Void

    private let titleLabel = UILabel()
    private let textNoteLabel = UILabel()
    private let dateLabel = UILabel()

    init(
        frame: CGRect,
        note: Note,
        onCompetion: @escaping (Note) -> Void
    ) {
        self.note = note
        self.onCompletion = onCompetion
        super.init(frame: frame)
        setUpView()
        addTapGesture()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }

    @objc func didTap(_ sender: UITapGestureRecognizer) {
        onCompletion(note)
    }

    private func setUpView() {
        self.layer.cornerRadius = 14
        self.backgroundColor = .white
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
            heightAnchor.constraint(equalToConstant: 90.0),

            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            titleLabel.heightAnchor.constraint(equalToConstant: 18.0),

            textNoteLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            textNoteLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            textNoteLabel.heightAnchor.constraint(equalToConstant: 14.0),

            dateLabel.topAnchor.constraint(equalTo: textNoteLabel.bottomAnchor, constant: 24),
            dateLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            dateLabel.heightAnchor.constraint(equalToConstant: 10.0)
        ])
        titleLabel.text = note.titleText
        textNoteLabel.text = note.mainText
        dateLabel.text = DateFormat.dateToday(day: note.date ?? Date(), formatter: Constant.listDateFormatter)
    }
}
