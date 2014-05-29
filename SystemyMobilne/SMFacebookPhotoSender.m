//
//  SMFacebookPhotoSender.m
//  SystemyMobilne
//
//  Created by Adam on 24.05.2014.
//  Copyright (c) 2014 Adam. All rights reserved.
//

#import "SMFacebookPhotoSender.h"
@interface SMFacebookPhotoSender()

@end
@implementation SMFacebookPhotoSender

-(void) createAlbum:(NSString*)albumName andUploadPhotos:(NSArray*) photosArray
{

    /// retrieve create album, retrieve informations about it and add photo with text
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            albumName,@"name",
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
                                  [self postPhotosToFacebook:photosArray withAlbumID:[result objectForKey:@"id"]];
                              }
                              else
                              {
                                  NSLog(@"creating album error: %@", error.localizedDescription);
                              }
                          }];
    
}

-(void)checkIfAlbumExists:(NSString*)name andUploadPhotos:(NSArray*) photosArray
{
    NSDictionary *params = [NSDictionary dictionaryWithObject:name forKey:name];
    
    
    [FBRequestConnection startWithGraphPath:@"/me/albums" parameters:params HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
     {
         BOOL found = NO;
         NSArray *data = [result valueForKey:@"data"];
         for(NSDictionary *album in data)
         {
             if([name isEqualToString:[album valueForKey:@"name"]])
             {
                 NSLog(@"found match");
                 [self postPhotosToFacebook:photosArray withAlbumID:[album valueForKeyPath:@"id"]];
                 found = YES;
                 break;
             }
         }
         if(found == NO)
         {
             [self createAlbum:name andUploadPhotos:photosArray];
         }
         
     }];
}

- (void)postPhotosToFacebook:(NSArray *)photos withAlbumID:(NSString *)albumID {
    
    UIImage *image = [photos lastObject];
    
    NSString *graphPath = [NSString stringWithFormat:@"%@/photos",albumID];
    
    NSLog(@"graphPath = %@",graphPath);
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                image,@"picture",
                                nil];
    
    FBRequest *request = [FBRequest requestWithGraphPath:graphPath
                                              parameters:parameters
                                              HTTPMethod:@"POST"];
    
    FBRequestConnection *connection = [[FBRequestConnection alloc] init];
    
    [connection addRequest:request
         completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
             
             if (!error) {
                 
                 NSLog(@"Photo uploaded successfuly! %@",result);
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Photo Uploaded successfuly" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alertView show];
                 
             } else {
                 
                 NSLog(@"Photo uploaded failed :( %@",error.userInfo);
             }
             
         }];
    
    [connection start];
    
}


-(void)LogInAndUploadPhotos:(NSArray*)photosArray toAlbum:(NSString*)albumName
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
        [session openWithBehavior:FBSessionLoginBehaviorForcingWebView
                completionHandler:^(FBSession *session,
                                    FBSessionState status,
                                    NSError *error) {
                    
                    if(error == nil)
                    {
                        NSLog(@"login successful");
                        // Respond to session state changes,
                        // ex: updating the view
                    }
                    else
                    {
                        NSLog(@"login unsuccessful");
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
                                   [self checkIfAlbumExists:albumName andUploadPhotos:photosArray];
                               }
                               else
                               {
                                   NSLog(@"ERROR PERMISSION :%@",error.localizedDescription);
                               }
                           }];
                      }
                      else
                      {
                          // Permissions are present
                          // We can request the user information
                          [self checkIfAlbumExists:albumName andUploadPhotos:photosArray];
                      }
                  }
                  
              }];
}





@end
