//
//  ViewController.m
//  iPhoneImages
//
//  Created by Daniel Grosman on 2017-11-18.
//  Copyright © 2017 Daniel Grosman. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *appleImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // creates a new NSURL object with the string of the image to be downloaded
    NSURL *url = [NSURL URLWithString:@"https://i.imgur.com/2vQtZBb.png"];
    // defines the behavior and policies to use when making a request with an NSURLSession object (using default in this case)
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    // creates a NSURLSession object using the session configuration
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    // creates a task that actually downloads the image from the server using the session session create above
    // the completion block gets called when the network request is complete
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        // handles the case if there is an error
        if (error) {
            NSLog(@"error: %@", error.localizedDescription);
            return;
        }
        // if there is no error, create a data object that contains the content of the URL (the image, in this case). location refers to the the location of the file that was downloaded on the device
        NSData *data = [NSData dataWithContentsOfURL:location];
        // creates an image object containing the image stored in the NSData object
        UIImage *image = [UIImage imageWithData:data]; // 2
        // the networking happens on a background thread and the UI can only be updated on the main thread. This means that we need to make sure that this line of code runs on the main thread
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.appleImageView.image = image; // 4
        }];
    }];
    // the task is created in a suspended state, so it needs to be resumed to run
    [downloadTask resume];
}



@end
