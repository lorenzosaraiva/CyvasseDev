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
    SKCell *currentCell;
    BOOL isSelected;
    BOOL isWalking;
    BOOL blackPlays;
    BOOL isAttacking;
    int moveCounter;
}

-(void)didMoveToView:(SKView *)view {
    isSelected = false;
    blackPlays = false;
    isWalking = false;
    isAttacking = false;
    moveCounter = 0;
    possibleCellsArray = [[NSMutableArray alloc]init];
    [self createMap];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    
    if (!isSelected && !isAttacking)
        [self checkSelectedCell:positionInScene ofPlayer:blackPlays? Black:White];
    else if (!isAttacking)
        [self movePiece:(SKPiece*)currentCell.currentPiece ToCell:positionInScene];
    else
         [self attackCell];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

-(void)attackCell{
    
    isAttacking = !isAttacking;

}

-(void)checkSelectedCell:(CGPoint)positionInScene ofPlayer:(Player)player{
    SKCell *tempCell;
    if (!isWalking){
    for (int i = 0; i < cellArray.count; i++){
        tempCell = [cellArray objectAtIndex:i];
        if ([tempCell containsPoint:positionInScene] && tempCell.currentPiece != nil){
            SKPiece *tempPiece = tempCell.currentPiece;
            if (tempPiece.player == player){
                [self selectCell:tempCell];
            }
        }
    }
}
}

-(void)selectCell:(SKCell*)cell{
    lastCell = currentCell;
    SKAction * unSelect = [SKAction colorizeWithColor:lastCell.cellColor colorBlendFactor:1.0f duration:0.0f];
    [lastCell runAction:unSelect];
    SKAction * select = [SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:1.0f duration:0.0f];
    [cell runAction:select];
    currentCell = cell;
    isSelected = true;
    if (cell.currentPiece != nil)
        [self highlightOptionsOfCellAtIndex:cell.index];

}


-(void)movePiece:(SKPiece*)piece ToCell:(CGPoint)positionInScene{
    SKCell *destinyCell;
    for (int i = 0; i < cellArray.count; i++){
        destinyCell = [cellArray objectAtIndex:i];
        if ([destinyCell containsPoint:positionInScene] ){
            if (currentCell.currentPiece != nil && [possibleCellsArray containsObject:destinyCell] && destinyCell.currentPiece == nil){
                destinyCell.currentPiece = currentCell.currentPiece;
                currentCell.currentPiece = nil;
                [currentCell removeAllChildren];
                [destinyCell addChild:destinyCell.currentPiece];
                currentCell = destinyCell;
                isWalking = true;
                [self unHighlightCells];
                [self selectCell:destinyCell];
                moveCounter++;
                if (moveCounter == piece.moveSpeed){
                    blackPlays = !blackPlays;
                    moveCounter = 0;
                    isWalking = false;
                    isSelected = false;
                    isAttacking = true;
                    [self unHighlightCells];
                    [self highlightAttackOptionsOfCellAtIndex:currentCell.index];
                    NSLog(@"entrou");
                }
                
            }
            SKAction * unSelect = [SKAction colorizeWithColor:lastCell.cellColor colorBlendFactor:1.0f duration:0.0f];
            [lastCell runAction:unSelect];
            
            
        }
    }
}

-(void)unHighlightCells{
    SKCell *tempCell;
    for (int i = 0; i < possibleCellsArray.count; i++){
        tempCell = [possibleCellsArray objectAtIndex:i];
        [tempCell runAction:[SKAction colorizeWithColor:tempCell.cellColor colorBlendFactor:1.0f duration:0.0f]];
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
            cell.position = CGPointMake(a + j * 50, b - i * 50);
            cell.index = i * 8 + j;
            if (i < 2 || i > 5){
                Player player = i < 3? Black:White;
                SKPiece *newPiece = [SKPiece initPieceOfType:i < 3? King:Queen ofPlayer:player];
                cell.currentPiece = newPiece;
                [cell addChild:newPiece];
            }
            
            blackOrWhite = !blackOrWhite;
        }
        blackOrWhite = !blackOrWhite;
    }

}

