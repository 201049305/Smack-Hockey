//
//  Gameplay.h
//  SmackHockey
//
//  Created by Stephen Danly Martadi on 2017/11/27.
//  Copyright © 2017 Stephen. All rights reserved.
//

#import "ViewController.h"
#import "Gameover.h"
#import "AVFoundation/AVFoundation.h"

extern int SCORE_1;
extern int SCORE_2;
extern int GAME_MODE;   //1: oneplayer  2: twoplayer

@interface Gameplay : ViewController{
    
    
    IBOutlet UILabel *lbl_score_one;
    IBOutlet UILabel *lbl_score_two;
    IBOutlet UILabel *lbl_time;
    IBOutlet UILabel *lbl_goal;
    IBOutlet UILabel *lbl_goal2;
    
    float goalDisplayTime;
    float goalDisplayTimer;
    float goal2DisplayTimer;
    
    IBOutlet UIButton *btn_resetPuck;
    
    IBOutlet UIImageView *img_puck;
    IBOutlet UIImageView *img_striker2;
    IBOutlet UIImageView *img_striker;
    IBOutlet UIImageView *img_obstacle;
    IBOutlet UIImageView *img_cushion;
    
    AVAudioPlayer * sfx_goal;
    AVAudioPlayer * sfx_puckhit;
    AVAudioPlayer * sfx_wallhit;
    
    NSTimer *MyUpdateTimer;
    
    //Puck
    CGPoint  dir;
    CGPoint  dir_obstacle;
    
    float speed;
    float onHitSpeed;
    
    float friction;
    CGPoint screenSize;
    CGPoint puckSize, strikerSize, obstacleSize;
    float speed_obstacle;
    
    float timer;
    
    
    NSDate *start;
    NSTimeInterval deltaTime;
    float strikerSpeed;
    
    float puckHitSpeedMultiplier;
    
    CGPoint previousStrikerPos;
    CGPoint previousStrikerPos2;
    
    float checkSpeedInterval;
    float checkSpeedTimer;
    
    float puckInvurnerableTimer;
    float puckInvurnerableTimer2;
    
    float puckInvurnerableInterval;
    
    float magnitude;
    float magnitude2;
    float minMagnitude;
    
    float maxSpeed;
    float minPuckSpeed;
    
    BOOL isInvurnerable;
    BOOL isInvurnerable2;
    
    BOOL controlOne;
    BOOL controlTwo;
}
- (void)UpdateStriker1PuckCollision;
- (void)UpdateStriker2PuckCollision;

- (void)UpdateObstacle;
- (void)UpdatePuckMovement;
- (void)MyUpdate;
- (BOOL)CircleIntersection: (CGPoint)pA arg2:(CGPoint)pB arg3:(float) dA arg4:(float) dB ;
- (BOOL) PuckBlockCollide;
- (void) Goal:(int)side;
- (void) GameOver;

-(void) PlaySFX:(AVAudioPlayer*)sound;

//Vector related
- (CGPoint)PointSubtraction: (CGPoint)pointA arg2:(CGPoint)pointB;
- (CGPoint)PointSum: (CGPoint)pointA arg2:(CGPoint)pointB;
- (CGPoint)Normalize:(CGPoint)point;

@end
