//
//  InterfaceController.m
//  Contacts WatchKit Extension
//
//  Created by Theo Scott on 20/03/2016.
//  Copyright © 2016 Theo Scott. All rights reserved.
//

#import "InterfaceController.h"
#import <Contacts/Contacts.h>
#import "ContactRow.h"

static NSString  *const kContactRowIdent=@"ContactRowIdent";
static NSString  *const kContacts=@"Contacts";
static NSString  *const kLoading=@"Loading...";

static NSString  *const kAnonymousPerson=@"AnonymousPerson";
static NSString  *const kAnonymousCompany=@"AnonymousCompany";
static NSString  *const kShowContactDetails=@"ShowContactDetails";


@interface InterfaceController()

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
    [self loadContacts];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}
- (void) loadContacts
{
    CNContactStore *store=[[CNContactStore alloc] init];
    
    [store requestAccessForEntityType:CNEntityTypeContacts
                    completionHandler:^(BOOL granted, NSError * _Nullable error)
     {
         if (granted == YES)
         {
            [self setTitle:kLoading];
             NSArray *keys = @[CNContactFamilyNameKey,
                               CNContactGivenNameKey,
                               CNContactPostalAddressesKey,
                               CNContactOrganizationNameKey,
                               CNContactTypeKey
                               ];
             NSString *containerId = store.defaultContainerIdentifier;
             NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
             
             
             NSError *error;
             NSArray *allContacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
             if (error)
             {
                 NSLog(@"error fetching contacts %@", error);
            }
             else
             {
                 for (CNContact *object in allContacts)
                 {
                     if ([object isKeyAvailable:CNContactPostalAddressesKey])
                     {
                         if (object.postalAddresses.count>0)
                         {
                             [self addContactToTable:object];
                         }
                     }
                 }
            }
          
         }
         else
         {
             NSLog(@"Permission not granted");
         }
         [self setTitle:kContacts];
     }];
    
}

-(void) addContactToTable:(CNContact *)contact
{
    
    NSInteger newRowIndex=self.tableView.numberOfRows;
    NSIndexSet *newRowIndexSet=[NSIndexSet indexSetWithIndex:newRowIndex];
    
    [self.tableView insertRowsAtIndexes:newRowIndexSet withRowType:kContactRowIdent] ;
    ContactRow *row=[self.tableView rowControllerAtIndex:newRowIndex] ;
    
    NSString *fullName=nil;
    NSString *orgName=nil;
    UIImage *Image=[UIImage imageNamed:kAnonymousPerson];
    
    if (contact.contactType==CNContactTypePerson)
    {
        fullName=[[NSString alloc] initWithFormat:@"%@ %@", contact.givenName, contact.familyName];
        orgName=contact.organizationName;
    }
    else if  (contact.contactType==CNContactTypeOrganization)
    {
        fullName=contact.organizationName;
        orgName=nil;
        {
            Image=[UIImage imageNamed:kAnonymousCompany];
        }
    }
    
    [row.name setText:fullName];
    [row.contactPicType setImage:Image];
    row.identifier=contact.identifier;
    
}


- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex
{
    ContactRow *row=[self.tableView rowControllerAtIndex:rowIndex] ;
    [self presentControllerWithName:kShowContactDetails context:row.identifier];
}


@end



