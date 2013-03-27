//
//  CFIViewController.h
//  CFIViewController
//
//  Created by Robert Widmann on 3/27/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import <Foundation/Foundation.h>


/*!
 * NSViewController is a strange little class.  A lot of it revolves around hacks to eliminate some
 * nasty NSNib retain cycles, and the other half of it is making Core Data work sanely with 
 * NSDocument.  The class is ultimately just a Nib loader with some fancy memory-management
 * built-in.  All "properties" are atomically assigned and gotten in that class, so we will 
 * atomically assign and get them in this remake.
 *
 * This class aims to be compatible with 10.3 (as weird as that sounds), and as such,
 * avoids a lot of the weird hacks present in CD from 10.4, and adds missing functionality which 
 * should have been present in the class with 10.5, namely -viewDidLoad
 */
@interface CFIViewController : NSResponder <NSCoding> {
@private
    NSString *_nibName;
    NSBundle *_nibBundle;
    id _representedObject;
    NSString *_title;
    IBOutlet NSView *view;
    NSArray *_topLevelObjects;
    NSPointerArray *_editors;
//    id _autounbinder;  A reference to the internal NSAutoUnBinder.  No need for it now, as we
						//Aren't going to touch Core Data or NSDocument with a ten-foot pole
//    NSString *_designNibBundleIdentifier;
}

/*!
 * The designated initializer. The specified nib should typically have the class of the file's owner 
 * set to CFIViewController, or a subclass of yours, with the "view" outlet connected to a view. If 
 * you pass in a nil nib name then -nibName will return nil and -loadView will throw an exception; 
 * you most likely must also invoke -setView: before -view is invoked, or override -loadView. If you
 * pass in a nil bundle then -nibBundle will return nil and -loadView will interpret it using the 
 * same rules as -[NSNib initWithNibNamed:bundle:].
 */
- (id)initWithNibName:(NSString*)nibName bundle:(NSBundle *)nibBundleOrNil;

/* "The object whose value is being presented in the view. The default implementation of 
 * -setRepresentedObject: doesn't copy the passed-in object, it retains it. (In another words, 
 * "representedObject" is a to-one relationship, not an attribute.) This class is key-value coding 
 * and key-value observing compliant for "representedObject" so when you use it as the file's owner 
 * of a view's nib you can bind controls to the file's owner using key paths that start with 
 * "representedObject."
 */
- (void)setRepresentedObject:(id)representedObject;
- (id)representedObject;

/* The localized title of the view.
 *
 * "This property is here because so many anticipated uses of this class will involve letting the 
 * user choose among multiple named views using a pulldown menu or something like that."
 * - The NSViewController documentation; *Slow Clap*
 */
- (void)setTitle:(NSString *)title;
- (NSString *)title;

/*!
 * Return the view. The default implementation of this method first invokes [self loadView] if the 
 * view hasn't been set yet.  Please don't reference self.view directly in this thing, or you will
 * trigger a recursion.
 */
- (NSView *)view;

/*!
 * Loads a view with the given nib name and bundle.  If this method does not happen to find a view, 
 * and it's subclass does not create one and call -setView:, this method will assume an internal 
 * failure and throw an NSInternalInconsistencyException.  Call through to super if you want to 
 * override it.
 */
- (void)loadView;

/*!
 * Benign getters for the specified nib bundle and nib name.
 */
- (NSString *)nibName;
- (NSBundle *)nibBundle;

/*!
 * "Set the view. You can invoke this method immediately after creating the object to specify a view 
 * that's created in a different manner than what -view's default implementation would do."
 */
- (void)setView:(NSView *)view;

@end

/*!
 * Missing something, iOS people?  Because the AppKit guys never gave us an NSNavigationController, 
 * these methods now don't have an -animated field.  Did anyone even use that anyhow?
 *
 * I also can't give you appearance methods, as they'd be worthless anyhow (again with the not
 * having an NSNavigationController!)
 */
@interface CFIViewController (CFIExtendedViewController)

- (void)viewDidLoad;

@end

/*!
 * The following methods are localized either to the NSDocument editing schema, or to Core Data, and
 * are intensely fragile and private.  I've chosen to leave them unimplemented.  Any editing needs 
 * to be manually saved to a context, or apply the workaround to NSTextViews where you resign its 
 * responder, save, them re-apply its first responder.
 */
@interface CFIViewController (CFIUnimplemented)

- (void)commitEditingWithDelegate:(id)delegate didCommitSelector:(SEL)didCommitSelector contextInfo:(void *)contextInfo;
- (BOOL)commitEditing;
- (void)discardEditing;

@end
