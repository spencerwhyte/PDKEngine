//
//  ModeSelectorController.m
//  PDKEngine
//
//  Created by Spencer Whyte on 10-12-06.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ModeSelectorController.h"


@implementation ModeSelectorController

-(void)join:(id)sender{
	BonjourPeerPicker * p = [[BonjourPeerPicker alloc] initWithStyle:UITableViewStylePlain];
	[self.navigationController pushViewController:p animated:YES];
		[Networking publishService];
}

-(void)host:(id)sender{
	
	[Networking publishService];
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
	return YES;
}


-(id)initWithPath:(NSString *)path{
	if(self = [super init]){
		[self.view setBackgroundColor:[UIColor whiteColor]];
		UIScrollView * sv= [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 480, 320)];
		[self.view addSubview:sv];
		[sv setContentSize:CGSizeMake(self.view.frame.size.width, 500) ];
		long offset=0;
		NSData *dataRead = [[NSData alloc] initWithContentsOfFile:path];
		int lengthOfName =0;
		[dataRead getBytes:&lengthOfName range:NSMakeRange(offset,4)];
		offset+=4;
		char *nameUTF8 = malloc(lengthOfName+1);
		[dataRead getBytes:nameUTF8 range:NSMakeRange(offset, lengthOfName)];
		nameUTF8[lengthOfName] = '\0';
		NSString* name = [[NSString alloc] initWithUTF8String:nameUTF8];
		free(nameUTF8);
		
		
		
		UILabel *mapLabel= [ [UILabel alloc ] initWithFrame:CGRectMake(150, 140, 180.0, 43.0) ];
		mapLabel.textAlignment =  UITextAlignmentCenter;
		mapLabel.textColor = [UIColor blackColor];
		mapLabel.backgroundColor = [UIColor whiteColor];
		mapLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(12.0)];
		mapLabel.text = name;
		[sv addSubview:mapLabel];
		[mapLabel release]; 		offset+=lengthOfName;
		int lengthOfDescription = 0;
		[dataRead getBytes:&lengthOfDescription range:NSMakeRange(offset,4)];
		offset+=4;
		char *descriptionUTF8 = malloc(lengthOfDescription+1);
		[dataRead getBytes:descriptionUTF8 range: NSMakeRange(offset, lengthOfDescription)];
		descriptionUTF8[lengthOfDescription] = '\0';
		NSString * description = [[NSString alloc] initWithUTF8String:descriptionUTF8];
		free(descriptionUTF8);
		//	[descriptionTextField setStringValue:description];
		offset+=lengthOfDescription;
		int descriptiveImageLength;
		[dataRead getBytes:&descriptiveImageLength range: NSMakeRange(offset, 4)];
		offset+=4;
		
		
		mapLabel= [ [UILabel alloc ] initWithFrame:CGRectMake(100, 165, 280.0, 43.0) ];
		mapLabel.lineBreakMode=UILineBreakModeWordWrap;
		mapLabel.numberOfLines=0;
		mapLabel.textAlignment =  UITextAlignmentCenter;
		mapLabel.textColor = [UIColor blackColor];
		mapLabel.backgroundColor = [UIColor whiteColor];
		mapLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(12.0)];
		mapLabel.text = description;
		[sv addSubview:mapLabel];
		[mapLabel release];
		
		UIButton *joinButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect]retain];
		[joinButton setTitle:@"Join" forState:UIControlStateNormal];
		[joinButton addTarget:self action:@selector(join:) forControlEvents:UIControlEventTouchUpInside];
		joinButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		joinButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		[joinButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		joinButton.frame = CGRectMake(130.0, 200.0, 100, 40);
		[sv addSubview:joinButton];
		[joinButton release];
		
		joinButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		[joinButton setTitle:@"Host" forState:UIControlStateNormal];
		[joinButton addTarget:self action:@selector(host:) forControlEvents:UIControlEventTouchUpInside];
		joinButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		joinButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		[joinButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		joinButton.frame = CGRectMake(250, 200, 100, 40);
		[sv addSubview:joinButton];
		[joinButton release];
		
		NSData *tiff =[dataRead subdataWithRange:NSMakeRange(offset, descriptiveImageLength)];
		UIImage * a=[[UIImage alloc] initWithData:tiff];
		imageView = [[UIImageView alloc] initWithImage:a];
		[a release];
		imageView.frame = CGRectMake(176, 10, 128, 128);
		[sv addSubview:imageView];
		[imageView release];
		[dataRead release];
		[description release];
		[name release];
    
         pathToMap = path;
        gameState = 1;
        
        
      //  [Networking publishService];
 
		
	}
	return self;
}


+(void)loadDefaultImage{
	
	defaultImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"defaultImage.png"]];
	defaultImageView.frame = CGRectMake(176, 10, 128, 128);
}

-(void)dealloc{
	NSLog(@"called");
	[super dealloc];	
}
@end
