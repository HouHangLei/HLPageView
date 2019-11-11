//
//  ItemViewController.swift
//  HLPageView
//
//  Created by mac on 2019/11/11.
//  Copyright © 2019 HL. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController {
    
    var text: String?
    
    lazy var textLabel: UILabel = {
        
        let label = UILabel.init()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 22)
        self.view.addSubview(label)
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let r = CGFloat(arc4random() % 255) / CGFloat(255)
        let g = CGFloat(arc4random() % 255) / CGFloat(255)
        let b = CGFloat(arc4random() % 255) / CGFloat(255)

        self.view.backgroundColor = UIColor.init(red: r, green: g, blue: b, alpha: 1)
        
        self.textLabel.text = self.text
        self.textLabel.snp.makeConstraints { (make) in
            
            make.center.equalToSuperview()
        }
    }
}
