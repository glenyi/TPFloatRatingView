//
//  TPFloatRatingView.m
//  TPFloatRatingViewApp
//
//  Created by Glen Yi on 2/26/2014.
//  Copyright (c) 2014 Glen Yi. All rights reserved.
//

#import "TPFloatRatingView.h"

@interface TPFloatRatingView()

@property (strong, nonatomic) NSMutableArray *emptyImageViews;
@property (strong, nonatomic) NSMutableArray *fullImageViews;

@end

@implementation TPFloatRatingView

- (void)baseInit
{
    _emptySelectedImage = nil;
    _fullSelectedImage = nil;
    _contentMode = UIViewContentModeCenter;
    _minRating = 0;
    _maxRating = 5;
    _minImageSize = CGSizeMake(5, 5);
    _rating = 0;
    _editable = NO;
    _halfRatings = NO;
    _floatRatings = NO;
    _delegate = nil;
    
    _emptyImageViews = [[NSMutableArray alloc] init];
    _fullImageViews = [[NSMutableArray alloc] init];
    [self initImageViews];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        [self baseInit];
    }
    return self;
}

- (void)refresh
{
    for (int i = 0; i < self.fullImageViews.count; ++i) {
        UIImageView *imageView = [self.fullImageViews objectAtIndex:i];
        // Changing the layer mask on the fly is drawn weird sometimes, so for whole ratings, just hide/unhide the image
        if (!self.halfRatings && !self.floatRatings) {
            imageView.layer.mask.frame = imageView.layer.bounds;
            imageView.hidden = self.rating<=i;
        }
        // Change rating display by updating Full selected image layer mask
        else {
            if (self.rating >= i+1) {
                imageView.layer.mask.frame = imageView.layer.bounds;
            }
            else if (self.rating>i && self.rating<i+1){
                CGRect maskBounds = CGRectMake(0, 0, (self.rating-i)*imageView.frame.size.width, imageView.frame.size.height);
                imageView.layer.mask.frame = maskBounds;
            }
            else {
                imageView.layer.mask.frame = CGRectZero;
            }
            imageView.hidden = NO;
        }
    }
}

- (CGSize)sizeForImage:(UIImage*)image inSize:(CGSize)size
{
    CGFloat imageRatio = image.size.width / image.size.height;
    CGFloat viewRatio = size.width / size.height;
    CGSize returnSize;
    
    // Find correct size for image to fit
    if(imageRatio < viewRatio) {
        CGFloat scale = size.height / image.size.height;
        CGFloat width = scale * image.size.width;
        
        returnSize = CGSizeMake(width, size.height);
    }
    else {
        CGFloat scale = size.width / image.size.width;
        CGFloat height = scale * image.size.height;
        
        returnSize = CGSizeMake(size.width, height);
    }
    
    return returnSize;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.emptySelectedImage)
        return;
    
    CGFloat desiredImageWidth = self.frame.size.width / self.emptyImageViews.count;
    CGFloat maxImageWidth = MAX(self.minImageSize.width, desiredImageWidth);
    CGFloat maxImageHeight = MAX(self.minImageSize.height, self.frame.size.height);
    CGSize imageViewSize = [self sizeForImage:self.emptySelectedImage inSize:CGSizeMake(maxImageWidth, maxImageHeight)];
    CGFloat imageXOffset = (self.frame.size.width-(imageViewSize.width*self.emptyImageViews.count))/(self.emptyImageViews.count-1);
    
    for (int i = 0; i < self.emptyImageViews.count; ++i) {
        CGRect imageFrame = CGRectMake(i==0? 0:i*(imageXOffset+imageViewSize.width), 0, imageViewSize.width, imageViewSize.height);
        
        UIImageView *imageView = [self.emptyImageViews objectAtIndex:i];
        imageView.frame = imageFrame;
        
        imageView = [self.fullImageViews objectAtIndex:i];
        imageView.frame = imageFrame;
    }
    [self refresh];
}

- (void)removeImageViews
{
    // Remove old image views
    for (int i = 0; i < self.emptyImageViews.count; ++i) {
        UIImageView *imageView = (UIImageView *)[self.emptyImageViews objectAtIndex:i];
        [imageView removeFromSuperview];
        imageView = (UIImageView *)[self.fullImageViews objectAtIndex:i];
        [imageView removeFromSuperview];
    }
    [self.emptyImageViews removeAllObjects];
    [self.fullImageViews removeAllObjects];
}

