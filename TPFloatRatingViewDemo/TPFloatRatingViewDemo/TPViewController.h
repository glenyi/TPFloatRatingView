//
//  TPViewController.h
//  TPFloatRatingViewDemo
//
//  Created by Glen Yi on 2/27/2014.
//  Copyright (c) 2014 Glen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPFloatRatingView.h"

@interface TPViewController : UIViewController <TPFloatRatingViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *ratingLabel;
@property (strong, nonatomic) IBOutlet UILabel *liveLabel;
@property (strong, nonatomic) IBOutlet TPFloatRatingView *ratingView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

- (IBAction)controlChange:(id)sender;

@end
