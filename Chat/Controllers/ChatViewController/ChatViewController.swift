//
//  ChatViewController.swift
//  Chat
//
//  Created by sidzhe on 03.05.2023.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {
    
    //MARK: Properties
    
    private let db = Firestore.firestore()
    
    private lazy var messege: [Message] = []
    
    //MARK: UI Elements
    
    private lazy var itemButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: Const.String.logOut,
                                     style: .plain, target: self,
                                     action: #selector(backToMain))
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 20
        return view
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: Const.Colors.paperplane), for: .normal)
        button.addTarget(self, action: #selector(pressedButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.separatorStyle = .none
        view.allowsSelection = false
        view.dataSource = self
        view.delegate = self
        view.register(ChatTableViewCell.self, forCellReuseIdentifier: Const.String.identifierCell)
        return view
    }()
    
    private lazy var messageView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: Const.Colors.brandPurple)
        return view
    }()
    
    private lazy var textField: UITextField = {
        let text = UITextField()
        text.borderStyle = .roundedRect
        text.placeholder = Const.String.writeMess
        text.delegate = self
        return text
    }()
    
    //MARK: Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        loadMessages()
        
    }
    
    //MARK: Keyboard init
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }
    
    //MARK: Setup Views
    
    private func setupViews() {
        view.backgroundColor = UIColor(named: Const.Colors.brandPurple)
        title = Const.String.flash
        navigationItem.rightBarButtonItem = itemButton
        navigationItem.hidesBackButton = true
        
        view.addSubview(messageView)
        view.addSubview(tableView)
        
        messageView.addSubview(stackView)
        
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(sendButton)
        
        messageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(100)
        }
        
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            make.bottom.equalTo(messageView.snp.top)
        }
        
        stackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(25)
            make.top.equalToSuperview().inset(25)
        }
    }
    
    //MARK: Keyboard methods
    
    private func adjustViewForKeyboard(show: Bool, notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardFrame.height
        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.3
        
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseInOut], animations: {
            let constant = show ? -keyboardHeight : 0
            self.messageView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(constant)
            }
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        adjustViewForKeyboard(show: true, notification: notification)
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        adjustViewForKeyboard(show: false, notification: notification)
    }
    
    private func addKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: Private methods
    
    private func loadMessages() {
        
        db.collection(Const.Fstore.collectionName)
            .order(by: Const.Fstore.date)
            .addSnapshotListener { querySnapshot, error in
                
                self.messege = []
                
                if let error = error {
                    print(error)
                }
                guard let querySnapshot = querySnapshot?.documents else { return }
                for i in querySnapshot {
                    let data = i.data()
                    guard let sender = data[Const.Fstore.sender] as? String else { return }
                    guard let body = data[Const.Fstore.body] as? String else { return }
                    let newMessage = Message(sender: sender, body: body)
                    self.messege.append(newMessage)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        let indexPath = IndexPath(row: self.messege.count - 1, section: 0)
                        self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                    }
                }
            }
    }
    
    //MARK: Taps methods
    
    @objc private func pressedButton() {
        guard let message = textField.text else { return }
        guard let messageSender = Auth.auth().currentUser?.email else { return }
        db.collection(Const.Fstore.collectionName).addDocument(data:[Const.Fstore.sender : messageSender, Const.Fstore.body : message, Const.Fstore.date : Date().timeIntervalSince1970]) { error in
            if let error = error {
                print(error)
            } else {
                DispatchQueue.main.async {
                    self.textField.text = ""
                }
            }
        }
    }
    
    @objc private func backToMain() {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

//MARK: Extension UITableViewDelegate, UITableViewDataSource

extension ChatViewController: UITableViewDelegate { }

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messege.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messege[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.String.identifierCell, for: indexPath) as! ChatTableViewCell
        cell.nameLabel.text = message.body
        
        if message.sender == Auth.auth().currentUser?.email {
            cell.imageCellLeft.isHidden = true
            cell.imageCellRight.isHidden = false
            cell.backgroungCellView.backgroundColor = UIColor(named: Const.Colors.brandLightPurple)
            cell.nameLabel.textColor = UIColor(named: Const.Colors.brandPurple)
        } else {
            cell.imageCellLeft.isHidden = false
            cell.imageCellRight.isHidden = true
            cell.backgroungCellView.backgroundColor = UIColor(named: Const.Colors.brandPurple)
            cell.nameLabel.textColor = UIColor(named: Const.Colors.brandLightPurple)
        }
        
        return cell
    }
}

extension ChatViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
