//
//  ViewController.m
//  townRush
//
//  Created by Nikita Taranov on 1/3/17.
//  Copyright © 2017 Nikita Taranov. All rights reserved.
//
@import GoogleMaps;
@import GooglePlaces;
#import "ViewController.h"
#import "LocationOperations.h"
#import "PolyLiner.h"



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
   
    GMSAutocompleteViewController *acController = [GMSAutocompleteViewController new];
    acController.delegate = self;
    [self presentViewController:acController animated:YES completion:nil];
    
}

-(void)textFieldDidBeginEditing:(UITextField *)sender {
    self.selectedTextField = sender;
    [self autoCompleteViewController];

}
- (IBAction)goAndSave:(id)sender {
        LocationOperations *moveOn = [LocationOperations sharedManager];
        PolyLiner *liner = [PolyLiner new];
        [liner getDataFromServerWithData:self.dataArray completion:^(id JSON) {
            [liner drawPolylineOnMap:mapView andData:JSON];
            [moveOn makeWrooomAndHustle:[liner getCoordsFromEncodedData:JSON] onMap:mapView];
        } failure:^(NSError *error) {
            
        }];
}

- (IBAction)addPointActionButton:(id)sender {
    
    if(self.dataArray[3] == (id)[NSNull null]){
        self.addPoint.enabled = YES;
        self.selectedTextField = nil;
        [self autoCompleteViewController];
    } else {
        self.addPoint.enabled = NO;
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Warning"
                                     message:@"Maximum additional point capability reached"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {

                                    }];
        
        
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }

}

-(void)viewController:(GMSAutocompleteViewController *)viewController didAutocompleteWithPlace:(GMSPlace *)place{
    
    RoadPath *path = [RoadPath new];
    
    path.coordinates = place.coordinate;
    path.pointName = place.formattedAddress;
    path.pointID = place.placeID;

    LocationOperations *operations = [LocationOperations sharedManager];
    
    if (self.selectedTextField == self.startPointAddress) {
        [self.dataArray replaceObjectAtIndex:0 withObject:path];
        [self dismissViewControllerAnimated:YES completion:^{
            self.selectedTextField.text = path.pointName;
            [operations addMarkerPoint:mapView andData:path];
        }];
    } else if (self.selectedTextField == self.endPointAddress){
        [self.dataArray replaceObjectAtIndex:4 withObject:path];
        [self dismissViewControllerAnimated:YES completion:^{
            self.selectedTextField.text = path.pointName;
            [operations addMarkerPoint:mapView andData:path];
        }];
    } else if (self.selectedTextField == nil) {
        for(int i = 1; i <self.dataArray.count-1;i++){
            if(self.dataArray[i] == (id)[NSNull null]){
                [self.dataArray replaceObjectAtIndex:i withObject:path];
                
                break;
            }
        }
        [self dismissViewControllerAnimated:YES completion:^{
            self.selectedTextField.text = path.pointName;
            [operations addMarkerPoint:mapView andData:path];
        }];
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
