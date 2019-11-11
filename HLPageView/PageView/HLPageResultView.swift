//
//  HLPageResultView.swift
//  HL
//
//  Created by mac on 2019/10/23.
//  Copyright © 2019 hhl. All rights reserved.
//

import UIKit

@objc protocol HLPageResultViewDelegate: NSObjectProtocol {

    /// 获取当前页需要展示的View
    /// - Parameter pageView: 当前pageView
    /// - Parameter isPresenceItemView: 当前页面是否已经添加了子view
    /// - Parameter page: 当前页码
    @objc func pageResultView(_ pageView: HLPageResultView, isPresenceItemView: Bool, viewForPageAt page: Int) -> UIView?
    
    /// 滑动结束代理
    /// - Parameter pageView: 当前pageView
    /// - Parameter page: 当前页码
    @objc optional func pageResultView(_ pageView: HLPageResultView, didEndScrolling page: Int)
    
}

class HLPageResultView: UIView,UIScrollViewDelegate {

    weak var delegate: HLPageResultViewDelegate?
    
    /// 当前页码
    var currentPage: Int = 0
    /// 总数
    var totalCount: Int = 0
    
    /// 页面的父view
    lazy var scrollView: UIScrollView = {
        
        let scrollView = UIScrollView.init()
        scrollView.scrollsToTop = false
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.delegate = self
        self.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { (make) in
            
            make.edges.equalTo(self)
        }
        
        return scrollView
        
    }()

    /// 初始化方法
    /// - Parameter totalCount: 页面的总数
    /// - Parameter currentPage: 当前页码
    class func pageResultView(_ totalCount: Int) -> HLPageResultView {
        
        let view = HLPageResultView.init()
        view.totalCount = totalCount
        view.initView()
        return view
    }
    
    /// 初始化
    func initView() {
                
    }
    
    /// 更新当前显示页面
    /// - Parameter currentPage: 当前要显示页面的页码
    /// - Parameter animated: 是否执行动画
    func setCurrentPage(_ currentPage: Int, animated: Bool = false) {

        self.currentPage = currentPage
        
        self.scrollView.setContentOffset(CGPoint(x: self.frame.size.width * CGFloat(currentPage), y: 0), animated: animated)
        
        self.addToScrollView(currentPage)
    }
    
    /// 添加view到scrollView上
    /// - Parameter page: 当前页码
    func addToScrollView(_ page: Int) {
        
        if self.delegate == nil {
            return
        }
        
        var isPresenceItemView = false
        
        if self.scrollView.viewWithTag(100 + page) != nil {
           
            isPresenceItemView = true
        }
        
        if let view = self.delegate?.pageResultView(self, isPresenceItemView: isPresenceItemView, viewForPageAt: page) {
//            如果返回的View已经有父view（已经添加到scrollView上），直接return
            if view.superview != nil {
                return
            }
            
//            如果当前页已经存在子view，删除原来的字view
            if self.scrollView.viewWithTag(100 + page) != nil {
            
                self.scrollView.viewWithTag(100 + page)?.removeFromSuperview()
            }
            
            self.scrollView.addSubview(view)
            
            view.tag = 100 + page
            view.frame = CGRect(x: self.frame.size.width * CGFloat(page), y: 0, width: self.frame.size.width, height: self.frame.size.height)

        }
    }
    
//    UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        
        self.currentPage = page
        
        if self.delegate != nil {
            
            if self.delegate!.responds(to: Selector(("pageResultView:didEndScrolling:"))) == true {
                
                self.delegate?.pageResultView?(self, didEndScrolling: page)
            }
        }
        
        self.addToScrollView(page)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.scrollView.contentSize = CGSize(width: self.frame.size.width * CGFloat(self.totalCount), height: self.frame.size.height)
        
    }
    
    
}
