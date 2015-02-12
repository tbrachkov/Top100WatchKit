//
//  DetailViewController.m
//  Top100
//
//  Created by Todor Brachkov on 2/10/15.
//  Copyright (c) 2015 Todor Brachkov. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *appImageView;
@property (weak, nonatomic) IBOutlet UILabel *appTitle;
@property (weak, nonatomic) IBOutlet UILabel *appArtist;
@property (weak, nonatomic) IBOutlet UILabel *appCategory;
@property (weak, nonatomic) IBOutlet UIButton *appPrice;
@property (weak, nonatomic) IBOutlet UITextView *appDescriptopn;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationTitle;


@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem)
    {
        _detailItem = newDetailItem;
            
        [self configureView];
    }
}

- (void)configureView
{
    if (self.detailItem)
    {
        self.appTitle.text = self.detailItem.title;
        [self.appPrice setTitle:self.detailItem.price forState:UIControlStateNormal];
        self.appCategory.text = self.detailItem.category;
        self.appDescriptopn.text= self.detailItem.summary;
        self.appArtist.text = self.detailItem.artist;
        
        dispatch_queue_t downloadQueue = dispatch_queue_create("download image", NULL);
        dispatch_async(downloadQueue, ^{
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.detailItem.image]]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.appImageView.image = image;
                [self.appImageView setNeedsLayout];
            });
        });
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationTitle.title = self.detailItem.title;
    
    if (isIOS7)
    {
        UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self.gestureTarget action:@selector(handlePinch:)];
        [self.view addGestureRecognizer:pinchRecognizer];
        
        UIScreenEdgePanGestureRecognizer *edgePanRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self.gestureTarget action:@selector(handleEdgePan:)];
        edgePanRecognizer.edges = UIRectEdgeLeft;
        [self.view addGestureRecognizer:edgePanRecognizer];
    }
    
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
