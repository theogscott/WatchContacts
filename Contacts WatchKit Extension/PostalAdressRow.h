//
//  PostalAdressRow.h
//  Contacts
//
//  Created by Theo Scott on 21/03/2016.
//  Copyright © 2016 Theo Scott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <watchkit/watchkit.h>

@interface PostalAdressRow : NSObject
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *locationName;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *locationAddress;

@end