-(void)highlightOptionsOfCellAtIndex:(int)cellIndex{
    
    SKCell *tempCell;
    if (cellIndex != 0){
        tempCell = [cellArray objectAtIndex:cellIndex - 1];
        if (tempCell.currentPiece == nil && (tempCell.line == currentCell.line)){
            [tempCell runAction:[SKAction colorizeWithColor:[UIColor blueColor] colorBlendFactor:1.0f duration:0.0f]];
            [possibleCellsArray addObject:tempCell];
        }
    }
    
    
    
    if (cellIndex + 1 < cellArray.count){
        tempCell = [cellArray objectAtIndex:cellIndex + 1];
        if (tempCell.currentPiece == nil && (tempCell.line == currentCell.line)){
            [tempCell runAction:[SKAction colorizeWithColor:[UIColor blueColor] colorBlendFactor:1.0f duration:0.0f]];
            [possibleCellsArray addObject:tempCell];
        }
    }
    
    if (cellIndex + 8 < cellArray.count ){
        tempCell = [cellArray objectAtIndex:cellIndex + 8];
        if (tempCell.currentPiece == nil){
            [tempCell runAction:[SKAction colorizeWithColor:[UIColor blueColor] colorBlendFactor:1.0f duration:0.0f]];
            [possibleCellsArray addObject:tempCell];
        }
    }
    
    if (cellIndex + 9 < cellArray.count ){
        tempCell = [cellArray objectAtIndex:cellIndex + 9];
        if (tempCell.currentPiece == nil && (fabsf(tempCell.column - currentCell.column) == 1) ){
            [tempCell runAction:[SKAction colorizeWithColor:[UIColor blueColor] colorBlendFactor:1.0f duration:0.0f]];
            [possibleCellsArray addObject:tempCell];
        }
    }
    
    if (cellIndex + 7 < cellArray.count ){
        tempCell = [cellArray objectAtIndex:cellIndex + 7];
        if (tempCell.currentPiece == nil && (fabsf(tempCell.column - currentCell.column) == 1) ){
            [tempCell runAction:[SKAction colorizeWithColor:[UIColor blueColor] colorBlendFactor:1.0f duration:0.0f]];
            [possibleCellsArray addObject:tempCell];
        }
    }
    
    if (cellIndex - 7 >= 0 ){
        tempCell = [cellArray objectAtIndex:cellIndex - 7];
        if (tempCell.currentPiece == nil && (fabsf(tempCell.column - currentCell.column) == 1) ){
            [tempCell runAction:[SKAction colorizeWithColor:[UIColor blueColor] colorBlendFactor:1.0f duration:0.0f]];
            [possibleCellsArray addObject:tempCell];
        }
    }
    
    if (cellIndex - 8 >= 0 ){
        tempCell = [cellArray objectAtIndex:cellIndex - 8];
        if (tempCell.currentPiece == nil){
            [tempCell runAction:[SKAction colorizeWithColor:[UIColor blueColor] colorBlendFactor:1.0f duration:0.0f]];
            [possibleCellsArray addObject:tempCell];
        }
    }
    
    if (cellIndex - 9 >= 0 ){
        tempCell = [cellArray objectAtIndex:cellIndex - 9];
        if (tempCell.currentPiece == nil && (fabsf(tempCell.column - currentCell.column) == 1) ){
            [tempCell runAction:[SKAction colorizeWithColor:[UIColor blueColor] colorBlendFactor:1.0f duration:0.0f]];
            [possibleCellsArray addObject:tempCell];
        }
    }
    
}


-(void)highlightAttackOptionsOfCellAtIndex:(int)cellIndex{
    
    SKCell *tempCell;
    if (cellIndex != 0){
        tempCell = [cellArray objectAtIndex:cellIndex - 1];
        if (tempCell.currentPiece != nil && (tempCell.line == currentCell.line)){
            [tempCell runAction:[SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:1.0f duration:0.0f]];
            [possibleCellsArray addObject:tempCell];
        }
    }
    
    
    
    if (cellIndex + 1 < cellArray.count){
        tempCell = [cellArray objectAtIndex:cellIndex + 1];
        if (tempCell.currentPiece != nil && (tempCell.line == currentCell.line)){
            [tempCell runAction:[SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:1.0f duration:0.0f]];
            [possibleCellsArray addObject:tempCell];
        }
    }
    
    if (cellIndex + 8 < cellArray.count ){
        tempCell = [cellArray objectAtIndex:cellIndex + 8];
        if (tempCell.currentPiece != nil){
            [tempCell runAction:[SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:1.0f duration:0.0f]];
            [possibleCellsArray addObject:tempCell];
        }
    }
    
    if (cellIndex + 9 < cellArray.count ){
        tempCell = [cellArray objectAtIndex:cellIndex + 9];
        if (tempCell.currentPiece != nil && (fabsf(tempCell.column - currentCell.column) == 1) ){
            [tempCell runAction:[SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:1.0f duration:0.0f]];
            [possibleCellsArray addObject:tempCell];
        }
    }
    
    if (cellIndex + 7 < cellArray.count ){
        tempCell = [cellArray objectAtIndex:cellIndex + 7];
        if (tempCell.currentPiece != nil && (fabsf(tempCell.column - currentCell.column) == 1) ){
            [tempCell runAction:[SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:1.0f duration:0.0f]];
            [possibleCellsArray addObject:tempCell];
        }
    }
    
    if (cellIndex - 7 >= 0 ){
        tempCell = [cellArray objectAtIndex:cellIndex - 7];
        if (tempCell.currentPiece != nil && (fabsf(tempCell.column - currentCell.column) == 1) ){
            [tempCell runAction:[SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:1.0f duration:0.0f]];
            [possibleCellsArray addObject:tempCell];
        }
    }
    
    if (cellIndex - 8 >= 0 ){
        tempCell = [cellArray objectAtIndex:cellIndex - 8];
        if (tempCell.currentPiece != nil){
            [tempCell runAction:[SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:1.0f duration:0.0f]];
            [possibleCellsArray addObject:tempCell];
        }
    }
    
    if (cellIndex - 9 >= 0 ){
        tempCell = [cellArray objectAtIndex:cellIndex - 9];
        if (tempCell.currentPiece != nil && (fabsf(tempCell.column - currentCell.column) == 1) ){
            [tempCell runAction:[SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:1.0f duration:0.0f]];
            [possibleCellsArray addObject:tempCell];
        }
    }
    
}


@end
