//
//  SMFacebookPhotoSender.m
//  SystemyMobilne
//
//  Created by Adam on 24.05.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import "SMFacebookPhotoSender.h"
#import "SMSheetVC.h"
@interface SMFacebookPhotoSender() <SMSheetVCProtocol>
@property (strong, nonatomic) NSArray *photosArray;
@property (strong, nonatomic) NSString *albumName;
@property (strong, nonatomic) SMSheetVC *sheet;
@end
@implementation SMFacebookPhotoSender

-(void) createAlbum:(NSString*)albumName andUploadPhotos:(NSArray*) photosArray privacy:(NSString*) paramPrivacy
{

    /// retrieve create album, retrieve informations about it and add photo with text
     NSString *privacy = [NSString stringWithFormat:@"{'value' :'%@'}",paramPrivacy];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            albumName,@"name",
                            privacy, @"privacy",
                            nil
                            ];
    // make the API call
    [FBRequestConnection startWithGraphPath:@"/me/albums"
                                 parameters:params
                                 HTTPMethod:@"POST"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                              // handle the result
                              if(error == nil)
                              {
                                  [self postPhotosToFacebook:photosArray withAlbumID:[result objectForKey:@"id"] privacy:@"EVERYONE"];
                              }
                              else
                              {
                                  NSLog(@"creating album error: %@", error.localizedDescription);
                              }
                          }];
    
}

-(void)checkIfAlbumExists:(NSString*)name andUploadPhotos:(NSArray*) photosArray withPrivacy:(NSString *)paramPrivacy;
{
    //NSDictionary *params = [NSDictionary dictionaryWithObject:name forKey:name];
    

    [FBRequestConnection startWithGraphPath:@"/me/albums?fields=name" completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
     {
         if(!error)
         {
             BOOL found = NO;
             NSArray *data = [result valueForKey:@"data"];
             for(NSDictionary *album in data)
             {
                 if([name isEqualToString:[album valueForKey:@"name"]])
                 {
                     NSLog(@"found match");
                     [self postPhotosToFacebook:photosArray withAlbumID:[album valueForKeyPath:@"id"] privacy:paramPrivacy];
                     found = YES;
                     break;
                 }
             }
             if(found == NO)
             {
                 [self createAlbum:name andUploadPhotos:photosArray privacy:paramPrivacy];
             }
         }
         else
         {
             NSLog(@"error getting albums data%@",error.localizedDescription);
             [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
             
         }
     }];
}

- (void)postPhotosToFacebook:(NSArray *)photos withAlbumID:(NSString *)albumID privacy:(NSString*)privacyVal  {
    
    SMFacebookPhoto *fbPhoto = [photos lastObject];
    
    UIImage *image = fbPhoto.image;
    NSString *description = fbPhoto.description;
    NSString *graphPath = [NSString stringWithFormat:@"%@/photos",albumID];
    
    NSLog(@"graphPath = %@",graphPath);

    NSString *privacy = [NSString stringWithFormat:@"{'value' :'%@'}",privacyVal];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                image,@"picture",
                                description,@"message",
                                privacy,@"privacy",
                                nil];
    
    FBRequest *request = [FBRequest requestWithGraphPath:graphPath
                                              parameters:parameters
                                              HTTPMethod:@"POST"];
    
    FBRequestConnection *connection = [[FBRequestConnection alloc] init];
    
    [connection addRequest:request
         completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
             
             if (!error)
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Photo uploaded successfuly" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alertView show];
                 [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
             }
             else
             {
                 NSLog(@"Photo uploaded failed :( %@",error.userInfo);
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Couldn't upload photo" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alertView show];
                 [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
             }
          }];
    
    [connection start];
    
}
-(void)LogInAndUploadPhotos:(NSArray*)photosArray toAlbum:(NSString*)albumName
{
    NSAssert(self.delegate, @"delegate not set");
    self.photosArray = photosArray;
    self.albumName = albumName;
    if(!self.sheet)
    {
        self.sheet = [[SMSheetVC alloc] init];
        self.sheet.delegate = self;
    }
    [self.delegate presentViewController:self.sheet animated:YES completion:nil];
}


-(void)LogInAndUploadPhotos:(NSArray*)photosArray toAlbum:(NSString*)albumName withPrivacy:(NSString*)paramPrivacy
{
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended)
    {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        //[FBSession.activeSession closeAndClearTokenInformation];
        
    }
    else
    {
        // Initialize a session object
        FBSession *session = [[FBSession alloc] initWithPermissions:@[@"publish_actions", @"user_photos"]];
        
        // Set the active session
        [FBSession setActiveSession:session];
        // Open the session
        [session openWithBehavior:FBSessionLoginBehaviorWithFallbackToWebView
                completionHandler:^(FBSession *session,
                                    FBSessionState status,
                                    NSError *error) {
                    
                    if(error == nil)
                    {
                        // Respond to session state changes,
                        // ex: updating the view
                    }
                    else
                    {
                        NSLog(@"login unsuccessful");
                        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                    }
                    
                }];
    }
    
    
    //    CHECKING FOR PARMISSION COPY_PASTE FROM FB SDK TUTORIAL
    NSArray *permissionsNeeded = @[@"publish_actions", @"user_photos"];
    
    // Request the permissions the user currently has
    [FBRequestConnection startWithGraphPath:@"/me/permissions"
              completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                  if (!error){
                      // These are the current permissions the user has:
                      NSDictionary *currentPermissions= [(NSArray *)[result data] objectAtIndex:0];
                      
                      // We will store here the missing permissions that we will have to request
                      NSMutableArray *requestPermissions = [[NSMutableArray alloc] initWithArray:@[]];
                      
                      // Check if all the permissions we need are present in the user's current permissions
                      // If they are not present add them to the permissions to be requested
                      for (NSString *permission in permissionsNeeded){
                          if (![currentPermissions objectForKey:permission]){
                              [requestPermissions addObject:permission];
                          }
                      }
                      
                      // If we have permissions to request
                      if ([requestPermissions count] > 0)
                      {
                          // Ask for the missing permissions
                          [FBSession.activeSession
                           requestNewReadPermissions:requestPermissions
                           completionHandler:^(FBSession *session, NSError *error) {
                               if (!error) {
                                   // Permission granted
                                   NSLog(@"new permissions %@", [FBSession.activeSession permissions]);
                                   // We can request the user information
                                   [self checkIfAlbumExists:albumName andUploadPhotos:photosArray withPrivacy:paramPrivacy];
                               }
                               else
                               {
                                   NSLog(@"ERROR PERMISSION :%@",error.localizedDescription);
                                   [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
                               }
                           }];
                      }
                      else
                      {
                          // Permissions are present
                          // We can request the user information
                          [self checkIfAlbumExists:albumName andUploadPhotos:photosArray withPrivacy:paramPrivacy];
                      }
                  }
                  
              }];
}

#pragma mark SMSheetVC protocol

- (void)choosenPrivacy:(NSString *)paramPrivacy
{
    NSAssert(self.delegate, @"delegate not set");
    [self.sheet dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self LogInAndUploadPhotos:self.photosArray toAlbum:self.albumName withPrivacy:paramPrivacy];
}



@end
