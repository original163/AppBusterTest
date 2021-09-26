//
//  PreviewVC.swift
//  AppBusterTest
//
//  Created by Денис Денисов on 10.09.2021.
//
import UIKit
import SnapKit

// for layout property
private extension CGFloat {
    static let spacing: CGFloat = 7.0 // for CollectionView Layout
    static let inset: CGFloat = 2.0   // for CollectionView Layout
    
    // for SizeForItem method in UICollectionViewDelegateFlowLayout
    //здесь задается количество ячеек в CollectionView
    static let rowsCountforCollectionViewLayoutBounds: CGFloat = 6.0
}


final class PreviewVC: UIViewController {
    private let gistProvider: GistsProvider
    private let username: String
    private var isFinished: Bool = false
    private var imageState: ImageState = .notLoaded
    private var gists: [Gist] = [Gist]()
    private let backgroundImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: Constants.imageNames.previewVCbackground ))
        return image
    }()
    
    private enum ImageState {
        case notLoaded
        case loading
        case loaded
    }
    
    private let userAvatar: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "1.jpg"))
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var infoView: UIStackView = {
        let stack = UIStackView()
        var userNickname = UILabel()
        userNickname.text = username
        userNickname.font = UIFont(name: Constants.fontNames.chalkboardSE, size: 30)
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fillEqually
        [userAvatar,userNickname,].forEach(stack.addArrangedSubview)
        return stack
        
    }()
    
    private let gistCollectionView: UICollectionView = {
        //2 CollectionView инициализируется с помощью объекта UICollectionViewFlowLayout
        //3 поэтому создаём объект этого класса
        //  он отвечает за расположение ячеек внутри CollectionView, что мы и определяем в его свойствах
        let layout = UICollectionViewFlowLayout()
        //4 прописываем то как у нас будут располагаться ячейки в CollectionView
        layout.scrollDirection = .vertical // направление скрола
        layout.minimumLineSpacing = .spacing // растояние между ячейками
        
        //5 расстояние между ячейками и краями CollectionView
        layout.sectionInset = UIEdgeInsets(top: .inset, left: .inset, bottom: .inset, right: .inset)
        //6 так как мы создали layout мы можем создать объект CollectionView с инциализатором collectionViewLayout
        // frame: .zero потому что дает явно понять что FRAME будет задаваться в будущем при расстовлении layout
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        
        collectionView.backgroundColor = .white.withAlphaComponent(0.0)
        collectionView.layer.cornerRadius = 25
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .red
//        label.backgroundColor = .init(white: 0, alpha: 0)
        label.textAlignment = .center
        label.font = UIFont(name: Constants.fontNames.chalkboardSE, size: 15)
        
        return label
    }()
    
    init(username: String) {
        self.username = username
        gistProvider = GistsProvider(username: username)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        gistProvider.delegate = self
        gistProvider.getNextGists()
        
        
        //10 обязательно ПЕРВЫМ ДЕЛОМ регистрируем ячейку КОСТОМНЫЙ КЛАСС ЯЧЕЙКИ
        gistCollectionView.register(GistCollectionViewCell.self, forCellWithReuseIdentifier: GistCollectionViewCell.reuseId)
        gistCollectionView.register(LoadingCollectionViewCell.self, forCellWithReuseIdentifier: LoadingCollectionViewCell.reuseId)
        //11 задаём PreviewVC поставщиком данных для gistCollectionView
        gistCollectionView.dataSource = self
        //12 задаём PreviewVC выполняющим метод (sizeForItemAt)
        gistCollectionView.delegate = self
        
        //14 располагаем коллекцию на экране
        view.addSubview(backgroundImage)
        view.addSubview(gistCollectionView)
        view.addSubview(infoView)
        view.addSubview(errorLabel)
        
        errorLabel.isHidden = true
        
        
        //15 делаем layout
        infoView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.height.equalToSuperview().multipliedBy(0.3)
            $0.width.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        gistCollectionView.snp.makeConstraints {
            $0.top.equalTo(infoView.snp.bottom)
            $0.width.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        backgroundImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        errorLabel.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.center.equalToSuperview()
            
        }
    }
}

