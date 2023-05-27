//
//  WelcomeViewController.swift
//  Chat
//
//  Created by sidzhe on 03.05.2023.
//

import UIKit
import SnapKit

class WelcomeViewController: UIViewController {
    
    //MARK: UI Elements
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemMint
        label.font = .systemFont(ofSize: 50, weight: .heavy)
        return label
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton()
        button.setTitle(Const.String.register, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 25, weight: .semibold)
        button.backgroundColor = UIColor(named: Const.Colors.brandLightBlue)
        button.setTitleColor(UIColor(named: Const.Colors.brandBlue), for: .normal)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(pressedButton(sender:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var logInButton: UIButton = {
        let button = UIButton()
        button.setTitle(Const.String.logIn, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 25, weight: .semibold)
        button.backgroundColor = UIColor(named: Const.Colors.brandBlue)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(pressedButton(sender:)), for: .touchUpInside)
        return button
    }()
    
    //MARK: init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        animationHeaderText()
        
    }
    
    //MARK: Private methods
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(headerLabel)
        view.addSubview(logInButton)
        view.addSubview(registerButton)
        
        headerLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        logInButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-30)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        
        registerButton.snp.makeConstraints { make in
            make.bottom.equalTo(logInButton.snp.top).offset(-20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
    }
    
    private func animationHeaderText() {
        headerLabel.text = ""
        let flash = Const.String.flash
        var indexChar = 0.1
        for i in flash {
            Timer.scheduledTimer(withTimeInterval: indexChar, repeats: false) { timer in
                self.headerLabel.text?.append(i)
            }
            
            indexChar += 0.1
        }
    }
    
    //MARK: Taps Methods
    
    @objc private func pressedButton(sender: UIButton) {
        if sender.currentTitle == Const.String.register {
            navigationController?.pushViewController(RegisterViewConlroller(), animated: true)
        } else {
            navigationController?.pushViewController(LogInViewController(), animated: true)
        }
    }
}


