//
//  HLPageView.swift
//  HL
//
//  Created by mac on 2019/10/22.
//  Copyright © 2019 hhl. All rights reserved.
//

import UIKit
import SnapKit

@objc protocol HLPageViewDelegate: NSObjectProtocol {
    
    /// 点击按钮回调
    /// - Parameter pageView: 当前pageView
    /// - Parameter index: 点击的索引
    @objc optional func pageView(_ pageView: HLPageView, didSelectIndexAt index: Int)
}

enum HLPageViewStyle {
    case average    // 按照PageView宽度平均分配按钮宽度
    case adaptive   // 按照按钮文本内容自动分配宽度
}

class HLPageView: UIView {
    
    /// 代理
    weak var delegate: HLPageViewDelegate?
    
    /// 按钮布局方式
    var style: HLPageViewStyle = .adaptive
    /// 如果有值，底部线的宽度将固定。否则和当前选中按钮宽度一样
    var lineViewWidth: CGFloat?

    /// 未点击状态按钮颜色
    var normalColor: UIColor = .black
    /// 选中状态按钮颜色
    var selectedColor: UIColor = .red
    /// 标记线的颜色
    var lineColor: UIColor = .red
    
    /// 未点击状态按钮大小
    var normalFont: UIFont = UIFont.systemFont(ofSize: 15)
    /// 选中状态按钮大小
    var selectedFont: UIFont = UIFont.systemFont(ofSize: 15)
    
    /// 按钮之间间隔距离(样式为adaptive生效)
    var spacing: CGFloat = 20
    
    /// 记录上一次选中的button
    var lastButton: UIButton?
    
    private var titles: Array<String> = []
    
    /// button的父view
    lazy var scrollView: UIScrollView = {
        
        let scrollView = UIScrollView.init()
        scrollView.scrollsToTop = false
        scrollView.showsHorizontalScrollIndicator = false
        self.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { (make) in
            
            make.edges.equalTo(self)
        }
        
        return scrollView
        
    }()
    
    /// 布局scrollView的view
    lazy var containerView: UIView = {
        
        let view = UIView.init()
        self.scrollView.addSubview(view)
        
        view.snp.makeConstraints { (make) in
            
            make.edges.equalTo(self.scrollView)
            make.height.equalTo(self.scrollView)
        }
        
        return view
        
    }()
    
    /// 底部标记线
    lazy var lineView: UIView = {
        
        let view = UIView.init()
        view.backgroundColor = self.lineColor
        self.containerView.addSubview(view)
        
        return view
    }()
    
    /// 初始化方法
    class func pageView() -> Self {
        
        let pageView = self.init()
        return pageView
    }
    
    /// 更新当前显示的选中状态按钮
    /// - Parameter index: 当前选中状态的下标
    /// - Parameter animated: 是否执行动画
    func setCurrentPage(_ index: Int, animated: Bool = false) {
        
        self.updateButtonLine(selectedIndex: index, animated: animated)
    }
    
