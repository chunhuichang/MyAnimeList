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
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    func setupUI() {
        addSubview(label, anchors: [.centerX(0), .centerY(0)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(_ subtype: String, isSelected: Bool = false) {
        label.text = subtype
        self.backgroundColor = isSelected ? .systemPink : .clear
        
    }
}

