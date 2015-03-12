//
//  GameScene.m
//  CyvasseDev
//
//  Created by Lorenzo Saraiva on 3/10/15.
//  Copyright (c) 2015 BEPID-PucRJ. All rights reserved.
//

#import "GameScene.h"
#import "SKCell.h"
#import "SKPiece.h"

@implementation GameScene{
    
    NSMutableArray *cellArray;
    NSMutableArray *possibleCellsArray;
    SKCell *lastCell;
    BOOL isSelected;
}

-(void)didMoveToView:(SKView *)view {
    isSelected = false;
    possibleCellsArray = [[NSMutableArray alloc]init];
    [self createMap];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    
    if (!isSelected)
        [self checkSelectedCell:positionInScene];
    else
        [self movePieceToCell:positionInScene];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

-(void)checkSelectedCell:(CGPoint)positionInScene{
    SKCell *tempCell;
    for (int i = 0; i < cellArray.count; i++){
        tempCell = [cellArray objectAtIndex:i];
        if ([tempCell containsPoint:positionInScene] && tempCell.currentPiece != nil){
            SKAction * unSelect = [SKAction colorizeWithColor:lastCell.cellColor colorBlendFactor:1.0f duration:0.1f];
            [lastCell runAction:unSelect];
            SKAction * select = [SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:1.0f duration:0.1f];
            [tempCell runAction:select];
            lastCell = tempCell;
            isSelected = true;
            if (tempCell.currentPiece != nil)
                [self highlightOptionsOfCellAtIndex:i];
        }
    }

}

-(void)highlightOptionsOfCellAtIndex:(int)cellIndex{

    SKCell *tempCell = [cellArray objectAtIndex:cellIndex - 1];
    [tempCell runAction:[SKAction colorizeWithColor:[UIColor blueColor] colorBlendFactor:1.0f duration:0.1f]];
    [possibleCellsArray addObject:tempCell];
    
    tempCell = [cellArray objectAtIndex:cellIndex + 1];
    [tempCell runAction:[SKAction colorizeWithColor:[UIColor blueColor] colorBlendFactor:1.0f duration:0.1f]];
    [possibleCellsArray addObject:tempCell];
    
    tempCell = [cellArray objectAtIndex:cellIndex + 8];
    [tempCell runAction:[SKAction colorizeWithColor:[UIColor blueColor] colorBlendFactor:1.0f duration:0.1f]];
    [possibleCellsArray addObject:tempCell];
    
    tempCell = [cellArray objectAtIndex:cellIndex + 9];
    [tempCell runAction:[SKAction colorizeWithColor:[UIColor blueColor] colorBlendFactor:1.0f duration:0.1f]];
    [possibleCellsArray addObject:tempCell];
    
    tempCell = [cellArray objectAtIndex:cellIndex + 7];
    [tempCell runAction:[SKAction colorizeWithColor:[UIColor blueColor] colorBlendFactor:1.0f duration:0.1f]];
    [possibleCellsArray addObject:tempCell];
    
    tempCell = [cellArray objectAtIndex:cellIndex - 7];
    [tempCell runAction:[SKAction colorizeWithColor:[UIColor blueColor] colorBlendFactor:1.0f duration:0.1f]];
    [possibleCellsArray addObject:tempCell];
    
    tempCell = [cellArray objectAtIndex:cellIndex - 8];
    [tempCell runAction:[SKAction colorizeWithColor:[UIColor blueColor] colorBlendFactor:1.0f duration:0.1f]];
    [possibleCellsArray addObject:tempCell];
    
    tempCell = [cellArray objectAtIndex:cellIndex - 9];
    [tempCell runAction:[SKAction colorizeWithColor:[UIColor blueColor] colorBlendFactor:1.0f duration:0.1f]];
    [possibleCellsArray addObject:tempCell];
    
}

-(void)movePieceToCell:(CGPoint)positionInScene{
    SKCell *destinyCell;
    for (int i = 0; i < cellArray.count; i++){
        destinyCell = [cellArray objectAtIndex:i];
        if ([destinyCell containsPoint:positionInScene] ){
            if (lastCell.currentPiece != nil && [possibleCellsArray containsObject:destinyCell]){
            destinyCell.currentPiece = lastCell.currentPiece;
            lastCell.currentPiece = nil;
            [lastCell removeAllChildren];
            [destinyCell addChild:destinyCell.currentPiece];
            }
            SKAction * unSelect = [SKAction colorizeWithColor:lastCell.cellColor colorBlendFactor:1.0f duration:0.1f];
            [lastCell runAction:unSelect];
            [self unHighlightCells];
            isSelected = false;
        }
    }

}

-(void)unHighlightCells{
    SKCell *tempCell;
    for (int i = 0; i < possibleCellsArray.count; i++){
        tempCell = [possibleCellsArray objectAtIndex:i];
        [tempCell runAction:[SKAction colorizeWithColor:tempCell.cellColor colorBlendFactor:1.0f duration:0.1f]];
    }
    [possibleCellsArray removeAllObjects];
}


-(void)createMap{

    BOOL blackOrWhite = true;
    cellArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < 8; i++){
        for (int j = 0; j < 8; j++){
            
            UIColor * color = blackOrWhite? [UIColor blackColor]:[UIColor whiteColor];
            SKCell *cell = [SKCell initWithColor:color];
            cell.line = i;
            cell.column = j;
            [self addChild:cell];
            [cellArray addObject:cell];
            int a = CGRectGetMidX(self.frame) - 200;
            int b = CGRectGetMidY(self.frame) + 200;
            cell.position = CGPointMake(a + j * 40, b - i * 40);
    
            if (i < 2 || i > 5){
            SKPiece *newPiece = [SKPiece initPieceOfType:King];
            cell.currentPiece = newPiece;
            [cell addChild:newPiece];
            }
            
            blackOrWhite = !blackOrWhite;
        }
        blackOrWhite = !blackOrWhite;
    }

}

@end
