//
//  ModelController.h
//  Notebook
//
//  Created by Emmanuel Alves on 2016-11-12.
//  Copyright © 2016 Emmanuel Alves. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataViewController;

@interface ModelController : NSObject <UIPageViewControllerDataSource>

- (DataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(DataViewController *)viewController;

@end

