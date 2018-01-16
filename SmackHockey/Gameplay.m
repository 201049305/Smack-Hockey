//
//  Gameplay.m
//  SmackHockey
//
//  Created by Stephen Danly Martadi on 2017/11/27.
//  Copyright © 2017 Stephen. All rights reserved.
//

#import "Gameplay.h"

//@interface Gameplay ()
//@end

@implementation Gameplay

-(void) PlaySFX:(AVAudioPlayer*)sound
{
    if([sound isPlaying])
    {
        [sound stop];
        
    }
    
        [sound prepareToPlay];
        [sound play];
}

- (void)UpdateStriker1PuckCollision{
    BOOL isCollideStriker = [self CircleIntersection:img_striker.center arg2:img_puck.center arg3:strikerSize.x arg4:puckSize.x];
    
    if(isCollideStriker && !isInvurnerable)
    {
        
        //[self PlaySFX:sfx_puckhit];
        
        
        puckInvurnerableTimer = 0;
        dir = [self PointSubtraction:img_puck.center arg2:img_striker.center];
        dir = [self Normalize:dir];
        
        speed = magnitude * puckHitSpeedMultiplier / checkSpeedInterval;
        if(speed> maxSpeed)
        {
            speed = maxSpeed;
        }
    }
}

- (void)UpdateStriker2PuckCollision{
    BOOL isCollideStriker2 = [self CircleIntersection:img_striker2.center arg2:img_puck.center arg3:strikerSize.x arg4:puckSize.x];
    
    if(isCollideStriker2 && !isInvurnerable2)
    {
        //[self PlaySFX:sfx_puckhit];
        
        
        puckInvurnerableTimer2 = 0;
        dir = [self PointSubtraction:img_puck.center arg2:img_striker2.center];
        dir = [self Normalize:dir];
        
        speed = magnitude2 * puckHitSpeedMultiplier / checkSpeedInterval;
        if(speed> maxSpeed)
        {
            speed = maxSpeed;
        }
    }

}

-(void) GameOver{
    [MyUpdateTimer invalidate];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    Gameover *myNewVC = (Gameover *)[storyboard instantiateViewControllerWithIdentifier:@"gameoverViewController"];
    [self presentModalViewController:myNewVC animated:YES];
    
}

-(void) UpdateObstacle
{
    CGPoint momentum_obstacle = CGPointMake(dir_obstacle.x * speed_obstacle * deltaTime, dir_obstacle.y * speed_obstacle * deltaTime);
    img_obstacle.center = [self PointSum:img_obstacle.center arg2:momentum_obstacle];
    
    if(img_obstacle.center.x + obstacleSize.x/2 > screenSize.x)
    {
        if(dir_obstacle.x> 0 ) dir_obstacle.x*=-1;
    }else if( img_obstacle.center.x - obstacleSize.x/2 <0)
    {
        if(dir_obstacle.x< 0 ) dir_obstacle.x*=-1;
    }
}

-(void) Goal:(int)side{
    [self PlaySFX:sfx_goal];
    if(side==1){
        SCORE_1++;
        lbl_goal.hidden=NO;
        goalDisplayTimer = goalDisplayTime;
    }else{
            SCORE_2++;
        lbl_goal2.hidden=NO;
        goal2DisplayTimer = goalDisplayTime;
    }
    
    lbl_score_one.text = [NSString stringWithFormat: @"%d", SCORE_1];
    lbl_score_two.text = [NSString stringWithFormat: @"%d", SCORE_2];
    
    img_puck.center = CGPointMake(screenSize.x/2, screenSize.y/2);
    
    speed = 0;
}

-(void) InitPosition
{
    img_puck.center = CGPointMake(screenSize.x/2, screenSize.y/2);
    speed = 0;
    
    img_striker.center = CGPointMake(screenSize.x / 2 , screenSize.y * 3.0/4.0);
}

