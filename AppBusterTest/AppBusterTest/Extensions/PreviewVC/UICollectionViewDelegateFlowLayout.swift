//
//  layot.swift
//  AppBusterTest
//
//  Created by Денис Денисов on 11.01.2022.
//

import UIKit
import Foundation


extension PreviewVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            CGSize(
                width: floor(collectionView.frame.width - (2 * .inset)),
                height: floor((collectionView.bounds.height - (.rowsCountforCollectionViewLayoutBounds - 1) * .spacing - 2 * .inset) / .rowsCountforCollectionViewLayoutBounds)
            )
        }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == gists.count - 1 && gists.count != 1 {
            gistProvider.getNextGists()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.row != gists.count else { return }
        guard let url = URL(string: gists[indexPath.row].htmlUrl) else {
            fatalError("Incorrect data from server")
        }
        let detailVC = DetailVC(url: url)
        present(detailVC, animated: true)
    }
}
