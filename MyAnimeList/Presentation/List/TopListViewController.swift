//
//  TopListViewController.swift
//  MyAnimeList
//
//  Created by Jill Chang on 2022/4/9.
//

import UIKit

class TopListViewController: UIViewController {
    
    private var viewModel: TopListVMManager
    private var posterImagesRepository: PosterImagesRepository?
    
    
    private lazy var subtypeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .horizontal
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(SubtypeCell.self, forCellWithReuseIdentifier: "\(SubtypeCell.self)")
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    private lazy var listCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .vertical
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(ItemCell.self, forCellWithReuseIdentifier: "\(ItemCell.self)")
        view.delegate = self
        view.dataSource = self
        return view
    }()
        
    private lazy var types: [UIButton] = {
        var views = [UIButton]()
        for (index, type) in self.viewModel.output.typeNames.enumerated() {
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
        self.viewModel.input.typeClick(index: sender.tag)
    }
    
    private lazy var loadingActivity: UIActivityIndicatorView = {
        let loadingActivity = UIActivityIndicatorView()
        loadingActivity.hidesWhenStopped = true
        loadingActivity.style = .large
        loadingActivity.color = .white
        loadingActivity.backgroundColor = .darkGray
        loadingActivity.layer.cornerRadius = 10
        return loadingActivity
    }()
    
    private lazy var loadingView: UIView = {
        return UIView()
    }()
    
    init(viewModel: TopListVMManager, posterImagesRepository: PosterImagesRepository) {
        self.viewModel = viewModel
        self.posterImagesRepository = posterImagesRepository
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.UIBinding()
        self.viewModel.input.typeClick(index: 0)
    }
}

// MARK: UI Setting
private extension TopListViewController {
    private func setupUI() {
        self.view.backgroundColor = .white
        
        [topStackView, subtypeCollectionView, listCollectionView, loadingActivity, loadingView].forEach { [superView = self.view] in
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
            heightConstraint,

            listCollectionView.topAnchor.constraint(equalTo: subtypeCollectionView.bottomAnchor, constant: 10),
            listCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            listCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            listCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            loadingActivity.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loadingActivity.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            loadingActivity.widthAnchor.constraint(equalToConstant: 80),
            loadingActivity.heightAnchor.constraint(equalTo: loadingActivity.widthAnchor),
            
            loadingView.topAnchor.constraint(equalTo: self.view.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
    
    private func showActivityIndicator(_ show: Bool) {
        if show {
            loadingActivity.startAnimating()
            loadingView.isHidden = false
        } else {
            loadingActivity.stopAnimating()
            loadingView.isHidden = true
        }
    }
}

// MARK: UI Binding
private extension TopListViewController {
    
    private func UIBinding() {
        
        let output = self.viewModel.output

        output.isLoading.binding {[weak self] newValue, _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.showActivityIndicator(newValue ?? false)
            }
        }
                
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
            DispatchQueue.main.async {
                self.types.forEach { $0.backgroundColor = .lightGray }
                self.types[newValue].backgroundColor = .systemPink
            }
        }
        
        output.scrollToTop.binding {[weak self] _, _ in
            guard let self = self, let dataCount = self.viewModel.output.listData.value?.count, dataCount > 0 else { return }
            DispatchQueue.main.async {
                self.listCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
            }
        }
        
        output.scrollToLeft.binding {[weak self] _, _ in
            guard let self = self, let dataCount = self.viewModel.output.subtypeData.value?.count, dataCount > 0 else { return }
            DispatchQueue.main.async {
                self.subtypeCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: true)
            }
        }
    }
}

extension TopListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.subtypeCollectionView {
            self.viewModel.input.subtypeClick(index: indexPath.row)
        } else if collectionView == self.listCollectionView, let cellVM = self.viewModel.output.listData.value?[indexPath.row] {
            self.viewModel.input.gotoWebVC(entity: cellVM)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard collectionView == self.listCollectionView, !self.subtypeCollectionView.isHidden,
              indexPath.row == (self.viewModel.output.listData.value?.count ?? 0) - 1 else {
                  return
              }
        
        self.viewModel.input.fetchDataTrigger.value = ()
    }
}

extension TopListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.subtypeCollectionView {
            return self.viewModel.output.subtypeData.value?.count ?? 0
        } else if collectionView == self.listCollectionView {
            return self.viewModel.output.listData.value?.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.listCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ItemCell.self)", for: indexPath) as? ItemCell,
                  let cellVM = self.viewModel.output.listData.value?[indexPath.row] else {
                return UICollectionViewCell()
            }
            
            let vm = ItemCellVM(entity: cellVM, posterImagesRepository: self.posterImagesRepository)
            cell.setupCell(viewModel: vm) { [weak self] entity in
                guard let self = self, let entity = entity else { return }
                self.viewModel.input.saveDataTrigger.value = entity
            }
            return cell
        } else if collectionView == self.subtypeCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(SubtypeCell.self)", for: indexPath) as? SubtypeCell ,
                  let cellVM = self.viewModel.output.subtypeData.value?[indexPath.row] else {
                return UICollectionViewCell()
            }
            
            cell.setupCell(cellVM.0, isSelected: cellVM.1)
            cell.layer.cornerRadius = 5.0
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

extension TopListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.subtypeCollectionView {
            let label = UILabel(frame: CGRect.zero)
            label.text = self.viewModel.output.subtypeData.value?[indexPath.row].0
            label.sizeToFit()
            return CGSize(width: label.frame.width + 20, height: collectionView.frame.height - 5)
        }

        return CGSize(width: (collectionView.frame.width - 10) / 2, height: collectionView.frame.height / 2)
    }
}
