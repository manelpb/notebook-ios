//
//  DataViewController.h
//  Notebook
//
//  Created by Emmanuel Alves on 2016-11-12.
//  Copyright © 2016 Emmanuel Alves. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Notes+CoreDataProperties.h"
#import "ModelController.h"
#import "RootViewController.h"

@interface DataViewController : UIViewController<UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) Notes* note;
@property (strong, nonatomic) ModelController* modelController;
@property (strong, nonatomic) RootViewController* rootController;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *txtName;

@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblPages;

@property (weak, nonatomic) IBOutlet UIButton *btnNewRecord;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIButton *btnAddBusinessCard;
@property (weak, nonatomic) IBOutlet UIButton *btnPrev;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;

@property (weak, nonatomic) IBOutlet UIView *uvBusinessCard;
@property (weak, nonatomic) IBOutlet UIImageView *imgBusinessCard;
@property (weak, nonatomic) IBOutlet UITextView *txtText;
@property (weak, nonatomic) IBOutlet UITextField *txtDateInteraction;


@end

