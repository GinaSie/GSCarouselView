//
//  GSCarouselView.m
//  GSCarouselView
//
//  Created by gina on 2018/11/14.
//  Copyright © 2018 gina. All rights reserved.
//

#import "GSCarouselView.h"
#define GSWidth  self.bounds.size.width
#define GSHeight self.bounds.size.height
@interface GSCarouselView ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSArray *imageNames;
@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, assign) NSInteger index;

@end
@implementation GSCarouselView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame imageNames:(NSArray *)imageNames target:(id)target tapAction:(SEL)action timeInterval:(NSTimeInterval)timeInterval
{
    self = [super initWithFrame:frame];
    if (self) {
        self.index = 0;
        NSString *firstImage = imageNames.firstObject;
        NSString *lastImage = imageNames.lastObject;
        NSMutableArray *tempArr = imageNames.mutableCopy;
        [tempArr insertObject:lastImage atIndex:0];
        [tempArr insertObject:firstImage atIndex:imageNames.count+1];
        self.imageNames = tempArr;
        
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        for (NSInteger i = 0; i < _imageNames.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(width * i, 0, width, height)];
            imageView.image = [UIImage imageNamed:_imageNames[i]];
            imageView.tag = i;
            imageView.contentMode = _imageContentMode;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:tap];
            [self.scrollView addSubview:imageView];
        }

        self.scrollView.pagingEnabled = YES;
        self.scrollView.contentSize = CGSizeMake(width * _imageNames.count, height);
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.contentOffset = CGPointMake(width, 0);
        self.scrollView.bounces = NO;
        [self addSubview:self.scrollView];

        self.pageControl = [[UIPageControl alloc] init];
        self.pageControl.numberOfPages = self.imageNames.count-2;
        self.pageControl.tintColor = self.currentPageIndicatorTintColor;
        self.pageControl.pageIndicatorTintColor = self.pageIndicatorTintColor;
        [self addSubview:self.pageControl];
        
        self.scrollView.delegate = self;
        self.timeInterval = timeInterval;
        [self startTimer];
    }
    return self;
}
- (void)setAllowDragging:(BOOL)allowDragging {
    _allowDragging = allowDragging;
    self.scrollView.scrollEnabled = allowDragging;
}
- (void)setPageControlVisible:(BOOL)pageControlVisible {
    _pageControlVisible = pageControlVisible;
    self.pageControl.hidden = !pageControlVisible;
}
- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
{
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    self.pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
}
- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
{
    _pageIndicatorTintColor = pageIndicatorTintColor;
    self.pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
}
- (void)setImageContentMode:(UIViewContentMode)imageContentMode {
    _imageContentMode = imageContentMode;
}
- (void)setPageControlPostion:(GSPageControlPostion)pageControlPostion {
    _pageControlPostion = pageControlPostion;
    
    self.pageControl.frame = [self getPageControlFrame];
}
- (void)nextPage
{
    self.index++;
    CGFloat width = self.scrollView.frame.size.width;
    [self.scrollView setContentOffset:CGPointMake(width*(self.index+1), 0) animated:YES];
    if (_index == self.imageNames.count-2) {
        _index = 0;
    }
    self.pageControl.currentPage = _index;
}

- (void)startTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (CGRect)getPageControlFrame {
    CGFloat pageControlHeight = 20.0;
    CGFloat pageControlWidth = self.imageNames.count * 20;
    CGFloat pageControlX;
    CGFloat pageControlY;
    switch (self.pageControlPostion) {
        case GSPageControlPostionBottomMiddel:
        {
            pageControlX = (GSWidth - pageControlWidth) *0.5;
            pageControlY = GSHeight - pageControlHeight;
        };
            break;
        case GSPageControlPostionBottomLeft:
        {
            pageControlX = 0;
            pageControlY = GSHeight - pageControlHeight;
        };
            break;
        case GSPageControlPostionBottomRight:
        {
            pageControlX = (GSWidth - pageControlWidth);
            pageControlY = GSHeight - pageControlHeight;
        };
            break;
        case GSPageControlPostionTopMiddel:
        {
            pageControlX = (GSWidth - pageControlWidth) *0.5;
            pageControlY = 0;
        };
            break;
        case GSPageControlPostionTopLeft:
        {
            pageControlX = 0;
            pageControlY = 0;
        };
            break;
        case GSPageControlPostionTopRight:
        {
            pageControlX = (GSWidth - pageControlWidth);
            pageControlY = 0;
        };
            break;
    }
    return CGRectMake(pageControlX, pageControlY, pageControlWidth, pageControlHeight);
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat scrollW = self.scrollView.frame.size.width;
    CGFloat offsetX = scrollView.contentOffset.x;
    self.index = offsetX / scrollW - 1;
    if (offsetX > (self.imageNames.count-2+0.5)*scrollW) {
        [scrollView setContentOffset:CGPointMake(scrollW, 0) animated:NO];
    }
    if (offsetX < 0.5*scrollW) {
        [scrollView setContentOffset:CGPointMake(scrollW*(self.imageNames.count-2), 0) animated:NO];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat scrollW = self.scrollView.frame.size.width;
    CGFloat offsetX = self.scrollView.contentOffset.x;
    if (offsetX < 0.5*scrollW) {
        self.pageControl.currentPage = (self.imageNames.count-2);
    }else if (offsetX > (self.imageNames.count-2+0.5)*scrollW){
        self.pageControl.currentPage = 0;
    }else{
        self.pageControl.currentPage = scrollView.contentOffset.x/scrollW-1;
    }
}

@end
