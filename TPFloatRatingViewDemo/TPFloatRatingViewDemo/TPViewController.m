//
//  TPViewController.m
//  TPFloatRatingViewDemo
//
//  Created by Glen Yi on 2/27/2014.
//  Copyright (c) 2014 Glen. All rights reserved.
//

#import "TPViewController.h"

@interface TPViewController ()

@end

@implementation TPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.ratingView.delegate = self;
    self.ratingView.emptySelectedImage = [UIImage imageNamed:@"StarEmpty"];
    self.ratingView.fullSelectedImage = [UIImage imageNamed:@"StarFull"];
    self.ratingView.contentMode = UIViewContentModeScaleAspectFill;
    self.ratingView.maxRating = 5;
    self.ratingView.minRating = 1;
    self.ratingView.rating = 2.5;
    self.ratingView.editable = YES;
    self.ratingView.halfRatings = YES;
    self.ratingView.floatRatings = NO;
    
    self.ratingLabel.text = [NSString stringWithFormat:@"%.2f", self.ratingView.rating];
    self.liveLabel.text = [NSString stringWithFormat:@"%.2f", self.ratingView.rating];
    
    self.segmentedControl.selectedSegmentIndex = 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TPFloatRatingViewDelegate

- (void)floatRatingView:(TPFloatRatingView *)ratingView ratingDidChange:(CGFloat)rating
{
    self.ratingLabel.text = [NSString stringWithFormat:@"%.2f", rating];
}

- (void)floatRatingView:(TPFloatRatingView *)ratingView continuousRating:(CGFloat)rating
{
    self.liveLabel.text = [NSString stringWithFormat:@"%.2f", rating];
}

- (IBAction)controlChange:(id)sender
{
    UISegmentedControl *control = (UISegmentedControl *)sender;
    
    self.ratingView.halfRatings = control.selectedSegmentIndex==1? YES:NO;
    self.ratingView.floatRatings = control.selectedSegmentIndex==2? YES:NO;
}

@end
