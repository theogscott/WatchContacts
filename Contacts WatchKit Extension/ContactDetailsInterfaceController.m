//
//  ContactDetailsInterfaceController.m
//  Contacts
//
//  Created by Theo Scott on 21/03/2016.
//  Copyright © 2016 Theo Scott. All rights reserved.
//

#import "ContactDetailsInterfaceController.h"
#import <Contacts/Contacts.h>
#import "PostalAdressRow.h"

static NSString  *const  kPostalAddressRow=@"PostalAddressRow";
static NSString  *const kAdresses=@"Adresses";
static NSString  *const kLoading=@"Loading...";

static NSString  *const kAnonymousPerson=@"AnonymousPerson";
static NSString  *const kAnonymousCompany=@"AnonymousCompany";

@interface ContactDetailsInterfaceController ()

@end

@implementation ContactDetailsInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    NSString *identifier=context;
    [self loadContact:identifier];
    

}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void) loadContact:(NSString *) identifier
{
    CNContactStore *store=[[CNContactStore alloc] init];
    
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error)
     {
         if (granted == YES)
         {
             [self setTitle:kLoading];
             //keys with fetching properties
             NSArray *keys = @[CNContactFamilyNameKey, CNContactGivenNameKey,
                               CNContactImageDataAvailableKey,
                               CNContactThumbnailImageDataKey,
                               CNContactPostalAddressesKey, CNContactOrganizationNameKey, CNContactTypeKey
                               ];

             NSPredicate *predicate = [CNContact predicateForContactsWithIdentifiers:@[identifier]];
             
             NSError *error;
             NSArray *allContacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
             if (error)
             {
                 NSLog(@"error fetching contacts %@", error);
             }
             else
             {
                 
                 NSAssert(allContacts.count==1, @"More than one contact with the same identifuer as %@", identifier );
                 for (CNContact *object in allContacts) // if no identifer, contact might have been deleted, won't enter loop...
                 {
                     [self setContactNameDetails:object];
                     [self setContactAddressDetails:object];


                     
                 }
             }
             [self setTitle:kAdresses];
         }
         else
         {
             NSLog(@"Permission not granted");
         }
     }];
    
}

- (void) setContactAddressDetails: (CNContact *) contact
{
    if ([contact isKeyAvailable:CNContactPostalAddressesKey])
    {
        CNPostalAddressFormatter *formatter=[[CNPostalAddressFormatter alloc] init];
        [self.tableView setNumberOfRows:contact.postalAddresses.count withRowType:kPostalAddressRow];
        NSInteger rowIndex=0;
        for (CNLabeledValue *label in contact.postalAddresses)
        {
            PostalAdressRow *row=[self.tableView rowControllerAtIndex:rowIndex];
            
            NSString *locationName=(NSString *)label;
            [row.locationName setText:[CNLabeledValue localizedStringForLabel:locationName]];
            
            CNPostalAddress *adress=label.value;
            NSString *location=[formatter stringFromPostalAddress:adress];
            [row.locationAddress setText:location];
  
            rowIndex++;
            
        }
   }
}

- (void) setContactNameDetails:(CNContact *) object
{

    UIImage *image=[UIImage imageNamed:kAnonymousPerson];
    NSString *name, *orgName;

    if (object.contactType==CNContactTypePerson)
    {
        name=[[NSString alloc] initWithFormat:@"%@ %@", object.givenName, object.familyName];
        if (object.imageDataAvailable)
        {
            image=[UIImage imageWithData:object.thumbnailImageData];
        }
        orgName=object.organizationName;
        if (name==nil)
        {
            name=orgName;
        }
        
    }
    else if  (object.contactType==CNContactTypeOrganization)
    {
        if (object.organizationName!=nil)
        {
            name=[[NSString alloc] initWithFormat:@"%@", object.organizationName];
        }
        else
        {
            name=[[NSString alloc] initWithFormat:@"%@ %@", object.givenName, object.familyName];
        }
        if (object.imageDataAvailable)
        {
            image=[UIImage imageWithData:object.thumbnailImageData];
        }
        else
        {
            image=[UIImage imageNamed:kAnonymousCompany];
        }
        
    }

    [self.name setText:name];
    [self.picture setImage:image];
    [self.organisationName setText:orgName];
}


@end



