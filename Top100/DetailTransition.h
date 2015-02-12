//
//  DetailTransition.h
//  Top100
//
//  Created by Todor Brachkov on 2/12/15.
//  Copyright (c) 2015 Todor Brachkov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TransitionGestureTarget <NSObject>

- (void) handlePinch:(UIPinchGestureRecognizer *)gestureRecognizer;
- (void) handleEdgePan:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer;

@end

@interface DetailTransition : UIPercentDrivenInteractiveTransition <UIViewControllerAnimatedTransitioning, UINavigationControllerDelegate, TransitionGestureTarget>

- (instancetype)initWithNavigationController:(UINavigationController *)nc;

@property (nonatomic, strong) UIView *sourceView;
@property (nonatomic, assign) UINavigationControllerOperation operation;
@property (nonatomic, assign) CGFloat transitionDuration;

@property(nonatomic,assign) UINavigationController *parent;
@property(nonatomic,assign,getter = isInteractive) BOOL interactive;

@property (nonatomic, strong) UIColor *transitionBackgroundColor;

@end