-(BOOL) PuckBlockCollide
{
    
    int distanceXPuckObstacle = abs(img_puck.center.x - img_obstacle.center.x);
    int distanceYPuckObstacle = abs(img_puck.center.y - img_obstacle.center.y);
    
    if(distanceXPuckObstacle > (obstacleSize.x/2 + puckSize.x/2)){return NO;}
    if(distanceYPuckObstacle > (obstacleSize.y/2 + puckSize.y/2)){return NO;}
    
    if(distanceXPuckObstacle <= (obstacleSize.x/2)){
        
        if(img_puck.center.y < img_obstacle.center.y)
        {
           if(dir.y >0)
           {dir.y *=-1;}
            
            if(speed < 5)
            {
                speed = speed_obstacle;
                dir.y = 1;
                dir = [self Normalize:dir];
            }

        }else if(img_puck.center.y > img_obstacle.center.y)
        {
            if(dir.y <0)
            {dir.y *= -1;}
            
            if(speed < 5)
            {
                speed = speed_obstacle;
                dir.y = 1;
                dir = [self Normalize:dir];
            }

        }else
        {
            dir.y = dir.y *-1;
            
            if(speed < 5)
            {
                speed = speed_obstacle;
                dir.y = 1;
                dir = [self Normalize:dir];
            }

        }
        
        return YES;}
    
    if(distanceYPuckObstacle <= (obstacleSize.y/2)){
        
        if(img_puck.center.x < img_obstacle.center.x)
        {
            if(dir.x >0)
            {dir.x *=-1;}
        }else if(img_puck.center.x > img_obstacle.center.x)
        {
            if(dir.x <0)
            {dir.x *= -1;}
            
            if(speed < 5)
            {
                speed = speed_obstacle;
                dir.y = 1;
                dir = [self Normalize:dir];
            }

        }else
        {
            dir.x = dir.x *-1;
            
            if(speed < 5)
            {
                speed = speed_obstacle;
                dir.y = 1;
                dir = [self Normalize:dir];
            }

        }
        
        return YES;}
    
    float cornerDistance_sq = pow((distanceXPuckObstacle- obstacleSize.x/2),2) + pow((distanceYPuckObstacle- obstacleSize.y/2),2);
    
    if(cornerDistance_sq <= pow(puckSize.x,2))
    {
        if(dir.x>dir.y)
        {
            dir.x *=-1;
        }else
        {
            dir.y *=-1;
        }
        
        if(speed < 5)
        {
            speed = speed_obstacle;
            dir.y = 1;
            dir = [self Normalize:dir];
        }

        
        return YES;
    }
    
    else{return NO;}
}

- (BOOL)CircleIntersection: (CGPoint)pA arg2:(CGPoint)pB arg3:(float) dA arg4:(float) dB
{
    
    float width = pA.x - pB.x;
    float height = pA.y-pB.y;
    
    float radiusSum = dA/2 + dB/2;
    float distance = sqrt(pow(width,2)+pow(height,2));
    
    
    if(distance < radiusSum){
        return YES;}
    else{
        return NO;}
}

- (CGPoint)PointSum: (CGPoint)pointA arg2:(CGPoint)pointB
{
    return CGPointMake(pointA.x + pointB.x, pointA.y + pointB.y);
}

- (CGPoint)PointSubtraction: (CGPoint)pointA arg2:(CGPoint)pointB
{
    
    return CGPointMake(pointA.x - pointB.x, pointA.y - pointB.y);
}

- (CGPoint)Normalize:(CGPoint)point
{
    float divider = sqrtf(powf(point.x, 2) + powf(point.y,2));
    return CGPointMake(point.x/divider, point.y/divider);
}

- (void) UpdatePuckMovement
{
    img_puck.center = CGPointMake(img_puck.center.x, img_puck.center.y);
    
    //Check if collide

}

