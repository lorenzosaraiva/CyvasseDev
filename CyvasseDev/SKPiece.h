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
    ChivalryScout = 3,
    FireMage = 4,
    LightMage = 5,
    RoyalGuard = 6,
    Dragon = 7,
    DragonSlayer = 8,
    Tower = 9,
    Catapult = 10,
    ArcherSniper = 11,
    ArcherIncendiary = 12,
    ArcherCrossBow = 13,
    ChivalryArcher = 14,
    ChivalryTemplar = 15,
    InfantryBarrier = 16,
    InfantrySaboteur = 17,
    StoneGiant = 18,
    TreeGiant = 19,
    Barrier = 20
    
} PieceType;

typedef enum SKMainClass{

    Chivalry = 0,
    Archery = 1,
    Mage = 2,
    Foot = 3
    
} MainClass;


@property PieceType pieceType;
@property int player;
@property int moveSpeed;
@property int hitPoints;
@property int maxHitPoints;
@property int attackDamage;
@property int rangeMax;
@property int rangeMin;
@property int mainClass;
@property int fireDamageMultiplier;
@property int arrowDamageMultiplier;
@property int fireDamage;
@property int turnsToAttack;
@property int turnsToAction;
@property BOOL hasAction;

+ (instancetype) initPieceOfType:(PieceType)type ofPlayer:(int)player;
- (NSString*)convertToString;

@end
