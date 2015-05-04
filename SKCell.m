//
//  SKCell.m
//  CyvasseDev
//
//  Created by Lorenzo Saraiva on 3/10/15.
//  Copyright (c) 2015 BEPID-PucRJ. All rights reserved.
//

#import "SKCell.h"


@implementation SKCell

+ (instancetype) initWithColor:(int)color
{
    
    SKCell * cell = [[SKCell alloc]init];
    SKTexture *texture;
    if (color)
        texture = [SKTexture textureWithImage:[UIImage imageNamed:@"erable.jpg"]];
    else
        texture = [SKTexture textureWithImage:[UIImage imageNamed:@"walnut.jpg"]];
    cell = [SKCell spriteNodeWithTexture:texture size:CGSizeMake(40, 40)];
    cell.cellTexture = texture;
    cell.test = 10;
    cell.currentPiece = nil;
    return cell;
}

@end
