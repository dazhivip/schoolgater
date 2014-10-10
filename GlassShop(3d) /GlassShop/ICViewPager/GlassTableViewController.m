//
//  GlassTableViewController.m
//  GlassShop
//
//  Created by Sarnath RD on 14-7-10.
//  Copyright (c) 2014年 Sense. All rights reserved.
//

/*
 具体用法：查看MJRefresh.h
 */
NSString *const MJCollectionViewCellIdentifier = @"Cell";

/**
 *  随机颜色
 */
#define MJRandomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]

#import "GlassTableViewController.h"
#import "GSUtil.h"
#import "MJRefresh.h"
#import "GlassImgCell.h"
@interface GlassTableViewController ()
/**
 *  存放眼镜数据
 */
@property (strong, nonatomic) NSMutableArray *ImgNameArr;
/**
 *  存放价格数据
 */
@property (strong, nonatomic) NSMutableArray *priceArr;
/**
 *  存放型号数据
 */
@property (strong, nonatomic) NSMutableArray *xingHaoArr;
/**
 *  存放详情ID
 */
@property (strong, nonatomic) NSMutableArray *goodIdArr;
/**
 *  存放详情ID
 */
@property (strong, nonatomic) NSMutableArray *dtailUrlArr;
@property (strong, nonatomic) NSMutableArray *webUrlArr;
@end

@implementation GlassTableViewController

#pragma mark - 初始化
/**
 *  数据的懒加载
 */
//- (NSMutableArray *)fakeColors
//{
//    if (!_gImgArr) {
//        self.gImgArr = [NSMutableArray array];
//
//        for (int i = 0; i<5; i++) {
//            // 添加随机色
//            [self.fakeColors addObject:MJRandomColor];
//        }
//    }
//    return _fakeColors;
//}

/**
 *  初始化
 */
- (id)init
{
    // UICollectionViewFlowLayout的初始化（与刷新控件无关）
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(107, 70);
    layout.sectionInset = UIEdgeInsetsMake(-0.5, -0.5, -0.5, -0.5);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    return [self initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _ImgNameArr = [NSMutableArray new];
    _priceArr = [NSMutableArray new];
    _xingHaoArr = [NSMutableArray new];
    _goodIdArr = [NSMutableArray new];
    _dtailUrlArr = [NSMutableArray new];
    _webUrlArr = [NSMutableArray new];
    // 1.初始化collectionView
    [self setupCollectionView];
    
    // 2.集成刷新控件
    [self addHeader];
    [self addFooter];
}
//,_pageIndex,_titStr
- (void)initRequest
{
	[[logicShareInstance getStarsManager] getGlassListWithPageNum:_pageIndex titStr:_titStr success:^(id responseObject) {
		
		NSString *suc = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"success"]];
		if ([suc isEqualToString:@"1"]) {
			[_ImgNameArr addObjectsFromArray:responseObject[@"url_list"]];
			[_priceArr addObjectsFromArray:responseObject[@"price_list"]];
			[_xingHaoArr addObjectsFromArray:responseObject[@"bn_list"]];
			[_goodIdArr addObjectsFromArray:responseObject[@"goodsid_list"]];
			[_dtailUrlArr addObjectsFromArray:responseObject[@"taobao_url"]];
            [_webUrlArr addObjectsFromArray:responseObject[@"web_url"]];
			_pageIndex++;
			[self.collectionView reloadData];
		}else{
			[GSUtil toast:@"webfail" ShowInView:[(UIViewController*)self.delegate view]];
		}

	} failure:^(id responseObject) {
		[GSUtil toast:@"网络异常" ShowInView:[(UIViewController*)self.delegate view]];
	}];
    
}

/**
 *  初始化collectionView
 */
- (void)setupCollectionView
{
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.alwaysBounceVertical = YES;
    // Register nib file for the cell
    UINib *nib = [UINib nibWithNibName:@"GlassImgCell"
                                bundle: [NSBundle mainBundle]];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:MJCollectionViewCellIdentifier];
	
}

- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;

    // 添加下拉刷新头部控件
    [self.collectionView addHeaderWithCallback:^{
   
        [vc.ImgNameArr removeAllObjects];
        vc.pageIndex = 0;
        [vc initRequest];

		// 结束刷新
		[vc.collectionView headerEndRefreshing];
	
    }];

    _pageIndex = 0;
    [self.collectionView headerBeginRefreshing];
}

- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    [self.collectionView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
 
        [vc initRequest];
        // 模拟延迟加载数据，因此2秒后才调用）
		// 结束刷新
		[vc.collectionView footerEndRefreshing];
	
    }];
}

/**
 为了保证内部不泄露，在dealloc中释放占用的内存
 */
- (void)dealloc
{
    NSLog(@"MJCollectionViewController--dealloc---");
}

#pragma mark - collection数据源代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.ImgNameArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GlassImgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MJCollectionViewCellIdentifier forIndexPath:indexPath];
    [self setBorderforView:cell];
    NSString *urlStr = [NSString stringWithFormat:@"http://www.schoolgater.com/%@",_ImgNameArr[indexPath.row]];
    [cell.ImgView setImageWithURL:[NSURL URLWithString:urlStr]
				 placeholderImage:[UIImage imageNamed:@"icon"]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate showDetail:_priceArr[indexPath.row] andxing:_xingHaoArr[indexPath.row] forId:_goodIdArr[indexPath.row] andUrl:[NSString stringWithFormat:@"%@,%@",_dtailUrlArr[indexPath.row],_webUrlArr[indexPath.row]]];
	[self.delegate startPeiDai:_ImgNameArr[indexPath.row]];
	
}


/**
 *	@brief	给视图设置边线
 *
 *	@param 	view 	要设置边线的视图
 */
-(void)setBorderforView:(UIView *)view
{
    view.layer.borderColor = [UIColor colorWithRed:213.0f/255.0f green:213.0f/255.0f blue:213.0f/255.0f alpha:1].CGColor;
    view.layer.borderWidth = 0.5;
}
@end