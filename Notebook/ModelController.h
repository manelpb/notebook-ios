//
//  ModelController.h
//  Notebook
//
//  Created by Emmanuel Alves on 2016-11-12.
//  Copyright © 2016 Emmanuel Alves. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "RootViewController.h"
#import "Notes+CoreDataProperties.h"

@class DataViewController;

@interface ModelController : NSObject <UIPageViewControllerDataSource>

- (DataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(DataViewController *)viewController;

@property RootViewController* rootView;
@property NSArray* records;

- (void) createNewEmptyRecord;
- (void) saveRecord:(Notes*)currentNote;
- (void) reloadData;
- (void) removeRecord:(Notes*)currentNote;

// Used for Core-Data
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel; // Schema
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;  // Get insert delete from the databse
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;  // Database connection
- (NSURL *)applicationDocumentsDirectory; // nice to have to reference files for core data


@end

