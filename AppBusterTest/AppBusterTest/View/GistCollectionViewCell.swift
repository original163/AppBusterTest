//
//  GistCollectionViewCell.swift
//  AppBusterTest
//
//  Created by Денис Денисов on 11.09.2021.
//

import UIKit
import SnapKit

class GistCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "GistCollectionViewCell"
    
    private let nameLabel = UILabel()
    private let createDateLabel = UILabel()
    private let updateDateLabel = UILabel()
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        
        
        contentView.backgroundColor = UIColor(white: 1, alpha: 0.4)
        contentView.layer.cornerRadius = 25
        
        //создаём stackView и помещаем в неё все наши View разделив им пространство поровну
        let stackView: UIStackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.alignment = .center
//            stack.distribution = .fillEqually
            [nameLabel,updateDateLabel, createDateLabel].forEach(stack.addArrangedSubview)
            return stack
        }()
        
        //добавляем на вьюху ячейки, обратить внимание что это ContentView
        contentView.addSubview(stackView)
        
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(10)
            $0.height.equalToSuperview().multipliedBy(0.2)
        }
        updateDateLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom)
            $0.left.equalToSuperview()
            $0.width.equalToSuperview()
        }
        createDateLabel.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.5)
            $0.height.equalToSuperview().multipliedBy(0.2)
            $0.bottom.equalToSuperview()
        }
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            }
        
        




        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //добавляем property нашему классу ячейки и инкапсулируем их
    var title: String? {
        get {
            nameLabel.text
        }
        set {
            nameLabel.text = newValue
        }
    }
    
    var createDate: String? {
        get {
            createDateLabel.text
        }
        set {
            createDateLabel.text = newValue
        }
    }
    
    var updateDate: String? {
        get {
            updateDateLabel.text
        }
        set {
            updateDateLabel.text = newValue
        }
    }
    
}
