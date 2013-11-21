//
//  TableViewController.m
//  JumpTable
//
//  Created by Sandip Saha on 13/11/13.
//  Copyright (c) 2013 Sandip Saha. All rights reserved.
//

#import "TableViewController.h"
#import "Statements.h"

@interface TableViewController ()
@property (strong , nonatomic) NSMutableArray *statementArray;
@property (strong , nonatomic) NSMutableArray *alphabetArray;
@property (strong , nonatomic) UIView *statementAddingView;
@property (strong , nonatomic) UIView *translucentView;
@property (strong , nonatomic) UITextView *statementTextView;

@end

@implementation TableViewController
@synthesize statementArray;
@synthesize alphabetArray;
@synthesize statementAddingView;
@synthesize statementTextView;
@synthesize translucentView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    statementArray = [[NSMutableArray alloc]initWithCapacity:0];
    Statements *Object=[[Statements alloc]init];
    statementArray=[Object initializeStatements];       //will initialize array with statements
    
    // will sort the array in ascending order
    [statementArray sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [self createAlphabetArray];
}


-(void)createAlphabetArray
{	
    alphabetArray = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i=0; i< statementArray.count; i++)
    {
         //modifying the statement to first letter
        NSString *firstletter=[[statementArray objectAtIndex:i]substringToIndex:1];
        //checking the array if the modified statement already exists in array
        if (![alphabetArray containsObject:firstletter])
        {
            [alphabetArray addObject:firstletter];  //adding modified statement to array
        }
    }
    [alphabetArray sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)]; //sorting array in ascending array
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{

    return alphabetArray;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSIndexPath *indexpath;
    for (int i=0; i < alphabetArray.count; i++)
    {
        NSString *titleToSearch=[alphabetArray objectAtIndex:i]; //getting the sectiontitle from array
        if ([title isEqualToString:titleToSearch]) //checking if title from tableview and sectiontitle are same
        {
            indexpath=[NSIndexPath indexPathForRow:0 inSection:i];
            //scrollimg the table view to required section
            [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            break;
        }
        
    }
    return indexpath.section;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return alphabetArray.count;
}


-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title;
    for (int i=0; i<alphabetArray.count; i++)
    {
        if (section==i)
        {
            title= [alphabetArray objectAtIndex:i];
        }
    }
    return title;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   NSMutableArray* rowArray=[[NSMutableArray alloc]initWithCapacity:0];
    rowArray=[self getArrayOfRowsForSection:section];
    return rowArray.count;
}

-(NSMutableArray *)getArrayOfRowsForSection:(NSInteger)section
{
    NSString *rowTitle;
    NSString *sectionTitle;
    NSMutableArray *rowContainer=[[NSMutableArray alloc]initWithCapacity:0];
    
    for (int i=0; i<alphabetArray.count; i++)
    {
        if (section==i)   // check for right section
        {
            sectionTitle= [alphabetArray objectAtIndex:i];  //getting section title
            for (NSString *title in statementArray)
            {
                rowTitle=[title substringToIndex:1];  //modifying the statement to its first alphabet
                if ([rowTitle isEqualToString:sectionTitle])  //checking if modified statement is same as section title
                {
                    [rowContainer addObject:title];  //adding the row contents of a particular section in array
                }
            }
        }
    }
    return rowContainer;
}

-(NSString *)titleForRow:(NSIndexPath *)indexpath
{
    NSMutableArray* rowArray=[[NSMutableArray alloc]initWithCapacity:0];
    rowArray=[self getArrayOfRowsForSection:indexpath.section];
    NSString *titleToBeDisplayed=[rowArray objectAtIndex:indexpath.row];
    return titleToBeDisplayed;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.textLabel.text= [self titleForRow:indexPath]; //geting cell content
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping; //enabling WordWrapping of text in  cell
    cell.textLabel.numberOfLines = 0;

    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray* rowArray=[[NSMutableArray alloc]initWithCapacity:0];
    rowArray=[self getArrayOfRowsForSection:indexPath.section];
    
    NSString *cellText =[rowArray objectAtIndex:indexPath.row];  //getting row content for cell
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:12.0];  //use fontName and fontSize same as that you used
                                                                      //in storyboard
    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    
    //will calculate labelSize for each cell required according to content
    CGSize labelSize = [cellText boundingRectWithSize:constraintSize
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:cellFont}
                                         context:nil].size;
    /*
     In case you are using Xcode 4.0 use function
     CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
     */
    
      CGFloat newHeight;
    
    if (labelSize.height+20 > 40)   //providing a padding of 10 below and 10 above
    {
        newHeight= labelSize.height+20;
    }
    else
    {
        newHeight= 40;
    }
    
    return newHeight;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *statementToBeDeleted=nil;
    NSMutableArray* rowArray=[[NSMutableArray alloc]initWithCapacity:0];
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        rowArray=[self getArrayOfRowsForSection:indexPath.section]; //getting the row content for a section
        statementToBeDeleted=[rowArray objectAtIndex:indexPath.row]; //getting the object to be deleted
        
        //removing object from the original content array
        [statementArray removeObject:statementToBeDeleted];
        //deleting content from tableview
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        //again creating the alphabet array for section titles and index scroller
        [self createAlphabetArray];
        //reloading the tableview for updation
        [[self tableView]reloadData];
    }
}

