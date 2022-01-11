//
//  PreviewVC.swift
//  AppBusterTest
//
//  Created by Денис Денисов on 10.09.2021.
//
import UIKit
import SnapKit

final class PreviewVC: UIViewController {
    let gistProvider: GistsProvider
    var username: String
    var isFinished: Bool = false
    var imageState: ImageState = .notLoaded
    var gists: [Gist] = [Gist]()
    private let backgroundImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: Constants.imageNames.previewVCbackground.rawValue ))
        return image
    }()
    enum ImageState {
        case notLoaded
        case loading
        case loaded
    }
    private let userAvatar: UIImageView = {
        let loader = UIActivityIndicatorView(style: .medium)
        let image = UIImage(named: Constants.imageNames.greetingVClogo.rawValue)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private lazy var infoView: UIStackView = {
        let stack = UIStackView()
        var userNickname = UILabel()
        userNickname.text = username
        userNickname.font = UIFont(name: Constants.fontNames.chalkboardSE.rawValue, size: 30)
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fillEqually
        [userAvatar,userNickname,].forEach(stack.addArrangedSubview)
        return stack
    }()
    let gistCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = .spacing
        layout.sectionInset = UIEdgeInsets(top: .inset, left: .inset, bottom: .inset, right: .inset)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white.withAlphaComponent(0.0)
        collectionView.layer.cornerRadius = 25
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    init(username: String) {
        self.username = username
        gistProvider = GistsProvider(username: username)
        print("PreviewVC - created")
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        gistProvider.delegate = self
        gistProvider.getNextGists()
        
        gistCollectionView.register(GistCollectionViewCell.self, forCellWithReuseIdentifier: GistCollectionViewCell.reuseId)
        gistCollectionView.register(LoadingCollectionViewCell.self, forCellWithReuseIdentifier: LoadingCollectionViewCell.reuseId)
        gistCollectionView.dataSource = self
        gistCollectionView.delegate = self
        
        setupUI()
    }
    
    func setupUI() {
        view.addSubview(backgroundImage)
        view.addSubview(gistCollectionView)
        view.addSubview(infoView)
        userAvatar.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.33)
        }
        infoView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.height.equalToSuperview().multipliedBy(0.3)
            $0.width.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        gistCollectionView.snp.makeConstraints {
            $0.top.equalTo(infoView.snp.bottom)
            $0.width.equalToSuperview().inset(10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        backgroundImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    func setImage(withURL url: URL) { // must be on отдельный класс API
        imageState = .loading
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if error != nil {
                self?.imageState = .notLoaded
                return
            }
            guard
                let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode)
            else {
                self?.imageState = .notLoaded
                return
            }
            guard
                let data = data,
                let image = UIImage(data: data)
            else {
                self?.imageState = .notLoaded
                return
            }
            DispatchQueue.main.async {
                self?.userAvatar.image = image
                self?.imageState = .loaded
            }
        }
        .resume()
    }
    
    deinit {
        print("PreviewVC deleted")
    }
}




