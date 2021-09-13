//
//  GreetingVC.swift
//  AppBusterTest
//
//  Created by Денис Денисов on 07.09.2021.
//

import UIKit
import SnapKit


final class GreetingVC: UIViewController {
    
    var nickname: String = K.text.emptyString
    
    
    
    private let backgroundImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: K.imageNames.greetingVCbackground ))
        return image
    }()
    
    private let wrappViewForLogo: UIView = {
        let view = UIView()
        return view
    }()
    
    private let logoImage:UIImageView = {
        let image = UIImageView(image: UIImage(named: K.imageNames.greetingVClogo))
        return image
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = K.text.infoLabelText
        label.backgroundColor = .init(white: 0, alpha: 0)
        label.textAlignment = .center
        label.font = UIFont(name: K.fontNames.chalkboardSE, size: 50)
        return label
    }()
    
    private let wrappViewForTextField: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.darkGray.cgColor
        view.backgroundColor = .lightGray
        view.layer.borderWidth = 2.0
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let userNameTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: K.fontNames.chalkboardSE, size: 27.0)
        textField.placeholder = K.text.placholderText
        textField.textColor = .black
        return textField
    }()
    
    private let noInputLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .init(white: 0, alpha: 0)
        label.textAlignment = .center
        label.font = UIFont(name: K.fontNames.chalkboardSE, size: 25)
        return label
    }()
    
    private let submitButton: UIButton = {
        let button = UIButton(type: .system) as UIButton
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        button.setTitle(K.text.buttonText, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        button.backgroundColor = .darkText
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.tintColor = .white
        return button
    }()
    
    
   @objc func buttonPressed(sender: UIButton!) {
        if userNameTextField.text == K.text.emptyString {
            noInputLabel.text = K.text.noInputLabelTextArray.randomElement()
            noInputLabel.fadeInAndOut()
        } else {
            nickname = userNameTextField.text!
       }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        view.addSubview(backgroundImage)
        view.addSubview(submitButton)
        view.addSubview(noInputLabel)
        view.addSubview(wrappViewForTextField)
        view.addSubview(wrappViewForLogo)
        
        
        wrappViewForTextField.addSubview(userNameTextField)
        wrappViewForLogo.addSubview(logoImage)
        wrappViewForLogo.addSubview(infoLabel)
        
        
        noInputLabel.isHidden = true
        
        
        backgroundImage.snp.makeConstraints {
            $0.size.equalToSuperview()
        }

        wrappViewForLogo.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalTo(wrappViewForTextField.snp.top)
        }

        logoImage.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalToSuperview().multipliedBy(0.8)
        }

        infoLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(40)
            $0.centerX.equalToSuperview()

        }

        wrappViewForTextField.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.8)
        }

        userNameTextField.snp.makeConstraints {
            $0.size.equalToSuperview().inset(10)
            $0.center.equalToSuperview()

        }

        noInputLabel.snp.makeConstraints {
            $0.top.equalTo(userNameTextField.snp.bottom)
            $0.bottom.equalTo(submitButton.snp.top)
            $0.centerX.equalToSuperview()
        }

        submitButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.6)
            $0.height.equalToSuperview().multipliedBy(0.08)
            $0.top.equalTo(userNameTextField.snp.bottom).offset(100)
        }
   }
}


private extension UIView {
    
    func fadeInAndOut(
            duration: TimeInterval = 0.2,
            delayIn: TimeInterval = 0.0,
            between: TimeInterval = 1.0
        ) {
            // delayIn (alpha = 0) -> duration (alpha = 1) -> between (alpha = 1) -> duration (alpha = 0)
            fadeIn(duration: duration, delay: delayIn) { _ in
                self.fadeOut(duration: duration, delay: between)
            }
        }
    func fadeIn(
            duration: TimeInterval = 0.2,
            delay: TimeInterval = 0.0,
            _ completion: @escaping ((Bool) -> Void)
        ) {
            guard isHidden else { return }
            alpha = 0.0
            isHidden = false
            UIView.animate(
                withDuration: duration,
                delay: delay,
                animations:
                    {
                        self.alpha = 1.0
                    },
                completion: completion
            )
        }
    
    func fadeOut(
            duration: TimeInterval = 0.2,
            delay: TimeInterval = 0.0,
            _ completion: ((Bool) -> Void)? = nil
        ) {
            guard !isHidden else { return }
            UIView.animate(
                withDuration: duration,
                delay: delay,
                animations:
                    {
                        self.alpha = 0.0
                    },
                completion:
                    { isAnimated in
                        self.isHidden = true
                        completion?(isAnimated)
                    }
            )
        }



}
