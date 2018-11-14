//
//  GSCarouselView.h
//  GSCarouselView
//
//  Created by gina on 2018/11/14.
//  Copyright © 2018 gina. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    GSPageControlPostionBottomLeft,
    GSPageControlPostionBottomRight,
    GSPageControlPostionBottomMiddel,
    GSPageControlPostionTopLeft,
    GSPageControlPostionTopRight,
    GSPageControlPostionTopMiddel,
} GSPageControlPostion;

@interface GSCarouselView : UIView

- (instancetype)initWithFrame:(CGRect)frame imageNames:(NSArray *)imageNames target:(id)target tapAction:(SEL)action timeInterval:(NSTimeInterval)timeInterval;

@property (assign, nonatomic) UIViewContentMode imageContentMode;
@property (assign, nonatomic, getter=isAllowDragging) BOOL allowDragging;
@property (assign, nonatomic, getter=isPageControlVisible) BOOL pageControlVisible;
@property (assign, nonatomic) GSPageControlPostion pageControlPostion;
@property (strong, nonatomic) UIColor *pageIndicatorTintColor;
@property (strong, nonatomic) UIColor *currentPageIndicatorTintColor;

@end

NS_ASSUME_NONNULL_END
