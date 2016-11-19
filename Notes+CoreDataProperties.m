//
//  Notes+CoreDataProperties.m
//  Notebook
//
//  Created by Emmanuel Alves on 2016-11-13.
//  Copyright © 2016 Emmanuel Alves. All rights reserved.
//

#import "Notes+CoreDataProperties.h"

@implementation Notes (CoreDataProperties)

+ (NSFetchRequest<Notes *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Notes"];
}

@dynamic text;
@dynamic timestamp;
@dynamic business_card;
@dynamic name;
@dynamic date_interaction;

@end
