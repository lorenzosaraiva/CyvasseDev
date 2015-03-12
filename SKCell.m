//
//  SKCell.m
//  CyvasseDev
//
//  Created by Lorenzo Saraiva on 3/10/15.
//  Copyright (c) 2015 BEPID-PucRJ. All rights reserved.
//

#import "SKCell.h"


@implementation SKCell

+ (instancetype) initWithColor:(UIColor*)color
{
    
    SKCell * cell;
    cell = [SKCell spriteNodeWithColor:color size:CGSizeMake(50, 50)];
    cell.cellColor = color;
    cell.currentPiece = nil;
    return cell;
}

@end
