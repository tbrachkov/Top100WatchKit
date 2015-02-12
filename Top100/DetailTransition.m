//
//  DetailTransition.m
//  Top100
//
//  Created by Todor Brachkov on 2/12/15.
//  Copyright (c) 2015 Todor Brachkov. All rights reserved.
//

#import "DetailTransition.h"

@interface DetailTransition ()

@property (nonatomic, assign) CGFloat startScale;
@property (nonatomic, assign) BOOL shouldCompleteTransition;

@end

@implementation DetailTransition

#pragma mark - Init

- (instancetype) initWithNavigationController:(UINavigationController *)nc
{
    self = [super init];
    if (self)
    {
        self.parent = nc;
        self.transitionDuration = .5;
        self.transitionBackgroundColor = [UIColor whiteColor];
        
        nc.delegate = self;
    }
    
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning protocol

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *inView = [transitionContext containerView];
    UIView *masterView = self.operation == UINavigationControllerOperationPush ? fromVC.view : toVC.view;
    UIView *detailView = self.operation == UINavigationControllerOperationPush ? toVC.view : fromVC.view;
    
    if (self.operation == UINavigationControllerOperationPush)
    {
        detailView.frame = [transitionContext finalFrameForViewController:toVC];
    } else
    {
        masterView.frame = [transitionContext finalFrameForViewController:toVC];
    }
    
    [inView addSubview:toVC.view];
    
    CGPoint detailContentOffset = CGPointMake(.0, .0);
    if ([detailView isKindOfClass:[UIScrollView class]])
    {
        detailContentOffset = ((UIScrollView *)detailView).contentOffset;
    }
    
    CGPoint masterContentOffset = CGPointMake(.0, .0);
    if ([masterView isKindOfClass:[UIScrollView class]])
    {
        masterContentOffset = ((UIScrollView *) masterView).contentOffset;
    }
    
    UIGraphicsBeginImageContextWithOptions(detailView.bounds.size, detailView.opaque, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, 0, -detailContentOffset.y);
    [detailView.layer renderInContext:ctx];
    UIImage *detailSnapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContextWithOptions(masterView.bounds.size, masterView.opaque, 0);
    ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, 0, -masterContentOffset.y);
    [masterView.layer renderInContext:ctx];
    UIImage *masterSnapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGRect sourceRect = [masterView convertRect:self.sourceView.bounds fromView:self.sourceView];
    CGFloat splitPoint = sourceRect.origin.y + sourceRect.size.height - masterContentOffset.y;
    CGFloat scale = [UIScreen mainScreen].scale;
    
    CGImageRef masterImgRef = masterSnapshot.CGImage;
    CGImageRef topImgRef = CGImageCreateWithImageInRect(masterImgRef, CGRectMake(0, 0, masterSnapshot.size.width * scale, splitPoint * scale));
    UIImage *topImage = [UIImage imageWithCGImage:topImgRef scale:scale orientation:UIImageOrientationUp];
    CGImageRelease(topImgRef);
    
    CGImageRef bottomImgRef = CGImageCreateWithImageInRect(masterImgRef, CGRectMake(0, splitPoint * scale,  masterSnapshot.size.width * scale, (masterSnapshot.size.height - splitPoint) * scale));
    UIImage *bottomImage = [UIImage imageWithCGImage:bottomImgRef scale:scale orientation:UIImageOrientationUp];
    CGImageRelease(bottomImgRef);
    
    UIImageView *masterTopView = [[UIImageView alloc] initWithImage:topImage];
    UIImageView *masterBottomView = [[UIImageView alloc] initWithImage:bottomImage];
    CGRect bottomFrame = masterBottomView.frame;
    bottomFrame.origin.y = splitPoint;
    masterBottomView.frame = bottomFrame;
    
    CGRect masterTopEndFrame = masterTopView.frame;
    CGRect masterBottomEndFrame = masterBottomView.frame;
    if (self.operation == UINavigationControllerOperationPush)
    {
        masterTopEndFrame.origin.y = -(masterTopEndFrame.size.height - sourceRect.size.height);
        masterBottomEndFrame.origin.y += masterBottomEndFrame.size.height;
    } else
    {
        CGRect masterTopStartFrame = masterTopView.frame;
        masterTopStartFrame.origin.y = -(masterTopStartFrame.size.height - sourceRect.size.height);
        masterTopView.frame = masterTopStartFrame;
        
        CGRect masterBottomStartFrame = masterBottomView.frame;
        masterBottomStartFrame.origin.y += masterBottomStartFrame.size.height;
        masterBottomView.frame = masterBottomStartFrame;
    }
    
    CGFloat initialAlpha = self.operation == UINavigationControllerOperationPush ? .0 : 1.0;
    CGFloat finalAlpha = self.operation == UINavigationControllerOperationPush ? 1.0 : .0;
    
    UIView *masterTopFadeView = [[UIView alloc] initWithFrame:masterTopView.frame];
    masterTopFadeView.backgroundColor = masterView.backgroundColor;
    masterTopFadeView.alpha = initialAlpha;
    
    UIView *masterBottomFadeView = [[UIView alloc] initWithFrame:masterBottomView.frame];
    masterBottomFadeView.backgroundColor = masterView.backgroundColor;
    masterBottomFadeView.alpha = initialAlpha;
    
    // create snapshot
    UIImageView *detailSmokeScreenView = [[UIImageView alloc] initWithImage:detailSnapshot];
    
    if (self.operation == UINavigationControllerOperationPush)
    {
        detailSmokeScreenView.layer.transform = CATransform3DMakeAffineTransform(CGAffineTransformMakeScale(.1, .1));
    }
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:inView.frame];
    backgroundView.backgroundColor = self.transitionBackgroundColor;
    
    [inView addSubview:backgroundView];
    [inView addSubview:detailSmokeScreenView];
    [inView addSubview:masterTopView];
    [inView addSubview:masterTopFadeView];
    [inView addSubview:masterBottomView];
    [inView addSubview:masterBottomFadeView];
    
    NSTimeInterval totalDuration = [self transitionDuration:transitionContext];
    
    [UIView animateKeyframesWithDuration:totalDuration
                                   delay:0
                                 options:UIViewKeyframeAnimationOptionCalculationModeLinear
                              animations:^{
                                  masterTopView.frame = masterTopEndFrame;
                                  masterTopFadeView.frame = masterTopEndFrame;
                                  masterBottomView.frame = masterBottomEndFrame;
                                  masterBottomFadeView.frame = masterBottomEndFrame;
                                  
                                  if (self.operation == UINavigationControllerOperationPush) {
                                      detailSmokeScreenView.layer.transform = CATransform3DMakeAffineTransform(CGAffineTransformIdentity);
                                  } else {
                                      detailSmokeScreenView.layer.transform = CATransform3DMakeAffineTransform(CGAffineTransformMakeScale(.1, .1));
                                  }
                                  
                                  CGFloat fadeStartTime = self.operation == UINavigationControllerOperationPush ? .5 : .0;
                                  [UIView addKeyframeWithRelativeStartTime:fadeStartTime relativeDuration:.5 animations:^{
                                      masterTopFadeView.alpha = finalAlpha;
                                      masterBottomFadeView.alpha = finalAlpha;
                                  }];
                              }
                              completion:^(BOOL finished) {
                                  [backgroundView removeFromSuperview];
                                  [detailSmokeScreenView removeFromSuperview];
                                  [masterTopView removeFromSuperview];
                                  [masterTopFadeView removeFromSuperview];
                                  [masterBottomView removeFromSuperview];
                                  [masterBottomFadeView removeFromSuperview];
                                  
                                  if ([transitionContext transitionWasCancelled]) {
                                      [toVC.view removeFromSuperview];
                                      [transitionContext completeTransition:NO];
                                  } else {
                                      [fromVC.view removeFromSuperview];
                                      [transitionContext completeTransition:YES];
                                  }
                              }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return self.transitionDuration;
}

