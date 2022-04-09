//
//  ViewController.swift
//  MyAnimeList
//
//  Created by Jill Chang on 2022/4/9.
//

import UIKit

class ViewController: UIViewController {
    
    private var viewModel: String
    
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
        self.view.backgroundColor = UIColor(displayP3Red: 224.0/255.0, green: 216.0/255.0, blue: 200.0/255.0, alpha: 1)
    }
}

