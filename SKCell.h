//
//  SKCell.h
//  CyvasseDev
//
//  Created by Lorenzo Saraiva on 3/10/15.
//  Copyright (c) 2015 BEPID-PucRJ. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKCell : SKSpriteNode

@property int line;
@property int column;

+ (instancetype) initWithColor:(UIColor*)color;

@end
