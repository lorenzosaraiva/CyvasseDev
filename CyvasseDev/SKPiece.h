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
    Queen = 1
    
} PieceType;


@property PieceType pieceType;
@property int player;
@property int moveSpeed;
@property int hitPoints;
@property int attackDamage;


+ (instancetype) initPieceOfType:(PieceType)type ofPlayer:(int)player;

@end
