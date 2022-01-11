//
//  dataSource.swift
//  AppBusterTest
//
//  Created by Денис Денисов on 11.01.2022.
//

import UIKit

extension PreviewVC: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        !isFinished ? gists.count + 1 : gists.count
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < gists.count {
            if imageState == .notLoaded,
               imageState != .loading,
               let url = URL(string: gists[indexPath.row].owner.avatarURL) {
                setImage(withURL: url)
            }
            return makeGistCollectionViewCell(collectionView, at: indexPath)
        } else {
            return makeLoadingCollectionViewCell(collectionView, at: indexPath)
        }
    }
    private func makeGistCollectionViewCell(_ collectionView: UICollectionView, at indexPath: IndexPath) -> GistCollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GistCollectionViewCell.reuseId, for: indexPath) as? GistCollectionViewCell else {
            fatalError("Error: Can not dequeue GistCollectionViewCell")
        }
        let gist = gists[indexPath.row]
        cell.createDate = gist.dateCreated
        cell.title = gist.title.isEmpty ? "No description" : gist.title
        return cell
    }
    
    private func makeLoadingCollectionViewCell(_ collectionView: UICollectionView, at indexPath: IndexPath) -> LoadingCollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCollectionViewCell.reuseId, for: indexPath) as? LoadingCollectionViewCell else {
            fatalError("Error: Can not dequeue GistCollectionViewCell")
        }
        return cell
    }
}

