#CHTScrollHeaderImageDemo
UITableView | UIWebView 下拉头部图片放大效果

* UITableView下拉效果

![](https://github.com/ChanRoy/CHTScrollHeaderImageDemo/blob/master/UITableView效果.gif)

* UIWebView下拉效果

![](https://github.com/ChanRoy/CHTScrollHeaderImageDemo/blob/master/UIWebView效果.gif)

## 简介
*UITableView、UIWebView 头部图片随着下拉放大的效果实现*

*具体效果见上图*

## 实现过程

### UITableView 实现过程：
1. 将UIImageView放置于UITableView的顶部，UIImageView高度为H；

2. 设置UITableView的contentOffset， 使UITableView的内容向下偏移H；

3. 在UIScrollViewDelegate中，根据UITableView的offset改变UIImageView的frame。


直接上代码，需要注意的都在代码中有注释:

* 宏定义及常量设置

```
#define kImgHeight 200 //height of the image
static NSString *const kCellId = @"cellId"; //reuse id
```

* interface

```
@interface ViewController ()<UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *headerImageView;

@end
```
* implementation

```
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.headerImageView];
}

#pragma mark - lazy load
- (UITableView *)tableView{
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(kImgHeight, 0, 0, 0);
        //去掉空白行的显示
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (UIImageView *)headerImageView{
    
    if (_headerImageView == nil) {
        _headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -kImgHeight, CGRectGetWidth(self.view.frame), kImgHeight)];
        _headerImageView.image = [UIImage imageNamed:@"img.jpg"];
        //UIViewContentModeScaleAspectFill，保证拉升时长宽一起拉升
        _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _headerImageView;
}

#pragma mark - tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellId];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"row -- %ld",indexPath.row];
    return cell;
}

#pragma mark - scrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.tableView) {
       
        CGPoint offset = scrollView.contentOffset;
//        NSLog(@"%.2f",offset.y);
        if (offset.y < -kImgHeight) {
            
            CGRect imgRect = _headerImageView.frame;
            //origin.y 保持不变，高度增加，保证了图片拉升的效果
            imgRect.origin.y = offset.y;
            imgRect.size.height = -offset.y;
            _headerImageView.frame = imgRect;
        }
    }
}

```
### UIWebView实现过程：
UIWebView的实现方法与UITableView差不多，我们注意到UIWebView中包含一个UIScrollView，可以通过_webView.scrollView调用到。拿到UIScrollView后，就可以参照UITableView的实现过程去实现。

需要注意的是，如果一开始设置了UIWebView的偏移，会造成HTML未加载出来时的UI错乱情况，影响用户体验，因此本人采取的方法是将修改偏移量的代码放到UIWebViewDelegate的方法中去实现，具体如下：

```
#pragma mark - webview delegate
//在webview delegate中写这部分代码的作用：防止html未加载出来时页面错乱
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    _webView.scrollView.contentInset = UIEdgeInsetsMake(kImgHeight, 0, -2*kImgHeight, 0);
    [self.webView.scrollView addSubview:self.headerImageView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    _webView.scrollView.contentInset = UIEdgeInsetsMake(kImgHeight, 0, 0, 0);
}
```

其他具体实现细节请参照仓库中的Demo。