//
//  HomeViewController.swift
//  HLPageView
//
//  Created by mac on 2019/11/8.
//  Copyright © 2019 HL. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    var titles = ["新闻","😸","长标题长标题长标题","我的","一","HLPageView","视频新闻"]
    
    lazy var pageView: HLPageView = {
        
        let pageView = HLPageView.pageView()
        pageView.delegate = self
        pageView.normalFont = UIFont.systemFont(ofSize: 15)
        pageView.selectedFont = UIFont.systemFont(ofSize: 20)
        pageView.normalColor = UIColor.init(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        pageView.selectedColor = UIColor.init(red: 0.86, green: 0.078, blue: 0.235, alpha: 1)
        self.view.addSubview(pageView)
        
        pageView.update(self.titles)

        return pageView
    }()
    
    lazy var pageResultView: HLPageResultView = {
       
        let resultView = HLPageResultView.pageResultView(self.titles.count)
        resultView.delegate = self
        self.view.addSubview(resultView)
        
        resultView.setCurrentPage(0, animated: false)
        
        return resultView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "首页"
        
        self.view.backgroundColor = .white
                
        self.pageView.snp.makeConstraints { (make) in
            
            make.left.right.top.equalToSuperview()
            make.height.equalTo(45)
        }
        
        self.pageResultView.snp.makeConstraints { (make) in
            
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.pageView.snp.bottom)
        }
    }
}

extension HomeViewController: HLPageViewDelegate {
        
    func pageView(_ pageView: HLPageView, didSelectIndexAt index: Int) {
        
        self.pageResultView.setCurrentPage(index, animated: true)
    }
}

extension HomeViewController: HLPageResultViewDelegate {
    
    func pageResultView(_ pageView: HLPageResultView, didEndScrolling page: Int) {
        
        self.pageView.setCurrentPage(page, animated: true)
    }
    
    func pageResultView(_ pageView: HLPageResultView, isPresenceItemView: Bool, viewForPageAt page: Int) -> UIView? {
        
        if isPresenceItemView == false {
            
            let itemVC = ItemViewController.init()
            itemVC.text = self.titles[page]
            self.addChild(itemVC)
            
            return itemVC.view

        }
        
        return nil
    }
}
