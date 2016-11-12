//
//  DataViewController.h
//  Notebook
//
//  Created by Emmanuel Alves on 2016-11-12.
//  Copyright © 2016 Emmanuel Alves. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *dataLabel;
@property (strong, nonatomic) id dataObject;

@end