- (void)initImageViews
{
    if (self.emptyImageViews.count!=0)
        return;
    
    // Add new image views
    for (int i = 0; i < self.maxRating; ++i) {
        UIImageView *emptyImageView = [[UIImageView alloc] init];
        emptyImageView.contentMode = self.contentMode;
        emptyImageView.image = self.emptySelectedImage;
        [self.emptyImageViews addObject:emptyImageView];
        [self addSubview:emptyImageView];
        
        UIImageView *fullImageView = [[UIImageView alloc] init];
        fullImageView.contentMode = self.contentMode;
        fullImageView.image = self.fullSelectedImage;
        // Set mask layer to hide full images
        CALayer *maskLayer = [CALayer layer];
        maskLayer.frame = CGRectMake(0, 0, 0, 0);
        maskLayer.backgroundColor = [UIColor blackColor].CGColor;
        fullImageView.layer.mask = maskLayer;
        [self.fullImageViews addObject:fullImageView];
        [self addSubview:fullImageView];
    }
}

- (void)setMaxRating:(NSInteger)maxRating
{
    _maxRating = maxRating;
    
    [self removeImageViews];
    
    [self initImageViews];
    
    // Relayout and refresh
    [self setNeedsLayout];
    [self refresh];
}

- (void)setEmptySelectedImage:(UIImage *)emptySelectedImage
{
    _emptySelectedImage = emptySelectedImage;
    
    // Update empty image views
    for (UIImageView *imageView in self.emptyImageViews) {
        imageView.image = emptySelectedImage;
    }
    [self refresh];
}

- (void)setFullSelectedImage:(UIImage *)fullSelectedImage
{
    _fullSelectedImage = fullSelectedImage;
    
    // Update full image views
    for (UIImageView *imageView in self.fullImageViews) {
        imageView.image = fullSelectedImage;
    }
    [self refresh];
}

- (void)setRating:(CGFloat)rating
{
    _rating = rating;
    [self refresh];
}

- (void)setHalfRatings:(BOOL)halfRatings
{
    _halfRatings = halfRatings;
    
    // Update masks for next refresh
    for (int i = 0; i < self.fullImageViews.count; ++i) {
        UIImageView *imageView = [self.fullImageViews objectAtIndex:i];

        if (self.rating >= i+1) {
            imageView.layer.mask.frame = imageView.layer.bounds;
        }
        else if (self.rating>i && self.rating<i+1){
            CGRect maskBounds = CGRectMake(0, 0, (self.rating-i)*imageView.frame.size.width, imageView.frame.size.height);
            imageView.layer.mask.frame = maskBounds;
        }
        else {
            imageView.layer.mask.frame = CGRectZero;
        }
    }
}

- (void)setFloatRatings:(BOOL)floatRatings
{
    _floatRatings = floatRatings;
    
    // Update masks for next refresh
    for (int i = 0; i < self.fullImageViews.count; ++i) {
        UIImageView *imageView = [self.fullImageViews objectAtIndex:i];
        
        if (self.rating >= i+1) {
            imageView.layer.mask.frame = imageView.layer.bounds;
        }
        else if (self.rating>i && self.rating<i+1){
            CGRect maskBounds = CGRectMake(0, 0, (self.rating-i)*imageView.frame.size.width, imageView.frame.size.height);
            imageView.layer.mask.frame = maskBounds;
        }
        else {
            imageView.layer.mask.frame = CGRectZero;
        }
    }
}

- (void)handleTouchAtLocation:(CGPoint)touchLocation
{
    if (!self.editable)
        return;
    
    CGFloat newRating = 0;
    for (NSInteger i = self.emptyImageViews.count - 1; i >= 0; i--) {
        UIImageView *imageView = [self.emptyImageViews objectAtIndex:i];
        if (touchLocation.x > imageView.frame.origin.x) {
            // Find touch point in image view
            CGPoint newLocation = [imageView convertPoint:touchLocation fromView:self];
            if ([imageView pointInside:newLocation withEvent:nil] && (self.floatRatings || self.halfRatings)) {
                CGFloat decimalNum = newLocation.x/imageView.frame.size.width;
                newRating = i + decimalNum;
                if (self.halfRatings) {
                    newRating = i + (decimalNum>0.75? 1:(decimalNum>0.25? 0.5:0));
                }
            }
            else {
                newRating = i+1;
            }
            break;
        }
    }
    
    self.rating = newRating<self.minRating? self.minRating:newRating;
    
    // Update delegate
    if ([self.delegate respondsToSelector:@selector(floatRatingView:continuousRating:)])
        [self.delegate floatRatingView:self continuousRating:self.rating];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    [self handleTouchAtLocation:touchLocation];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    [self handleTouchAtLocation:touchLocation];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(floatRatingView:ratingDidChange:)])
        [self.delegate floatRatingView:self ratingDidChange:self.rating];
}

@end
