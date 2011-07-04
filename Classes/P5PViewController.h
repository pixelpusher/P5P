//
//  P5PViewController.h
//  P5P
//
//  Created by CNPP on 10.2.2011.
//  Copyright 2011 Beat Raess. All rights reserved.
//

#import <UIKit/UIKit.h>

// declarations
@class SketchesViewController;
@class SketchViewController;
@class CollectionsViewController;
@class Collection;
@class Sketch;
@class PreloaderView;
@class NoteView;


/*
* Delegate.
*/
@protocol P5PDelegate <NSObject>
- (void)navigateToRoot;
- (void)navigateToSketch:(Sketch*)sketch;
- (void)toggleCollections;
- (void)openCollections;
- (void)closeCollections;
- (void)preloaded;
@end

/**
* P5PViewController.
*/
@interface P5PViewController : UIViewController <P5PDelegate> {

	// view controllers
	SketchesViewController *sketchesViewController;
	SketchViewController *sketchViewController;
	CollectionsViewController *collectionsViewController;
	
	// gestures
	UITapGestureRecognizer *gestureModeCollectionsTap;
	
	// modes
	BOOL modeCollections;
	
	// Preloader
	PreloaderView *preloader;
	
	// note
	NoteView *note;

}

// Properties
@property (nonatomic, retain) SketchesViewController *sketchesViewController;
@property (nonatomic, retain) SketchViewController *sketchViewController;
@property (nonatomic, retain) CollectionsViewController *collectionsViewController;
@property BOOL modeCollections;

@end
