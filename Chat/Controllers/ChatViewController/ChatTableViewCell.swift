//
//  ChatTableViewCell.swift
//  Chat
//
//  Created by sidzhe on 04.05.2023.
//

import UIKit
import SnapKit

class ChatTableViewCell: UITableViewCell {
    
    //MARK: UI Elements
    
    lazy var backgroungCellView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 25
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .top
        view.distribution = .fill
        view.spacing = 20
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    lazy var imageCellLeft: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: Const.Colors.avatarYou)
        return image
    }()
    
    lazy var imageCellRight: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: Const.Colors.avatar)
        return image
    }()
    
    //MARK: Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Private methods
    
    private func setupViews() {
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(imageCellLeft)
        stackView.addArrangedSubview(backgroungCellView)
        stackView.addArrangedSubview(imageCellRight)
        
        backgroungCellView.addSubview(nameLabel)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
        
        backgroungCellView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.verticalEdges.equalToSuperview().inset(20)
        }
        
        imageCellLeft.snp.makeConstraints { make in
            make.size.equalTo(40)
        }
        
        imageCellRight.snp.makeConstraints { make in
            make.size.equalTo(40)
        }
    }
}
