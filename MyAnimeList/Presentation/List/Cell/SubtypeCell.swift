//
//  SubtypeCell.swift
//  MyAnimeList
//
//  Created by Jill Chang on 2022/4/14.
//

import UIKit


class SubtypeCell: UICollectionViewCell {
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .blue
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    func setupUI() {
        [label].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(_ subtype: String, isSelected: Bool = false) {
        DispatchQueue.main.async {
            self.label.text = subtype
            self.backgroundColor = isSelected ? .systemPink : .clear
        }
    }
}

