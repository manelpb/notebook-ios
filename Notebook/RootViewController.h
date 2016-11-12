//
//  RootViewController.h
//  Notebook
//
//  Created by Emmanuel Alves on 2016-11-12.
//  Copyright © 2016 Emmanuel Alves. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController <UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;

@end

