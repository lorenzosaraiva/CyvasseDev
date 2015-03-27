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
    NSMutableArray *possibleAttackers;
    SKCell *lastCell;
    SKCell *currentCell;
    UILabel *mainLabel;
    BOOL isSelected;
    BOOL isWalking;
    BOOL blackPlays;
    BOOL isAttacking;
    BOOL selectAttacker;
    BOOL hasTarget;
    BOOL hasAttacker;
    int moveCounter;
    int cells;
}

-(void)didMoveToView:(SKView *)view {
    isSelected = false;
    blackPlays = false;
    isWalking = false;
    isAttacking = false;
    selectAttacker = false;
    hasTarget = false;
    hasAttacker = false;
    cells = 0;
    moveCounter = 0;
    possibleCellsArray = [[NSMutableArray alloc]init];
    possibleAttackers = [[NSMutableArray alloc]init];
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
    else if (!selectAttacker){
        NSLog(@"Possible Attackers : %d", possibleAttackers.count);
        [self checkSelectedCell:positionInScene ofPlayer:blackPlays? Black:White];
    }
    else
        [self attackCell:positionInScene];

}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}


/* Verifica se há ataques possíveis */

-(BOOL)checkPossibleAttacksOfPlayer:(int)player{
    SKCell *tempCell;
    SKAction * unSelect = [SKAction colorizeWithColor:lastCell.cellColor colorBlendFactor:1.0f duration:0.0f];
    [lastCell runAction:unSelect];
    hasAttacker = false;
    [possibleCellsArray removeAllObjects];
    for (int i = 0; i < cellArray.count; i++){
        tempCell = [cellArray objectAtIndex:i];
        if (tempCell.currentPiece.player == player || tempCell.currentPiece.pieceType == Tower)
            continue;
        [self highlightAttackOptionsOfCell:tempCell withRangeMin:tempCell.currentPiece.rangeMin andMax:tempCell.currentPiece.rangeMax];
        if ( hasTarget == true ){
            [possibleAttackers addObject:tempCell];
            [tempCell runAction:[SKAction colorizeWithColor:[UIColor purpleColor] colorBlendFactor:1.0f duration:0.0]];
            hasAttacker = true;
        }
        [self unHighlightCells];
    }
    NSLog(@"Resultado : %d",hasAttacker);
    return hasAttacker;
}

-(void)attackCell:(CGPoint)positionInScene{
    SKCell *tempCell;
    NSLog(@"Attack Cell");
    for (int i = 0; i < possibleCellsArray.count; i++){
        tempCell = [possibleCellsArray objectAtIndex:i];
        if ([tempCell containsPoint:positionInScene]){
            [self checkAttackersOnCell:tempCell];
        }
    }
    isAttacking = !isAttacking;
    blackPlays = !blackPlays;
    selectAttacker = !selectAttacker;
    isSelected = !isSelected;
    SKAction * unSelect = [SKAction colorizeWithColor:lastCell.cellColor colorBlendFactor:1.0f duration:0.0f];
    [lastCell runAction:unSelect];
    [possibleAttackers removeAllObjects];
    [self unHighlightCells];
}

-(void)checkAttackersOnCell:(SKCell*)targetCell{
    SKCell *tempCell;
    SKAction * unSelect = [SKAction colorizeWithColor:lastCell.cellColor colorBlendFactor:1.0f duration:0.0f];
    [lastCell runAction:unSelect];
    [possibleCellsArray removeAllObjects];
    for (int i = 0; i < possibleAttackers.count; i++){
        tempCell = [possibleAttackers objectAtIndex:i];
        [self highlightAttackOptionsOfCell:tempCell withRangeMin:tempCell.currentPiece.rangeMin andMax:tempCell.currentPiece.rangeMax];
        if ([possibleCellsArray containsObject:targetCell]){
            int temp = targetCell.currentPiece.hitPoints;
            targetCell.currentPiece.hitPoints -= tempCell.currentPiece.attackDamage;
            NSLog(@"Piece one attacks piece two with %d damage. Piece two hp goes from %d -> %d", tempCell.currentPiece.attackDamage, temp, targetCell.currentPiece.hitPoints);
            if (targetCell.currentPiece.hitPoints <= 0){
                [targetCell removeAllChildren];
                targetCell.currentPiece = nil;
            }
        }
        }
        [targetCell runAction:[SKAction colorizeWithColor:targetCell.cellColor colorBlendFactor:1.0f duration:0.0f]];
        [self unHighlightAttackersCells];
        [self unHighlightCells];
    }


