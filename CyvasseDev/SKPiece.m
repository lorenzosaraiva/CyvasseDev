//
//  SKPiece.m
//  CyvasseDev
//
//  Created by Lorenzo Saraiva on 3/11/15.
//  Copyright (c) 2015 BEPID-PucRJ. All rights reserved.
//

#import "SKPiece.h"

@implementation SKPiece

+ (instancetype) initPieceOfType:(PieceType)type ofPlayer:(int)player{

    SKPiece *newPiece;
    newPiece.canAttack = true;
    if (type == 0){
        newPiece = [SKPiece spriteNodeWithImageNamed:@"King.png"];
        newPiece.player = player;
        newPiece.pieceType = type;
        newPiece.moveSpeed = 2;
        newPiece.size = CGSizeMake(40, 40);
        newPiece.hitPoints = 8;
        newPiece.attackDamage = 3;
        newPiece.range = 1;
        newPiece.fireProof = NO;
    }
    
    if (type == 1){
        newPiece = [SKPiece spriteNodeWithImageNamed:@"pawn.png"];
        newPiece.player = player;
        newPiece.pieceType = type;
        newPiece.moveSpeed = 1;
        newPiece.size = CGSizeMake(40, 40);
        newPiece.hitPoints = 5;
        newPiece.attackDamage = 5;
        newPiece.range = 1;
        newPiece.fireProof = NO;
    }
    
    if (type == 2){
        newPiece = [SKPiece spriteNodeWithImageNamed:@"archer.png"];
        newPiece.player = player;
        newPiece.pieceType = type;
        newPiece.moveSpeed = 1;
        newPiece.size = CGSizeMake(40, 40);
        newPiece.hitPoints = 3;
        newPiece.attackDamage = 5;
        newPiece.range = 2;
        newPiece.fireProof = NO;
    
    }
    
    if (type == 3){
        newPiece = [SKPiece spriteNodeWithImageNamed:@"horse.png"];
        newPiece.player = player;
        newPiece.pieceType = type;
        newPiece.moveSpeed = 2;
        newPiece.size = CGSizeMake(40, 40);
        newPiece.hitPoints = 10;
        newPiece.attackDamage = 5;
        newPiece.range = 1;
        newPiece.fireProof = NO;
    }
    
    if (type == 4){
        newPiece = [SKPiece spriteNodeWithImageNamed:@"firemage.png"];
        newPiece.player = player;
        newPiece.pieceType = type;
        newPiece.moveSpeed = 1;
        newPiece.size = CGSizeMake(40, 40);
        newPiece.hitPoints = 3;
        newPiece.attackDamage = 5;
        newPiece.range = 1;
        newPiece.fireProof = YES;
    }
    
    if (type == 5){
        newPiece = [SKPiece spriteNodeWithImageNamed:@"lightmage.gif"];
        newPiece.player = player;
        newPiece.pieceType = type;
        newPiece.moveSpeed = 1;
        newPiece.size = CGSizeMake(40, 40);
        newPiece.hitPoints = 3;
        newPiece.attackDamage = 10;
        newPiece.range = 2;
        
    }
    
    if (type == 6){
        newPiece = [SKPiece spriteNodeWithImageNamed:@"royalguard.png"];
        newPiece.player = player;
        newPiece.pieceType = type;
        newPiece.moveSpeed = 2;
        newPiece.size = CGSizeMake(40, 40);
        newPiece.hitPoints = 20;
        newPiece.attackDamage = 7;
        newPiece.range = 2;
        
    }
    
    if (type == 7){
        newPiece = [SKPiece spriteNodeWithImageNamed:@"dragon.jpg"];
        newPiece.player = player;
        newPiece.pieceType = type;
        newPiece.moveSpeed = 2;
        newPiece.size = CGSizeMake(40, 40);
        newPiece.hitPoints = 30;
        newPiece.attackDamage = 10;
        newPiece.range = 2;
        newPiece.fireProof = YES;
        
    }
    
    if (type == 8){
        newPiece = [SKPiece spriteNodeWithImageNamed:@"dragonslayer.jpg"];
        newPiece.player = player;
        newPiece.pieceType = type;
        newPiece.moveSpeed = 2;
        newPiece.size = CGSizeMake(40, 40);
        newPiece.hitPoints = 15;
        newPiece.attackDamage = 5;
        newPiece.range = 2;
        newPiece.fireProof = YES;
        
    }
    
    if (type == 9){
        newPiece = [SKPiece spriteNodeWithImageNamed:@"tower.png"];
        newPiece.player = player;
        newPiece.pieceType = type;
        newPiece.moveSpeed = 0;
        newPiece.size = CGSizeMake(40, 40);
        newPiece.hitPoints = 30;
        newPiece.attackDamage = 5;
        newPiece.range = 2;
        newPiece.fireProof = NO;
        
    }
    
    if (type == 10){
        newPiece = [SKPiece spriteNodeWithImageNamed:@"catapult.png"];
        newPiece.player = player;
        newPiece.pieceType = type;
        newPiece.moveSpeed = 1;
        newPiece.size = CGSizeMake(40, 40);
        newPiece.hitPoints = 3;
        newPiece.attackDamage = 10;
        newPiece.range = 2;
        newPiece.fireProof = NO;
        
    }
    return newPiece;

}

@end
