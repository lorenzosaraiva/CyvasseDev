//
//  SKCell.h
//  CyvasseDev
//
//  Created by Lorenzo Saraiva on 3/10/15.
//  Copyright (c) 2015 BEPID-PucRJ. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SKPiece.h"

@interface SKCell : SKSpriteNode

@property int line;
@property int column;
@property int cellSize;
@property int index;
@property int test;
@property SKTexture *cellTexture;
@property (nonatomic) SKPiece *currentPiece;


+ (instancetype) initWithColor:(int)color;

@end
