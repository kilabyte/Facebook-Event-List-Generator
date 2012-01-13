//
//  AppDelegate.m
//  GuestListGenerator
//
//  Created by Dave Sferra on 12-01-12.
//  Copyright (c) 2012 Blue Hawk Solutions inc. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate


#define API_TOKEN @"https://developers.facebook.com/tools/explorer/?method=GET&path=506989947"

@synthesize window = _window;
@synthesize responseData;

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}


-(IBAction)processData:(id)sender{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.responseData = [NSMutableData data];
    if ([defaults objectForKey:@"ID"] != nil) {
        inputBox.stringValue = [defaults objectForKey:@"ID"];
        authBox.stringValue = [defaults objectForKey:@"AUTH"];
    }

    NSString *s = [NSString stringWithFormat:@"https://graph.facebook.com/%@/attending?access_token=%@", inputBox.stringValue, authBox.stringValue];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:s]];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSString *i = inputBox.stringValue;
    NSString *a = authBox.stringValue;
    [defaults setObject:i forKey:@"ID"];
    [defaults setObject:a forKey:@"AUTH"];
    [defaults synchronize];
    
}

#pragma mark -
#pragma mark Fetch event data from facebook

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[connection release];
	self.responseData = nil;
}

#pragma mark -
#pragma mark Process event data
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [connection release];
	
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	self.responseData = nil;
	
	atendees = [(NSDictionary*)[responseString JSONValue] objectForKey:@"data"];
    
    NSString *path = @"~/Desktop/FacebookGuestList.txt";
    path = [path stringByExpandingTildeInPath];
    [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    NSLog(@"%@",path);
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:path];
    for (int i = 0; i < [atendees count]; i++) {
        NSDictionary* data = [atendees objectAtIndex:i];
        NSString *s = [NSString stringWithFormat:@"%@\n",[data objectForKey:@"name"]];
        [fileHandle writeData:[s dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [fileHandle closeFile];
    [atendees retain];
	[responseString release];
    [outputData reloadData];
}

    
#pragma mark Table Delegate/Methods
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return [atendees count];
}
-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    NSString* objVal = nil;
    NSDictionary* data = [atendees objectAtIndex:row];
    NSString* identifier = [tableColumn identifier];
    
    if ([identifier isEqualToString:@"Name"] == YES)
    {
        objVal = [data objectForKey:@"name"];
    }
    else if ([identifier isEqualToString:@"RSVP"] == YES)
    {
        objVal = [data objectForKey:@"rsvp_status"];
    }
    

    return objVal;
    
}

@end
