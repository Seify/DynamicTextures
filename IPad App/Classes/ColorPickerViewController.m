    //
//  ColorPickerViewController.m
//  DynamicTextures
//
//  Created by naceka on 08.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ColorPickerViewController.h"
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>

@implementation ColorPickerViewController

@synthesize delegate;

- (UIButton *)colorButton
{
    if (!colorButton) {
        colorButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [colorButton retain];        
    }
    return colorButton;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	//[self setContentSizeForViewInPopover:CGSizeMake(270.0, 340.0)];
	[self setContentSizeForViewInPopover:CGSizeMake(270.0, 300.0)];
	
	/*
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documents = [paths objectAtIndex:0];
	NSString *coderPath = [documents stringByAppendingPathComponent:@"ColorPickerSettings"];
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:coderPath]) {
		// we can load from a coder
		picker = [[NSKeyedUnarchiver unarchiveObjectWithFile:coderPath] retain];
	} else {
		picker = [[ANColorPicker alloc] initWithFrame:CGRectMake(0, 0, 231, 190)];
	}
	
	[picker setDelegate:self];
		
	picker.center = CGPointMake((self.view.frame.size.width / 2), (self.view.frame.size.height / 2) - 70);
	[self.view addSubview:picker];
	
	CGRect frm = picker.frame;
	frm.origin.y += frm.size.height + 20;
	frm.size.height = 60;
		
	colorView = [[UIView alloc] initWithFrame:frm];
	[colorView setBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:[colorView autorelease]];
	
	// set the initial color
	[colorView setBackgroundColor:[picker color]];
	[picker setDrawsBrightnessChanger:NO];
	*/
	
	UIColor* tempColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"woodenBGWithPictures.png"]];
	self.view.backgroundColor = tempColor;
	[tempColor release]; 
	
	[self initPicker];
	
    [super viewDidLoad];
}

-(void) initPicker
{
	if (picker == nil)
	{
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documents = [paths objectAtIndex:0];
		NSString *coderPath = [documents stringByAppendingPathComponent:@"ColorPickerSettings"];
		
		if ([[NSFileManager defaultManager] fileExistsAtPath:coderPath]) {
			// we can load from a coder
			picker = [[NSKeyedUnarchiver unarchiveObjectWithFile:coderPath] retain];
		} else {
			picker = [[ANColorPicker alloc] initWithFrame:CGRectMake(0, 0, 231, 190)];
		}
		
		[picker setDelegate:self];
		
		picker.center = CGPointMake((self.view.frame.size.width / 2), (self.view.frame.size.height / 2) - 70);
		[self.view addSubview:picker];
		
		CGRect frm = picker.frame;
		frm.origin.y += frm.size.height + 20;
		frm.size.height = 60;
/*		
		colorView = [[UIView alloc] initWithFrame:frm];
		[colorView setBackgroundColor:[UIColor clearColor]];
		
		colorView.layer.masksToBounds = YES;
		colorView.layer.borderColor = [UIColor colorWithRed:0.7422 green:0.7383 blue:0.7383 alpha:1.0].CGColor;
		colorView.layer.borderWidth = 2.0;
		[colorView.layer setCornerRadius:20.0];
		
		[self.view addSubview:[colorView autorelease]];
		
		// set the initial color
		[colorView setBackgroundColor:[picker color]];
*/
        
		[self.colorButton setBackgroundColor:[UIColor clearColor]];
        self.colorButton.frame = frm;	

		self.colorButton.layer.masksToBounds = YES;
		self.colorButton.layer.borderColor = [UIColor colorWithRed:0.7422 green:0.7383 blue:0.7383 alpha:1.0].CGColor;
		self.colorButton.layer.borderWidth = 2.0;
		[self.colorButton.layer setCornerRadius:20.0];
        
        [self.colorButton setTitleColor:[UIColor colorWithRed:0.9 
                                                   green:0.9 
                                                    blue:0.8 
                                                   alpha:1.0]
                          forState:UIControlStateNormal];
        self.colorButton.titleLabel.font = [UIFont systemFontOfSize:30.0];
        [self.colorButton setTitle:NSLocalizedString(@"CHOOSE_COLLOR_BUTTON_TEXT", nil)
                     forState:UIControlStateNormal];
		
		
		// set the initial color
		[self.colorButton setBackgroundColor:[picker color]];
        
        if (picker.delegate) {
            [self.colorButton addTarget:picker.delegate action:@selector(newColorButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
//        [self.view addSubview:[self.colorButton autorelease]];
        [self.view addSubview:self.colorButton];

        
		[picker setDrawsBrightnessChanger:NO];
	}
}

-(void) setColorPickerDelegate:(id) ctrl
{
	[picker setDelegate:ctrl];
}

- (void) newColorButtonPressed:(UIButton *)sender
{

/*    
    if (picker.delegate != self) {
//        GLfloat r, g, b, a;
//        [colorButton.backgroundColor getRed:&r green:&g blue:&b alpha:&a];
        [picker.delegate newColorButtonPressed:sender];
*/
    [self.delegate newColorButtonPressed:sender];
}

- (void)pickColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
	[self initPicker];
	
	// TODO: выбирать цвет
	//[picker setCirclePicker:CGPointMake(352, 200)];
	
	UIColor * newColor = [UIColor colorWithRed:red green:green blue:blue alpha:kPaintingViewAlpha];
//	[colorView setBackgroundColor:newColor];
    [self.colorButton setBackgroundColor:newColor];
}

- (void)saveState {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documents = [paths objectAtIndex:0];
	NSString *coderPath = [documents stringByAppendingPathComponent:@"ColorPickerSettings"];
	[NSKeyedArchiver archiveRootObject:picker toFile:coderPath];
}

- (void)colorChangedWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
	// alpha соответствует прозрачности PaintingView (только для режима акварели)
	UIColor * newColor = [UIColor colorWithRed:red green:green blue:blue alpha:kPaintingViewAlpha];
//	[colorView setBackgroundColor:newColor];
    [self.colorButton setBackgroundColor:newColor];
    
#define K 0.3
#define globalred 0.7 //компонента глобального освещения
#define globalgreen 0.7
#define globalblue 0.8
    
    int K2 = (3.0 - (red + green + blue)) / 3.0;
    
    [self.colorButton setTitleColor:[UIColor colorWithRed:K*green+ K2*globalred 
                                               green:K*blue + K2*globalgreen
                                                blue:K*red + K2*globalblue 
                                               alpha:1.0]
                      forState:UIControlStateNormal];


}

- (IBAction)restoreColorClicked:(id)sender
{
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
//    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	
	[picker removeFromSuperview];
	[picker release];
//	
////	[colorView removeFromSuperview];
////    [colorButton removeFromSuperview];
    if (colorButton) [colorButton release];
//    
//	//[colorView release];
//
    [super dealloc];
}


@end
