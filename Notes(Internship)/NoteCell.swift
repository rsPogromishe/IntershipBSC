//
//  NoteView.swift
//  Notes(Internship)
//
//  Created by Снытин Ростислав on 12.04.2022.
//

import UIKit

class NoteCell: UITableViewCell {
    static let cellIdentifier = "cell"

    private let conteinerView = UIView()
    private let titleLabel = UILabel()
    private let textNoteLabel = UILabel()
    private let dateLabel = UILabel()
    var imageView1 = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupCell()
        let viewS = UIView()
        self.backgroundView = viewS
        viewS.addSubview(imageView1)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func willTransition(to state: UITableViewCell.StateMask) {
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0))
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 14

        layer.cornerRadius = 14
        backgroundColor = .white

        //setupCellCheckbox()
        if isEditing {
            imageView1.frame = CGRect(x: 19, y: 33, width: 16, height: 16)
            imageView1.clipsToBounds = true
            if isSelected {
                imageView1.image = UIImage(named: Constant.selectCellCheckbox)
            } else {
                imageView1.image = UIImage(named: Constant.deselectCellCheckbox)
            }
        }
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
        //conteinerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        contentView.addSubview(textNoteLabel)
        contentView.addSubview(dateLabel)
        //addSubview(conteinerView)
        imageView1.translatesAutoresizingMaskIntoConstraints = false
        //addSubview(imageView1)
        //self.backgroundView?.addSubview(imageView1)

        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 94.0),

//            view.leftAnchor.constraint(equalTo: backView.leftAnchor),
//            view.rightAnchor.constraint(equalTo: backView.rightAnchor),
//            view.topAnchor.constraint(equalTo: backView.topAnchor),
//            view.bottomAnchor.constraint(equalTo: backView.bottomAnchor),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            titleLabel.heightAnchor.constraint(equalToConstant: 18.0),

            textNoteLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 3),
            textNoteLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            textNoteLabel.heightAnchor.constraint(equalToConstant: 14.0),

            dateLabel.topAnchor.constraint(equalTo: textNoteLabel.bottomAnchor, constant: 26),
            dateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            dateLabel.heightAnchor.constraint(equalToConstant: 10.0)

//            imageView1.leftAnchor.constraint(equalTo: self.backgroundView?.leftAnchor ?? leftAnchor, constant: 6),
//            imageView1.topAnchor.constraint(equalTo: self.backgroundView?.topAnchor ?? topAnchor, constant: 10),
//            imageView1.heightAnchor.constraint(equalToConstant: 21.67),
//            imageView1.widthAnchor.constraint(equalToConstant: 21.67)
        ])
    }

    private func setupCellCheckbox() {
        for control in self.subviews {
            if control.isMember(of: NSClassFromString("UITableViewCellEditControl") ?? AnyObject.self) {
                for view in control.subviews {
                    if view.isKind(of: UIImageView.self) {
                        guard let image = view as? UIImageView else { return }
                        if isEditing {
                            image.frame = CGRect(x: 5, y: 7, width: 16, height: 16)
                            if isSelected {
                                image.image = UIImage(named: Constant.selectCellCheckbox)
                            } else {
                                image.image = UIImage(named: Constant.deselectCellCheckbox)
                            }
                        }
                    }
                }
            }
        }
    }

    func configure(note: Note) {
        titleLabel.text = note.titleText
        textNoteLabel.text = note.mainText
        dateLabel.text = DateFormat.dateToday(day: note.date ?? Date(), formatter: Constant.listDateFormatter)
    }
}
