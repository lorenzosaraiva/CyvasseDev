//
//  GameScene.h
//  CyvasseDev
//

//  Copyright (c) 2015 BEPID-PucRJ. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameScene : SKScene

typedef enum currentPlayer {
    
    Black = 0,
    White = 1
    
} Player;

typedef enum TurnPhase {

    ChoseMove = 0,
    ChoseDirection = 1,
    ChoseAttacker = 2,
    ChoseAttackTarget = 3,
    ChoseTowerTarget = 4

} turnPhase;

@end
