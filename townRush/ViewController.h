//
//  ViewController.h
//  townRush
//
//  Created by Nikita Taranov on 1/3/17.
//  Copyright © 2017 Nikita Taranov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <GMSAutocompleteViewControllerDelegate>

@property(strong,nonatomic) NSString *textString;
@property (weak, nonatomic) IBOutlet UITextField *startPointAddress;
@property (weak, nonatomic) IBOutlet UITextField *endPointAddress;

@end