    /// 更新pageView
    /// - Parameter titles: 标题数据源
    /// - Parameter currentIndex: 当前选中的索引
    func update(_ titles: [String], currentIndex: Int = 0) {
        
        self.titles = titles
        
        for (index, item) in titles.enumerated() {
            
            let button = UIButton.init(type: .system)
            button.tintColor = .clear
            button.setTitle(item, for: .normal)
            button.setTitleColor(self.normalColor, for: .normal)
            button.setTitleColor(self.selectedColor, for: .selected)
            button.setTitleColor(self.selectedColor, for: UIControl.State(rawValue: UIControl.State.selected.rawValue + UIControl.State.highlighted.rawValue))
            button.titleLabel?.font = self.normalFont
            button.addTarget(self, action: #selector(self.buttonClick(button:)), for: .touchUpInside)
            button.tag = 100 + index
            self.containerView.addSubview(button)
            
            if index == currentIndex {
                button.titleLabel?.font = self.selectedFont
                self.lastButton = button
                button.isSelected = true
            }
  
            self.updateButtonFrame(index: index, button: button)
        }
        
        self.updateLineViewFrame(self.lastButton!.tag - 100)
    }
    
    /// 更新按钮frame
    /// - Parameter index: 按钮下标
    /// - Parameter button: 按钮
    func updateButtonFrame(index: Int, button: UIButton) {
        
        if self.style == .adaptive {
            
            if index == 0 {
                
                button.snp.makeConstraints { (make) in
                    
                    make.left.equalTo(self.spacing)
                    make.top.bottom.equalToSuperview()
                }
                
            }else {
                
                let lsButton = self.containerView.viewWithTag(100 + index - 1)
                
                button.snp.makeConstraints { (make) in
                    
                    make.left.equalTo(lsButton!.snp.right).offset(self.spacing)
                    make.top.bottom.equalToSuperview()
                    
                    if index == self.titles.count - 1 {
                        
                        make.right.equalTo(-self.spacing)
                    }
                }
            }
        
        }else if self.style == .average {
                        
            if self.frame.size.width == 0 {
                
                return
            }
            
            let buttonWidth = self.frame.size.width / CGFloat(self.titles.count)

            button.snp.makeConstraints { (make) in
                
                make.left.equalTo(CGFloat(index) * buttonWidth)
                make.top.bottom.equalTo(0)
                make.width.equalTo(buttonWidth)
                
                if index == self.titles.count - 1 {
                    
                    make.right.equalTo(0)
                }
            }
        }
    }
    
    /// 更新标记线view的位置
    /// - Parameter currentIndex: 当前选中的索引
    func updateLineViewFrame(_ currentIndex: Int, animated: Bool = false) {
        
        self.lineView.snp.remakeConstraints { (make) in
            
            if self.lineViewWidth != nil {
               
                make.width.equalTo(self.lineViewWidth!)

            }else {
                
                make.width.equalTo(self.lastButton!)

            }
            make.height.equalTo(3)
            make.bottom.equalToSuperview()
            make.centerX.equalTo(self.lastButton!)
        }
        
        if self.scrollView.contentSize.width > self.scrollView.frame.size.width {
            
            let pointX = max(0, self.lastButton!.center.x - self.scrollView.frame.size.width / 2)
            let pointX1 = min(pointX, self.scrollView.contentSize.width - self.scrollView.frame.size.width)
            self.scrollView.setContentOffset(CGPoint(x: pointX1, y: 0), animated: true)

        }
                
        if animated == true {
            
            UIView.animate(withDuration: 0.5) {
                self.layoutIfNeeded()
            }
            
        }else {
            
            self.layoutIfNeeded()

        }
        
    }
    
    /// 按钮点击事件
    /// - Parameter button: 点击的按钮
    @objc func buttonClick(button: UIButton) {
        
        self.updateButtonLine(selectedIndex: button.tag - 100, animated: true)
        
        if self.delegate != nil {
            
            self.delegate?.pageView?(self, didSelectIndexAt: button.tag - 100)
        }
    }
    
    /// 更新按钮的状态和标记线的位置
    /// - Parameter selectedIndex: 当前选中状态的索引
    /// - Parameter animated: 是否执行动画
    func updateButtonLine(selectedIndex: Int, animated: Bool = false) {
        
        let button = self.containerView.viewWithTag(100 + selectedIndex) as! UIButton
        
        self.lastButton?.titleLabel?.font = self.normalFont
        button.titleLabel?.font = self.selectedFont
        
        self.lastButton?.isSelected = false
        button.isSelected = true
        self.lastButton = button
        
        self.updateLineViewFrame(selectedIndex, animated: animated)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.style == .average {
            
            for (index, _) in self.titles.enumerated() {
            
                self.updateButtonFrame(index: index, button: self.containerView.viewWithTag(100 + index) as! UIButton)
            }
        }
    }
}
