//
//  GreetingVC.swift
//  AppBusterTest
//
//  Created by Денис Денисов on 07.09.2021.
//

import UIKit
import SnapKit


final class GreetingVC: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
        print("GreetingVC - created")
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let backgroundImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: Constants.imageNames.greetingVCbackground.rawValue))
        return image
    }()
    private let stackLogoWithLabel: UIStackView = {
        let logo = UIImageView(image: UIImage(named: Constants.imageNames.greetingVClogo.rawValue))
        logo.contentMode = .scaleAspectFit
        let label = UILabel()
        label.text = Constants.text.infoLabelText.rawValue
        label.backgroundColor = .init(white: 0, alpha: 0)
        label.textAlignment = .center
        label.font = UIFont(name: Constants.fontNames.chalkboardSE.rawValue, size: 50)
        
        let stack = UIStackView(arrangedSubviews: [logo, label])
        stack.alignment = .center
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.autoresizesSubviews = true
        return stack
    }()
    
    private let wrappViewForTextField: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.darkGray.cgColor
        view.backgroundColor = .lightGray
        view.layer.borderWidth = 2.0
        view.layer.cornerRadius = 15
        return view
    }()
    let userNameTextField: UITextField = {
        let textField = UITextField()
        textField.autocapitalizationType = .none
        textField.font = UIFont(name: Constants.fontNames.chalkboardSE.rawValue, size: 27.0)
        textField.placeholder = Constants.text.placholderText.rawValue
        textField.textColor = .black
        textField.autocorrectionType = .no
        textField.returnKeyType = .search
        return textField
    }()
    private let submitButton: UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        button.setTitle(Constants.text.buttonText.rawValue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        button.backgroundColor = .darkText
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.tintColor = .white
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameTextField.delegate = self
        setupLayout()
    }
    @objc func buttonPressed(sender: UIButton!) {
        
        userNameTextField.endEditing(true)
        if userNameTextField.text == "" {
            let alert = UIAlertController(title: "No input", message: "Please enter nickaname", preferredStyle: .alert)
            let action = UIAlertAction(title: "ok", style: .cancel)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else {
            guard let username = userNameTextField.text else { return }
            let previewVC = PreviewVC(username: username)
            navigationController?.pushViewController(previewVC, animated: true)
        }
    }
    
    func setupLayout() {
        view.addSubview(backgroundImage)
        view.addSubview(stackLogoWithLabel)
        view.addSubview(wrappViewForTextField)
        view.addSubview(submitButton)
        wrappViewForTextField.addSubview(userNameTextField)
        
        backgroundImage.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalToSuperview()
        }
        stackLogoWithLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.centerX.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.4)
        }
        wrappViewForTextField.snp.makeConstraints {
            $0.top.equalTo(stackLogoWithLabel.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.height.equalToSuperview().multipliedBy(0.08)
        }
        userNameTextField.snp.makeConstraints {
            $0.size.equalToSuperview().inset(10)
            $0.center.equalToSuperview()
        }
        submitButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.6)
            $0.height.equalToSuperview().multipliedBy(0.08)
            $0.bottom.equalToSuperview().inset(40)
        }
    }
    deinit {
        print("GreatingVC deleted")
    }
}


