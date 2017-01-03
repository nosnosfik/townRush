//
//  ViewController.m
//  townRush
//
//  Created by Nikita Taranov on 1/3/17.
//  Copyright © 2017 Nikita Taranov. All rights reserved.
//
#define kOFFSET_FOR_KEYBOARD 185.0
#import "ViewController.h"
#import "LocationOperations.h"
@import GoogleMaps;

@interface ViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *mapTest;
@property (weak, nonatomic) IBOutlet UITextField *startPointAddress;
@property (weak, nonatomic) IBOutlet UITextField *endPointAddress;
@property (strong,nonatomic) NSDictionary *coordsDictionary;

@end

@implementation ViewController {
    GMSMapView *mapView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LocationOperations *sharedManager = [LocationOperations sharedManager];
    
    [sharedManager loadLocationManager];
  
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[sharedManager deviceLatitude]
                                                            longitude:[sharedManager deviceLongitude]
                                                                 zoom:16];
    mapView = [GMSMapView mapWithFrame:self.mapTest.bounds camera:camera];
    mapView.myLocationEnabled = YES;
    [_mapTest addSubview:mapView];
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake([sharedManager deviceLatitude], [sharedManager deviceLongitude]);
    marker.title = @"Sydney";
    marker.snippet = @"Australia";
    marker.map = mapView;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (newString.length >2 ) {
        NSLog(@"OLOLOLOLOLOL");
    }
    
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
  
    if ([sender isEqual:@""])
    {
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
}


-(BOOL) textFieldShouldReturn: (UITextField *) textField {
   
     [self setViewMovedUp:NO];
     [textField resignFirstResponder];
    
     return YES;

}

-(void) textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField == self.startPointAddress) {
        
        [self.endPointAddress becomeFirstResponder];
        [self setViewMovedUp:YES];
        
    } else if (textField == self.endPointAddress) {

       [self setViewMovedUp:NO];

    }

}

-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

@end
