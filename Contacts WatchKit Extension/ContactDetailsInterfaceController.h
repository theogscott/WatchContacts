//
//  ContactDetailsInterfaceController.h
//  Contacts
//
//  Created by Theo Scott on 21/03/2016.
//  Copyright © 2016 Theo Scott. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface ContactDetailsInterfaceController : WKInterfaceController
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *picture;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *name;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *organisationName;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceTable *tableView;


@end