/* checa qual celula foi clicada */

-(void)checkSelectedCell:(CGPoint)positionInScene ofPlayer:(Player)player{
    SKCell *tempCell;
    if (!isWalking){
        for (int i = 0; !isAttacking? i < cellArray.count : i < possibleAttackers.count; i++){
            tempCell = !isAttacking ? [cellArray objectAtIndex:i] : [possibleAttackers objectAtIndex:i];
        if ([tempCell containsPoint:positionInScene] && tempCell.currentPiece != nil && tempCell.currentPiece.pieceType != Tower){
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
    SKAction * select = [SKAction colorizeWithColor:[UIColor greenColor] colorBlendFactor:1.0f duration:0.0f];
    [cell runAction:select];
    currentCell = cell;
    isSelected = true;
    if (cell.currentPiece != nil){
        if (!isAttacking)
            [self highlightOptionsOfCell:cell];
        else{
            [self highlightAttackOptionsOfCell:cell withRangeMin:cell.currentPiece.rangeMin andMax:cell.currentPiece.rangeMax];
            selectAttacker = !selectAttacker;
        }
    }
}


-(void)movePiece:(SKPiece*)piece ToCell:(CGPoint)positionInScene{
    SKCell *destinyCell;
    if (possibleCellsArray.count == 0){
        isWalking = false;
        isSelected = false;
        isAttacking = true;
    }
    NSLog(@"looking FOR");
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
                    moveCounter = 0;
                    isWalking = false;
                    isSelected = false;
                    [self unHighlightCells];
                    if ([self checkPossibleAttacksOfPlayer:blackPlays]){
                        isAttacking = true;
                        NSLog(@"Possible Attackers : %d", possibleAttackers.count);
                    }
                    else{
                        blackPlays = !blackPlays;
                        NSLog(@"Possible Attackers : %d", possibleAttackers.count);

                    }
                    
                }
            }
            
            
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

-(void)unHighlightAttackersCells{
    SKCell *tempCell;
    for (int i = 0; i < possibleAttackers.count; i++){
        tempCell = [possibleAttackers objectAtIndex:i];
        [tempCell runAction:[SKAction colorizeWithColor:tempCell.cellColor colorBlendFactor:1.0f duration:0.0f]];
    }
    [possibleAttackers removeAllObjects];
}


-(void)createMap{

    BOOL blackOrWhite = false;
    
    mainLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - 300, 0,300, 100)];
    mainLabel.backgroundColor = [UIColor redColor];
    [self.view addSubview:mainLabel];
    cellArray = [[NSMutableArray alloc]init];
    for (int g = 0; g < 4; g++){
        for (int h = 0; h < 6; h++){
            UIColor * color = blackOrWhite? [UIColor brownColor]:[UIColor darkGrayColor];
            SKCell *cell = [SKCell initWithColor:color];
            [self addChild:cell];
            [cellArray addObject:cell];
            cell.index = cells;
            cell.line = g;
            cell.column = h + 5;
            cells++;
            int a = CGRectGetMidX(self.frame) - 120;
            int b = CGRectGetMidY(self.frame) + 360;
            cell.position = CGPointMake(a + h * 40, b - g * 40);
            [self pieceForCell:cell];
            blackOrWhite = !blackOrWhite;
        }
        blackOrWhite = !blackOrWhite;
    }
    blackOrWhite = !blackOrWhite;
    for (int i = 0; i < 8; i++){
        for (int j = 0; j < 8; j++){
            
            UIColor * color = blackOrWhite? [UIColor brownColor]:[UIColor darkGrayColor];
            SKCell *cell = [SKCell initWithColor:color];
            cell.line = i + 4;
            cell.column = j + 4;
            [self addChild:cell];
            [cellArray addObject:cell];
            int a = CGRectGetMidX(self.frame) - 160;
            int b = CGRectGetMidY(self.frame) + 200;
            cell.position = CGPointMake(a + j * 40, b - i * 40);
            cell.index = cells;
            cells++;
            [self pieceForCell:cell];
            blackOrWhite = !blackOrWhite;
        }
        blackOrWhite = !blackOrWhite;
    }
    
    blackOrWhite = !blackOrWhite;
    for (int g = 0; g < 4; g++){
        for (int h = 0; h < 6; h++){
            UIColor * color = blackOrWhite? [UIColor brownColor]:[UIColor darkGrayColor];
            SKCell *cell = [SKCell initWithColor:color];
            [self addChild:cell];
            [cellArray addObject:cell];
            cell.index = cells;
            cell.line = g + 12;
            cell.column = h + 5;
            cells++;
            int a = CGRectGetMidX(self.frame) - 120;
            int b = CGRectGetMidY(self.frame) - 120;
            cell.position = CGPointMake(a + h * 40, b - g * 40);
            [self pieceForCell:cell];
            blackOrWhite = !blackOrWhite;
        }
        blackOrWhite = !blackOrWhite;
    }
    
    for (int g = 0; g < 6; g++){
        for (int h = 0; h < 4; h++){
            NSLog(@"a");
            UIColor * color = blackOrWhite? [UIColor brownColor]:[UIColor darkGrayColor];
            SKCell *cell = [SKCell initWithColor:color];
            [self addChild:cell];
            [cellArray addObject:cell];
            cell.index = cells;
            cell.line = g + 5;
            cell.column = h + 12;
            cells++;
            int a = CGRectGetMidX(self.frame) + 160;
            int b = CGRectGetMidY(self.frame) + 160;
            cell.position = CGPointMake(a + h * 40, b - g * 40);
            blackOrWhite = !blackOrWhite;
        }
        blackOrWhite = !blackOrWhite;
    }
    
    for (int g = 0; g < 6; g++){
        for (int h = 0; h < 4; h++){
            UIColor * color = blackOrWhite? [UIColor brownColor]:[UIColor darkGrayColor];
            SKCell *cell = [SKCell initWithColor:color];
            [self addChild:cell];
            [cellArray addObject:cell];
            cell.index = cells;
            cell.line = g + 5;
            cell.column = h;
            cells++;
            int a = CGRectGetMidX(self.frame) - 320;
            int b = CGRectGetMidY(self.frame) + 160;
            cell.position = CGPointMake(a + h * 40, b - g * 40);
            blackOrWhite = !blackOrWhite;
        }
        blackOrWhite = !blackOrWhite;
    }
    

}
-(void)pieceForCell:(SKCell*)cell{
    SKPiece *newPiece;
    Player player =  cell.line < 10? Black:White;
    
    if (cell.line == 0 || cell.line == 15){
        switch (cell.column) {
            case 5:
                newPiece = [SKPiece initPieceOfType:Archer ofPlayer:player];
                break;
            case 6:
                newPiece = [SKPiece initPieceOfType:LightMage ofPlayer:player];
                break;
            case 7:
                newPiece = [SKPiece initPieceOfType:King ofPlayer:player];
                break;
            case 8:
                newPiece = [SKPiece initPieceOfType:RoyalGuard ofPlayer:player];
                break;
            case 9:
                newPiece = [SKPiece initPieceOfType:FireMage ofPlayer:player];
                break;
            case 10:
                newPiece = [SKPiece initPieceOfType:Archer ofPlayer:player];
                break;
        }
    }
    
    if (cell.line == 1 || cell.line == 14){
        switch (cell.column) {
            case 5:
                newPiece = [SKPiece initPieceOfType:Archer ofPlayer:player];
                break;
            case 6:
                newPiece = [SKPiece initPieceOfType:Chivalry ofPlayer:player];
                break;
            case 7:
                newPiece = [SKPiece initPieceOfType:Dragon ofPlayer:player];
                break;
            case 8:
                newPiece = [SKPiece initPieceOfType:DragonSlayer ofPlayer:player];
                break;
            case 9:
                newPiece = [SKPiece initPieceOfType:Chivalry ofPlayer:player];
                break;
            case 10:
                newPiece = [SKPiece initPieceOfType:Archer ofPlayer:player];
                break;
        }
    }
    
    if (cell.line == 2 || cell.line == 13){
        switch (cell.column) {
            case 5:
                newPiece = [SKPiece initPieceOfType:Infantry ofPlayer:player];
                break;
            case 6:
                newPiece = [SKPiece initPieceOfType:Catapult ofPlayer:player];
                break;
            case 7:
                newPiece = [SKPiece initPieceOfType:Infantry ofPlayer:player];
                break;
            case 8:
                newPiece = [SKPiece initPieceOfType:Infantry ofPlayer:player];
                break;
            case 9:
                newPiece = [SKPiece initPieceOfType:Catapult ofPlayer:player];
                break;
            case 10:
                newPiece = [SKPiece initPieceOfType:Infantry ofPlayer:player];
                break;
        }
    }
    
    if (cell.line == 3 || cell.line == 12){
        switch (cell.column) {
            case 5:
                newPiece = [SKPiece initPieceOfType:Infantry ofPlayer:player];
                break;
            case 6:
                newPiece = [SKPiece initPieceOfType:Chivalry ofPlayer:player];
                break;
            case 7:
                newPiece = [SKPiece initPieceOfType:Infantry ofPlayer:player];
                break;
            case 8:
                newPiece = [SKPiece initPieceOfType:Infantry ofPlayer:player];
                break;
            case 9:
                newPiece = [SKPiece initPieceOfType:Chivalry ofPlayer:player];
                break;
            case 10:
                newPiece = [SKPiece initPieceOfType:Infantry ofPlayer:player];
                break;
        }
    }

    if (cell.line == 5 || cell.line == 10){
        if (cell.column == 5|| cell.column == 10){
            newPiece = [SKPiece initPieceOfType:Tower ofPlayer:player];
        }
    }
    if (newPiece != nil){
        cell.currentPiece = newPiece;
        [cell addChild:newPiece];
        }
   }

