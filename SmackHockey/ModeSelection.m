//
//  ModeSelection.m
//  SmackHockey
//
//  Created by Stephen Danly Martadi on 2017/12/07.
//  Copyright © 2017 Stephen. All rights reserved.
//

#import "ModeSelection.h"
#import "Gameplay.h"

@interface ModeSelection ()

@end

@implementation ModeSelection

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

int GAME_MODE=0;

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)OnePlayerMode:(id)sender {
    
    GAME_MODE = 1;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    Gameplay *myNewVC = (Gameplay *)[storyboard instantiateViewControllerWithIdentifier:@"gameplayViewController"];
    [self presentModalViewController:myNewVC animated:YES];
}

- (IBAction)TwoPlayerMode:(id)sender {
    
    GAME_MODE = 2;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    Gameplay *myNewVC = (Gameplay *)[storyboard instantiateViewControllerWithIdentifier:@"gameplayViewController"];
    [self presentModalViewController:myNewVC animated:YES];
}


@end
