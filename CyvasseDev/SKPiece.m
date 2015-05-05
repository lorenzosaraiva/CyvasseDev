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
        newPiece = player? [SKPiece spriteNodeWithImageNamed:@"king"]:[SKPiece spriteNodeWithImageNamed:@"altking.png"];
        newPiece.player = player;
        newPiece.pieceType = type;
        newPiece.moveSpeed = 2;
        newPiece.size = CGSizeMake(40, 40);
        newPiece.hitPoints = 8;
        newPiece.attackDamage = 2;
        newPiece.rangeMin = 1;
        newPiece.rangeMax = 1;
        newPiece.fireDamageMultiplier = 1;
        newPiece.fireDamage = 0;
        newPiece.arrowDamageMultiplier = 1;
        newPiece.maxHitPoints = newPiece.hitPoints;
        

    }
    
    if (type == 1){
        newPiece =  player? [SKPiece spriteNodeWithImageNamed:@"pawn"]:[SKPiece spriteNodeWithImageNamed:@"altpawn"];
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
        newPiece.maxHitPoints = newPiece.hitPoints;


    }
    
    if (type == 2){
        newPiece = player? [SKPiece spriteNodeWithImageNamed:@"archer"]:[SKPiece spriteNodeWithImageNamed:@"altarcher"];
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
        newPiece.maxHitPoints = newPiece.hitPoints;
    
    }
    
    if (type == 3){
        /* Scout */
        newPiece = player? [SKPiece spriteNodeWithImageNamed:@"horse"]:[SKPiece spriteNodeWithImageNamed:@"althorse"];
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
        newPiece.maxHitPoints = newPiece.hitPoints;

    }
    
    if (type == 4){
        /* FireMage */
        newPiece = player? [SKPiece spriteNodeWithImageNamed:@"firemage"]:[SKPiece spriteNodeWithImageNamed:@"altfiremage"];
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
        newPiece.mainClass = Mage;
        newPiece.maxHitPoints = newPiece.hitPoints;

    }
    
    if (type == 5){
        /* LightMage */
        newPiece = player? [SKPiece spriteNodeWithImageNamed:@"lightmage"]:[SKPiece spriteNodeWithImageNamed:@"altlightmage"];
        newPiece.player = player;
        newPiece.pieceType = type;
        newPiece.moveSpeed = 1;
        newPiece.size = CGSizeMake(40, 40);
        newPiece.hitPoints = 3;
        newPiece.attackDamage = 2;
        newPiece.rangeMin = 1;
        newPiece.rangeMax = 2;
        newPiece.fireDamageMultiplier = 1;
        newPiece.fireDamage = 0;
        newPiece.arrowDamageMultiplier = 1;
        newPiece.hasAction = true;
        newPiece.mainClass = Mage;
        newPiece.maxHitPoints = newPiece.hitPoints;
        
    }
    
    if (type == 6){
        newPiece = player? [SKPiece spriteNodeWithImageNamed:@"royalguard.png"]:[SKPiece spriteNodeWithImageNamed:@"altroyalguard.png"];
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
        newPiece.maxHitPoints = newPiece.hitPoints;
        newPiece.hasAction = true;
        
    }
    
    if (type == 7){
        newPiece = player? [SKPiece spriteNodeWithImageNamed:@"dragon"]:[SKPiece spriteNodeWithImageNamed:@"altdragon"];
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
        newPiece.mainClass = Chivalry;
        newPiece.maxHitPoints = newPiece.hitPoints;

    }
    
    if (type == 8){
        newPiece = player? [SKPiece spriteNodeWithImageNamed:@"dragonslayer"]:[SKPiece spriteNodeWithImageNamed:@"altdragonslayer"];
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
        newPiece.maxHitPoints = newPiece.hitPoints;
        
    }
    
    if (type == 9){
        newPiece = player? [SKPiece spriteNodeWithImageNamed:@"tower.png"]:[SKPiece spriteNodeWithImageNamed:@"alttower.png"];
        newPiece.player = player;
        newPiece.pieceType = type;
        newPiece.moveSpeed = 0;
        newPiece.size = CGSizeMake(40, 40);
        newPiece.hitPoints = 30;
        newPiece.attackDamage = 5;
        newPiece.rangeMin = 1;
        newPiece.rangeMax = 2;
        newPiece.fireDamageMultiplier = 2;
        newPiece.fireDamage = 0;
        newPiece.arrowDamageMultiplier = 1;
        newPiece.maxHitPoints = newPiece.hitPoints;

    }
    
    if (type == 10){
        /* Catapulta */
        newPiece = player? [SKPiece spriteNodeWithImageNamed:@"catapult.png"]:[SKPiece spriteNodeWithImageNamed:@"altcatapult.png"];
        newPiece.player = player;
        newPiece.pieceType = type;
        newPiece.moveSpeed = 1;
        newPiece.size = CGSizeMake(40, 40);
        newPiece.hitPoints = 3;
        newPiece.attackDamage = 10;
        newPiece.rangeMin = 1;
        newPiece.rangeMax = 2;
        newPiece.fireDamageMultiplier = 2;
        newPiece.fireDamage = 0;
        newPiece.arrowDamageMultiplier = 0;
        newPiece.maxHitPoints = newPiece.hitPoints;

    }
    if (type == 11){
        /* Sniper */
        newPiece = player? [SKPiece spriteNodeWithImageNamed:@"archer"]:[SKPiece spriteNodeWithImageNamed:@"altarcher"];
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
        newPiece.maxHitPoints = newPiece.hitPoints;

    }
    if (type == 12){
        /* FireArcher */
        
        newPiece = player? [SKPiece spriteNodeWithImageNamed:@"archer"]:[SKPiece spriteNodeWithImageNamed:@"altarcher"];
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
        newPiece.maxHitPoints = newPiece.hitPoints;

    }
    if (type == 13){
        
        /* CrossbowMan */
        
        newPiece = player? [SKPiece spriteNodeWithImageNamed:@"archer"]:[SKPiece spriteNodeWithImageNamed:@"altarcher"];
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
        newPiece.maxHitPoints = newPiece.hitPoints;

    }
    if (type == 14){
        
        /* ChivalryArcher */
        
        newPiece = player? [SKPiece spriteNodeWithImageNamed:@"horse"]:[SKPiece spriteNodeWithImageNamed:@"althorse"];
        newPiece.player = player;
        newPiece.pieceType = type;
        newPiece.moveSpeed = 2;
        newPiece.size = CGSizeMake(40, 40);
        newPiece.hitPoints = 10;
        newPiece.attackDamage = 5;
        newPiece.rangeMin = 2;
        newPiece.rangeMax = 3;
        newPiece.fireDamageMultiplier = 1;
        newPiece.fireDamage = 0;
        newPiece.mainClass = Chivalry;
        newPiece.arrowDamageMultiplier = 1;
        newPiece.maxHitPoints = newPiece.hitPoints;


    }
    if (type == 15){
        
        /* Templar */
        
        newPiece = player? [SKPiece spriteNodeWithImageNamed:@"horse"]:[SKPiece spriteNodeWithImageNamed:@"althorse"];
        newPiece.player = player;
        newPiece.pieceType = type;
        newPiece.moveSpeed = 1;
        newPiece.size = CGSizeMake(40, 40);
        newPiece.hitPoints = 12;
        newPiece.attackDamage = 6;
        newPiece.rangeMin = 1;
        newPiece.rangeMax = 2;
        newPiece.fireDamageMultiplier = 0;
        newPiece.fireDamage = 0;
        newPiece.mainClass = Chivalry;
        newPiece.arrowDamageMultiplier = 0;
        newPiece.maxHitPoints = newPiece.hitPoints;


    }
    if (type == 16){
        
        /* Barrier */
        
        newPiece =  player? [SKPiece spriteNodeWithImageNamed:@"pawn"]:[SKPiece spriteNodeWithImageNamed:@"altpawn"];
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
        newPiece.hasAction = false;
        newPiece.maxHitPoints = newPiece.hitPoints;
        
    }
    if (type == 17){
        
        /* Saboteur */
        
        newPiece =  player? [SKPiece spriteNodeWithImageNamed:@"pawn"]:[SKPiece spriteNodeWithImageNamed:@"altpawn"];
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
        newPiece.maxHitPoints = newPiece.hitPoints;

        
    }
    if (type == 18){
        
        /* StoneGiant */
        
        newPiece = [SKPiece spriteNodeWithImageNamed:@"mountain"];
        newPiece.pieceType = type;
        newPiece.moveSpeed = 1;
        newPiece.size = CGSizeMake(40, 40);
        newPiece.hitPoints = 25;
        newPiece.attackDamage = 10;
        newPiece.rangeMin = 1;
        newPiece.rangeMax = 1;
        newPiece.fireDamageMultiplier = 0;
        newPiece.fireDamage = 0;
        newPiece.arrowDamageMultiplier = 0;
        newPiece.hasAction = false;
        newPiece.maxHitPoints = newPiece.hitPoints;
        
        
    }
    if (type == 19){
        
        /* TreeGiant */
        
        newPiece = [SKPiece spriteNodeWithImageNamed:@"tree"];
        newPiece.pieceType = type;
        newPiece.moveSpeed = 2;
        newPiece.size = CGSizeMake(40, 40);
        newPiece.hitPoints = 20;
        newPiece.attackDamage = 8;
        newPiece.rangeMin = 1;
        newPiece.rangeMax = 1;
        newPiece.fireDamageMultiplier = 1.5;
        newPiece.fireDamage = 0;
        newPiece.arrowDamageMultiplier = 0;
        newPiece.hasAction = true;
        newPiece.maxHitPoints = newPiece.hitPoints;
        
        
    }
    return newPiece;

}

- (void)performActionForPiece{

}

- (NSString*) convertToString {
    
    switch (self.pieceType) {
        case 0:
            return @"King";
            break;
        case 1:
            return @"Soldier";
            break;
        case 2:
            return @"Archer";
            break;
        case 3:
            return @"Scout";
            break;
        case 4:
            return @"Fire Mage";
            break;
        case 5:
            return @"Light Mage";
            break;
        case 6:
            return @"Royal Guard";
            break;
        case 7:
            return @"Dragon";
            break;
        case 8:
            return @"Dragon Slayer";
            break;
        case 9:
            return @"Tower";
            break;
        case 10:
            return @"Catapult";
            break;
        case 11:
            return @"Sniper";
            break;
        case 12:
            return @"Incendiary Archer";
            break;
        case 13:
            return @"Crossbow Man";
            break;
        case 14:
            return @"Mounted Archer";
            break;
        case 15:
            return @"Templar";
            break;
        case 16:
            return @"Shield Man";
            break;
        case 17:
            return @"Saboteur";
            break;
        case 18:
            return @"Stone Giant";
            break;
        case 19:
            return @"Tree Giant";
            break;
    }
}

@end
