//
//  SettingViewController.m
//  NewTibetanBible
//
//  Created by Cuong Nguyen The on 2/23/16.
//  Copyright © 2016 Cuong Nguyen The. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewDidAppear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *currentFontSizeTmp = @"";
    if ([defaults objectForKey:@"CurrentFontSize"]) {
        currentFontSizeTmp = [defaults objectForKey:@"CurrentFontSize"];
    } else {
        currentFontSizeTmp = @"2";
    }
    switch ([currentFontSizeTmp integerValue]) {
        case 0:
            self.currentFontSize = @"ལྷག་ཏུ་ཆུང་བ།";
            break;
        case 1:
            self.currentFontSize = @"ཆུང་བ།";
            break;
        case 2:
            self.currentFontSize = @"འབྲིང་ཙམ།";
            break;
        case 3:
            self.currentFontSize = @"ཆེ་བ།";
            break;
        case 4:
            self.currentFontSize = @"ལྷག་ཏུ་ཆེ་བ།";
            break;
        default:
            break;
    }
    // using text on button
    [self.fontSizeBtn setTitle:_currentFontSize forState:UIControlStateNormal];
    
    NSString *currentStateJustifiedText = @"";
    if ([defaults objectForKey:@"CurrentStateJustifiedText"]) {
        currentStateJustifiedText = [defaults objectForKey:@"CurrentStateJustifiedText"];
    } else {
        currentStateJustifiedText = @"Yes";
    }
    
    if ([currentStateJustifiedText isEqualToString:@"Yes"]) {
        [self.justifiedText setOn:YES];
    } else {
        [self.justifiedText setOn:NO];
    }
    
    NSString *currentFontTmp = @"";
    if ([defaults objectForKey:@"CurrentFont"]) {
        currentFontTmp = [defaults objectForKey:@"CurrentFont"];
    } else {
        currentFontTmp = @"1";
    }
    
    switch ([currentFontTmp integerValue]) {
        case 0:
            self.currentFont = @"དབུ་ཅན།";
            break;
        case 1:
            self.currentFont = @"འཁྱུག་ཡིག";
            break;
        case 2:
            self.currentFont = @"དཔེ་ཚུགས།";
            break;
        default:
            break;
    }
    // using text on button
    [self.fontBtn setTitle: _currentFont forState:UIControlStateNormal];
}

- (IBAction)selectBackgroundColor:(id)sender {
    UIButton *btnPressed = (UIButton *)sender;
    int tagOfBtn = (int)btnPressed.tag;
    if (tagOfBtn == 601) {
        [self.delegate changeBackground:@"white"];
    }
    
    if (tagOfBtn == 602) {
        [self.delegate changeBackground:@"#CFB53B"];//F9FAE6 moi, f3f4c9 mau cu
    }
    
    if (tagOfBtn == 603) {
        [self.delegate changeBackground:@"black"];
    }
}


- (IBAction)selectJustifiedText:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *currentStateJustifiedText = @"";
    if (self.justifiedText.isOn) {
        currentStateJustifiedText = @"Yes";
    } else {
        currentStateJustifiedText = @"No";
    }
    [defaults setObject:currentStateJustifiedText forKey:@"CurrentStateJustifiedText"];
    [self.delegate changeJustifiedText:self.justifiedText.isOn];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ShowEditFontSize"]) {
        EditFontSizeTableViewController *editFontSizeTVC = segue.destinationViewController;
        editFontSizeTVC.delegate = self.viewController;
    }
    
    if ([segue.identifier isEqualToString:@"ShowEditFont"]) {
        EditFontTableViewController *editFontTVC = segue.destinationViewController;
        editFontTVC.delegate = self.viewController;
    }
}

@end
