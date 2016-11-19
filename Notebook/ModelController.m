//
//  ModelController.m
//  Notebook
//
//  Created by Emmanuel Alves on 2016-11-12.
//  Copyright © 2016 Emmanuel Alves. All rights reserved.
//

#import "ModelController.h"
#import "DataViewController.h"

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */


@interface ModelController ()

@property (readonly, strong, nonatomic) NSArray *pageData;
@end

@implementation ModelController

@synthesize managedObjectContext = _managedObjectContext;               // Get, insert, delete.
@synthesize managedObjectModel = _managedObjectModel;                   // Schema
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;   // Database connection

- (instancetype)init {
    self = [super init];
    if (self) {
        // loads the data
        [self reloadData];
        
        // check if there's no data, i will automatically add a new empty record
        if(_records.count == 0) {
            [self createNewEmptyRecord];
        }
        
    }
    return self;
}

/*
 * reload all the notes from database
 */
- (void) reloadData {
    // loads the data
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Notes" inManagedObjectContext: context]];
    
    // store in an array
    _records = [context executeFetchRequest:request error:&error];
    
    NSLog(@"Items on database: %ld", _records.count);
}

/*
 * saves the recond on database
 */
- (void) saveRecord:(Notes *)currentNote {
    // Save it to SQLLite
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error;
    
    if(![context save:&error]) {
        NSLog(@"Save failed: %@", [error localizedDescription]);
    } else {
        NSLog(@"Item %@ saved", currentNote);
    }
    
    // reload the data
    [self reloadData];
}

- (void) removeRecord:(Notes *)currentNote {
    NSManagedObjectContext *context = [self managedObjectContext];
    [context deleteObject:currentNote];
    
    // reload the data
    [self reloadData];
    
    // tells the root view to move to the first page
    [[self rootView] moveToFirstPage];
}

/*
 * create a new empty record and flip to it
 */
- (void) createNewEmptyRecord {
    // Save it to SQLLite
    NSManagedObjectContext *context = [self managedObjectContext];
    NSError *error;
    
    Notes* notes = [NSEntityDescription insertNewObjectForEntityForName:@"Notes" inManagedObjectContext: context];
    notes.timestamp = [NSDate date];
    notes.text = @"";
    
    if(![context save:&error]) {
        NSLog(@"Save failed: %@", [error localizedDescription]);
    } else {
        NSLog(@"Item %@ saved", notes);
    }
    
    // reload the data
    [self reloadData];
    
    // tells the root view to move to the last page (the new empty record)
    [[self rootView] moveToLastPage];
}

- (DataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard {
    // Return the data view controller for the given index.
    if (([self.records count] == 0) || (index >= [self.records count])) {
        return nil;
    }

    // Create a new view controller and pass suitable data.
    DataViewController *dataViewController = [storyboard instantiateViewControllerWithIdentifier:@"DataViewController"];
    //dataViewController.dataObject = self.pageData[index];
    dataViewController.note = self.records[index];
    dataViewController.modelController = self;
    dataViewController.rootController = self.rootView;
    
    return dataViewController;
}


- (NSUInteger)indexOfViewController:(DataViewController *)viewController {
    // Return the index of the given data view controller.
    // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    return [self.records indexOfObject:viewController.note];
}


#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(DataViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(DataViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    
    if (index == [self.records count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}


//////////////////////////////////////////////////////
// FOR CORE DATA //
//////////////////////////////////////////////////////

- (void)saveContext{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


- (NSManagedObjectContext *)managedObjectContext{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return _managedObjectContext;
}


- (NSManagedObjectModel *)managedObjectModel{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Notebook" withExtension:@"momd"];
    
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ModelCoreData.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


#pragma mark - Application's Documents directory


// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

// END CORE DATA //

@end
