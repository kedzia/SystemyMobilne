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
    
    [self checkIfAlbumExists:albumName andUploadPhotos:photosArray];
}



@end
