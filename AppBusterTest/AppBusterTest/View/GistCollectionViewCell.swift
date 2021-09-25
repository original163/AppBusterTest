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
        
        contentView.backgroundColor = UIColor(white: 1, alpha: 0.4)
        contentView.layer.cornerRadius = 25
        
        //создаём stackView и помещаем в неё все наши View разделив им пространство поровну
        let stackView: UIStackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.alignment = .center
            stack.distribution = .fillEqually
            [nameLabel,createDateLabel,updateDateLabel].forEach(stack.addArrangedSubview)
            return stack
        }()
        
        //добавляем на вьюху ячейки, обратить внимание что это ContentView
        contentView.addSubview(stackView)
        
        //и растягиваем stackView на всю ячейку
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