-(void)highlightOptionsOfCell:(SKCell*)cell{
    
    SKCell *tempCell;
    NSLog(@"Index da celula principal : %d", currentCell.index);
    if (cell.column != 0){
        tempCell = [self cellForLine:currentCell.line andColumn:currentCell.column - 1];
        if (tempCell != nil)
        if (tempCell.currentPiece == nil && (tempCell.line == currentCell.line)){
            [tempCell runAction:[SKAction colorizeWithColor:[UIColor blueColor] colorBlendFactor:1.0f duration:0.0f]];
            [possibleCellsArray addObject:tempCell];
            NSLog(@"1 - Index da celula : %d", tempCell.index);
        }
    }
    
    
    
    if (cell.column < 16){
        tempCell = [self cellForLine:currentCell.line andColumn:currentCell.column + 1];
        if (tempCell != nil)
        if (tempCell.currentPiece == nil && (tempCell.line == currentCell.line)){
            [tempCell runAction:[SKAction colorizeWithColor:[UIColor blueColor] colorBlendFactor:1.0f duration:0.0f]];
            [possibleCellsArray addObject:tempCell];
            NSLog(@"2 - Index da celula : %d", tempCell.index);
        }
    }
    
    if (cell.line != 15 ){
        tempCell = [self cellForLine:currentCell.line + 1 andColumn:currentCell.column];
        if (tempCell != nil)
        if (tempCell.currentPiece == nil){
            [tempCell runAction:[SKAction colorizeWithColor:[UIColor blueColor] colorBlendFactor:1.0f duration:0.0f]];
            [possibleCellsArray addObject:tempCell];
            NSLog(@"3 - Index da celula : %d", tempCell.index);
        }
    }
    
    if (cell.column != 16 && cell.line != 15 ){
        tempCell = [self cellForLine:currentCell.line + 1 andColumn:currentCell.column + 1];
        if (tempCell != nil)
        if (tempCell.currentPiece == nil && (fabsf(tempCell.column - currentCell.column) == 1) ){
            [tempCell runAction:[SKAction colorizeWithColor:[UIColor blueColor] colorBlendFactor:1.0f duration:0.0f]];
            [possibleCellsArray addObject:tempCell];
            NSLog(@"4 - Index da celula : %d", tempCell.index);
        }
    }
    
    if (cell.column > 0 && cell.line != 15 ){
        tempCell = [self cellForLine:currentCell.line + 1 andColumn:currentCell.column - 1];
         if (tempCell != nil)
        if (tempCell.currentPiece == nil && (fabsf(tempCell.column - currentCell.column) == 1) ){
            [tempCell runAction:[SKAction colorizeWithColor:[UIColor blueColor] colorBlendFactor:1.0f duration:0.0f]];
            [possibleCellsArray addObject:tempCell];
            NSLog(@"5- Index da celula : %d", tempCell.index);
        }
    }
    
    if (cell.line > 0 && cell.column != 15 ){
        tempCell = [self cellForLine:currentCell.line - 1 andColumn:currentCell.column + 1];
        if (tempCell != nil)
        if (tempCell.currentPiece == nil && (fabsf(tempCell.column - currentCell.column) == 1) ){
            [tempCell runAction:[SKAction colorizeWithColor:[UIColor blueColor] colorBlendFactor:1.0f duration:0.0f]];

            [possibleCellsArray addObject:tempCell];
            NSLog(@"6 - Index da celula : %d", tempCell.index);
        }
    }
    
    if (cell.line > 0 ){
        tempCell = [self cellForLine:currentCell.line - 1 andColumn:currentCell.column];
        if (tempCell != nil)
        if (tempCell.currentPiece == nil){
            [tempCell runAction:[SKAction colorizeWithColor:[UIColor blueColor] colorBlendFactor:1.0f duration:0.0f]];
            [possibleCellsArray addObject:tempCell];
            NSLog(@"7 - Index da celula : %d", tempCell.index);
        }
    }
    
    if (cell.line > 0 && cell.column > 0 ){
        tempCell = [self cellForLine:currentCell.line - 1 andColumn:currentCell.column - 1];
        if (tempCell != nil)
        if (tempCell.currentPiece == nil && (fabsf(tempCell.column - currentCell.column) == 1) ){
            [tempCell runAction:[SKAction colorizeWithColor:[UIColor blueColor] colorBlendFactor:1.0f duration:0.0f]];
            [possibleCellsArray addObject:tempCell];
            NSLog(@"8 - Index da celula : %d", tempCell.index);
        }
    }
    
    if (possibleCellsArray.count == 0){
        isSelected = false;
        SKAction * unSelect = [SKAction colorizeWithColor:currentCell.cellColor colorBlendFactor:1.0f duration:0.0f];
        [currentCell runAction:unSelect];
        
    }
}


