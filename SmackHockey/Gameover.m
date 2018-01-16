//
//  Gameover.m
//  SmackHockey
//
//  Created by Stephen Danly Martadi on 2017/11/27.
//  Copyright © 2017 Stephen. All rights reserved.
//

#import "Gameover.h"


@implementation Gameover

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    lbl_score.text = [NSString stringWithFormat: @"%d",SCORE_1];
    lbl_score2.text = [NSString stringWithFormat: @"%d",SCORE_2];
    
    if(GAME_MODE == 1){
    img_puck2.hidden=YES;
    lbl_score2.hidden=YES;
    }
    
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

@end
