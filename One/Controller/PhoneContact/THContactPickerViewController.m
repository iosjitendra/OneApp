//
//  ContactPickerViewController.m
//  ContactPicker
//
//  Created by Tristan Himmelman on 11/2/12.
//  Copyright (c) 2012 Tristan Himmelman. All rights reserved.
//

#import "THContactPickerViewController.h"
#import <AddressBook/AddressBook.h>
#import "THContact.h"
#import "UIExtensions.h"
#import "ECSHelper.h"
UIBarButtonItem *barButton;

@interface THContactPickerViewController ()<UISearchBarDelegate>

@property (nonatomic, assign) ABAddressBookRef addressBookRef;
@property(weak,nonatomic) IBOutlet UILabel*lblHeader;
@property(weak,nonatomic) IBOutlet UISearchBar *searchBar;
@property(strong,nonatomic) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end

//#define kKeyboardHeight 216.0
#define kKeyboardHeight 0.0

@implementation THContactPickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.lblHeader.text = @"Select Contacts (0)";
        
        CFErrorRef error;
        _addressBookRef = ABAddressBookCreateWithOptions(NULL, &error);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonItemStyleBordered target:self action:@selector(removeAllContacts:)];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
   //self.navigationController.navigationBar.translucent = YES;
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.translucent = NO;
//    barButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done:)];
//    barButton.enabled = FALSE;
//    
//    self.navigationItem.rightBarButtonItem = barButton;
    
    // Initialize and add Contact Picker View
//    self.contactPickerView = [[THContactPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
//    self.contactPickerView.delegate = self;
//    [self.contactPickerView setPlaceholderString:@"     Search..."];
//    [self.contactPickerView setTintColor:[UIColor blackColor]];
//    
//    [self.view addSubview:self.contactPickerView];
//    
//    // Fill the rest of the view with the table view
//    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.contactPickerView.frame.size.height+500, self.view.frame.size.width, self.view.frame.size.height - self.contactPickerView.frame.size.height - kKeyboardHeight) style:UITableViewStylePlain];
    self.searchBar.backgroundColor = [UIColor whiteColor];
    
    self.searchBar.barTintColor = [UIColor whiteColor];
    self.searchBar.tintColor = [UIColor blueColor];
    self.searchBar.delegate=self;
    self.searchBar.placeholder=@"  Search people...  ";
    // self.searchBar.tableHeaderView = self.headerView;
    [ self.searchBar setImage:[UIImage imageNamed:@"Search-icon.png"]
             forSearchBarIcon:UISearchBarIconSearch
                        state:UIControlStateNormal];
  
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"THContactPickerTableViewCell" bundle:nil] forCellReuseIdentifier:@"ContactCell"];
    
   // [self.view insertSubview:self.tableView belowSubview:self.contactPickerView];
    self.tableView.tableHeaderView=self.headerView;
//    [self.view addSubview:self.tableView];
    ABAddressBookRequestAccessWithCompletion(self.addressBookRef, ^(bool granted, CFErrorRef error) {
        if (granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self getContactsFromAddressBook];
            });
        } else {
            // TODO: Show alert
        }
    });
}

