//
//  LoadingCollectionViewCell.swift
//  AppBusterTest
//
//  Created by Денис Денисов on 26.09.2021.
//

import UIKit
import SnapKit

final class LoadingCollectionViewCell: UICollectionViewCell {
    static let reuseId = "LoadingCell"

    private let loader = UIActivityIndicatorView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(loader)
        loader.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        loader.startAnimating()
    }

    override func prepareForReuse() {
        loader.startAnimating()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
