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

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        label.font = UIFont(name: Constants.FontNames.chalkboardSE.rawValue, size: 20)
        return label
    }()

    private let createDateLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        isUserInteractionEnabled = true
        contentView.backgroundColor = UIColor(white: 1, alpha: 0.4)
        contentView.layer.cornerRadius = 25

        let stackView: UIStackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.alignment = .center
            return stack
        }()

        contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10.0)

        }

        titleLabel.snp.contentCompressionResistanceVerticalPriority = 750.0
        titleLabel.snp.contentHuggingVerticalPriority = 250.0
        createDateLabel.snp.contentCompressionResistanceVerticalPriority = 250.0
        createDateLabel.snp.contentHuggingVerticalPriority = 750.0

        [titleLabel, createDateLabel].forEach(stackView.addArrangedSubview)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }
     var createDate: String? {
        get { createDateLabel.text }
        set { createDateLabel.text = newValue }
    }
}