-(IBAction)addNewStatement:(id)sender
{
    self.tableView.scrollEnabled=NO;  //disabling scroll of tableview
    
    //Creating a UIView on which whole functionality is to be implemented
    CGRect statementAdderFrame=CGRectMake(20, -480, 280, 440);
    statementAddingView=[[UIView alloc]initWithFrame:statementAdderFrame];
    statementAddingView.backgroundColor=[UIColor whiteColor];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    statementAddingView.frame=CGRectMake(20,20, 280, 440);
    
    translucentView=[[UIView alloc]initWithFrame:CGRectMake(0,0, 320, 480)];
    translucentView.backgroundColor=[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.7];
    [self.view.window addSubview:translucentView];
    [translucentView addSubview:statementAddingView];
    
    // creating a UILabel for Enter Statement label
    CGRect enterStatementLabelFrame= CGRectMake(20, 20, 240, 40);
    UILabel *enterStatementLabel=[[UILabel alloc]initWithFrame:enterStatementLabelFrame];
    enterStatementLabel.backgroundColor=[UIColor clearColor];
    [enterStatementLabel setFont:[UIFont fontWithName:@"Helvetica" size:16]];
    enterStatementLabel.text=@"Enter Statement:";
    enterStatementLabel.userInteractionEnabled=NO;
    enterStatementLabel.textAlignment=NSTextAlignmentLeft;
    [statementAddingView addSubview:enterStatementLabel];

    //cretaing a UITextView for entering statement to be added
    CGRect statementTextViewFrame=CGRectMake(20, 85, 240,130);
    statementTextView=[[UITextView alloc]initWithFrame:statementTextViewFrame];
    statementTextView.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    statementTextView.textColor=[UIColor blackColor];
    [statementTextView setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    [statementAddingView addSubview:statementTextView];
    [UIView commitAnimations];
    
    //creating add button for adding statements to tableview
    UIButton *addButton=[UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame=CGRectMake(20, 365, 70, 30);
    [addButton setTitle:@"Save" forState:UIControlStateNormal];
    addButton.tag=1;
    [addButton setBackgroundColor:[UIColor colorWithRed:85.0/255.0 green:255.0 blue:85.0/255.0 alpha:1.0]];
    [addButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //declaring the selector and target for the Save button
    [addButton addTarget:self action:@selector(statementAdded:) forControlEvents:UIControlEventTouchUpInside];
    [self.statementAddingView addSubview:addButton];
    
    //creating cancel button for cancelling whole operation
    UIButton *cancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame=CGRectMake(190, 365, 70, 30);
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    cancelButton.tag=2;
    [cancelButton setBackgroundColor:[UIColor colorWithRed:255.0 green:85.0/255.0 blue:85.0/255.0 alpha:1.0]];
    [cancelButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //declaring the selector and target for the Cancel button
    [cancelButton addTarget:self action:@selector(statementAdded:) forControlEvents:UIControlEventTouchUpInside];
    [self.statementAddingView addSubview:cancelButton];
    
    // a tap gesture for hiding the keyboard when entering of statement is over
    UITapGestureRecognizer *tapOnView=[[UITapGestureRecognizer alloc]init];
    [tapOnView addTarget:self action:@selector(hideKeyboard:)];  //declaring the selector for tap gesture
    [tapOnView setNumberOfTapsRequired:1];
    [tapOnView setNumberOfTouchesRequired:1];
    tapOnView.enabled=YES;
    [statementAddingView addGestureRecognizer:tapOnView];
}

-(void)hideKeyboard:(UITapGestureRecognizer *)sender
{
    //hide keybaord
    [statementTextView resignFirstResponder];
}


-(void)statementAdded:(UIButton *)sender
{
    if (sender.tag==1)  //checking if button was "Save" button
    {
        if ([statementTextView.text isEqualToString:@""] )  // if no statement is added to text view
        {
            UIAlertView *notAddedAlert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"No statement to add" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [notAddedAlert show];
        }
        else
        {
            //providing animations for release of the UIView
            [UIView animateWithDuration:0.4
                                  delay:0.0
                                options:UIViewAnimationOptionTransitionNone
                             animations:^{
                                 
                                 statementAddingView.frame=CGRectMake(20,-480, 280, 440);
                                 
                             }
                             completion:^(BOOL finished)  //completion handler for animation
             {
                 //adding codes which are to be implemented after animation is over
                 self.tableView.scrollEnabled=YES;  //enabling scroll of UIView
                 [translucentView removeFromSuperview];
                 
                 NSString *statementToAdd=self.statementTextView.text;
                 [statementArray  addObject:statementToAdd];  //adding statement to original array
                 [statementArray sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];  //sorting the array
                 [self createAlphabetArray];  // creating alphabet array for section title and index scroller
                 [self.tableView reloadData];  //reloading the tableview for updation
                
                 //code for scrolling of tableview to the position where statement is added
                 NSMutableArray *rowContainer=[[NSMutableArray alloc]initWithCapacity:0];
                 NSString *sectionString=[statementToAdd substringToIndex:1];
                 NSInteger sectionIndex=[alphabetArray indexOfObject:sectionString];
                 for (NSString *title in statementArray)
                 {
                    NSString *rowTitle=[title substringToIndex:1];
                     if ([rowTitle isEqualToString:sectionString])
                     {
                         
                         [rowContainer addObject:title];
                     }
                 }
                 NSInteger rowIndex=rowContainer.count-1;
                 [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                 
             }];
            
            [UIView commitAnimations];
        }
        
    }
    else  // if the button is "Cancel" button
    {
        // providing animations for release of UIView
        [UIView animateWithDuration:0.4
                              delay:0.0
                            options:UIViewAnimationOptionTransitionNone
                         animations:^{
                             
                             statementAddingView.frame=CGRectMake(20,-480, 280, 440);
                             
                         }
                         completion:^(BOOL finished) //completion handler for animation.
         {
             //adding codes which are to be executed after animation is oover
             self.tableView.scrollEnabled=YES;  // enabling scroll of tableview
             [translucentView removeFromSuperview];
         }];
        [UIView commitAnimations];
    }
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
