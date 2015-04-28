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
        newPiece.rangeMin = 1;
        newPiece.rangeMax = 1;
        newPiece.fireDamageMultiplier = 1;
        newPiece.fireDamage = 0;
        newPiece.arrowDamageMultiplier = 1;

    }
    
    if (type == 1){
        newPiece = [SKPiece spriteNodeWithImageNamed:@"pawn.png"];
        newPiece.player = player;
        newPiece.pieceType = type;
        newPiece.moveSpeed = 1;
        newPiece.size = CGSizeMake(40, 40);
        newPiece.hitPoints = 5;
        newPiece.attackDamage = 5;
        newPiece.rangeMin = 1;
        newPiece.rangeMax = 1;
        newPiece.fireDamageMultiplier = 1;
        newPiece.fireDamage = 0;
        newPiece.arrowDamageMultiplier = 1;


    }
    
    if (type == 2){
        newPiece = [SKPiece spriteNodeWithImageNamed:@"archer.png"];
        newPiece.player = player;
        newPiece.pieceType = type;
        newPiece.moveSpeed = 1;
        newPiece.size = CGSizeMake(40, 40);
        newPiece.hitPoints = 3;
        newPiece.attackDamage = 5;
        newPiece.rangeMin = 2;
        newPiece.rangeMax = 3;
        newPiece.fireDamageMultiplier = 1;
        newPiece.fireDamage = 0;
        newPiece.arrowDamageMultiplier = 1;
        newPiece.mainClass = Archer;


    
    }
    
    if (type == 3){
        /* Scout */
        newPiece = [SKPiece spriteNodeWithImageNamed:@"horse.png"];
        newPiece.player = player;
        newPiece.pieceType = type;
        newPiece.moveSpeed = 3;
        newPiece.size = CGSizeMake(40, 40);
        newPiece.hitPoints = 10;
        newPiece.attackDamage = 3;
        newPiece.rangeMin = 1;
        newPiece.rangeMax = 1;
        newPiece.fireDamageMultiplier = 1;
        newPiece.fireDamage = 0;
        newPiece.mainClass = Chivalry;
        newPiece.arrowDamageMultiplier = 1;

    }
    
    if (type == 4){
        /* FireMage */
        newPiece = [SKPiece spriteNodeWithImageNamed:@"firemage.png"];
        newPiece.player = player;
        newPiece.pieceType = type;
        newPiece.moveSpeed = 1;
        newPiece.size = CGSizeMake(40, 40);
        newPiece.hitPoints = 3;
        newPiece.attackDamage = 2;
        newPiece.rangeMin = 1;
        newPiece.rangeMax = 1;
        newPiece.fireDamageMultiplier = 0;
        newPiece.fireDamage = 1;
        newPiece.arrowDamageMultiplier = 1;
        newPiece.hasAction = true;


    }
    
    if (type == 5){
        /* LightMage */
        newPiece = [SKPiece spriteNodeWithImageNamed:@"lightmage.gif"];
        newPiece.player = player;
        newPiece.pieceType = type;
        newPiece.moveSpeed = 1;
        newPiece.size = CGSizeMake(40, 40);
        newPiece.hitPoints = 3;
        newPiece.attackDamage = 2;
        newPiece.rangeMin = 1;
        newPiece.rangeMax = 1;
        newPiece.fireDamageMultiplier = 1;
        newPiece.fireDamage = 0;
        newPiece.arrowDamageMultiplier = 1;
        newPiece.hasAction = true;

        
    }
    
    if (type == 6){
        newPiece = [SKPiece spriteNodeWithImageNamed:@"royalguard.png"];
        newPiece.player = player;
        newPiece.pieceType = type;
        newPiece.moveSpeed = 2;
        newPiece.size = CGSizeMake(40, 40);
        newPiece.hitPoints = 20;
        newPiece.attackDamage = 7;
        newPiece.rangeMin = 1;
        newPiece.rangeMax = 1;
        newPiece.fireDamageMultiplier = 0;
        newPiece.fireDamage = 0;
        newPiece.arrowDamageMultiplier = 0;

        
    }
    
    if (type == 7){
        newPiece = [SKPiece spriteNodeWithImageNamed:@"dragon.jpg"];
        newPiece.player = player;
        newPiece.pieceType = type;
        newPiece.moveSpeed = 2;
        newPiece.size = CGSizeMake(40, 40);
        newPiece.hitPoints = 30;
        newPiece.attackDamage = 10;
        newPiece.rangeMin = 1;
        newPiece.rangeMax = 1;;
        newPiece.fireDamageMultiplier = 0;
        newPiece.fireDamage = 1;
        newPiece.arrowDamageMultiplier = 1;
        newPiece.hasAction = true;

        
    }
    
    if (type == 8){
        newPiece = [SKPiece spriteNodeWithImageNamed:@"dragonslayer.jpg"];
        newPiece.player = player;
        newPiece.pieceType = type;
        newPiece.moveSpeed = 2;
        newPiece.size = CGSizeMake(40, 40);
        newPiece.hitPoints = 15;
        newPiece.attackDamage = 5;
        newPiece.rangeMin = 1;
        newPiece.rangeMax = 1;
        newPiece.fireDamageMultiplier = 0;
        newPiece.fireDamage = 0;
        newPiece.arrowDamageMultiplier = 1;
        
        
    }
    
    if (type == 9){
        newPiece = [SKPiece spriteNodeWithImageNamed:@"tower.png"];
        newPiece.player = player;
        newPiece.pieceType = type;
        newPiece.moveSpeed = 0;
        newPiece.size = CGSizeMake(40, 40);
        newPiece.hitPoints = 30;
        newPiece.attackDamage = 5;
        newPiece.rangeMin = 1;
        newPiece.rangeMax = 1;
        newPiece.fireDamageMultiplier = 2;
        newPiece.fireDamage = 0;
        newPiece.arrowDamageMultiplier = 1;

        
    }
    
    if (type == 10){
        /* Catapulta */
        newPiece = [SKPiece spriteNodeWithImageNamed:@"catapult.png"];
        newPiece.player = player;
        newPiece.pieceType = type;
        newPiece.moveSpeed = 1;
        newPiece.size = CGSizeMake(40, 40);
        newPiece.hitPoints = 6;
        newPiece.attackDamage = 10;
        newPiece.rangeMin = 1;
        newPiece.rangeMax = 1;
        newPiece.fireDamageMultiplier = 2;
        newPiece.fireDamage = 0;
        newPiece.arrowDamageMultiplier = 0;
        
    }
    if (type == 11){
        /* Sniper */
        newPiece = [SKPiece spriteNodeWithImageNamed:@"archer.png"];
        newPiece.player = player;
        newPiece.pieceType = type;
        newPiece.moveSpeed = 1;
        newPiece.size = CGSizeMake(40, 40);
        newPiece.hitPoints = 3;
        newPiece.attackDamage = 7;
        newPiece.rangeMin = 3;
        newPiece.rangeMax = 4;
        newPiece.fireDamageMultiplier = 1;
        newPiece.fireDamage = 0;
        newPiece.arrowDamageMultiplier = 1;
        newPiece.mainClass = Archer;
        
    }
    if (type == 12){
        /* FireArcher */
        
        newPiece = [SKPiece spriteNodeWithImageNamed:@"archer.png"];
        newPiece.player = player;
        newPiece.pieceType = type;
        newPiece.moveSpeed = 1;
        newPiece.size = CGSizeMake(40, 40);
        newPiece.hitPoints = 3;
        newPiece.attackDamage = 5;
        newPiece.rangeMin = 2;
        newPiece.rangeMax = 3;
        newPiece.fireDamageMultiplier = 1;
        newPiece.fireDamage = 1;
        newPiece.arrowDamageMultiplier = 1;
        newPiece.mainClass = Archer;

    }
    if (type == 13){
        
        /* CrossbowMan */
        
        newPiece = [SKPiece spriteNodeWithImageNamed:@"archer.png"];
        newPiece.player = player;
        newPiece.pieceType = type;
        newPiece.moveSpeed = 1;
        newPiece.size = CGSizeMake(40, 40);
        newPiece.hitPoints = 3;
        newPiece.attackDamage = 7;
        newPiece.rangeMin = 1;
        newPiece.rangeMax = 2;
        newPiece.fireDamageMultiplier = 1;
        newPiece.fireDamage = 0;
        newPiece.arrowDamageMultiplier = 1;
        newPiece.mainClass = Archer;
    }
    if (type == 14){
        
        /* ChivalryArcher */
        
        newPiece = [SKPiece spriteNodeWithImageNamed:@"horse.png"];
        newPiece.player = player;
        newPiece.pieceType = type;
        newPiece.moveSpeed = 2;
        newPiece.size = CGSizeMake(40, 40);
        newPiece.hitPoints = 10;
        newPiece.attackDamage = 5;
        newPiece.rangeMin = 1;
        newPiece.rangeMax = 2;
        newPiece.fireDamageMultiplier = 1;
        newPiece.fireDamage = 0;
        newPiece.mainClass = Chivalry;
        newPiece.arrowDamageMultiplier = 1;

    }
    if (type == 15){
        
        /* Templar */
        
        newPiece = [SKPiece spriteNodeWithImageNamed:@"horse.png"];
        newPiece.player = player;
        newPiece.pieceType = type;
        newPiece.moveSpeed = 1;
        newPiece.size = CGSizeMake(40, 40);
        newPiece.hitPoints = 12;
        newPiece.attackDamage = 6;
        newPiece.rangeMin = 1;
        newPiece.rangeMax = 1;
        newPiece.fireDamageMultiplier = 0;
        newPiece.fireDamage = 0;
        newPiece.mainClass = Chivalry;
        newPiece.arrowDamageMultiplier = 0;

    }
    if (type == 16){
        
        /* Barrier */
        
        newPiece = [SKPiece spriteNodeWithImageNamed:@"pawn.png"];
        newPiece.player = player;
        newPiece.pieceType = type;
        newPiece.moveSpeed = 1;
        newPiece.size = CGSizeMake(40, 40);
        newPiece.hitPoints = 5;
        newPiece.attackDamage = 5;
        newPiece.rangeMin = 1;
        newPiece.rangeMax = 1;
        newPiece.fireDamageMultiplier = 1;
        newPiece.fireDamage = 0;
        newPiece.arrowDamageMultiplier = 0;
        newPiece.hasAction = true;

        
    }
    if (type == 17){
        
        /* Saboteur */
        
        newPiece = [SKPiece spriteNodeWithImageNamed:@"pawn.png"];
        newPiece.player = player;
        newPiece.pieceType = type;
        newPiece.moveSpeed = 1;
        newPiece.size = CGSizeMake(40, 40);
        newPiece.hitPoints = 5;
        newPiece.attackDamage = 5;
        newPiece.rangeMin = 1;
        newPiece.rangeMax = 1;
        newPiece.fireDamageMultiplier = 1;
        newPiece.fireDamage = 0;
        newPiece.arrowDamageMultiplier = 0;
        newPiece.hasAction = true;
        
        
        
    }
    return newPiece;

}

- (void)performActionForPiece{
    

}

@end
