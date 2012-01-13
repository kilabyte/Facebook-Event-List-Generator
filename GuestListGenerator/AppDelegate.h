//
//  AppDelegate.h
//  GuestListGenerator
//
//  Created by Dave Sferra on 12-01-12.
//  Copyright (c) 2012 Blue Hawk Solutions inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JSON.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSTableViewDelegate, NSTableViewDataSource>{
    IBOutlet NSTextField *inputBox;
    IBOutlet NSTextField *authBox;
    IBOutlet NSButton *sendButton;
    IBOutlet NSTableView *outputData;
    NSString *_formattedUrl;
    NSMutableData* responseData;
    NSArray* atendees;
}

@property (retain, nonatomic) NSMutableData* responseData;
@property (assign) IBOutlet NSWindow *window;


@end
