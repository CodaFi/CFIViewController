//
//  CFIAppDelegate.m
//  CFIViewController
//
//  Created by Robert Widmann on 3/27/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "CFIAppDelegate.h"

@implementation CFIAppDelegate

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	viewController = [[CFIViewController alloc]initWithNibName:@"EmptyView" bundle:nil];
	
	[self.window.contentView addSubview:viewController.view];
	// Insert code here to initialize your application
}

- (IBAction)action:(id)sender {
	[viewController.view removeFromSuperview];
	[viewController release];
	viewController = nil;
}

@end