- (void) MyUpdate
{
    
    
    deltaTime = [start timeIntervalSinceNow];
    deltaTime *= -1;
    
    checkSpeedTimer += deltaTime;
    
    if(goalDisplayTimer>0)
    goalDisplayTimer-= deltaTime;
    
    if(goal2DisplayTimer>0)
    goal2DisplayTimer-= deltaTime;
    
    [lbl_goal setAlpha:(float)goalDisplayTimer / goalDisplayTime];
    [lbl_goal2 setAlpha:(float)goal2DisplayTimer / goalDisplayTime];
    
    if(goalDisplayTimer<=0)
    {
               lbl_goal.hidden=YES;
    }
    
    if(goal2DisplayTimer<=0)
    {
      
        lbl_goal2.hidden = YES;
    }
    
    if(checkSpeedTimer > checkSpeedInterval)
    {
        CGPoint PointDif = [self PointSubtraction:img_striker.center arg2:previousStrikerPos];
        CGPoint PointDif2 = [self PointSubtraction:img_striker2.center arg2:previousStrikerPos2];
        
        previousStrikerPos = img_striker.center;
        previousStrikerPos2 = img_striker2.center;
        
        magnitude = sqrt(pow(PointDif.x,2)+pow(PointDif.y,2));
        magnitude2 = sqrt(pow(PointDif2.x,2)+pow(PointDif2.y,2));
        
        if(magnitude < minMagnitude)
        {
            magnitude = minMagnitude;
        }
        if(magnitude2 < minMagnitude)
        {
            magnitude2 = minMagnitude;
        }
        
        checkSpeedTimer = 0;
    }
    
    //Friction
    speed = speed - friction;
    if(speed < minPuckSpeed)
        speed = minPuckSpeed;
    
    
    //Update Puck Movement
    CGPoint momentum = CGPointMake(dir.x*speed *deltaTime, dir.y*speed*deltaTime);
    img_puck.center = [self PointSum:img_puck.center arg2:momentum];
    
    //Update obstacle movement
    [self UpdateObstacle];
    
    
    
    //Check player striker and puck collision
    [self UpdateStriker1PuckCollision];
    
    if(GAME_MODE == 2)
    [self UpdateStriker2PuckCollision];
    
    //Check collision wall
    //Collision Horizontal
    if(img_puck.center.x + puckSize.x/2 > screenSize.x){
        if(dir.x>0)dir.x*=-1;
        
        
        //[self PlaySFX:sfx_wallhit];
    }
    else if(img_puck.center.x - puckSize.x/2 < 0){
        if(dir.x<0)dir.x*=-1;
        
        //[self PlaySFX:sfx_wallhit];
    }
    
    //Collision Vertical
    if(img_puck.center.y + puckSize.y/2 > screenSize.y){
        
        
        if(img_puck.center.x < 124.0/450.0 * screenSize.x || img_puck.center.x > 325.0/450.0 * screenSize.x)
        {
            if(dir.y>0)dir.y*=-1;
         //[self PlaySFX:sfx_wallhit];
        }else{
            if(GAME_MODE == 1)
            {if(dir.y>0)dir.y*=-1;}
        }
    }
    else if( img_puck.center.y - puckSize.y/2 < 0){
        
        if(img_puck.center.x < 124.0/450.0 * screenSize.x || img_puck.center.x > 325.0/450.0 * screenSize.x)
        {
            
        if(dir.y<0)dir.y*=-1;
            //[self PlaySFX:sfx_wallhit];
        }
    }
    
    //0 124 - 325 450
    //325
    
    //Check collision block
    if(GAME_MODE == 1)
        [self PuckBlockCollide];
    
    
    //Update Time
    timer -= deltaTime;
    
    lbl_time.text = [NSString stringWithFormat:@"%d", (int)timer];;
    
    puckInvurnerableTimer += deltaTime;
    puckInvurnerableTimer2 += deltaTime;
    
    if(puckInvurnerableTimer > puckInvurnerableInterval)
    {
        isInvurnerable = NO;
    }else{
        isInvurnerable = YES;
    }
    
    if(puckInvurnerableTimer2 > puckInvurnerableInterval)
    {
        isInvurnerable2 = NO;
    }else{
        isInvurnerable2 = YES;
    }
    
    if(timer <= 0 )
    {
        [self GameOver];
    }
    
    
    //If center lebih kecil dari apa atau lebih besr dari apa  = goal
    if(img_puck.center.y < -1 )
    {
        [self Goal:1];
    }
    
    if(img_puck.center.y > screenSize.y )
    {
        [self Goal:2];
    }
    
    
    //NSLog(@"momentum: %f , %f",momentum.x,momentum.y);
    //NSLog(@"screenBounds: %f , %f",screenBounds.size.width,screenBounds.size.height);
    //NSLog(@"strikerPos: %f , %f",img_striker.center.x,img_striker.center.y);
    //NSLog(@"timer: %f",timer);
    //NSLog(@"invulnerable: %d", (int)isInvurnerable);
    
   start = [NSDate date];
}

