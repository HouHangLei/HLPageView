# HLPageView
多页面管理控件

# 使用方法
### HLPageView
```
let pageView = HLPageView.pageView()
pageView.delegate = self
// 配置项参考Demo，或查看HLPageView提供的属性
self.view.addSubview(pageView)

pageView.update(字符串数组)

```
HLPageViewDelegate
```
// 点击按钮
func pageView(_ pageView: HLPageView, didSelectIndexAt index: Int) {

}
```

### HLPageResultView
```
let resultView = HLPageResultView.pageResultView(页的总数量)
resultView.delegate = self
self.view.addSubview(resultView)

resultView.setCurrentPage(当前页, animated: false)
```
HLPageResultViewDelegate
```
// 滑动结束
func pageResultView(_ pageView: HLPageResultView, didEndScrolling page: Int) {

}

// 获取当前页展示的View
func pageResultView(_ pageView: HLPageResultView, isPresenceItemView: Bool, viewForPageAt page: Int) -> UIView? {

}

```

# 效果图

![效果图](https://upload-images.jianshu.io/upload_images/3643442-e18f4b3693aae181.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
