//
//  LogInViewController.swift
//  Chat
//
//  Created by sidzhe on 03.05.2023.
//

import UIKit
import SnapKit
import FirebaseAuth

class LogInViewController: UIViewController {
    
    //MARK: UI Elements
    
    private lazy var backgroundEmail: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: Const.Colors.textfield)
        return image
    }()
    
    private lazy var backgroundPassword: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: Const.Colors.textfield)
        return image
    }()
    
    private lazy var logInButton: UIButton = {
        let button = UIButton()
        button.setTitle(Const.String.logIn, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 25, weight: .semibold)
        button.addTarget(self, action: #selector(pressedButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var emailTexiField: UITextField = {
        let text = UITextField()
        text.font = .systemFont(ofSize: 20)
        text.placeholder = Const.String.email
        text.delegate = self
        return text
    }()
    
    private lazy var passwordTexiField: UITextField = {
        let text = UITextField()
        text.font = .systemFont(ofSize: 20)
        text.isSecureTextEntry = true
        text.delegate = self
        text.placeholder = Const.String.password
        return text
    }()
    
    //MARK: Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
    }
    
    //MARK: Prvate methods
    
    private func setupViews() {
        view.backgroundColor = UIColor(named: Const.Colors.brandBlue)
        view.addSubview(backgroundEmail)
        view.addSubview(backgroundPassword)
        view.addSubview(logInButton)
        view.addSubview(emailTexiField)
        view.addSubview(passwordTexiField)
        
        backgroundEmail.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(200)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(130)
        }
        
        backgroundPassword.snp.makeConstraints { make in
            make.top.equalTo(backgroundEmail.snp.top).inset(80)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(130)
        }
        
        emailTexiField.snp.makeConstraints { make in
            make.centerX.equalTo(backgroundEmail.snp.centerX)
            make.centerY.equalTo(backgroundEmail.snp.centerY).offset(-20)
        }
        
        passwordTexiField.snp.makeConstraints { make in
            make.centerX.equalTo(backgroundPassword.snp.centerX)
            make.centerY.equalTo(backgroundPassword.snp.centerY).offset(-20)
        }
        
        logInButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTexiField.snp.top).inset(70)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }
    
    //MARK: Taps methods
    
    @objc private func pressedButton() {
        guard let email = emailTexiField.text else { return }
        guard let password = passwordTexiField.text else { return }
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.navigationController?.pushViewController(ChatViewController(), animated: true)
            }
        }
    }
}

//MARK: extension UITextFieldDelegate

extension LogInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
