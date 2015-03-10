//
//  GameScene.m
//  CyvasseDev
//
//  Created by Lorenzo Saraiva on 3/10/15.
//  Copyright (c) 2015 BEPID-PucRJ. All rights reserved.
//

#import "GameScene.h"
#import "SKCell.h"

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    BOOL blackOrWhite = true;
    
    for (int i = 0; i < 8; i++){
        for (int j = 0; j < 8; j++){
            
            UIColor * color = blackOrWhite? [UIColor blackColor]:[UIColor whiteColor];
            SKCell *cell = [SKCell initWithColor:color];
            cell.line = i;
            cell.column = j;
            [self addChild:cell];
            int a = CGRectGetMidX(self.frame) - 200;
            int b = CGRectGetMidY(self.frame) + 200;
            
            cell.position = CGPointMake(a + j * 30, b - i * 30);
            blackOrWhite = !blackOrWhite;
        }
        blackOrWhite = !blackOrWhite;
    }

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
