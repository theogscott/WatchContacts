//
//  InterfaceController.h
//  Contacts WatchKit Extension
//
//  Created by Theo Scott on 20/03/2016.
//  Copyright © 2016 Theo Scott. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface InterfaceController : WKInterfaceController
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceTable *tableView;

- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex;
@end
