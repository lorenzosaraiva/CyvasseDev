//
//  SKPiece.h
//  CyvasseDev
//
//  Created by Lorenzo Saraiva on 3/11/15.
//  Copyright (c) 2015 BEPID-PucRJ. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKPiece : SKSpriteNode

typedef enum SKPieceType {
    
    King = 0,
    Infantry = 1,
    Archer = 2,
    Chivalry = 3,
    FireMage = 4,
    LightMage = 5,
    RoyalGuard = 6,
    Dragon = 7,
    DragonSlayer = 8,
    Tower = 9,
    Catapult = 10,
    ArcherSniper = 11,
    ArcherIncendiary = 12,
    ArcherCrossBow = 13
    
    
} PieceType;


@property PieceType pieceType;
@property int player;
@property int moveSpeed;
@property int hitPoints;
@property int attackDamage;
@property int rangeMax;
@property int rangeMin;
@property BOOL canAttack;
@property BOOL fireProof;
+ (instancetype) initPieceOfType:(PieceType)type ofPlayer:(int)player;

@end
