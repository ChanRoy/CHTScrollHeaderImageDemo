//
//  CHTWebScrollVC.m
//  CHTScrollHeaderImageDemo
//
//  Created by cht on 2017/2/15.
//  Copyright © 2017年 cht. All rights reserved.
//

#import "CHTWebScrollVC.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

static CGFloat const kImgHeight = 200.0;

@interface CHTWebScrollVC ()<UIWebViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) UIImageView *headerImageView;

@end

@implementation CHTWebScrollVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view addSubview:self.webView];
//    [self.webView.scrollView addSubview:self.headerImageView];
}

#pragma mark - lazy load
- (UIWebView *)webView{
    
    if (_webView == nil) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
        _webView.delegate = self;
        _webView.scrollView.delegate = self;
//        _webView.scrollView.contentInset = UIEdgeInsetsMake(kImgHeight, 0, 0, 0);
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.zhihu.com/explore"]]];
    }
    return _webView;
}

- (UIImageView *)headerImageView{
    
    if (_headerImageView == nil) {
        _headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -kImgHeight, CGRectGetWidth(self.webView.frame), kImgHeight)];
        _headerImageView.image = [UIImage imageNamed:@"img.jpg"];
        _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _headerImageView;
}

#pragma mark - webview delegate
//在webview delegate中写这部分代码的作用：防止html未加载出来时页面错乱
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    _webView.scrollView.contentInset = UIEdgeInsetsMake(kImgHeight, 0, -2*kImgHeight, 0);
    [self.webView.scrollView addSubview:self.headerImageView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    _webView.scrollView.contentInset = UIEdgeInsetsMake(kImgHeight, 0, 0, 0);
}

#pragma mark - scrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.webView.scrollView) {
        
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
