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
    static let spacing: CGFloat = 2.0 // for CollectionView Layout
    static let inset: CGFloat = 2.0   // for CollectionView Layout
    
    // for SizeForItem method in UICollectionViewDelegateFlowLayout
    //здесь задается количество ячеек в CollectionView
    static let rowsCountforCollectionViewLayoutBounds: CGFloat = 3.0
}

//private extension String {
//    var converted = {
//        let ISOFormatter = ISO8601DateFormatter()
//        let date = ISOFormatter.date(from: self)!
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MMM d, HH:mm"
//        let stringDate = dateFormatter.string(from: date)
//        print(stringDate)
//
//
//
//    }()
//}



final class PreviewVC: UIViewController {
    
    
    
    
    let gistProvider = GistsProvider(username: "original163")
    private var mainGistsArray: [Gist] = [Gist]()
    
    
    
    
    
    
    
    private let backgroundImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: K.imageNames.previewVCbackground ))
        return image
    }()
    private let infoView: UIStackView = {
        let stack = UIStackView()
        let userAvatar = UIImageView(image: UIImage(named: "1.jpg"))
        let userNickname = UILabel()
        userAvatar.contentMode = .scaleAspectFit
        userNickname.text = "Original163"
        userNickname.font = UIFont(name: K.fontNames.chalkboardSE, size: 30)
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
        
        collectionView.allowsSelection = true
        collectionView.isUserInteractionEnabled = true
        
        collectionView.backgroundColor = UIColor(white: 0, alpha: 0)
        collectionView.layer.cornerRadius = 25
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .red
//        label.backgroundColor = .init(white: 0, alpha: 0)
        label.textAlignment = .center
        label.font = UIFont(name: K.fontNames.chalkboardSE, size: 15)
        
        return label
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        gistProvider.delegate = self
        gistProvider.getNextGists()
        
        
        
        //10 обязательно ПЕРВЫМ ДЕЛОМ регистрируем ячейку КОСТОМНЫЙ КЛАСС ЯЧЕЙКИ
        gistCollectionView.register(GistCollectionViewCell.self, forCellWithReuseIdentifier: GistCollectionViewCell.reuseId)
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
            $0.bottom.equalToSuperview()
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
extension UIViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //ожидает получить CGSize объект
        //поэтому мы его создаём и высчитываем размер ячейки который будет зависесть от размера
        //collectionView, которая в свою очередь будет зависеть от размера Veiw (всего экрана)
        
        CGSize(
            //ширина ячейки. Округляем до целого вниз.
            width: floor(collectionView.frame.width - (2 * .inset)),
            
            //высота ячейки. Округляем до целого вниз.
            height: floor((collectionView.bounds.height - 3 * .spacing - 2 * .inset) / .rowsCountforCollectionViewLayoutBounds)
        )
        
    }
    
}



extension PreviewVC: GistsProviderDelegate {
    func gistProviderDelegate(_ gistProvider: GistsProvider, didReceiveNextPage gists: [Gist]) {
        let newGists = gists
        if mainGistsArray.count < (mainGistsArray + newGists).count {
            mainGistsArray = mainGistsArray + newGists
            gistCollectionView.reloadData()
        }
    
        
    }
    
    func gistProviderDelegate(_ gistProvider: GistsProvider, didFailWithError error: Error) {
        errorLabel.text = error.localizedDescription
        errorLabel.fadeInAndOut(duration: 3, delayIn: 0.0, between: 0.5)
        
        
        
    }
        
        
    
    func gistProviderDelegate(_ gistProvider: GistsProvider, didReachFinalPage finished: Bool) {
    
    }
}

// 9 для заполнения PreviewVC -> CollectionView нужно реализовать два метода которые находятся в протоколе
extension PreviewVC: UICollectionViewDataSource {
    
    // метод отвечающий за количество ячеек
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return mainGistsArray.count
    }
    
    // метод возвращающий ячейку в конкретную позицию (IndexPath)
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // тут происходит заполнение ячейки данными
        // 13, 16 - создаем класс ячейки
        // заливаем данные в шаблон ячейки с идентификатором который мы задали при создании этого шаблона
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GistCollectionViewCell.reuseId, for: indexPath) as? GistCollectionViewCell else {
            fatalError("Error: Can not dequeue GistCollectionViewCell")
        }
        
        let cellHtmlUrl = mainGistsArray[indexPath.row].htmlUrl
        let dateCreated = mainGistsArray[indexPath.row].dateCreated
        //setting cell
        cell.createDate = "created at: " + covertDate(ISO8601string: dateCreated) //might be extension of String?
        cell.updateDate = "WebView"
        if mainGistsArray[indexPath.row].gistTitle == "" {
            cell.title = "no discription"
        } else {
            cell.title = mainGistsArray[indexPath.row].gistTitle
        }
        
        return cell
    }
    
    func covertDate(ISO8601string: String) -> String {
        let ISOFormatter = ISO8601DateFormatter()
        let date = ISOFormatter.date(from: ISO8601string)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, HH:mm"
        return dateFormatter.string(from: date)
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == mainGistsArray.count - 1 {
            gistProvider.getNextGists()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("УРААА")
        print(indexPath.row)
    }
    
}





