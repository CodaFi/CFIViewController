//
//  CFIViewController.m
//  CFIViewController
//
//  Created by Robert Widmann on 3/27/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "CFIViewController.h"

@implementation CFIViewController

#pragma mark - Lifecycle

- (id)init {
	self = [self initWithNibName:nil bundle:nil];
	
	return self;
}

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundleOrNil {
	self = [super init];
	
	_nibName = [nibName copy];
	_nibBundle = [nibBundleOrNil retain];
	
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	
	_nibName = [[aDecoder decodeObjectForKey:@"CFINibName"]retain];
	_title = [[aDecoder decodeObjectForKey:@"CFITitle"]retain];
	self->view = [[aDecoder decodeObjectForKey:@"CFINSView"]retain];
	_nibBundle = [[aDecoder decodeObjectForKey:@"CFINibBundleIdentifier"]retain];
	
	return self;
}

- (void)dealloc {
	[_editors release];
	[_topLevelObjects release];
	[view release];
	[_title release];
	[_representedObject release];
	[_nibBundle release];
	[_nibName release];
	
	[super dealloc];
}



- (void)setView:(NSView *)newView {
	if (self->view == newView) return;
	
	self->view = [newView retain];
}

- (NSView*)_view {
	return [[self.view retain]autorelease];
}

- (NSView*)view {
	if (self->view == nil) {
		[self loadView];
	}
	return [[self->view retain]autorelease];
}

- (void)setRepresentedObject:(id)representedObject {
	if (_representedObject == representedObject) return;
	
	_representedObject = [representedObject retain];
}

- (id)representedObject {
	return [[_representedObject retain]autorelease];
}

- (void)loadView {
	NSArray *topLevelObjects = nil;
	
	NSNib *loadedNib = [[[NSNib alloc]initWithNibNamed:self.nibName bundle:self.nibBundle]autorelease];
	if (loadedNib == nil) {
		[NSException raise:NSInternalInconsistencyException format:@"-[%@ %@]", NSStringFromClass(self.class), NSStringFromSelector(_cmd)];
		return;
	}
	
	BOOL loaded = NO;
	
	
#if MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_8
	loaded = [loadedNib instantiateWithOwner:self topLevelObjects:&topLevelObjects];
#else 
	loaded = [loadedNib instantiateNibWithOwner:self topLevelObjects:&topLevelObjects];
#endif
	
	if (loaded) {
		[self _setTopLevelObjects:topLevelObjects];
		[topLevelObjects makeObjectsPerformSelector:@selector(release)];
	} else {
		[NSException raise:NSInternalInconsistencyException format:@"CFIViewController could not instantiate the %@ nib.", self.nibName];
	}
	
	if (self.view != nil) {
		[self viewDidLoad];
		return;
	}
	
	[NSException raise:NSInternalInconsistencyException format:@"-[%@ %@]", NSStringFromClass(self.class), NSStringFromSelector(_cmd)];
}


/*!
 * Possibly the most interesting method in this bucket.  When a NIB is de-frosted, all its objects
 * are owned by NSCoder, which is why we make them weak.  But if you're the controller, then you 
 * really don't want NSCoder keeping a reference to what is rightfully yours.  NSViewController
 * solves this by doing a sneaky shallow-copy of all the objects in the array, then releases them
 * out from under NSCoder.
 */
- (void)_setTopLevelObjects:(NSArray*)newTopLevelObjects {
	if (_topLevelObjects == newTopLevelObjects) return;
	
	_topLevelObjects = [newTopLevelObjects copy];
}

- (NSString*)nibName {
	return [[_nibName retain]autorelease];
}

- (NSBundle *)nibBundle {
	return [[_nibBundle retain]autorelease];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	if (_nibName != nil) {
		[aCoder encodeObject:_nibName forKey:@"CFINibName"];
	}
	if (_title != nil) {
		[aCoder encodeObject:_title forKey:@"CFITitle"];
	}
	if (_nibName == nil && [self _view] != nil) {
		[aCoder encodeObject:[self _view] forKey:@"CFINSView"];
	}
	if (_nibBundle == [NSBundle mainBundle]) {
		return;
	}
	if ([_nibBundle bundleIdentifier] == nil) {
		return;
	} else {
		[aCoder encodeObject:[_nibBundle bundleIdentifier] forKey:@"CFINibBundleIdentifier"];
	}
	
}

- (void)setTitle:(NSString *)title {
	if (_title == title) return;
	
	_title = [title copy];
}

- (NSString*)title {
	return [[_title retain]autorelease];
}

@end

@implementation CFIViewController (CFIExtendedViewController)

- (void)viewDidLoad { }

@end

@implementation CFIViewController (CFIUnimplemented)


/******************************************UNSAFE**************************************************/
- (void)commitEditingWithDelegate:(id)delegate didCommitSelector:(SEL)didCommitSelector contextInfo:(void *)contextInfo {
	//Literally, this is what Apple was doing to get Core Data saving to work with NSViewController:
	
	//	NSInvocation *invoc = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:didCommitSelector]];
	//	[invoc setTarget:self];
	//	[invoc setSelector:didCommitSelector];
	//	[invoc setArgument:&delegate atIndex:2];
	//	[invoc setArgument:&contextInfo atIndex:4];
	//	if ([self _topEditor]) {
	//		[invoc retain];
	//		[[self _topEditor] commitEditingWithDelegate:delegate didCommitSelector:@selector(_editor:didCommit:withOriginalDelegateInvocation:) contextInfo:contextInfo];
	//	}
}

- (void)objectDidBeginEditing:(id)editor {
	//NSPointerArray: NSArray's yokel cousin.  It allows you to hold references to NULL pointers,
	//and allows you to specify the holding pattern of its member elements.  But, it's
	//kind of janky to keep around an array like that, so it's gone.  Here's what Apple does to get
	//Core Data's weird editor context workers pinned into a collection:
	
	//	if (_editors == nil) {
	//		_editors = [[NSPointerArray alloc]initWithOptions:NSPointerFunctionsOpaqueMemory];
	//	}
	//	[_editors addPointer:editor];
}

- (void)objectDidEndEditing:(id)editor {
	//Does some very simpple search and destroy of *hopefully* the last editor.  of course, this
	//is quite a dangerous implementation, as you could just remove NULL, and not that darn Core
	//Data object you were hoping for.  Oh well:
	
	//	NSUInteger testingIndex = (_editors.count);
	//	if (testingIndex == 0) {
	//		return;
	//	}
	//
	//	if ([_editors pointerAtIndex:(testingIndex - 1)] != editor) {
	//		return;
	//	}
	//
	//	[_editors removePointerAtIndex:(testingIndex - 1)];
}

- (id)_topEditor {
	//This would hopefuilly return the last editor from the pointer array
	
	//	NSUInteger testingIndex = (_editors.count - 1);
	
	return nil;
}

- (BOOL)commitEditing {
	//Ideally, this should tell the _topEdit to -commitEditing
	
	return YES;
}

- (void)discardEditing {
	//I don't even want to know what they did here.  Something about looping through every editor
	// and calling -discardEditing.
}

/******************************************END OF UNSAFE*******************************************/

@end
