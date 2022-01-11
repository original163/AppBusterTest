//
//  gist.swift
//  AppBusterTest
//
//  Created by Денис Денисов on 11.01.2022.
//

import UIKit

extension PreviewVC: GistsProviderDelegate {
    
    func gistProviderDelegate(_ gistProvider: GistsProvider, didReceiveNextPage gists: [Gist]) {
        self.gists += gists
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.gistCollectionView.reloadData()
        }
    }
    func gistProviderDelegate(_ gistProvider: GistsProvider, didFailWithError error: GistProviderError) {
        gistCollectionView.isHidden = true
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .cancel)
        alert.addAction(action)
        switch error {
        case .incorrectInput:
            alert.title = "Username doesn't exist"
            alert.message = "Type another one"
            present(alert, animated: true, completion: nil)
            break
        case .systemError:
            alert.title = "Connection is lost..."
            present(alert, animated: true, completion: nil)
            break
        case .serverError:
            alert.title = "Server error"
            present(alert, animated: true, completion: nil)
        default:
            break
        }
    }
  
    func gistProviderDelegate(_ gistProvider: GistsProvider, didReachFinalPage finished: Bool) {
        isFinished = true
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .cancel)
        alert.addAction(action)
        alert.message = "User doesn't have gists"
        present(alert, animated: true, completion: nil)
        //        errorLabel.text = "User doesn't have gists"
        //        errorLabel.isHidden = !gists.isEmpty
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if self.gists.isEmpty == false {
                self.gistCollectionView.deleteItems(at: [IndexPath(row: self.gists.count, section: 0)])
            }
        }
    }
    func gistProviderDelegate(_ gistProvider: GistsProvider, didReachedFinalPage finished: Bool) {
        isFinished = true
    }
}
