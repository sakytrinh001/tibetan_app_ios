//
//  ChapterPickerCollectionView.m
//  NewTibetanBible
//
//  Created by Minh Thanh iOS on 3/8/17.
//  Copyright © 2017 Cuong Nguyen The. All rights reserved.
//

#import "ChapterPickerCollectionView.h"

@interface ChapterPickerCollectionView ()

@end

@implementation ChapterPickerCollectionView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)doneBack:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
    
}
@end