// 7 высчитываем размер для ячейки с помощью метода делегата именно layout'a
// эти методы вызовутся когда collectionView установиться со своим layout и начнет прогружать layot для ячеек
extension PreviewVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //ожидает получить CGSize объект
        //поэтому мы его создаём и высчитываем размер ячейки который будет зависесть от размера
        //collectionView, которая в свою очередь будет зависеть от размера Veiw (всего экрана)
        
        CGSize(
            //ширина ячейки. Округляем до целого вниз.
            width: floor(collectionView.frame.width - (2 * .inset)),
            
            //высота ячейки. Округляем до целого вниз.
            height: floor((collectionView.bounds.height - (.rowsCountforCollectionViewLayoutBounds - 1) * .spacing - 2 * .inset) / .rowsCountforCollectionViewLayoutBounds)
        )
        
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == gists.count - 1 {
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


final class InformationButton: UIView {
    private let tapHandler: () -> ()
    private let infoText: String
    private let buttonText: String
    
    private let button = UIButton()
    private let label = UILabel()
    
    init(frame: CGRect = .zero, infoText: String, buttonText: String, tapHandler: @escaping () -> ()) {
        self.buttonText = buttonText
        self.tapHandler = tapHandler
        self.infoText = infoText
        super.init(frame: frame)
        
        let stack: UIStackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.alignment = .center
            [label, button].forEach(stack.addArrangedSubview)
            return stack
        }()
        
        addSubview(stack)
        stack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10.0)
        }
        
        button.addTarget(self, action: #selector(invokeTapHandler), for: .touchUpInside)
        button.setTitle(buttonText, for: .normal)
        
        label.text = infoText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func invokeTapHandler() {
        tapHandler()
    }
}


extension PreviewVC: GistsProviderDelegate {
    func gistProviderDelegate(_ gistProvider: GistsProvider, didReceiveNextPage gists: [Gist]) {
        self.gists += gists
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.gistCollectionView.reloadData()
        }
    }
    
    func gistProviderDelegate(_ gistProvider: GistsProvider, didFailWithError error: GistProviderError) {
        gistCollectionView.isHidden = true
        switch error {
        case .incorrectInput:
            showInformationButton(infoText: "Username doesn't exist", buttonText: "Type another one") { [weak self] in
                self?.dismiss(animated: true)
            }
            break
        case .systemError:
            // button.isHidden = true
            gistCollectionView.isHidden = false
            gistProvider.getNextGists() // вызов в обжс селекторе кнопки
        case .serverError:
            gistProvider.getNextGists() // вызов в обжс селекторе кнопки
        default:
            break
        }
        errorLabel.fadeInAndOut(duration: 3, delayIn: 0.0, between: 0.5)
    }
    
    private func showInformationButton(infoText: String, buttonText: String, tapHandler: @escaping () -> ()){
        let informationButton = InformationButton(infoText: "Username doesn't exist", buttonText: "Type another one", tapHandler: tapHandler)
        view.addSubview(informationButton)
        informationButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    
        
    
    
    func gistProviderDelegate(_ gistProvider: GistsProvider, didReachFinalPage finished: Bool) {
        isFinished = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.gistCollectionView.deleteItems(at: [IndexPath(row: self.gists.count, section: 0)])
        }
    }
}

// 9 для заполнения PreviewVC -> CollectionView нужно реализовать два метода которые находятся в протоколе
extension PreviewVC: UICollectionViewDataSource {
    // метод отвечающий за количество ячеек
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        !isFinished ? gists.count + 1 : gists.count
    }
    
    // метод возвращающий ячейку в конкретную позицию (IndexPath)
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
    
    private func setImage(withURL url: URL) {
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
}





