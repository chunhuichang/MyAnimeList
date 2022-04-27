//
//  ItemCell.swift
//  MyAnimeList
//
//  Created by Jill Chang on 2022/4/11.
//

import UIKit

class ItemCell: UICollectionViewCell {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage.init(named: "malId47347")
        return imgView
    }()
    
    
    private lazy var dateTitles: [UILabel] = {
        var views = [UILabel]()
        for text in ["Start date","End date"] {
            let label = UILabel()
            label.font = .systemFont(ofSize: 12, weight: .light)
            label.textColor = .darkGray
            label.text = text
            views.append(label)
        }
        return views
    }()
    
    private lazy var dateDetails: [UILabel] = {
        var views = [UILabel]()
        for text in 0..<2 {
            let label = UILabel()
            label.font = .systemFont(ofSize: 16, weight: .regular)
            label.textColor = .systemGray
            views.append(label)
        }
        return views
    }()
    
    private lazy var dateTitleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: dateTitles)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 5.0
        return stackView
    }()
    
    private lazy var dateDetailStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: dateDetails)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 5.0
        return stackView
    }()
    
    private lazy var rankLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .white
        label.backgroundColor = .blue
        label.textAlignment = .center
        return label
    }()
    
    private lazy var starButton: UIButton = {
        let button = UIButton()
        let normalImage = UIImage(systemName: "star.fill")?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        let selectedImage = UIImage(systemName: "star.fill")?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
        button.setImage(normalImage, for: .normal)
        button.setImage(selectedImage, for: .selected)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(nil, action: #selector(favButtonClicked(_:)), for: .touchUpInside)
        return button
    }()
    
    private var viewModel: ItemCellVM?
    
    typealias ChangeFavortite = (_ entity: TopEntity?) -> Void
    private var completion: ChangeFavortite? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [imageView, titleLabel, dateTitleStackView, dateDetailStackView, rankLabel, starButton].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 3/4),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            dateTitleStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            dateTitleStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dateTitleStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            dateDetailStackView.topAnchor.constraint(equalTo: dateTitleStackView.bottomAnchor),
            dateDetailStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dateDetailStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dateDetailStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            rankLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            rankLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 2/5),
            rankLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -10),
            
            starButton.widthAnchor.constraint(equalToConstant: 30),
            starButton.heightAnchor.constraint(equalToConstant: 30),
            starButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            starButton.bottomAnchor.constraint(equalTo: rankLabel.bottomAnchor),
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ItemCell {
    private func removeAllBinding() {
        self.viewModel?.isFavorite.removeAllBinding()
        self.viewModel?.entity.removeAllBinding()
    }
    
    public func binding() {
        self.removeAllBinding()
        
        if let vm = self.viewModel {
            vm.entity.binding(listener: { [weak self] (newValue, _) in
                guard let self = self, let entity = newValue else { return }
                DispatchQueue.main.async {
                    self.titleLabel.text = entity.title
                    self.rankLabel.text = "# \(entity.rank)"
                    self.starButton.isSelected = entity.isFavorite
                    self.dateDetails[0].text = entity.startDate
                    
                    if let endDate = entity.endDate {
                        self.dateDetails[1].text = endDate
                    } else {
                        self.dateDetails[1].text = ""
                    }
                }
            })
            
            vm.imageData.binding(listener: { [weak self] (newValue, _) in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.imageView.image = nil
                    guard let data = newValue else { return }
                    self.imageView.image = UIImage(data: data)
                }
            })
            
            vm.isFavorite.binding(listener: { [weak self] (newValue, _) in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.starButton.isSelected = (newValue ?? false)
                }
            })
        }
    }
}

extension ItemCell {
    func setupCell(viewModel: ItemCellVM, completion: @escaping ChangeFavortite) {
        self.viewModel = viewModel
        self.completion = completion
        self.binding()
        self.viewModel?.fetchImage()
    }
}

extension ItemCell {
    @objc private func favButtonClicked(_ sender: UIButton) {
        sender.isSelected.toggle()
        self.viewModel?.upadteFavorite(isFavorite: sender.isSelected)
        self.completion?(self.viewModel?.entity.value)
    }
}