#pragma mark - TransitionControllerGestureTarget
- (void) handlePinch:(UIPinchGestureRecognizer *)gr
{
    CGFloat scale = gr.scale;
    
    switch (gr.state) {
        case UIGestureRecognizerStateBegan:
            self.interactive = YES;
            self.startScale = scale;
            [self.parent popViewControllerAnimated:YES];
            break;
        case UIGestureRecognizerStateChanged: {
            CGFloat percent = (1.0 - scale / self.startScale);
            self.shouldCompleteTransition = (percent > 0.25);
            
            [self updateInteractiveTransition: (percent <= 0.0) ? 0.0 : percent];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            if (!self.shouldCompleteTransition || gr.state == UIGestureRecognizerStateCancelled)
                [self cancelInteractiveTransition];
            else
                [self finishInteractiveTransition];
            self.interactive = NO;
            break;
        default:
            break;
    }
}

- (void) handleEdgePan:(UIScreenEdgePanGestureRecognizer *)gr
{
    CGPoint point = [gr translationInView:gr.view];
    
    switch (gr.state) {
        case UIGestureRecognizerStateBegan:
            self.interactive = YES;
            [self.parent popViewControllerAnimated:YES];
            break;
        case UIGestureRecognizerStateChanged: {
            CGFloat percent = point.x / gr.view.frame.size.width;
            self.shouldCompleteTransition = (percent > 0.25);
            
            [self updateInteractiveTransition: (percent <= 0.0) ? 0.0 : percent];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            if (!self.shouldCompleteTransition || gr.state == UIGestureRecognizerStateCancelled)
                [self cancelInteractiveTransition];
            else
                [self finishInteractiveTransition];
            self.interactive = NO;
            break;
        default:
            break;
    }
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    if (!navigationController) {
        return  nil;
    }
    
    self.operation = operation;
    
    return self;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    if (self.isInteractive)
    {
        return self;
    }
    
    return nil;
}

@end
