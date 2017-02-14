#CHTScrollHeaderImageDemo
UITableView 下拉头部图片放大效果

![](https://github.com/ChanRoy/CHTScrollHeaderImageDemo/blob/master/CHTScrollHeaderImageDemo.gif)

## 简介
*UITableView 头部图片随着下拉放大的效果实现*

*具体效果见上图*

## 实现过程
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
具体细节可参照Demo。