-(void)getContactsFromAddressBook
{
    CFErrorRef error = NULL;
    self.contacts = [[NSMutableArray alloc]init];
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    if (addressBook) {
          //CFErrorRef error = NULL;
       // ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
        ABRecordRef source = ABAddressBookCopyDefaultSource(addressBook);
       // NSArray *allContacts = (__bridge_transfer NSArray*)ABAddressBookCopyArrayOfAllPeople(addressBook);
        NSArray *allContacts = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, kABPersonSortByFirstName);

        NSMutableArray *mutableContacts = [NSMutableArray arrayWithCapacity:allContacts.count];
        
        NSUInteger i = 0;
        for (i = 0; i<[allContacts count]; i++)
        {
            THContact *contact = [[THContact alloc] init];
            ABRecordRef contactPerson = (__bridge ABRecordRef)allContacts[i];
            contact.recordId = ABRecordGetRecordID(contactPerson);

            // Get first and last names
            NSString *firstName = (__bridge_transfer NSString*)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
            NSString *lastName = (__bridge_transfer NSString*)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
            
            // Set Contact properties
            contact.firstName = firstName;
            contact.lastName = lastName;
            
            // Get mobile number
            ABMultiValueRef phonesRef = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty);
            contact.phone = [self getMobilePhoneProperty:phonesRef];
            if(phonesRef) {
                CFRelease(phonesRef);
            }
            
            ABMultiValueRef  emails = ABRecordCopyValue(contactPerson, kABPersonEmailProperty);
            if(ABMultiValueGetCount(emails)> 0)
            {
                NSString *emailId = (__bridge NSString *)ABMultiValueCopyValueAtIndex(emails, 0);//0 for "Home Email"
                contact.email = emailId;
            }
            else contact.email = @"";
            
            // Get image if it exists
            NSData  *imgData = (__bridge_transfer NSData *)ABPersonCopyImageData(contactPerson);
            contact.imageData = imgData;
//            if (!contact.image) {
//                contact.image = [UIImage imageNamed:@"icon-avatar-60x60"];
//            }
            
            [mutableContacts addObject:contact];
        }
        
        if(addressBook) {
            CFRelease(addressBook);
        }
        
        self.contacts = [NSArray arrayWithArray:mutableContacts];
        self.selectedContacts = [NSMutableArray array];
        self.filteredContacts = self.contacts;
        
        [self.tableView reloadData];
    }
    else
    {
        NSLog(@"Error");
        
    }
}

- (void) refreshContacts
{
    for (THContact* contact in self.contacts)
    {
        [self refreshContact: contact];
    }
    [self.tableView reloadData];
}

- (void) refreshContact:(THContact*)contact
{
    
    ABRecordRef contactPerson = ABAddressBookGetPersonWithRecordID(self.addressBookRef, (ABRecordID)contact.recordId);
    contact.recordId = ABRecordGetRecordID(contactPerson);
    
    // Get first and last names
    NSString *firstName = (__bridge_transfer NSString*)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
    NSString *lastName = (__bridge_transfer NSString*)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
    
    // Set Contact properties
    contact.firstName = firstName;
    contact.lastName = lastName;
    
    // Get mobile number
    ABMultiValueRef phonesRef = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty);
    contact.phone = [self getMobilePhoneProperty:phonesRef];
    if(phonesRef) {
        CFRelease(phonesRef);
    }
    
    // Get image if it exists
    NSData  *imgData = (__bridge_transfer NSData *)ABPersonCopyImageData(contactPerson);
    contact.imageData= imgData;
//    contact.image = [UIImage imageWithData:imgData];
//    if (!contact.image) {
//        contact.image = [UIImage imageNamed:@"icon-avatar-60x60"];
//    }
}

- (NSString *)getMobilePhoneProperty:(ABMultiValueRef)phonesRef
{
    for (int i=0; i < ABMultiValueGetCount(phonesRef); i++) {
        CFStringRef currentPhoneLabel = ABMultiValueCopyLabelAtIndex(phonesRef, i);
        CFStringRef currentPhoneValue = ABMultiValueCopyValueAtIndex(phonesRef, i);
        
        if(currentPhoneLabel) {
            if (CFStringCompare(currentPhoneLabel, kABPersonPhoneMobileLabel, 0) == kCFCompareEqualTo) {
                return (__bridge NSString *)currentPhoneValue;
            }
            
            if (CFStringCompare(currentPhoneLabel, kABHomeLabel, 0) == kCFCompareEqualTo) {
                return (__bridge NSString *)currentPhoneValue;
            }
        }
        if(currentPhoneLabel) {
            CFRelease(currentPhoneLabel);
        }
        if(currentPhoneValue) {
            CFRelease(currentPhoneValue);
        }
    }
    
    return nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self refreshContacts];
