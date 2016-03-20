//
//  ContactRow.h
//  Contacts
//
//  Created by Theo Scott on 20/03/2016.
//  Copyright © 2016 Theo Scott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WatchKit/WatchKit.h>

@interface ContactRow : NSObject
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *contactPicType;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *name;
@property (nonatomic, strong ) NSString *identifier;
@end
