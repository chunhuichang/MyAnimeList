//
//  TopListViewController.swift
//  MyAnimeList
//
//  Created by Jill Chang on 2022/4/9.
//

import UIKit

class TopListViewController: UIViewController {
    
    private var viewModel: String
    
    private let typeNames = ["Anime","Manga","Favorite"]
    private let typeSubtype = ["anime":["airing","upcoming","tv","movie","ova","special","bypopularity","favorite"],"manga":["manga","novels","oneshots","doujin","manhwa","manhua","bypopularity","favorite"],"favorite":[]]
    private var tmpData = ["airing","upcoming","tv","movie","ova","special","bypopularity","favorite"]
    
    
    var horizontalScrollLayoutSection: NSCollectionLayoutSection {
            let space: Double = 10
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .absolute(318))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = space
            section.contentInsets = NSDirectionalEdgeInsets(top: space, leading: space, bottom: space, trailing: space)
            section.orthogonalScrollingBehavior = .continuous
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section.boundarySupplementaryItems = [header]
            return section
    }
        
    var verticalScrollLayoutSection: NSCollectionLayoutSection {
            let space: Double = 10
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/2))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = space
            section.contentInsets = NSDirectionalEdgeInsets(top: space, leading: space, bottom: space, trailing: space)
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(10))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section.boundarySupplementaryItems = [header]
            return section
    }

    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        //section的間距
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        //cell間距
        layout.minimumLineSpacing = 5
        //cell 長寬
        layout.itemSize = CGSize(width: 100, height: 30)
        //layout.estimatedItemSize
        //滑動的方向
        layout.scrollDirection = .horizontal
        
        
        let space: Double = 10
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .fractionalHeight(1))
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = space
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: space, bottom: 0, trailing: space)
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.scrollDirection = .horizontal
        let compositionalLayout =  UICollectionViewCompositionalLayout(section: section, configuration: configuration)
        
        let dynamicLayout = UICollectionViewCompositionalLayout { [unowned self] section, environment in
            if section.isMultiple(of: 2) {
                return self.horizontalScrollLayoutSection
            } else {
                return self.verticalScrollLayoutSection
            }
        }
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: dynamicLayout)
        view.register(ItemCell.self, forCellWithReuseIdentifier: "\(ItemCell.self)")
        view.delegate = self
        view.dataSource = self
        view.isPagingEnabled = true
        view.collectionViewLayout.invalidateLayout()
        return view
    }()
    
    private lazy var types: [TypeView] = {
        //only use in struct
//        return [TypeView](repeating: TypeView(title: "QWERASDF"), count: 3)
        
        let typeName = typeSubtype.keys
        print("typeName=\(typeName)")
        var views = [TypeView]()
        for type in typeNames {
            let view = TypeView(title: type)
            views.append(view)
        }
        return views
    }()
    
    private lazy var topStackView: UIStackView = {
        let topStackView = UIStackView(arrangedSubviews: types)
        topStackView.axis = .horizontal
        topStackView.distribution = .fillEqually
        topStackView.spacing = 10.0
        return topStackView
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Button", for: .normal)
        button.addTarget(self, action: #selector(handleButtonTapped), for: .touchUpInside)
        button.setTitleColor(.darkGray, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc private func handleButtonTapped() {
        print("Button tapped")
    }
    
    init(viewModel: String) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
    }
    
    private func setupUI() {
        self.view.backgroundColor = .white
        
        view.addSubview(topStackView, anchors: [.leadingSafeArea(20), .trailingSafeArea(-20),.topSafeArea(10),.height(50)])
        
        view.addSubview(collectionView, anchors: [.leadingSafeArea(20), .trailingSafeArea(-20),.topSafeArea(70),.bottomSafeArea(-50)])
        
    }
}

extension TopListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
        
        let nav = UINavigationController(rootViewController: WebViewController(urlString: "https://myanimelist.net/manga/23390/Shingeki_no_Kyojin"))
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
}

extension TopListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tmpData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ItemCell.self)", for: indexPath) as? ItemCell {
            //tmpData[indexPath.row]

            cell.setupCell(entity: TopEntity(malID: 23390, rank: 2, title: "Imaizumin Chi wa Douyara Gal no Tamariba ni Natteru Rashii", url: "https://myanimelist.net/manga/124483/Imaizumin_Chi_wa_Douyara_Gal_no_Tamariba_ni_Natteru_Rashii", imageURL: "https://cdn.myanimelist.net/images/manga/1/242797.jpg?s=71736414410e4600ca16d063fb9e67e1", type: "Doujinshi", startDate: "Aug 2019", isFavorite: true))
            
            cell.backgroundColor = .cyan
            return cell
        }
        fatalError("Unable to dequeue subclassed cell")
    }
}

//extension ViewController: UICollectionViewDelegateFlowLayout {
////    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
////        CGSize(width: collectionView.frame.width, height: 60)
////    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        CGSize(width: 100, height: 50)
//    }
//}



class TypeView: UIView {
    private lazy var typeBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPink
        view.layer.cornerRadius = 20
        return view
    }()
    
    private lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    required init(title: String) {
        super.init(frame: .zero)
        addSubview(typeBackgroundView, anchors: [.leading(0), .trailing(0),.top(0),.bottom(0)])
        addSubview(typeLabel, anchors: [.centerX(0), .centerY(0)])
        
        self.typeLabel.text = title
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