//    });
}

//- (void)viewDidLayoutSubviews {
//    [super viewDidLayoutSubviews];
//    CGFloat topOffset = 0;
//    if ([self respondsToSelector:@selector(topLayoutGuide)]){
//        topOffset = self.topLayoutGuide.length;
//    }
//    CGRect frame = self.contactPickerView.frame;
//    frame.origin.y = topOffset;
//    self.contactPickerView.frame = frame;
//    [self adjustTableViewFrame:NO];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)adjustTableViewFrame:(BOOL)animated {
//    CGRect frame = self.tableView.frame;
//    // This places the table view right under the text field
//    frame.origin.y = self.contactPickerView.frame.size.height+20;
//    // Calculate the remaining distance
//    frame.size.height = self.view.frame.size.height - self.contactPickerView.frame.size.height - kKeyboardHeight;
//    
//    if(animated) {
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:0.3];
//        [UIView setAnimationDelay:0.1];
//        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
//        
//        self.tableView.frame = frame;
//        
//        [UIView commitAnimations];
//    }
//    else{
//        self.tableView.frame = frame;
//    }
//}



#pragma mark - UITableView Delegate and Datasource functions

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredContacts.count;
}

- (CGFloat)tableView: (UITableView*)tableView heightForRowAtIndexPath: (NSIndexPath*) indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Get the desired contact from the filteredContacts array
    THContact *contact = [self.filteredContacts objectAtIndex:indexPath.row];
    
    // Initialize the table view cell
    NSString *cellIdentifier = @"ContactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // Get the UI elements in the cell;
    UILabel *contactNameLabel = (UILabel *)[cell viewWithTag:101];
    UILabel *mobilePhoneNumberLabel = (UILabel *)[cell viewWithTag:102];
    UIImageView *contactImage = (UIImageView *)[cell viewWithTag:103];
    UIImageView *checkboxImageView = (UIImageView *)[cell viewWithTag:104];
    
    // Assign values to to US elements
    contactNameLabel.text = [contact fullName];
    mobilePhoneNumberLabel.text = contact.phone;
  
//    if(contact.imageData) {
//      [contactImage setImage:[UIImage imageWithData:contact.imageData]];
//    }
    contactImage.layer.masksToBounds = YES;
    contactImage.layer.cornerRadius = 20;
    
    // Set the checked state for the contact selection checkbox
    UIImage *image;
    if ([self.selectedContacts containsObject:[self.filteredContacts objectAtIndex:indexPath.row]]){
        //cell.accessoryType = UITableViewCellAccessoryCheckmark;
        image = [UIImage imageNamed:@"icon-checkbox-selected-green-25x25"];
    } else {
        //cell.accessoryType = UITableViewCellAccessoryNone;
        image = [UIImage imageNamed:@"icon-checkbox-unselected-25x25"];
    }
    checkboxImageView.image = image;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Hide Keyboard
    [self.contactPickerView resignKeyboard];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    // This uses the custom cellView
    // Set the custom imageView
    THContact *user = [self.filteredContacts objectAtIndex:indexPath.row];
    UIImageView *checkboxImageView = (UIImageView *)[cell viewWithTag:104];
    UIImage *image;
    

    checkboxImageView.image = image;
    // Reset the filtered contacts
    self.filteredContacts = self.contacts;
    // Refresh the tableview
     [[NSNotificationCenter defaultCenter] postNotificationName:@"carryingDataofFilter" object:user];
    
    [self.navigationController popViewControllerAnimated:YES];
   // [self.tableView reloadData];
}

#pragma mark - THContactPickerTextViewDelegate

- (void)contactPickerTextViewDidChange:(NSString *)textViewText {
    if ([textViewText isEqualToString:@""]){
        self.filteredContacts = self.contacts;
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.%@ contains[cd] %@ OR self.%@ contains[cd] %@", @"firstName", textViewText, @"lastName", textViewText];
        self.filteredContacts = [self.contacts filteredArrayUsingPredicate:predicate];
    }
    [self.tableView reloadData];
}

