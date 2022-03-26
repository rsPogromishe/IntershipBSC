//
//  ViewController.swift
//  Notes(Internship)
//
//  Created by Снытин Ростислав on 26.03.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    private let mainTextField = UITextField()
    private let titleTextField = UITextField()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        
        let mainContainer = UIView()
        mainContainer.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mainContainer)
        mainContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mainContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        mainContainer.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        mainContainer.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        
        mainContainer.addSubview(titleTextField)
        titleTextField.topAnchor.constraint(equalTo: mainContainer.topAnchor).isActive = true
        titleTextField.leftAnchor.constraint(equalTo: mainContainer.leftAnchor).isActive = true
        titleTextField.rightAnchor.constraint(equalTo: mainContainer.rightAnchor).isActive = true
        titleTextField
        titleTextField.backgroundColor = .darkGray
        
        mainContainer.addSubview(mainTextField)
        mainTextField.leftAnchor.constraint(equalTo: mainContainer.leftAnchor).isActive = true
        mainTextField.rightAnchor.constraint(equalTo: mainContainer.rightAnchor).isActive = true
        mainTextField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20).isActive = true
        mainTextField.bottomAnchor.constraint(lessThanOrEqualTo: mainContainer.bottomAnchor).isActive = true
        mainTextField.backgroundColor = .gray
        
    }


}

