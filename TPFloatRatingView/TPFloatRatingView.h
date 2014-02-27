//
//  TPFloatRatingView.h
//  TPFloatRatingViewApp
//
//  Created by Glen Yi on 2/26/2014.
//  Copyright (c) 2014 Glen Yi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TPFloatRatingViewDelegate;

@interface TPFloatRatingView : UIView

@property (weak, nonatomic) id <TPFloatRatingViewDelegate> delegate;
@property (strong, nonatomic) UIImage *emptySelectedImage;
@property (strong, nonatomic) UIImage *fullSelectedImage;
@property (nonatomic) NSInteger maxRating;
@property (nonatomic) CGSize minImageSize;
@property (nonatomic) CGFloat rating;
@property (nonatomic) BOOL editable;
@property (nonatomic) BOOL halfRatings;
@property (nonatomic) BOOL floatRatings;

@end


@protocol TPFloatRatingViewDelegate <NSObject>
@optional
- (void)floatRatingView:(TPFloatRatingView *)ratingView ratingDidChange:(CGFloat)rating;
- (void)floatRatingView:(TPFloatRatingView *)ratingView continuousRating:(CGFloat)rating;
@end