- (void)contactPickerDidResize:(THContactPickerView *)contactPickerView {
  //  [self adjustTableViewFrame:YES];
}

//- (void)contactPickerDidRemoveContact:(id)contact {
//    [self.selectedContacts removeObject:contact];
//    
//    NSUInteger index = [self.contacts indexOfObject:contact];
//    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
//    //cell.accessoryType = UITableViewCellAccessoryNone;
//    
//    // Enable Done button if total selected contacts > 0
//    if(self.selectedContacts.count > 0) {
//        barButton.enabled = TRUE;
//    }
//    else
//    {
//        barButton.enabled = FALSE;
//    }
//    
//    // Set unchecked image
//    UIImageView *checkboxImageView = (UIImageView *)[cell viewWithTag:104];
//    UIImage *image;
//    image = [UIImage imageNamed:@"icon-checkbox-unselected-25x25"];
//    checkboxImageView.image = image;
//    
//    // Update window title
//    self.title = [NSString stringWithFormat:@"Add Members (%lu)", (unsigned long)self.selectedContacts.count];
//}

- (void)removeAllContacts:(id)sender
{
    [self.contactPickerView removeAllContacts];
    [self.selectedContacts removeAllObjects];
    self.filteredContacts = self.contacts;
    [self.tableView reloadData];
}
#pragma mark ABPersonViewControllerDelegate

- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return YES;
}



- (IBAction)viewContactDetail:(UIButton*)sender {
    ABRecordID personId = (ABRecordID)sender.tag;
    ABPersonViewController *view = [[ABPersonViewController alloc] init];
    view.addressBook = self.addressBookRef;
    view.personViewDelegate = self;
    view.displayedPerson = ABAddressBookGetPersonWithRecordID(self.addressBookRef, personId);

    
    [self.navigationController pushViewController:view animated:YES];
}

// TODO: send contact object
- (IBAction)done:(id)sender
{

    
      [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)onClickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if ([searchText isEqualToString:@""]){
        self.filteredContacts = self.contacts;
    } else {
        self.searchBar.showsCancelButton = YES ;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.%@ contains[cd] %@ OR self.%@ contains[cd] %@", @"firstName", searchText, @"lastName", searchText];
        self.filteredContacts = [self.contacts filteredArrayUsingPredicate:predicate];
    }
    [self.tableView reloadData];

   
    
   
    NSLog(@"searchText %@",searchText);
    
    
    
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    // called only once
    [self.searchBar resignFirstResponder];
   // [self.searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
   // [self serviceToSearchContact:searchBar.text];
     [self.searchBar resignFirstResponder];
    [self.tableView reloadData];
   
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
     self.searchBar.text = @"";
    if ([ self.searchBar.text isEqualToString:@""]){
        self.filteredContacts = self.contacts;
    }
    self.searchBar.showsCancelButton = NO;
  [self.searchBar resignFirstResponder];
     [self.tableView reloadData];
}
/*
 - (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
 {
 self.textView.hidden = NO;
 
 if ( [text isEqualToString:@"\n"] ) { // Return key was pressed
 return NO;
 }
 
 // Capture "delete" key press when cell is empty
 if ([textView.text isEqualToString:@""] && [text isEqualToString:@""]){
 // If no contacts are selected, select the last contact
 self.selectedContactBubble = [self.contacts objectForKey:[self.contactKeys lastObject]];
 [self.selectedContactBubble select];
 }
 
 return YES;
 }
 
 - (void)textViewDidChange:(UITextView *)textView {
 if ([self.delegate respondsToSelector:@selector(contactPickerTextViewDidChange:)]){
 [self.delegate contactPickerTextViewDidChange:textView.text];
 }
 
 if ([textView.text isEqualToString:@""] && self.contacts.count == 0){
 self.placeholderLabel.hidden = NO;
 } else {
 self.placeholderLabel.hidden = YES;
 }
 }

 
 */

@end
