//
//  DataViewController.m
//  Notebook
//
//  Created by Emmanuel Alves on 2016-11-12.
//  Copyright © 2016 Emmanuel Alves. All rights reserved.
//

#import "DataViewController.h"

@interface DataViewController ()

@end

@implementation DataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // sets borders
    [[self.imgBusinessCard layer] setBorderColor:[[UIColor blackColor] CGColor]];
    [[self.imgBusinessCard layer] setBorderWidth:1];
    [[self.imgBusinessCard layer] setCornerRadius:5];
    
    [[self.txtText layer] setBorderColor:[[UIColor blackColor] CGColor]];
    [[self.txtText layer] setBorderWidth:1];
    [[self.txtText layer] setCornerRadius:5];
    self.txtText.delegate = self;
    
    [[self.txtName layer] setBorderColor:[[UIColor blackColor] CGColor]];
    [[self.txtName layer] setBorderWidth:1];
    [[self.txtName layer] setCornerRadius:5];
    self.txtName.delegate = self;
    
    [[self.txtDateInteraction layer] setBorderColor:[[UIColor blackColor] CGColor]];
    [[self.txtDateInteraction layer] setBorderWidth:1];
    [[self.txtDateInteraction layer] setCornerRadius:5];
    
    // creates the date picker
    self.txtDateInteraction.delegate = self;
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.txtDateInteraction.inputView = datePicker;
}

/*
 * textView and textField delegate events
 */
- (void) textViewDidBeginEditing:(UITextView *)textView {
    self.btnNewRecord.hidden = true;
    self.btnSave.hidden = false;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    self.btnNewRecord.hidden = true;
    self.btnSave.hidden = false;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.txtText resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [self saveRecord];
        return NO;
    }
    
    return YES;
}

- (void) datePickerValueChanged:(UIDatePicker*)datePicker {
    // formatting the selected date to display on our textField
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"MMMM d, yyyy 'at' HH'h'mm'm'"];
    
    // sets the date based on the datapicker
    self.note.date_interaction = datePicker.date;
    
    // just updates the textfield
    [self.txtDateInteraction setText:[dateFormatter stringFromDate:datePicker.date]];
    NSLog(@"%@", datePicker.date);
}

- (void)textViewDidChange:(UITextView *)textView {
    [self updateTextViewSize];
}

/*
 * take or choose a picture (business card) and save
 */
- (IBAction)btnAddBusinessCard:(id)sender {
    // loads camera or photo gallery
    [self takeOrChoosePhoto];
}


/*
 * creates a new record and flip the page
 */
- (IBAction)btnNew:(id)sender {
    [[self modelController] createNewEmptyRecord];
}

/*
 * save the object on database
 */
- (IBAction)btnSave:(id)sender {
    [self saveRecord];
}

/*
 * navigation
 */
- (IBAction)btnPrev:(id)sender {
    [[self rootController] moveToPreviousPage];
}

/*
 * navigation
 */
- (IBAction)btnNext:(id)sender {
    [[self rootController] moveToNextPage];
}

/*
 * saves the current object on database
 */
- (void) saveRecord {
    self.note.name = _txtName.text;
    self.note.text = _txtText.text;
    self.note.timestamp = [NSDate date];
    
    self.btnSave.hidden = true;
    self.btnNewRecord.hidden = false;
    
    // unfocus textview
    [_txtText resignFirstResponder];
    
    // saves itself on database
    [[self modelController] saveRecord:self.note];
}

/*
 * force update the size of my uitextview and following elements
 */
- (void) updateTextViewSize {
    // changes the size of uitextview based on its content
    CGRect frame = self.txtText.frame;
    frame.size.height = self.txtText.contentSize.height + 10;
    self.txtText.frame = frame;
    
    // sets the position of other components
    CGRect frame2 = self.uvBusinessCard.frame;
    frame2.origin.y = frame.origin.y + frame.size.height + 10;
    self.uvBusinessCard.frame = frame2;
    
    // sets the size of scrollview
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, (frame.size.height + frame2.size.height) + 200);
}

/*
 * When load this view, sets all objects based on the current note
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   
    // formatting the timestamp
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"MMMM d, yyyy 'at' HH'h'mm'm'"];
    
    NSInteger currentIndex = [self.modelController.records indexOfObject:self.note];
    
    // sets attributes
    self.txtName.text = self.note.name;
    self.lblDate.text = [NSString stringWithFormat:@"Saved in %@", [dateFormatter stringFromDate:self.note.timestamp]];
    self.txtDateInteraction.text = [dateFormatter stringFromDate:self.note.date_interaction];
    self.txtText.text = self.note.text;
    self.lblPages.text = [NSString stringWithFormat:@"%ld / %ld", currentIndex+1, self.modelController.records.count];
    
    // only loads an image if i have a saved object
    if(self.note.business_card != nil) {
        self.imgBusinessCard.image = [UIImage imageWithData:self.note.business_card];
        [self.btnAddBusinessCard setTitle:@"" forState:UIControlStateNormal];
    } else {
        [self.btnAddBusinessCard setTitle:@"Add business card" forState:UIControlStateNormal];
    }
    
    // force update the size of my uitextview and following elements
    [self updateTextViewSize];
    
    // check if i still have pages before and after the current note
    _btnPrev.hidden = currentIndex == 0;
    _btnNext.hidden = currentIndex+1 == self.modelController.records.count;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/////////////////////////////////////
// PHOTO PICKER
/////////////////////////////////////

- (void) takeOrChoosePhoto {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
#if TARGET_IPHONE_SIMULATOR
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
#else
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
#endif
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // retrieve the selected image
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    // convert to a NSData and set on the object
    NSData *imageData = UIImageJPEGRepresentation(chosenImage, 9.0);
    self.note.business_card = imageData;
    
    // saves the record
    [self saveRecord];
    
    // release the picker
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


@end
