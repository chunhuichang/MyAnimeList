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
        return button
    }()
    
    private var viewModel: ItemCellVM?
    
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
            rankLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/4),
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
    func setupCell(entity: TopEntity) {
        self.titleLabel.text = entity.title
        //        self.imageView.image
        self.rankLabel.text = "# \(entity.rank)"
        self.starButton.isSelected = entity.isFavorite
        self.dateDetails[0].text = entity.startDate
        
        if let endDate = entity.endDate {
            self.dateDetails[1].text = endDate
        } else {
            self.dateDetails[1].text = ""
        }
    }
}

public final class ItemCellVM {
    var isFavorite: Box<Bool> = Box(false)
    var entity: Box<TopEntity> = Box(nil)
    
    public init(entity: TopEntity) {
        self.isFavorite.value = entity.isFavorite
        self.entity.value = entity
    }
    
    public func upadteFavorite(isFavorite: Bool) {
        self.isFavorite.value?.toggle()
    }
}
