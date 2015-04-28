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
    NSMutableArray *possibleTowerTargets;
    NSMutableArray *possibleActionCells;
    SKCell *lastCell;
    SKCell *currentCell;
    UILabel *mainLabel;
    UILabel *actionLabel;
    turnPhase currentPhase;
    
    BOOL blackPlays;
    BOOL hasTarget;
    BOOL hasAttacker;
    BOOL actionIsSimple;
    int moveCounter;
    int cells;
}

#pragma mark - DefaultFunctions

-(void)didMoveToView:(SKView *)view {
    blackPlays = false;
    hasTarget = false;
    hasAttacker = false;
    actionIsSimple = false;
    currentPhase = ChoseMove;
    cells = 0;
    moveCounter = 0;
    possibleCellsArray = [[NSMutableArray alloc]init];
    possibleAttackers = [[NSMutableArray alloc]init];
    cellArray = [[NSMutableArray alloc]init];
    possibleTowerTargets = [[NSMutableArray alloc]init];
    possibleActionCells = [[NSMutableArray alloc]init];
    [self createMap];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];

    switch (currentPhase) {
        case ChoseMove:
             [self checkSelectedCell:positionInScene ofPlayer:blackPlays? Black:White];
            break;
        case ChoseDirection:
            [self movePiece:currentCell.currentPiece ToCell:positionInScene];
            break;
        case ChoseAttacker:
            [self checkSelectedCell:positionInScene ofPlayer:blackPlays? Black:White];
            break;
        case ChoseAttackTarget:
            [self attackCell:positionInScene];
            break;
        case ChoseTowerTarget:
            [self attackCellWithTower:positionInScene];
            break;
        case ChoseAction:
            [self performActionOfCell:positionInScene];
            break;
        case ChoseActionTarget:
            [self complexActionForCell:currentCell withTarget:positionInScene];
            break;
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

#pragma mark - CreationFunctions

-(void)createHUD{
    
    mainLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - 300, 0,300, 100)];
    mainLabel.backgroundColor = [UIColor redColor];
    actionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 100)];
    actionLabel.backgroundColor = [UIColor yellowColor];
    actionLabel.userInteractionEnabled = YES;
    [self.view addSubview:mainLabel];
    [self.view addSubview:actionLabel];
    
    
}

