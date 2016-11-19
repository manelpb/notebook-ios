//
//  Notes+CoreDataProperties.h
//  Notebook
//
//  Created by Emmanuel Alves on 2016-11-13.
//  Copyright © 2016 Emmanuel Alves. All rights reserved.
//

#import "Notes+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Notes (CoreDataProperties)

+ (NSFetchRequest<Notes *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *text;
@property (nullable, nonatomic, copy) NSDate *timestamp;
@property (nullable, nonatomic, retain) NSData *business_card;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSDate *date_interaction;

@end

NS_ASSUME_NONNULL_END