- (IBAction)BtnResetPressed:(id)sender {
    [self InitPosition];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    
    CGPoint location = [touch locationInView:self.view];
    
    
    //Check if touch bottom area only
    if(location.y < screenSize.y/2)
    {
        controlTwo = YES;
    }else if(location.y > screenSize.y/2)
    {
        controlOne = YES;
    }
    
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event//upon leaving
{
    UITouch *touch = [[event allTouches] anyObject];
    
    CGPoint location = [touch locationInView:self.view];
    
    //Check if touch bottom area only
    if(location.y < screenSize.y/2)
    {
        img_striker2.center = CGPointMake(location.x,location.y);
        controlTwo = NO;
        
    }else if(location.y > screenSize.y/2)
    {
        img_striker.center = CGPointMake(location.x,location.y);
        controlOne = NO;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:touch.view];
    
    
    //Check if touch bottom area only
    if(location.y < screenSize.y/2)
    {
        if(controlTwo)
            img_striker2.center = CGPointMake(location.x,location.y);
        
        
    }else if(location.y > screenSize.y/2)
    {
        if(controlOne)
            img_striker.center = CGPointMake(location.x,location.y);
    }
}

- (void)viewDidAppear:(BOOL)animated {
      MyUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.005 target:self selector:@selector(MyUpdate) userInfo:nil repeats:YES];
}

int SCORE_1= 0;
int SCORE_2= 0;

- (void)viewDidLoad {
    
    NSString *path_goal = [[NSBundle mainBundle] pathForResource:@"sfx_goal" ofType:@"mp3"];
    NSString *path_puckhit = [[NSBundle mainBundle] pathForResource:@"sfx_puckhit" ofType:@"mp3"];
    NSString *path_wallhit = [[NSBundle mainBundle] pathForResource:@"sfx_wallhit" ofType:@"mp3"];
    
    
    sfx_goal=[[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:path_goal] error:NULL];
    sfx_puckhit=[[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:path_puckhit] error:NULL];
    sfx_wallhit=[[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:path_wallhit] error:NULL];
    
    goalDisplayTimer = goalDisplayTime;
    goal2DisplayTimer = goalDisplayTime;
    
    lbl_goal.hidden=YES;
    lbl_goal2.hidden=YES;
    
    
    [lbl_score_two setTransform:CGAffineTransformMakeRotation(M_PI/2)];
    [lbl_score_one setTransform:CGAffineTransformMakeRotation(M_PI/2)];
    [lbl_time setTransform:CGAffineTransformMakeRotation(M_PI/2)];
    [lbl_goal2 setTransform:CGAffineTransformMakeRotation(M_PI)];
    
    CGRect scr = [[UIScreen mainScreen] bounds];
    screenSize = CGPointMake(scr.size.width,scr.size.height);
    
    //Init
    speed = 5;
    dir = CGPointMake(1, 1);
    dir = [self Normalize:dir];
    onHitSpeed = 500;
    friction = 5;
    SCORE_1 = 0;
    SCORE_2 = 0;
    minPuckSpeed = 0;
    
    goalDisplayTime = 1.0;
    
    if(GAME_MODE == 1)
    {
        dir_obstacle = CGPointMake(1,0);
        speed_obstacle = 50;
        timer = 15;
        
        lbl_score_two.hidden = YES;
        img_striker2.hidden = YES;
        
    }else if(GAME_MODE==2)
    {
        timer = 60;
        
        img_obstacle.hidden = YES;
        btn_resetPuck.hidden = YES;
        img_cushion.hidden = YES;
    }
    
    lbl_score_one.text = [NSString stringWithFormat: @"%d", (int) SCORE_1];
    lbl_score_two.text = [NSString stringWithFormat: @"%d", (int) SCORE_2];
    
    puckSize = CGPointMake(img_puck.bounds.size.width,img_puck.bounds.size.height);
    strikerSize = CGPointMake(img_striker.bounds.size.width,img_striker.bounds.size.height);
    obstacleSize = CGPointMake(img_obstacle.bounds.size.width,img_obstacle.bounds.size.height);
    
    puckHitSpeedMultiplier = 1;
    checkSpeedTimer = 0;
    checkSpeedInterval = 0.02;
    puckInvurnerableTimer = 0;
    puckInvurnerableInterval = 0.03;
    
    minMagnitude = 4;
    maxSpeed = 2000;
    [super viewDidLoad];
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
