//
//  CFIAppDelegate.h
//  CFIViewController
//
//  Created by Robert Widmann on 3/27/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CFIViewController.h"

@interface CFIAppDelegate : NSObject <NSApplicationDelegate> {
	CFIViewController *viewController;
}

@property (assign) IBOutlet NSWindow *window;

- (IBAction)action:(id)sender;

@property (nonatomic, copy) NSString *string;

@end
