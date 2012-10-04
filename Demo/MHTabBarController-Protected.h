//
//  MHTabBarController-Protected.h
//  Pods
//
//  Created by Angel Garcia on 10/4/12.
//
//

#import "MHTabBarController.h"

@interface MHTabBarController ()

@property(nonatomic, strong) IBOutlet UIView *tabButtonsContainerView;
@property(nonatomic, strong) IBOutlet UIView *contentContainerView;
@property(nonatomic, strong) IBOutlet UIImageView *indicatorImageView;

//Tab Customization
@property(nonatomic, strong) UIFont *tabTitleFont;

@property(nonatomic, assign) CGSize tabShadowOffset;

@property(nonatomic, strong) UIImage *tabInactiveBackgroundImage;
@property(nonatomic, strong) UIImage *tabActiveBackgroundImage;

@property(nonatomic, strong) UIColor *tabInactiveTitleColor;
@property(nonatomic, strong) UIColor *tabActiveTitleColor;

@property(nonatomic, strong) UIColor *tabInactiveShadowColor;
@property(nonatomic, strong) UIColor *tabActiveShadowColor;


@end