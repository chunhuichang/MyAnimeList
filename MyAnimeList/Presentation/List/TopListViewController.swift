//
//  TopListViewController.swift
//  MyAnimeList
//
//  Created by Jill Chang on 2022/4/9.
//

import UIKit

class TopListViewController: UIViewController {
    
    private var viewModel: TopListViewModel
//    private let typeNames = ["Anime","Manga","Favorite"]
//    private let typeSubtype = ["anime":["airing","upcoming","tv","movie","ova","special","bypopularity","favorite"],"manga":["manga","novels","oneshots","doujin","manhwa","manhua","bypopularity","favorite"],"favorite":[]]
//    private var tmpData = ["airing","upcoming","tv","movie","ova","special","bypopularity","favorite"]
    
    
    private lazy var subtypeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        //section的間距
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        //cell間距
        layout.minimumLineSpacing = 5
        //cell 長寬
//        layout.itemSize = CGSize(width: 100, height: 30)
        //layout.estimatedItemSize
        //滑動的方向
        layout.scrollDirection = .horizontal
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(SubtypeCell.self, forCellWithReuseIdentifier: "\(SubtypeCell.self)")
        view.delegate = self
        view.dataSource = self
//        view.backgroundColor = .systemPink
//        view.isPagingEnabled = true
//        view.collectionViewLayout.invalidateLayout()
        return view
    }()
    
    private lazy var listCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        //section的間距
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        //cell間距
        layout.minimumLineSpacing = 5
        //cell 長寬
//        layout.itemSize = CGSize(width: 100, height: 30)
        //layout.estimatedItemSize
        //滑動的方向
        layout.scrollDirection = .vertical
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(ItemCell.self, forCellWithReuseIdentifier: "\(ItemCell.self)")
        view.delegate = self
        view.dataSource = self
//        view.isPagingEnabled = true
//        view.collectionViewLayout.invalidateLayout()
        return view
    }()
        
    private lazy var types: [UIButton] = {
        var views = [UIButton]()
        for (index, type) in self.viewModel.typeNames.enumerated() {
            let button = UIButton()
            button.backgroundColor = .lightGray
            button.setTitle("\(type.rawValue)", for: .normal)
            button.setTitleColor(.darkGray, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 18)
            button.layer.cornerRadius = 5.0
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tag = index
            button.addTarget(nil, action: #selector(selected(_:)), for: .touchUpInside)
            views.append(button)
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
    
    private lazy var heightConstraint: NSLayoutConstraint = {
        subtypeCollectionView.heightAnchor.constraint(equalToConstant: 50)
    }()
        
    @objc private func selected(_ sender: UIButton) {
        print("Button tapped:\(sender.tag)")
        self.viewModel.typeClick(index: sender.tag)
    }
    
    init(viewModel: TopListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.UIBinding()
        self.viewModel.typeClick(index: 0)
    }
}

// MARK: UI Setting
private extension TopListViewController {
    private func setupUI() {
        self.view.backgroundColor = .white
        
        [topStackView, subtypeCollectionView, listCollectionView].forEach { [superView = self.view] in
            superView?.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            topStackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            topStackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            topStackView.heightAnchor.constraint(equalToConstant: 50),
            
            subtypeCollectionView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 10),
            subtypeCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            subtypeCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
//            subtypeCollectionView.heightAnchor.constraint(equalToConstant: 50),
            heightConstraint,

            listCollectionView.topAnchor.constraint(equalTo: subtypeCollectionView.bottomAnchor, constant: 10),
            listCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            listCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            listCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

// MARK: UI Binding
private extension TopListViewController {
    
    private func UIBinding() {
        
        let output = self.viewModel.output

//        output.isLoading.binding {[weak self] newValue, _ in
//            guard let self = self else { return }
//            DispatchQueue.main.async {
//                self.currentTimeZoneLabel.text = newValue
//            }
//        }
                
        output.isSubTypeHidden.binding {[weak self] newValue, _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                let isHidden = newValue ?? false
                self.subtypeCollectionView.isHidden = isHidden
                self.heightConstraint.constant = isHidden ? 0 : 50
            }
        }
        
        output.subtypeData.binding {[weak self] _, _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.subtypeCollectionView.reloadData()
            }
        }
        
        output.listData.binding {[weak self] _, _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.listCollectionView.reloadData()
            }
        }
                
        output.typeIndex.binding {[weak self] newValue, _ in
            guard let self = self, let newValue = newValue else { return }
//            print("typeIndex=\(newValue),subtypeData=\(self.viewModel.subtypeData.value)")
            DispatchQueue.main.async {
                self.types.forEach { $0.backgroundColor = .lightGray }
                self.types[newValue].backgroundColor = .systemPink
            }
        }
    }
}

extension TopListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
        
        if collectionView == self.subtypeCollectionView {
            self.viewModel.subtypeClick(index: indexPath.row)
        } else if collectionView == self.listCollectionView, let cellVM = self.viewModel.listData.value?[indexPath.row] {
            self.viewModel.gotoWebVC(entity: cellVM)
        }
    }
}

extension TopListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.subtypeCollectionView {
            return self.viewModel.subtypeData.value?.count ?? 0
        } else if collectionView == self.listCollectionView {
            return self.viewModel.listData.value?.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.listCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ItemCell.self)", for: indexPath) as? ItemCell,
                  let cellVM = self.viewModel.listData.value?[indexPath.row] else {
                return UICollectionViewCell()
            }

            cell.setupCell(entity: cellVM)
            
//            cell.backgroundColor = .cyan
            return cell
        } else if collectionView == self.subtypeCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(SubtypeCell.self)", for: indexPath) as? SubtypeCell ,
                  let cellVM = self.viewModel.subtypeData.value?[indexPath.row] else {
                return UICollectionViewCell()
            }
            
            cell.setupCell(cellVM.0, isSelected: cellVM.1)
            
            cell.layer.cornerRadius = 5.0
//            cell.backgroundColor = .yellow
            return cell
        } else {
            return UICollectionViewCell()
        }
//        fatalError("Unable to dequeue subclassed cell")
    }
}

extension TopListViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        CGSize(width: collectionView.frame.width, height: 60)
//    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.subtypeCollectionView {
            return CGSize(width: 100, height: collectionView.frame.height - 5)
        } else if collectionView == self.listCollectionView {
            return CGSize(width: (collectionView.frame.width - 10) / 2, height: collectionView.frame.height / 2)
        }

        return CGSize(width: collectionView.frame.width - 10, height: collectionView.frame.height / 3)
    }
}



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