-(void)highlightAttackOptionsOfCell:(SKCell*)cell withRangeMin:(int)minRange andMax:(int)maxRange{
    
    [possibleCellsArray removeAllObjects];
    SKCell *tempCell;
    if (cell.currentPiece.rangeMin <= 1 && cell.currentPiece.rangeMax >=1){
    if (cell.column != 0){
        tempCell = [self cellForLine:cell.line andColumn:cell.column - 1];
        if (tempCell != nil)
        if (tempCell.currentPiece != nil){
            if (tempCell.currentPiece.player != cell.currentPiece.player){
            [tempCell runAction:[SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:1.0f duration:0.0f]];
            [possibleCellsArray addObject:tempCell];
            }
        }
    }
    
    
    
    
    if (cell.column < 16){
        tempCell = [self cellForLine:cell.line andColumn:cell.column + 1];
        if (tempCell != nil)
        if (tempCell.currentPiece != nil && (tempCell.line == cell.line)){
            if (tempCell.currentPiece.player != cell.currentPiece.player){

            [tempCell runAction:[SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:1.0f duration:0.0f]];
            [possibleCellsArray addObject:tempCell];
            }
        }
    }
        tempCell = nil;
    if (cell.line != 15 ){
        tempCell = [self cellForLine:cell.line + 1 andColumn:cell.column];
        if (tempCell != nil)
        if (tempCell.currentPiece != nil){
            if (tempCell.currentPiece.player != cell.currentPiece.player){

            [tempCell runAction:[SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:1.0f duration:0.0f]];
            [possibleCellsArray addObject:tempCell];
            }
        }
    }
    tempCell = nil;
    if (cell.column != 16 && cell.line != 15 ){
        tempCell = [self cellForLine:cell.line + 1 andColumn:cell.column + 1];
        if (tempCell != nil)
        if (tempCell.currentPiece != nil && (fabsf(tempCell.column - cell.column) == 1) ){
            if (tempCell.currentPiece.player != cell.currentPiece.player){

            [tempCell runAction:[SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:1.0f duration:0.0f]];
            [possibleCellsArray addObject:tempCell];
            }
        }
    }
    tempCell = nil;
    if (cell.column > 0 && cell.line != 15 ){
        tempCell = [self cellForLine:cell.line + 1 andColumn:cell.column - 1];
        if (tempCell != nil)
        if (tempCell.currentPiece != nil && (fabsf(tempCell.column - cell.column) == 1) ){
            if (tempCell.currentPiece.player != cell.currentPiece.player){

            [tempCell runAction:[SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:1.0f duration:0.0f]];
            [possibleCellsArray addObject:tempCell];
            }
        }
    }
    tempCell = nil;
    
    if (cell.line > 0 && cell.column != 15 ){
        tempCell = [self cellForLine:cell.line - 1 andColumn:cell.column + 1];
        if (tempCell != nil)        if (tempCell.currentPiece != nil && (fabsf(tempCell.column - cell.column) == 1) ){
            if (tempCell.currentPiece.player != cell.currentPiece.player){

            [tempCell runAction:[SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:1.0f duration:0.0f]];
            [possibleCellsArray addObject:tempCell];
            }
        }
    }
    tempCell = nil;
    if (cell.line > 0 ){
        tempCell = [self cellForLine:cell.line - 1 andColumn:cell.column];
        if (tempCell != nil)
        if (tempCell.currentPiece != nil){
            if (tempCell.currentPiece.player != cell.currentPiece.player){

            [tempCell runAction:[SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:1.0f duration:0.0f]];
            [possibleCellsArray addObject:tempCell];
            }
        }
    }
        tempCell = nil;
    if (cell.line > 0 && cell.column > 0 ){
        tempCell = [self cellForLine:cell.line - 1 andColumn:cell.column - 1];
        if (tempCell != nil)
        if (tempCell.currentPiece != nil && (fabsf(tempCell.column - cell.column) == 1) ){
            if (tempCell.currentPiece.player != cell.currentPiece.player){

            [tempCell runAction:[SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:1.0f duration:0.0f]];
            [possibleCellsArray addObject:tempCell];
            }
        }
    }
        tempCell = nil;
    }
    
    /*aqui*/
    
    if (cell.currentPiece.rangeMin <= 2 && cell.currentPiece.rangeMax >=2){
        
        NSLog(@"entrou");
        for (int i = -2; i < 3; i ++){
                tempCell = [self cellForLine:cell.line + 2 andColumn:cell.column + i];
                if (tempCell != nil)
                    if (tempCell.currentPiece != nil ){
                        if (tempCell.currentPiece.player != cell.currentPiece.player){
                            [tempCell runAction:[SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:1.0f duration:0.0f]];
                            [possibleCellsArray addObject:tempCell];
                        }
                    }
                tempCell = nil;
        }
        
        for (int i = -2; i < 3; i ++){
            tempCell = [self cellForLine:cell.line - 2 andColumn:cell.column + i];
            if (tempCell != nil)
                if (tempCell.currentPiece != nil ){
                    if (tempCell.currentPiece.player != cell.currentPiece.player){
                        [tempCell runAction:[SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:1.0f duration:0.0f]];
                        [possibleCellsArray addObject:tempCell];
                    }
                }
            tempCell = nil;
        }
        
        for (int i = -1; i < 2; i ++){
            tempCell = [self cellForLine:cell.line +i andColumn:cell.column + 2];
            if (tempCell != nil)
                if (tempCell.currentPiece != nil){
                    if (tempCell.currentPiece.player != cell.currentPiece.player){
                        [tempCell runAction:[SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:1.0f duration:0.0f]];
                        [possibleCellsArray addObject:tempCell];
                    }
                }
            tempCell = nil;
        }
        
        for (int i = -1; i < 2; i ++){
            tempCell = [self cellForLine:cell.line + 1 andColumn:cell.column - 2];
            if (tempCell != nil)
                if (tempCell.currentPiece != nil){
                    if (tempCell.currentPiece.player != cell.currentPiece.player){
                        [tempCell runAction:[SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:1.0f duration:0.0f]];
                        [possibleCellsArray addObject:tempCell];
                    }
                }
            tempCell = nil;
        }
        
    }

    
    NSLog(@"Possible Targets : %d",possibleCellsArray.count);
    if (possibleCellsArray.count == 0){
        hasTarget = false;
    }else{
        hasTarget = true;
    }
    
}

-(SKCell*)cellForLine:(int)line andColumn:(int)column{
    SKCell* tempCell;
    for (int i = 0; i < cellArray.count; i++){
        tempCell = cellArray[i];
        if (tempCell.line == line && tempCell.column == column)
            return tempCell;
    }
    return nil;
}

@end
