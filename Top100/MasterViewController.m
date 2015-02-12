//
//  MasterViewController.m
//  Top100
//
//  Created by Todor Brachkov on 2/10/15.
//  Copyright (c) 2015 Todor Brachkov. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "Application.h"
#import "Application+Create.h"
#import "Application+Delete.h"
#import "ContextsManager.h"
#import "DetailTransition.h"
#import "AppTableViewCell.h"
#import "Constants.h"

#define isIOS7 floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1

@interface MasterViewController ()

#ifdef __IPHONE_7_0

@property (nonatomic, strong) DetailTransition *zoomTransition;

#endif

@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.managedObjectContext = [[ContextsManager sharedManager] getContext];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    [self setRefreshControl:refreshControl];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Application"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES]];
    request.predicate = nil;
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    if (isIOS7)
    {
        self.zoomTransition = [[DetailTransition alloc] initWithNavigationController:self.navigationController];
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - TableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AppCell";
    AppTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Application *app = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.appTitle.text = [NSString stringWithFormat:@"%d - %@", app.index.intValue, app.name];
    cell.appAuthor.text = app.artist;
    cell.appCategory.text = app.category;

    cell.appPrice.text = app.price;
    
    cell.imageView.image = nil;
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("download imagem", NULL);
    dispatch_async(downloadQueue, ^{
        UIImage *imagem = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:app.image]]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.imageView.image = imagem;
            [cell setNeedsLayout];
        });
    });
    
    
    return cell;
}


#pragma mark - Refresh methods

- (void)refresh:(id)sender
{
    
    [self.refreshControl beginRefreshing];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    dispatch_queue_t privateQueue = dispatch_queue_create("Top100 AppStore", NULL);
    
    dispatch_async(privateQueue, ^{
        NSString *url = kFilesUrl;
        
        NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *error = nil;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[ UIAlertView alloc]
                                       initWithTitle:@"Error loading data!"
                                       message:nil
                                       delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
                [alertView show];
                
            });
            
        } else
        {
            [self.managedObjectContext performBlock:^{
                
                NSDictionary *feed = [result objectForKey:@"feed"];
                NSArray *apps = [feed objectForKey:@"entry"];
                int index = 0;
                
                [Application deleteObjectsInManagedObjectContext:self.managedObjectContext];
                
                for (NSDictionary *app in apps) {
                    index++;
                    [Application withAppFromTheStore:app withManagedObjectContext:self.managedObjectContext atIndex:index];
                }
                
                [[ContextsManager sharedManager] saveContext:self.managedObjectContext error:nil];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.refreshControl endRefreshing];
                });
            }];
        }
    });
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        Application *app = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [[segue destinationViewController] setDetailItem:app];
        
        if (isIOS7)
        {
            [[segue destinationViewController] setGestureTarget:self.zoomTransition];
            
            self.zoomTransition.sourceView = [self.tableView cellForRowAtIndexPath:indexPath];

        }
    }
}
@end
