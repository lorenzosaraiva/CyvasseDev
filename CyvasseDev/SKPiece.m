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
    if (type == 0){
        
        
        newPiece = [SKPiece spriteNodeWithImageNamed:@"King.png"];
        newPiece.player = player;
        newPiece.pieceType = type;
        newPiece.moveSpeed = 3;
        newPiece.size = CGSizeMake(40, 40);
        
    }
    
    if (type == 1){
    
       
        newPiece = [SKPiece spriteNodeWithImageNamed:@"Queen.png"];
        newPiece.player = player;
        newPiece.pieceType = type;
        newPiece.moveSpeed = 3;
        newPiece.size = CGSizeMake(40, 40);
        
       
    }
    return newPiece;

}

@end
