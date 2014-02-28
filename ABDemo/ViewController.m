//
//  ViewController.m
//  ABDemo
//
//  Created by Chris on 2/4/14.
//  Copyright (c) 2014 Kii Corporation. All rights reserved.
//

#import "ViewController.h"

#import <KiiSDK/Kii.h>
#import <KiiAnalytics/KiiAnalytics.h>
#import "KiiToolkit.h"

@interface ViewController () {
    KiiExperiment *_experiment;
}

@end

@implementation ViewController

- (KiiVariation*) currentVariation
{
    NSError *error;
    KiiVariation *variation = [_experiment appliedVariationWithError:&error];
    if (error != nil) {
        // Failed to apply a variation
        // (Check error.code for the failure reason)
        // In this example, 'A' would be applied when failing to apply a variation randomly.
        variation = [_experiment variationByName:@"A"];
    }

    // toggle this to manually override
    variation = [_experiment variationByName:@"B"];

    return variation;
}

- (IBAction) buttonClicked:(id)sender
{
    KiiVariation *variation = [self currentVariation];

    // The button is clicked and "eventClicked" event triggered.
    NSDictionary *clickEvent = [variation eventDictionaryForConversionWithName:@"buttonClicked"];
    [KiiAnalytics trackEvent:_experiment.experimentID withExtras:clickEvent];
    
    [[[UIAlertView alloc] initWithTitle:@"Sending $1,000,000 now!"
                               message:@"Even if you think we deserve more, this is all we wish to take. It'll buy us a beer or two!"
                              delegate:nil
                     cancelButtonTitle:@"All Done"
                      otherButtonTitles:nil] show];
}

- (void) setupVariation
{
    KiiVariation *variation = [self currentVariation];
    
    NSDictionary *variableSet = variation.variableDictionary;
    
    NSLog(@"Var set: %@", variableSet);
    
    // update our button accordingly
    UIColor *newColor = [UIColor redColor];
    if([[variableSet objectForKey:@"buttonColor"] isEqualToString:@"green"]) {
        newColor = [UIColor greenColor];
    }
    
    [_mainButton setBackgroundColor:newColor];
    
    [_mainButton setTitle:[variableSet objectForKey:@"buttonLabel"] forState:UIControlStateNormal];
    
    // The button is displayed and "eventViewed" event triggered.
    NSDictionary *viewEvent = [variation eventDictionaryForConversionWithName:@"buttonViewed"];

    // send our 'view' event
    [KiiAnalytics trackEvent:_experiment.experimentID withExtras:viewEvent];
}

- (void) viewDidAppear:(BOOL)animated
{
    NSLog(@"User: %@", [KiiUser currentUser]);
    
    [KTLoader showLoader:@"Getting Experiment"];
    
    [KiiExperiment getExperiment:@"f411ae7c-aba2-4724-8555-16dabb93a641"
                       withBlock:^(KiiExperiment *experiment, NSError *error) {
                           if(error == nil) {
                               
                               _experiment = experiment;
                               
                               [self setupVariation];
                               
                               [KTLoader hideLoader];
                               
                           } else {
                               [KTLoader showLoader:@"Error getting experiment!"
                                           animated:TRUE
                                      withIndicator:KTLoaderIndicatorError
                                    andHideInterval:KTLoaderDurationAuto];
                           }
                       }];


}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