-(void)createMap{
    
    BOOL blackOrWhite = false;
    
    //    [self createHUD];
    
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
#pragma mark - SelectFunctions

/* Checa qual celula foi clicada */

-(void)checkSelectedCell:(CGPoint)positionInScene ofPlayer:(Player)player{
    SKCell *tempCell;
    BOOL foundIt = false;
    if (currentPhase != ChoseDirection){
        for (int i = 0; currentPhase != ChoseAttacker? i < cellArray.count : i < possibleAttackers.count; i++){
            tempCell = currentPhase != ChoseAttacker ? [cellArray objectAtIndex:i] : [possibleAttackers objectAtIndex:i];
            if ([tempCell containsPoint:positionInScene] && tempCell.currentPiece != nil && tempCell.currentPiece.pieceType != Tower && tempCell.currentPiece.player == player){
                SKPiece *tempPiece = tempCell.currentPiece;
                if (tempPiece.player == player){
                    foundIt = true;
                    [self selectCell:tempCell];
                }
            }
        }
    }
    if (foundIt){
        currentPhase++;
        NSLog(@"Select function, current phase is %d", currentPhase);
    }
}

-(void)selectCell:(SKCell*)cell{
    lastCell = currentCell;
    if (currentPhase == ChoseMove || currentPhase == ChoseDirection){
        SKAction * unSelect = [SKAction colorizeWithColor:lastCell.cellColor colorBlendFactor:1.0f duration:0.0f];
        [lastCell runAction:unSelect];
    }
    SKAction * select = [SKAction colorizeWithColor:[UIColor greenColor] colorBlendFactor:1.0f duration:0.0f];
    [cell runAction:select];
    currentCell = cell;
    if (cell.currentPiece != nil){
        if (currentPhase == ChoseMove || currentPhase == ChoseDirection)
            [self highlightOptionsOfCell:cell];
        else{
            [self highlightAttackOptionsOfCell:cell withRangeMin:cell.currentPiece.rangeMin andMax:cell.currentPiece.rangeMax];
        }
    }
}

#pragma mark - AttackFunctions
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

/* Controla o ataque */

-(void)attackCell:(CGPoint)positionInScene{
    SKCell *tempCell;
    NSLog(@"Attack Cell");
    for (int i = 0; i < possibleCellsArray.count; i++){
        tempCell = [possibleCellsArray objectAtIndex:i];
        if ([tempCell containsPoint:positionInScene]){
            [self checkAttackersOnCell:tempCell];
        }
    }
    
    SKAction * unSelect = [SKAction colorizeWithColor:lastCell.cellColor colorBlendFactor:1.0f duration:0.0f];
    [lastCell runAction:unSelect];
    [self unHighlightAttackersCells];
    [self unHighlightCells];
    
    if ([self showTowerTargetsOfPlayer:blackPlays]){
        currentPhase = ChoseTowerTarget;
    }
    else if ([self highlightsPossibleActionCellsOfPlayer:blackPlays]){
        currentPhase = ChoseAction;
    }
    else{
        currentPhase = ChoseMove;
        blackPlays = !blackPlays;
    }
}

/* Attaca uma cell com a torre */

-(void)attackCellWithTower:(CGPoint)positionInScene{
    SKCell *tempCell;
   
    for (int i = 0; i < possibleCellsArray.count; i++){
        tempCell = [possibleCellsArray objectAtIndex:i];
        if ([tempCell containsPoint:positionInScene]){
            tempCell.currentPiece.hitPoints -= 5;
             NSLog(@"Tower Attack Cell with 5 damage, %d hp left", currentCell.currentPiece.hitPoints);
            if (tempCell.currentPiece.hitPoints <= 0){
                [tempCell removeAllChildren];
                tempCell.currentPiece = nil;
            
            }
        }
    }
    
    [possibleAttackers removeAllObjects];
    [self unHighlightCells];
    
    if ([self highlightsPossibleActionCellsOfPlayer:blackPlays])
        currentPhase = ChoseAction;
    else{
    currentPhase = ChoseMove;
    blackPlays = !blackPlays;
    }
    
    SKAction * unSelect = [SKAction colorizeWithColor:lastCell.cellColor colorBlendFactor:1.0f duration:0.0f];
    [lastCell runAction:unSelect];
    
}


/* Ve quais pecas atacarão o alvo escolhido */

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
            
            /* Dano com fogo */
            if (currentCell.currentPiece.fireDamage){
                if (tempCell.currentPiece.mainClass == Archer){
                    targetCell.currentPiece.hitPoints -= tempCell.currentPiece.attackDamage * targetCell.currentPiece.arrowDamageMultiplier * targetCell.currentPiece.fireDamageMultiplier;
                }
                else{
                    targetCell.currentPiece.hitPoints -= tempCell.currentPiece.attackDamage * targetCell.currentPiece.fireDamageMultiplier;
                }
            }
            
            /* Dano sem fogo */
            else{
                if (tempCell.currentPiece.mainClass == Archer){
                    targetCell.currentPiece.hitPoints -= tempCell.currentPiece.attackDamage * targetCell.currentPiece.arrowDamageMultiplier;
                }
                else{
                    targetCell.currentPiece.hitPoints -= tempCell.currentPiece.attackDamage;
                }
            
            
            }
            
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



/* Mostra que alvos podem ser atacados pelo jogador */

-(BOOL)showTowerTargetsOfPlayer:(Player)player{
    SKCell * tempCell;
    [possibleTowerTargets removeAllObjects];
    for (int i = 0; i < cellArray.count; i++){
        tempCell = cellArray[i];
        if (tempCell.currentPiece.pieceType == Tower && tempCell.currentPiece.player != player){

            [self highlightAttackOptionsOfCell:tempCell withRangeMin:tempCell.currentPiece.rangeMin andMax:tempCell.currentPiece.rangeMax];
            [possibleTowerTargets addObjectsFromArray:possibleCellsArray];
        }
    }
    for (int i = 0; i < possibleTowerTargets.count; i++){
        SKCell * targetCell = possibleTowerTargets[i];
        [targetCell runAction:[SKAction colorizeWithColor:[UIColor yellowColor] colorBlendFactor:1.0 duration:0.0f]];
    
    }
    NSLog(@"Tower targets are %ld",(unsigned long) possibleTowerTargets.count);
    if (possibleTowerTargets.count == 0){
        return false;
    }
    return true;
}

#pragma mark - MoveFunctions

-(void)movePiece:(SKPiece*)piece ToCell:(CGPoint)positionInScene{
    SKCell *destinyCell;
    
    NSLog(@"Start move function, current phase is %d", currentPhase);
    if (currentCell.currentPiece.mainClass == Chivalry){
        if (currentCell.currentPiece.hitPoints <= 5 ){
            currentCell.currentPiece.moveSpeed = 1;
        }
    }
    for (int i = 0; i < cellArray.count; i++){
        destinyCell = [cellArray objectAtIndex:i];
        if ([destinyCell containsPoint:positionInScene] ){
            if (currentCell.currentPiece != nil && [possibleCellsArray containsObject:destinyCell] && destinyCell.currentPiece == nil){
                destinyCell.currentPiece = currentCell.currentPiece;
                currentCell.currentPiece = nil;
                [currentCell removeAllChildren];
                [destinyCell addChild:destinyCell.currentPiece];
                currentCell = destinyCell;
                [self unHighlightCells];
                [self selectCell:destinyCell];
                
                moveCounter++;
                if (moveCounter == piece.moveSpeed){
                    moveCounter = 0;
                    [self unHighlightCells];
                    if ([self checkPossibleAttacksOfPlayer:blackPlays]){
                        currentPhase = ChoseAttacker;
                        NSLog(@"Possible Attackers : %lu", (unsigned long)possibleAttackers.count);
                    }
                    else{
                        if ([self showTowerTargetsOfPlayer:blackPlays]){
                            currentPhase = ChoseTowerTarget;
                        }else if ([self highlightsPossibleActionCellsOfPlayer:blackPlays]){
                            currentPhase = ChoseAction;
                            
                        }else{
                            currentPhase = ChoseMove;
                            blackPlays = !blackPlays;
                        }
                    }
                    
                }
            }
            
            
        }
    }
    NSLog(@"End move function, current phase is %d", currentPhase);

}

#pragma mark - ActionFunctions

/* Verificada qual foi a peça escolhida para realizar a action */

-(void)performActionOfCell:(CGPoint)positionInScene{
    SKCell * tempCell;
    for (int i = 0; i < possibleActionCells.count; i++){
        tempCell = possibleActionCells[i];
        if ([tempCell containsPoint:positionInScene]){
            [self simpleActionForCell:tempCell];
        }
    }
    if (actionIsSimple){
    [self unHighlightCellsOfAction];
    [self unHighlightCells];
    currentPhase = ChoseMove;
    blackPlays = !blackPlays;
    }
    else{
        currentPhase++;
    }
    NSLog(@"Depois da performAction, a turnPhase é %d", currentPhase);
}

/* Acha a action correspondente dependendo da piece */

-(void)simpleActionForCell:(SKCell*)actionCell{
    
    switch (actionCell.currentPiece.pieceType) {
        case FireMage:
        {
            actionIsSimple = true;
            [self highlightAttackOptionsOfCell:actionCell withRangeMin:1 andMax:1];
            SKAction *burnUp = [SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:1 duration:0.2f];
            SKCell * tempCell;
            for (int i = 0; i < possibleCellsArray.count; i++){
                tempCell = possibleCellsArray[i];
                SKAction *burnDown = [SKAction colorizeWithColor:tempCell.cellColor colorBlendFactor:1 duration:0.2f];
                [tempCell runAction:burnUp completion:^{[tempCell runAction:burnDown];}];
                if (tempCell.currentPiece != nil && tempCell.currentPiece.player != actionCell.currentPiece.player){
                    int temp = tempCell.currentPiece.hitPoints;
                    tempCell.currentPiece.hitPoints -= 5 * tempCell.currentPiece.fireDamageMultiplier;
                    NSLog(@"HP of piece was burned from %d to %d", temp, tempCell.currentPiece.hitPoints);
                    if (tempCell.currentPiece.hitPoints <= 0){
                        [tempCell removeAllChildren];
                        tempCell.currentPiece = nil;
                    }
                }
            }
            break;
        }
        case LightMage:
        {
            
            currentCell = actionCell;
            [self highlightAttackOptionsOfCell:actionCell withRangeMin:2 andMax:2];
            actionIsSimple = false;
            break;
        }
        case InfantrySaboteur:
        {
            [self highlightSurroundingsOfCell:actionCell];
            SKAction *burnUp = [SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:1 duration:0.2f];
            SKCell * tempCell;
            for (int i = 0; i < possibleCellsArray.count; i++){
                tempCell = possibleCellsArray[i];
                SKAction *burnDown = [SKAction colorizeWithColor:tempCell.cellColor colorBlendFactor:1 duration:0.2f];
                [tempCell runAction:burnUp completion:^{[tempCell runAction:burnDown];}];
                if (tempCell.currentPiece != nil){
                    int temp = tempCell.currentPiece.hitPoints;
                    tempCell.currentPiece.hitPoints -= 10 * tempCell.currentPiece.fireDamageMultiplier;
                    NSLog(@"HP of piece was burned from %d to %d", temp, tempCell.currentPiece.hitPoints);
                    if (tempCell.currentPiece.hitPoints <= 0){
                        [tempCell removeAllChildren];
                        tempCell.currentPiece = nil;
                    }
                }
            }
            [actionCell removeAllChildren];
            actionCell.currentPiece = nil;
            actionIsSimple = true;
            break;
        }
        default:
        {
            actionIsSimple = true;
        }
            break;
    }
    
    
    
}


-(void)complexActionForCell:(SKCell*)actionCell withTarget:(CGPoint)positionInScene{
    if (actionCell.currentPiece.pieceType == LightMage){
        SKCell * tempCell;
        for (int i = 0; i < possibleCellsArray.count; i++){
            tempCell = possibleCellsArray[i];
            if ([tempCell containsPoint:positionInScene]){
                tempCell.currentPiece.hitPoints -= 10;
                SKAction *lightUp = [SKAction colorizeWithColor:[UIColor whiteColor] colorBlendFactor:1 duration:0.2f];
                SKAction *lightDown = [SKAction colorizeWithColor:tempCell.cellColor colorBlendFactor:1 duration:0.2f];
                [tempCell runAction:lightUp completion:^{[tempCell runAction:lightDown];}];
                if (tempCell.currentPiece.hitPoints <= 0)
                    [tempCell removeAllChildren];
                    tempCell.currentPiece = nil;
            }
        
        }
    
    }
    [self unHighlightAllCells];
    [self unHighlightCells];
    currentPhase = ChoseMove;
    blackPlays = !blackPlays;
}



#pragma mark - HighlightFunctions


-(void)highlightOptionsOfCell:(SKCell*)cell{
    
    SKCell *tempCell;
    NSLog(@"Index da celula principal : %d", cell.index);
    if (cell.column != 0){
        tempCell = [self cellForLine:cell.line andColumn:cell.column - 1];
        if (tempCell != nil)
            if (tempCell.currentPiece == nil && (tempCell.line == cell.line)){
                [tempCell runAction:[SKAction colorizeWithColor:[UIColor blueColor] colorBlendFactor:1.0f duration:0.0f]];
                [possibleCellsArray addObject:tempCell];
            }
    }
    
    
    
    if (cell.column < 16){
        tempCell = [self cellForLine:cell.line andColumn:cell.column + 1];
        if (tempCell != nil)
            if (tempCell.currentPiece == nil && (tempCell.line == cell.line)){
                [tempCell runAction:[SKAction colorizeWithColor:[UIColor blueColor] colorBlendFactor:1.0f duration:0.0f]];
                [possibleCellsArray addObject:tempCell];
                
            }
    }
    
    if (cell.line != 15 ){
        tempCell = [self cellForLine:cell.line + 1 andColumn:cell.column];
        if (tempCell != nil)
            if (tempCell.currentPiece == nil){
                [tempCell runAction:[SKAction colorizeWithColor:[UIColor blueColor] colorBlendFactor:1.0f duration:0.0f]];
                [possibleCellsArray addObject:tempCell];
            }
    }
    
    if (cell.column != 16 && cell.line != 15 ){
        tempCell = [self cellForLine:cell.line + 1 andColumn:cell.column + 1];
        if (tempCell != nil)
            if (tempCell.currentPiece == nil ){
                [tempCell runAction:[SKAction colorizeWithColor:[UIColor blueColor] colorBlendFactor:1.0f duration:0.0f]];
                [possibleCellsArray addObject:tempCell];
            }
    }
    
    if (cell.column > 0 && cell.line != 15 ){
        tempCell = [self cellForLine:cell.line + 1 andColumn:cell.column - 1];
        if (tempCell != nil)
            if (tempCell.currentPiece == nil ){
                [tempCell runAction:[SKAction colorizeWithColor:[UIColor blueColor] colorBlendFactor:1.0f duration:0.0f]];
                [possibleCellsArray addObject:tempCell];
            }
    }
    
    if (cell.line > 0 && cell.column != 15 ){
        tempCell = [self cellForLine:cell.line - 1 andColumn:cell.column + 1];
        if (tempCell != nil)
            if (tempCell.currentPiece == nil ){
                [tempCell runAction:[SKAction colorizeWithColor:[UIColor blueColor] colorBlendFactor:1.0f duration:0.0f]];
                
                [possibleCellsArray addObject:tempCell];
            }
    }
    
    if (cell.line > 0 ){
        tempCell = [self cellForLine:cell.line - 1 andColumn:cell.column];
        if (tempCell != nil)
            if (tempCell.currentPiece == nil){
                [tempCell runAction:[SKAction colorizeWithColor:[UIColor blueColor] colorBlendFactor:1.0f duration:0.0f]];
                [possibleCellsArray addObject:tempCell];
            }
    }
    
    if (cell.line > 0 && cell.column > 0 ){
        tempCell = [self cellForLine:cell.line - 1 andColumn:cell.column - 1];
        if (tempCell != nil)
            if (tempCell.currentPiece == nil  ){
                [tempCell runAction:[SKAction colorizeWithColor:[UIColor blueColor] colorBlendFactor:1.0f duration:0.0f]];
                [possibleCellsArray addObject:tempCell];
            }
    }
    
    if (possibleCellsArray.count == 0){
        SKAction * unSelect = [SKAction colorizeWithColor:cell.cellColor colorBlendFactor:1.0f duration:0.0f];
        [cell runAction:unSelect];
        
    }
}

-(void)highlightSurroundingsOfCell:(SKCell*)cell{
    
    SKCell *tempCell;
    NSLog(@"Index da celula principal : %d", cell.index);
    if (cell.column != 0){
        tempCell = [self cellForLine:cell.line andColumn:cell.column - 1];
        if (tempCell != nil)
                [tempCell runAction:[SKAction colorizeWithColor:[UIColor blueColor] colorBlendFactor:1.0f duration:0.0f]];
                [possibleCellsArray addObject:tempCell];
    }
    
    
    
    if (cell.column < 16){
        tempCell = [self cellForLine:cell.line andColumn:cell.column + 1];
        if (tempCell != nil)
                [tempCell runAction:[SKAction colorizeWithColor:[UIColor blueColor] colorBlendFactor:1.0f duration:0.0f]];
                [possibleCellsArray addObject:tempCell];
            }
    
    if (cell.line != 15 ){
        tempCell = [self cellForLine:cell.line + 1 andColumn:cell.column];
        if (tempCell != nil)
                [tempCell runAction:[SKAction colorizeWithColor:[UIColor blueColor] colorBlendFactor:1.0f duration:0.0f]];
                [possibleCellsArray addObject:tempCell];
        
    }
    
    if (cell.column != 16 && cell.line != 15 ){
        tempCell = [self cellForLine:cell.line + 1 andColumn:cell.column + 1];
        if (tempCell != nil)
                [tempCell runAction:[SKAction colorizeWithColor:[UIColor blueColor] colorBlendFactor:1.0f duration:0.0f]];
                [possibleCellsArray addObject:tempCell];
    }
    
    if (cell.column > 0 && cell.line != 15 ){
        tempCell = [self cellForLine:cell.line + 1 andColumn:cell.column - 1];
        if (tempCell != nil)
                [tempCell runAction:[SKAction colorizeWithColor:[UIColor blueColor] colorBlendFactor:1.0f duration:0.0f]];
                [possibleCellsArray addObject:tempCell];
    }
    
    if (cell.line > 0 && cell.column != 15 ){
        tempCell = [self cellForLine:cell.line - 1 andColumn:cell.column + 1];
        if (tempCell != nil)
                [tempCell runAction:[SKAction colorizeWithColor:[UIColor blueColor] colorBlendFactor:1.0f duration:0.0f]];
                [possibleCellsArray addObject:tempCell];
        
    }
    
    if (cell.line > 0 ){
        tempCell = [self cellForLine:cell.line - 1 andColumn:cell.column];
        if (tempCell != nil)
                [tempCell runAction:[SKAction colorizeWithColor:[UIColor blueColor] colorBlendFactor:1.0f duration:0.0f]];
                [possibleCellsArray addObject:tempCell];
        
    }
    
    if (cell.line > 0 && cell.column > 0 ){
        tempCell = [self cellForLine:cell.line - 1 andColumn:cell.column - 1];
        if (tempCell != nil)
                [tempCell runAction:[SKAction colorizeWithColor:[UIColor blueColor] colorBlendFactor:1.0f duration:0.0f]];
                [possibleCellsArray addObject:tempCell];
    }
    
    if (possibleCellsArray.count == 0){
        SKAction * unSelect = [SKAction colorizeWithColor:cell.cellColor colorBlendFactor:1.0f duration:0.0f];
        [cell runAction:unSelect];
        
    }
}



-(void)highlightAttackOptionsOfCell:(SKCell*)cell withRangeMin:(int)rangeMin andMax:(int)rangeMax{
    
    [possibleCellsArray removeAllObjects];
    SKCell *tempCell;
    if (rangeMin <= 1 && rangeMax >=1){
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
                if (tempCell.currentPiece != nil  ){
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
                if (tempCell.currentPiece != nil ){
                    if (tempCell.currentPiece.player != cell.currentPiece.player){
                        
                        [tempCell runAction:[SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:1.0f duration:0.0f]];
                        [possibleCellsArray addObject:tempCell];
                    }
                }
        }
        tempCell = nil;
        
        if (cell.line > 0 && cell.column != 15 ){
            tempCell = [self cellForLine:cell.line - 1 andColumn:cell.column + 1];
            if (tempCell != nil)
                if (tempCell.currentPiece != nil  ){
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
                if (tempCell.currentPiece != nil ){
                    if (tempCell.currentPiece.player != cell.currentPiece.player){
                        
                        [tempCell runAction:[SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:1.0f duration:0.0f]];
                        [possibleCellsArray addObject:tempCell];
                    }
                }
        }
        tempCell = nil;
    }
    
    
    
    if (rangeMin <= 2 && rangeMax >=2){
        
        
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
            tempCell = [self cellForLine:cell.line + i andColumn:cell.column + 2];
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
            tempCell = [self cellForLine:cell.line + i andColumn:cell.column - 2];
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
    
    /* Range = 3 */
    
    if (rangeMin <= 3 && rangeMax >= 3){
        
        
        for (int i = -3; i < 4; i ++){
            tempCell = [self cellForLine:cell.line + 3 andColumn:cell.column + i];
            if (tempCell != nil)
                if (tempCell.currentPiece != nil ){
                    if (tempCell.currentPiece.player != cell.currentPiece.player){
                        [tempCell runAction:[SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:1.0f duration:0.0f]];
                        [possibleCellsArray addObject:tempCell];
                    }
                }
            tempCell = nil;
        }
        
        for (int i = -3; i < 4; i ++){
            tempCell = [self cellForLine:cell.line - 3 andColumn:cell.column + i];
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
            tempCell = [self cellForLine:cell.line + i andColumn:cell.column + 3];
            if (tempCell != nil)
                if (tempCell.currentPiece != nil){
                    if (tempCell.currentPiece.player != cell.currentPiece.player){
                        [tempCell runAction:[SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:1.0f duration:0.0f]];
                        [possibleCellsArray addObject:tempCell];
                    }
                }
            tempCell = nil;
        }
        
        for (int i = -2; i < 3; i ++){
            tempCell = [self cellForLine:cell.line + i andColumn:cell.column - 3];
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
    
    /* Range = 4 */
    
    if (rangeMin <= 4 && rangeMax >= 4){
        
        
        for (int i = -4; i < 5; i ++){
            tempCell = [self cellForLine:cell.line + 4 andColumn:cell.column + i];
            if (tempCell != nil)
                if (tempCell.currentPiece != nil ){
                    if (tempCell.currentPiece.player != cell.currentPiece.player){
                        [tempCell runAction:[SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:1.0f duration:0.0f]];
                        [possibleCellsArray addObject:tempCell];
                    }
                }
            tempCell = nil;
        }
        
        for (int i = -4; i < 5; i ++){
            tempCell = [self cellForLine:cell.line - 4 andColumn:cell.column + i];
            if (tempCell != nil)
                if (tempCell.currentPiece != nil ){
                    if (tempCell.currentPiece.player != cell.currentPiece.player){
                        [tempCell runAction:[SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:1.0f duration:0.0f]];
                        [possibleCellsArray addObject:tempCell];
                    }
                }
            tempCell = nil;
        }
        
        for (int i = -3; i < 4; i ++){
            tempCell = [self cellForLine:cell.line + i andColumn:cell.column + 4];
            if (tempCell != nil)
                if (tempCell.currentPiece != nil){
                    if (tempCell.currentPiece.player != cell.currentPiece.player){
                        [tempCell runAction:[SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:1.0f duration:0.0f]];
                        [possibleCellsArray addObject:tempCell];
                    }
                }
            tempCell = nil;
        }
        
        for (int i = -3; i < 4; i ++){
            tempCell = [self cellForLine:cell.line + i andColumn:cell.column - 4];
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
    
    
    
    
    if (possibleCellsArray.count == 0){
        hasTarget = false;
    }else{
        hasTarget = true;
    }
    
}

-(BOOL)highlightsPossibleActionCellsOfPlayer:(Player)player{
    
    SKCell *tempCell;
    
    for (int i = 0; i < cellArray.count; i++){
        tempCell = cellArray[i];
        if (tempCell.currentPiece.hasAction && tempCell.currentPiece.player != player){
            [tempCell runAction:[SKAction colorizeWithColor:[UIColor magentaColor] colorBlendFactor:1 duration:0]];
            [possibleActionCells addObject:tempCell];
        }
    }
    if (possibleActionCells.count == 0){
        return false;
    }
    return true;
}

-(void)unHighlightCells{
    SKCell *tempCell;
    for (int i = 0; i < possibleCellsArray.count; i++){
        tempCell = [possibleCellsArray objectAtIndex:i];
        [tempCell runAction:[SKAction colorizeWithColor:tempCell.cellColor colorBlendFactor:1.0f duration:0.0f]];
    }
    [possibleCellsArray removeAllObjects];
}

-(void)unHighlightAllCells{
    SKCell *tempCell;
    for (int i = 0; i < cellArray.count; i++){
        tempCell = [cellArray objectAtIndex:i];
        [tempCell runAction:[SKAction colorizeWithColor:tempCell.cellColor colorBlendFactor:1.0f duration:0.0f]];
    }
}

-(void)unHighlightCellsOfAction{
    SKCell *tempCell;
    for (int i = 0; i < possibleActionCells.count; i++){
        tempCell = [possibleActionCells objectAtIndex:i];
        [tempCell runAction:[SKAction colorizeWithColor:tempCell.cellColor colorBlendFactor:1.0f duration:0.0f]];
    }
    [possibleActionCells removeAllObjects];
}

-(void)unHighlightAttackersCells{
    SKCell *tempCell;
    for (int i = 0; i < possibleAttackers.count; i++){
        tempCell = [possibleAttackers objectAtIndex:i];
        [tempCell runAction:[SKAction colorizeWithColor:tempCell.cellColor colorBlendFactor:1.0f duration:0.0f]];
    }
    [possibleAttackers removeAllObjects];
}

#pragma mark - DataPairingFunctions

-(SKCell*)cellForLine:(int)line andColumn:(int)column{
    SKCell* tempCell;
    for (int i = 0; i < cellArray.count; i++){
        tempCell = cellArray[i];
        if (tempCell.line == line && tempCell.column == column)
            return tempCell;
    }
    return nil;
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
                newPiece = [SKPiece initPieceOfType:ChivalryScout ofPlayer:player];
                break;
            case 7:
                newPiece = [SKPiece initPieceOfType:Dragon ofPlayer:player];
                break;
            case 8:
                newPiece = [SKPiece initPieceOfType:DragonSlayer ofPlayer:player];
                break;
            case 9:
                newPiece = [SKPiece initPieceOfType:ChivalryScout ofPlayer:player];
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
                newPiece = [SKPiece initPieceOfType:ChivalryScout ofPlayer:player];
                break;
            case 7:
                newPiece = [SKPiece initPieceOfType:InfantrySaboteur ofPlayer:player];
                break;
            case 8:
                newPiece = [SKPiece initPieceOfType:LightMage ofPlayer:player];
                break;
            case 9:
                newPiece = [SKPiece initPieceOfType:ChivalryScout ofPlayer:player];
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


@end
