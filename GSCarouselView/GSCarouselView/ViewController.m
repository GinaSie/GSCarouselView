//
//  ViewController.m
//  GSCarouselView
//
//  Created by gina on 2018/11/14.
//  Copyright © 2018 gina. All rights reserved.
//

#import "ViewController.h"
#import "GSCarouselView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *imageNames = @[@"apple01.png",@"apple02.png",@"apple03.png",@"apple04.png",@"apple05.png"];
    GSCarouselView *carouselView = [[GSCarouselView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 250) imageNames:imageNames target:self tapAction:@selector(tapAction:) timeInterval:2.0];
    carouselView.currentPageIndicatorTintColor = [UIColor redColor];
    carouselView.pageIndicatorTintColor = [UIColor lightGrayColor];
    carouselView.pageControlVisible = true;
    carouselView.allowDragging = true;
    carouselView.imageContentMode = UIViewContentModeScaleAspectFit;
    carouselView.pageControlPostion = GSPageControlPostionBottomMiddel;
    [self.view addSubview:carouselView];

}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    NSLog(@"%ld", tap.view.tag);
}
@end
