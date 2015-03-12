//
//  SKPiece.m
//  CyvasseDev
//
//  Created by Lorenzo Saraiva on 3/11/15.
//  Copyright (c) 2015 BEPID-PucRJ. All rights reserved.
//

#import "SKPiece.h"

@implementation SKPiece

+ (instancetype) initPieceOfType:(PieceType)type{

    SKPiece *newPiece;
    
    if (type == 0){
        
        newPiece.pieceType = 0;
        newPiece = [SKPiece spriteNodeWithImageNamed:@"King.png"];
        newPiece.size = CGSizeMake(30, 30);
    
    }
    return newPiece;

}

@end
