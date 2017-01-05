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
@import GooglePlaces;

@interface ViewController () <UITextFieldDelegate,GMSAutocompleteViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *mapTest;
@property (strong,nonatomic) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UIButton *addPoint;
@property (strong,nonatomic) UITextField* selectedTextField;


@end

@implementation ViewController {
    GMSMapView *mapView;
}

@synthesize dataArray = _dataArray;

- (NSMutableArray*)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:5];
        for (int i = 0; i < 5; i++) {
            [_dataArray addObject:[NSNull null]];
        }
    }
    
    return _dataArray;
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

}

-(void) autoCompleteViewController {
   
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;
    [self presentViewController:acController animated:YES completion:nil];
    
}



-(void)textFieldDidBeginEditing:(UITextField *)sender {
    self.selectedTextField = sender;
    [self autoCompleteViewController];

}

- (IBAction)addPointActionButton:(id)sender {
     self.selectedTextField = nil;
    [self autoCompleteViewController];

    
}

- (void)viewController:(GMSAutocompleteViewController *)viewController didAutocompleteWithPlace:(GMSPlace *)place {
    
    RoadPath *path = [RoadPath new];
    
    path.coordinate = place.coordinate;
    path.pointName = place.formattedAddress;
    
    if (self.selectedTextField == self.startPointAddress) {
        [self.dataArray replaceObjectAtIndex:0 withObject:path];
        [self dismissViewControllerAnimated:YES completion:^{
            self.selectedTextField.text = path.pointName;
        }];
    } else if (self.selectedTextField == self.endPointAddress){
        [self.dataArray replaceObjectAtIndex:4 withObject:path];
        [self dismissViewControllerAnimated:YES completion:^{
            self.selectedTextField.text = path.pointName;
        }];
    } else {
        for(int i = 1; i <self.dataArray.count-1;i++){
            if(self.dataArray[i] == (id)[NSNull null]){
                [self.dataArray replaceObjectAtIndex:i withObject:path];
                
                break;
            }
            
        }
        [self dismissViewControllerAnimated:YES completion:^{
            self.selectedTextField.text = path.pointName;
        }];
    }

    if(self.dataArray[3] != (id)[NSNull null]){
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Warning"
                                     message:@"Maximum point capability reached"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        [self dismissViewControllerAnimated:YES completion:nil];
                                    }];
        
        
        [alert addAction:yesButton];

        [viewController presentViewController:alert animated:YES completion:nil];
    }
}

- (void)viewController:(GMSAutocompleteViewController *)viewController didFailAutocompleteWithError:(NSError *)error {

    NSLog(@"error: %ld", [error code]);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {

    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
