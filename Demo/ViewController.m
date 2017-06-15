//
//  ViewController.m
//  Demo
//
//  Created by 阮巧华 on 2017/6/15.
//  Copyright © 2017年 阮巧华. All rights reserved.
//

#import "ViewController.h"
#import "SDCycleScrollView.h"
#import "iCarousel.h"

@interface ViewController ()<iCarouselDataSource,iCarouselDelegate>
{
    NSArray *imageNames;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 情景一：采用本地图片实现
    imageNames = @[@"h1.jpg",
                            @"h2.jpg",
                            @"h3.jpg",
                            @"h4.jpg",
                            ];

    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 60, CGRectGetWidth(self.view.frame), 200) imageNamesGroup:imageNames];
    [self.view addSubview:cycleScrollView];
    
    
    iCarousel *_iCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 300, CGRectGetWidth(self.view.frame), 200)];
    _iCarousel.delegate = self;
    _iCarousel.dataSource = self;
    _iCarousel.bounces = NO;
    _iCarousel.pagingEnabled = YES;
    _iCarousel.type = iCarouselTypeCustom;
    [self.view addSubview:_iCarousel];

}

-(UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    if (view == nil) {
        CGFloat viewWidth = CGRectGetWidth(self.view.frame)-60;
        CGFloat viewHeight = CGRectGetHeight(carousel.frame);
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    }
    
    ((UIImageView *)view).image = [UIImage imageNamed:[imageNames objectAtIndex:index]];
    
    return view;
}

-(NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return imageNames.count;
}

-(CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform{
    static CGFloat max_sacle = 1.0f;
    static CGFloat min_scale = 0.6f;
    if (offset <= 1 && offset >= -1) {
        float tempScale = offset < 0 ? 1+offset : 1-offset;
        float slope = (max_sacle - min_scale) / 1;
        
        CGFloat scale = min_scale + slope*tempScale;
        transform = CATransform3DScale(transform, scale, scale, 1);
    }else{
        transform = CATransform3DScale(transform, min_scale, min_scale, 1);
    }
    
    return CATransform3DTranslate(transform, offset * carousel.itemWidth * 1.4, 0.0, 0.0);
}

@end
