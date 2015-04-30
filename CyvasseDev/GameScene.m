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
    UILabel *mainLabel2;
    UILabel *actionLabel;
    UILabel *actionLabel2;
    turnPhase currentPhase;
    
    BOOL blackPlays;
    BOOL hasTarget;
    BOOL hasAttacker;
    int moveCounter;
    int cells;
}

#pragma mark - DefaultFunctions

-(void)didMoveToView:(SKView *)view {
    blackPlays = false;
    hasTarget = false;
    hasAttacker = false;
    currentPhase = ChoseMove;
    cells = 0;
    moveCounter = 0;
    self.backgroundColor = [UIColor colorWithRed:0.027 green:0.388 blue:0.141 alpha:1];
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
    
    mainLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - (300 + self.frame.size.width*0.02), self.frame.size.height*0.05, 300, 125)];
    mainLabel.numberOfLines = 2;
    mainLabel.text = @"Chose which piece will move";
    mainLabel.transform = CGAffineTransformMakeScale(-1, -1);
    mainLabel.textAlignment = NSTextAlignmentCenter;
    mainLabel.font = [UIFont fontWithName:@"Superclarendon" size:18];
    mainLabel.backgroundColor = [UIColor colorWithRed:0.933 green:0.875 blue:0.651 alpha:1];
    mainLabel.layer.cornerRadius = 5;
    mainLabel.clipsToBounds = true;
    mainLabel.layer.borderWidth = 2;
    
    mainLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - (300 + self.frame.size.width*0.02), self.frame.size.height - (125 + self.frame.size.height*0.05) ,300, 125)];
    mainLabel2.numberOfLines = 2;
    mainLabel2.text = @"Chose which piece will move";
    mainLabel2.textAlignment = NSTextAlignmentCenter;
    mainLabel2.font = [UIFont fontWithName:@"Superclarendon" size:18];
    mainLabel2.backgroundColor = [UIColor colorWithRed:0.933 green:0.875 blue:0.651 alpha:1];
    mainLabel2.layer.cornerRadius = 5;
    mainLabel2.clipsToBounds = true;
    mainLabel2.layer.borderWidth = 2;


    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(skipPhaseOfPlayerOne)];

    actionLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width*0.05, self.frame.size.height*0.05, 100, 100)];
    actionLabel.backgroundColor = [UIColor colorWithRed:0.863 green:0.078 blue:0.235 alpha:1];
    actionLabel.userInteractionEnabled = YES;
    actionLabel.transform = CGAffineTransformMakeScale(-1, -1);
    actionLabel.layer.cornerRadius = 50;
    actionLabel.clipsToBounds = YES;
    actionLabel.text = @"SKIP!";
    actionLabel.textAlignment = NSTextAlignmentCenter;
    actionLabel.font = [UIFont fontWithName:@"Superclarendon" size:25];
    actionLabel.layer.borderWidth = 2;
    
    UITapGestureRecognizer* tapGesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(skipPhaseOfPlayerTwo)];

    actionLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width*0.05, self.frame.size.height - (100 + self.frame.size.height*0.05), 100, 100)];
    actionLabel2.backgroundColor = [UIColor colorWithRed:0.863 green:0.078 blue:0.235 alpha:1];
    actionLabel2.userInteractionEnabled = YES;
    actionLabel2.layer.cornerRadius = 50;
    actionLabel2.clipsToBounds = YES;
    actionLabel2.text = @"SKIP!";
    actionLabel2.textAlignment = NSTextAlignmentCenter;
    actionLabel2.font = [UIFont fontWithName:@"Superclarendon" size:25];
    actionLabel2.layer.borderWidth = 2;

    [actionLabel addGestureRecognizer:tapGesture];
    [actionLabel2 addGestureRecognizer:tapGesture2];
    
    [self.view addSubview:mainLabel];
    [self.view addSubview:actionLabel];
    [self.view addSubview:mainLabel2];
    [self.view addSubview:actionLabel2];
    
    
}

-(void)createMap{
    
    BOOL blackOrWhite = false;
    
        [self createHUD];
    
    SKPiece* treeGiant = [SKPiece initPieceOfType:TreeGiant ofPlayer:2];
    treeGiant.position = CGPointMake(CGRectGetMidX(self.frame) - 360,CGRectGetMidY(self.frame));
    treeGiant.size = CGSizeMake(40, 40);
    [self addChild:treeGiant];

    SKPiece* stoneGiant = [SKPiece initPieceOfType:StoneGiant ofPlayer:2];
    stoneGiant.position = CGPointMake(CGRectGetMidX(self.frame) + 355,CGRectGetMidY(self.frame));
    stoneGiant.size = CGSizeMake(40, 40);
    [self addChild:stoneGiant];
    
    for (int g = 0; g < 4; g++){
        for (int h = 0; h < 6; h++){
            UIColor * color = blackOrWhite? [UIColor colorWithRed:0.4 green:0.2 blue:0 alpha:1]:[UIColor colorWithRed:0.624 green:0.588 blue:0.533 alpha:1];
            SKCell *cell = [SKCell initWithColor:color];
            [self addChild:cell];
            [cellArray addObject:cell];
            cell.index = cells;
            cell.line = g;
            cell.column = h + 5;
            cells++;
            int a = CGRectGetMidX(self.frame) - 105;
            int b = CGRectGetMidY(self.frame) + 300;
            cell.position = CGPointMake(a + h * 40, b - g * 40);
            [self pieceForCell:cell];
            cell.currentPiece.zRotation = M_PI;
            blackOrWhite = !blackOrWhite;
        }
        blackOrWhite = !blackOrWhite;
    }
    blackOrWhite = !blackOrWhite;
    for (int i = 0; i < 8; i++){
        for (int j = 0; j < 8; j++){
            
            UIColor * color = blackOrWhite? [UIColor colorWithRed:0.4 green:0.2 blue:0 alpha:1]:[UIColor colorWithRed:0.624 green:0.588 blue:0.533 alpha:1];
            SKCell *cell = [SKCell initWithColor:color];
            cell.line = i + 4;
            cell.column = j + 4;
            [self addChild:cell];
            [cellArray addObject:cell];
            int a = CGRectGetMidX(self.frame) - 145;
            int b = CGRectGetMidY(self.frame) + 140;
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
            UIColor * color = blackOrWhite? [UIColor colorWithRed:0.4 green:0.2 blue:0 alpha:1]:[UIColor colorWithRed:0.624 green:0.588 blue:0.533 alpha:1];
            SKCell *cell = [SKCell initWithColor:color];
            [self addChild:cell];
            [cellArray addObject:cell];
            cell.index = cells;
            cell.line = g + 12;
            cell.column = h + 5;
            cells++;
            int a = CGRectGetMidX(self.frame) - 105;
            int b = CGRectGetMidY(self.frame) - 180;
            cell.position = CGPointMake(a + h * 40, b - g * 40);
            [self pieceForCell:cell];
            blackOrWhite = !blackOrWhite;
        }
        blackOrWhite = !blackOrWhite;
    }
    
    for (int g = 0; g < 6; g++){
        for (int h = 0; h < 4; h++){
            UIColor * color = blackOrWhite? [UIColor colorWithRed:0.4 green:0.2 blue:0 alpha:1]:[UIColor colorWithRed:0.624 green:0.588 blue:0.533 alpha:1];
            SKCell *cell = [SKCell initWithColor:color];
            [self addChild:cell];
            [cellArray addObject:cell];
            cell.index = cells;
            cell.line = g + 5;
            cell.column = h + 12;
            cells++;
            int a = CGRectGetMidX(self.frame) + 175;
            int b = CGRectGetMidY(self.frame) + 100;
            cell.position = CGPointMake(a + h * 40, b - g * 40);
            blackOrWhite = !blackOrWhite;
        }
        blackOrWhite = !blackOrWhite;
    }
    
    for (int g = 0; g < 6; g++){
        for (int h = 0; h < 4; h++){
            UIColor * color = blackOrWhite? [UIColor colorWithRed:0.4 green:0.2 blue:0 alpha:1]:[UIColor colorWithRed:0.624 green:0.588 blue:0.533 alpha:1];
            SKCell *cell = [SKCell initWithColor:color];
            [self addChild:cell];
            [cellArray addObject:cell];
            cell.index = cells;
            cell.line = g + 5;
            cell.column = h;
            cells++;
            int a = CGRectGetMidX(self.frame) - 305;
            int b = CGRectGetMidY(self.frame) + 100;
            cell.position = CGPointMake(a + h * 40, b - g * 40);
            blackOrWhite = !blackOrWhite;
        }
        blackOrWhite = !blackOrWhite;
    }
    
    
}

-(void)skipPhaseOfPlayerOne{
    if (blackPlays){
    if (currentPhase == ChoseMove || currentPhase == ChoseDirection){
        [self unHighlightCells];
        [self unHighlightAllCells];
        if ([self checkPossibleAttacksOfPlayer:blackPlays]){
            
            NSLog(@"Attack of skipPhase, turnPhase is %d", currentPhase);
            currentPhase = ChoseAttacker;
            [self labelTextForTurnPhase];
            return;
            
        }else if ([self showTowerTargetsOfPlayer:blackPlays]){
            
            NSLog(@"Tower of skipPhase, turnPhase is %d", currentPhase);
            currentPhase = ChoseTowerTarget;
            [self labelTextForTurnPhase];
            return;
            
        } else if ([self highlightsPossibleActionCellsOfPlayer:blackPlays]){
            
            currentPhase = ChoseAction;
            NSLog(@"Action of skipPhase, turnPhase is %d", currentPhase);
            [self labelTextForTurnPhase];
            return;

        } else {
        
            blackPlays = !blackPlays;
            currentPhase = ChoseMove;
            [self labelTextForTurnPhase];
            return;
        }
    }
        if (currentPhase == ChoseAttacker || currentPhase == ChoseAttacker){
            [self unHighlightAttackersCells];
            [self unHighlightAllCells];
            if ([self showTowerTargetsOfPlayer:blackPlays]){
                
                NSLog(@"Tower of skipPhase, turnPhase is %d", currentPhase);
                currentPhase = ChoseTowerTarget;
                [self labelTextForTurnPhase];
                return;
                
            } else if ([self highlightsPossibleActionCellsOfPlayer:blackPlays]){
                
                currentPhase = ChoseAction;
                NSLog(@"Action of skipPhase, turnPhase is %d", currentPhase);
                [self labelTextForTurnPhase];
                return;
                
            } else {
                [self unHighlightAllCells];
                blackPlays = !blackPlays;
                currentPhase = ChoseMove;
                [self labelTextForTurnPhase];
                return;
            }

        
        }
    
    if (currentPhase == ChoseTowerTarget){
        [self unHighlightCells];
        [self unHighlightAllCells];
        if ([self highlightsPossibleActionCellsOfPlayer:blackPlays]){
            
            currentPhase = ChoseAction;
            NSLog(@"Action of skipPhase, turnPhase is %d", currentPhase);
            [self labelTextForTurnPhase];
            return;
            
        } else {
            [self unHighlightAllCells];
            blackPlays = !blackPlays;
            currentPhase = ChoseMove;
            [self labelTextForTurnPhase];
            return;
        }

    }
    
    if (currentPhase == ChoseAction || currentPhase == ChoseActionTarget){
        [self unHighlightCells];
        [self unHighlightCellsOfAction];
        [self unHighlightAllCells];
        blackPlays = !blackPlays;
        currentPhase = ChoseMove;
        [self labelTextForTurnPhase];
    
    }
        NSLog(@"End of skipPhase, turnPhase is %d", currentPhase);
    }
}

-(void)skipPhaseOfPlayerTwo{
    if (!blackPlays){
        if (currentPhase == ChoseMove || currentPhase == ChoseDirection){
            [self unHighlightCells];
            [self unHighlightAllCells];
            if ([self checkPossibleAttacksOfPlayer:blackPlays]){
                
                NSLog(@"Attack of skipPhase, turnPhase is %d", currentPhase);
                currentPhase = ChoseAttacker;
                [self labelTextForTurnPhase];
                return;
                
            }else if ([self showTowerTargetsOfPlayer:blackPlays]){
                
                NSLog(@"Tower of skipPhase, turnPhase is %d", currentPhase);
                currentPhase = ChoseTowerTarget;
                [self labelTextForTurnPhase];
                return;
                
            } else if ([self highlightsPossibleActionCellsOfPlayer:blackPlays]){
                
                currentPhase = ChoseAction;
                NSLog(@"Action of skipPhase, turnPhase is %d", currentPhase);
                [self labelTextForTurnPhase];
                return;
                
            } else {
                
                blackPlays = !blackPlays;
                currentPhase = ChoseMove;
                [self labelTextForTurnPhase];
                return;
            }
        }
        if (currentPhase == ChoseAttacker || currentPhase == ChoseAttacker){
            [self unHighlightAttackersCells];
            [self unHighlightAllCells];
            if ([self showTowerTargetsOfPlayer:blackPlays]){
                
                NSLog(@"Tower of skipPhase, turnPhase is %d", currentPhase);
                currentPhase = ChoseTowerTarget;
                [self labelTextForTurnPhase];
                return;
                
            } else if ([self highlightsPossibleActionCellsOfPlayer:blackPlays]){
                
                currentPhase = ChoseAction;
                NSLog(@"Action of skipPhase, turnPhase is %d", currentPhase);
                [self labelTextForTurnPhase];
                return;
                
            } else {
                [self unHighlightAllCells];
                blackPlays = !blackPlays;
                currentPhase = ChoseMove;
                [self labelTextForTurnPhase];
                return;
            }
            
            
        }
        
        if (currentPhase == ChoseTowerTarget){
            [self unHighlightCells];
            [self unHighlightAllCells];
            if ([self highlightsPossibleActionCellsOfPlayer:blackPlays]){
                
                currentPhase = ChoseAction;
                NSLog(@"Action of skipPhase, turnPhase is %d", currentPhase);
                [self labelTextForTurnPhase];
                return;
                
            } else {
                [self unHighlightAllCells];
                blackPlays = !blackPlays;
                currentPhase = ChoseMove;
                [self labelTextForTurnPhase];
                return;
            }
            
        }
        
        if (currentPhase == ChoseAction || currentPhase == ChoseActionTarget){
            [self unHighlightCells];
            [self unHighlightCellsOfAction];
            [self unHighlightAllCells];
            blackPlays = !blackPlays;
            currentPhase = ChoseMove;
            [self labelTextForTurnPhase];
            
        }
        NSLog(@"End of skipPhase, turnPhase is %d", currentPhase);
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
        [self labelTextForTurnPhase];
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
    BOOL foundTarget = false;
    SKCell *tempCell;
    NSLog(@"Attack Cell");
    for (int i = 0; i < possibleCellsArray.count; i++){
        tempCell = [possibleCellsArray objectAtIndex:i];
        if ([tempCell containsPoint:positionInScene]){
            foundTarget = true;
            [self checkAttackersOnCell:tempCell];
        }
    }
    
    if (!foundTarget)
        return;
    SKAction * unSelect = [SKAction colorizeWithColor:lastCell.cellColor colorBlendFactor:1.0f duration:0.0f];
    [lastCell runAction:unSelect];
    [self unHighlightAttackersCells];
    [self unHighlightCells];
    
    if ([self showTowerTargetsOfPlayer:blackPlays]){
        currentPhase = ChoseTowerTarget;
        [self labelTextForTurnPhase];

    }
    else if ([self highlightsPossibleActionCellsOfPlayer:blackPlays]){
        currentPhase = ChoseAction;
        [self labelTextForTurnPhase];

    }
    else{
        currentPhase = ChoseMove;
        blackPlays = !blackPlays;
        [self labelTextForTurnPhase];

    }
}

/* Attaca uma cell com a torre */

-(void)attackCellWithTower:(CGPoint)positionInScene{
    SKCell *towerCell;
    SKCell *tempCell;
    
    for (int i = 0; i < cellArray.count; i++){
        towerCell = cellArray[i];
        if (towerCell.currentPiece.pieceType == Tower)
            break;
    }
    
    for (int i = 0; i < possibleCellsArray.count; i++){
        tempCell = [possibleCellsArray objectAtIndex:i];
        if ([tempCell containsPoint:positionInScene]){
            [self damageFromCell:towerCell toCell:tempCell];
        }
    }
    
    [possibleAttackers removeAllObjects];
    [self unHighlightCells];
    
    if ([self highlightsPossibleActionCellsOfPlayer:blackPlays]){
        currentPhase = ChoseAction;
        [self labelTextForTurnPhase];
    }
    else{
    currentPhase = ChoseMove;
    blackPlays = !blackPlays;
    [self labelTextForTurnPhase];
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
        if ([possibleCellsArray containsObject:targetCell])
            [self damageFromCell:tempCell toCell:targetCell];
        }
        [targetCell runAction:[SKAction colorizeWithColor:targetCell.cellColor colorBlendFactor:1.0f duration:0.0f]];
        [self unHighlightAttackersCells];
        [self unHighlightAllCells];
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


-(void)damageFromCell: (SKCell*)attacker toCell: (SKCell*)target{
    int temp = target.currentPiece.hitPoints;
    
    if (attacker.currentPiece.fireDamage){
        if (attacker.currentPiece.mainClass == Archer){
            target.currentPiece.hitPoints -= attacker.currentPiece.attackDamage * target.currentPiece.arrowDamageMultiplier * target.currentPiece.fireDamageMultiplier;
        }
        else{
            target.currentPiece.hitPoints -= attacker.currentPiece.attackDamage * attacker.currentPiece.fireDamageMultiplier;
        }
    }
    
    /* Dano sem fogo */
    else{
        if (attacker.currentPiece.mainClass == Archer){
            target.currentPiece.hitPoints -= attacker.currentPiece.attackDamage * target.currentPiece.arrowDamageMultiplier;
        }
        else{
            target.currentPiece.hitPoints -= attacker.currentPiece.attackDamage;
        }
        
        
    }
    
    NSLog(@"Piece one attacks piece two with %d damage. Piece two hp goes from %d -> %d", attacker.currentPiece.attackDamage, temp, target.currentPiece.hitPoints);

    
    if (target.currentPiece.hitPoints <= 0){
        [target removeAllChildren];
        if (target.currentPiece.pieceType == King){
            NSLog(@"GGWP");
        }
        target.currentPiece = nil;
        
        }
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
                if (moveCounter >= piece.moveSpeed){
                    moveCounter = 0;
                    [self unHighlightCells];
                    if ([self checkPossibleAttacksOfPlayer:blackPlays]){
                        currentPhase = ChoseAttacker;
                        [self labelTextForTurnPhase];
                        NSLog(@"Possible Attackers : %lu", (unsigned long)possibleAttackers.count);
                    }
                    else{
                        if ([self showTowerTargetsOfPlayer:blackPlays]){
                            currentPhase = ChoseTowerTarget;
                            [self labelTextForTurnPhase];
                        }else if ([self highlightsPossibleActionCellsOfPlayer:blackPlays]){
                            currentPhase = ChoseAction;
                            [self labelTextForTurnPhase];
                        }else{
                            currentPhase = ChoseMove;
                            blackPlays = !blackPlays;
                            [self labelTextForTurnPhase];
                        }
                    }
                    return;
                }
            }
            
            
        }
    }
    
    SKCell* changeCell;
    if (moveCounter == 0){
        for (int i = 0; i < cellArray.count; i++){
            changeCell = cellArray[i];
            if ([changeCell containsPoint:positionInScene]){
                if (changeCell.currentPiece.player != blackPlays && changeCell.currentPiece.pieceType != Tower && changeCell.currentPiece != nil){
                    [self unHighlightAllCells];
                    [self selectCell:changeCell];
                    return;
                }
            }
        }
    }
    NSLog(@"End move function, current phase is %d", currentPhase);

}

#pragma mark - ActionFunctions

/* Verificada qual foi a peça escolhida para realizar a action */

-(void)performActionOfCell:(CGPoint)positionInScene{
    BOOL foundCell = false;
    BOOL simple = false;
    SKCell * tempCell;
    for (int i = 0; i < possibleActionCells.count; i++){
        tempCell = possibleActionCells[i];
        if ([tempCell containsPoint:positionInScene]){
            simple = [self simpleActionForCell:tempCell];
            foundCell = true;
        }
    }
    if (!foundCell){
        return;
    }
    if (simple){
    [self unHighlightCellsOfAction];
    [self unHighlightCells];
    currentPhase = ChoseMove;
    blackPlays = !blackPlays;
    [self labelTextForTurnPhase];
    }
    else{
        currentPhase++;
        [self labelTextForTurnPhase];
    }
    NSLog(@"Depois da performAction, a turnPhase é %d", currentPhase);
}

/* Acha a action correspondente dependendo da piece */

-(BOOL)simpleActionForCell:(SKCell*)actionCell{
    
    BOOL actionIsSimple = false;
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
        case RoyalGuard:
        {
            currentCell = actionCell;
            [self highlightFriendlyOptionsOfCell:actionCell];
            actionIsSimple = false;
            break;
        }
        case Dragon:
        {
            currentCell = actionCell;
            [self highlightAttackOptionsOfCell:actionCell withRangeMin:1 andMax:2];
            actionIsSimple = false;
            break;
        }
        default:
        {
            actionIsSimple = true;
        }
    }
    
    return actionIsSimple;
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
                if (tempCell.currentPiece.hitPoints <= 0){
                    [tempCell removeAllChildren];
                    tempCell.currentPiece = nil;
                }
            }
        
        }
    
    }
    
    if (actionCell.currentPiece.pieceType == RoyalGuard){
        SKCell * tempCell;
        for (int i = 0; i < possibleCellsArray.count; i++){
            tempCell = possibleCellsArray[i];
            if ([tempCell containsPoint:positionInScene]){
                SKAction *healUp = [SKAction colorizeWithColor:[UIColor yellowColor] colorBlendFactor:1 duration:0.4f];
                SKAction *healDown = [SKAction colorizeWithColor:tempCell.cellColor colorBlendFactor:1 duration:0.2f];
                [tempCell runAction:healUp completion:^{[tempCell runAction:healDown];}];
                tempCell.currentPiece.hitPoints += 5;
                if (tempCell.currentPiece.hitPoints > tempCell.currentPiece.maxHitPoints)
                    tempCell.currentPiece.hitPoints = tempCell.currentPiece.maxHitPoints;
            }
            
        }
        
    }
    
    if (actionCell.currentPiece.pieceType == Dragon){
        SKCell * tempCell;
        for (int i = 0; i < possibleCellsArray.count; i++){
            tempCell = possibleCellsArray[i];
            if ([tempCell containsPoint:positionInScene]){
                SKAction *burnUp = [SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:1 duration:0.4f];
                SKAction *burnDown = [SKAction colorizeWithColor:tempCell.cellColor colorBlendFactor:1 duration:0.2f];
                [tempCell runAction:burnUp completion:^{[tempCell runAction:burnDown];}];
                tempCell.currentPiece.hitPoints -= 5 * tempCell.currentPiece.fireDamageMultiplier;
                if (tempCell.currentPiece.hitPoints <= 0){
                    [tempCell removeAllChildren];
                    tempCell.currentPiece = nil;
                }
            }
            
        }
        
    }
    [self unHighlightAllCells];
    [self unHighlightCells];
    currentPhase = ChoseMove;
    blackPlays = !blackPlays;
    [self labelTextForTurnPhase];
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


-(void)highlightFriendlyOptionsOfCell:(SKCell*)cell{
    
    [possibleCellsArray removeAllObjects];
    SKCell *tempCell;
        if (cell.column != 0){
            tempCell = [self cellForLine:cell.line andColumn:cell.column - 1];
            if (tempCell != nil)
                if (tempCell.currentPiece != nil){
                    if (tempCell.currentPiece.player == cell.currentPiece.player){
                        [tempCell runAction:[SKAction colorizeWithColor:[UIColor whiteColor] colorBlendFactor:1.0f duration:0.0f]];
                        [possibleCellsArray addObject:tempCell];
                    }
                }
        
        
        if (cell.column < 16){
            tempCell = [self cellForLine:cell.line andColumn:cell.column + 1];
            if (tempCell != nil)
                if (tempCell.currentPiece != nil && (tempCell.line == cell.line)){
                    if (tempCell.currentPiece.player == cell.currentPiece.player){
                        
                        [tempCell runAction:[SKAction colorizeWithColor:[UIColor whiteColor] colorBlendFactor:1.0f duration:0.0f]];
                        [possibleCellsArray addObject:tempCell];
                    }
                }
        }
        tempCell = nil;
        if (cell.line != 15 ){
            tempCell = [self cellForLine:cell.line + 1 andColumn:cell.column];
            if (tempCell != nil)
                if (tempCell.currentPiece != nil){
                    if (tempCell.currentPiece.player == cell.currentPiece.player){
                        
                        [tempCell runAction:[SKAction colorizeWithColor:[UIColor whiteColor] colorBlendFactor:1.0f duration:0.0f]];
                        [possibleCellsArray addObject:tempCell];
                    }
                }
        }
        tempCell = nil;
        if (cell.column != 16 && cell.line != 15 ){
            tempCell = [self cellForLine:cell.line + 1 andColumn:cell.column + 1];
            if (tempCell != nil)
                if (tempCell.currentPiece != nil  ){
                    if (tempCell.currentPiece.player == cell.currentPiece.player){
                        
                        [tempCell runAction:[SKAction colorizeWithColor:[UIColor whiteColor] colorBlendFactor:1.0f duration:0.0f]];
                        [possibleCellsArray addObject:tempCell];
                    }
                }
        }
        tempCell = nil;
        if (cell.column > 0 && cell.line != 15 ){
            tempCell = [self cellForLine:cell.line + 1 andColumn:cell.column - 1];
            if (tempCell != nil)
                if (tempCell.currentPiece != nil ){
                    if (tempCell.currentPiece.player == cell.currentPiece.player){
                        
                        [tempCell runAction:[SKAction colorizeWithColor:[UIColor whiteColor] colorBlendFactor:1.0f duration:0.0f]];
                        [possibleCellsArray addObject:tempCell];
                    }
                }
        }
        tempCell = nil;
        
        if (cell.line > 0 && cell.column != 15 ){
            tempCell = [self cellForLine:cell.line - 1 andColumn:cell.column + 1];
            if (tempCell != nil)
                if (tempCell.currentPiece != nil  ){
                    if (tempCell.currentPiece.player == cell.currentPiece.player){
                        
                        [tempCell runAction:[SKAction colorizeWithColor:[UIColor whiteColor] colorBlendFactor:1.0f duration:0.0f]];
                        [possibleCellsArray addObject:tempCell];
                    }
                }
        }
        tempCell = nil;
        if (cell.line > 0 ){
            tempCell = [self cellForLine:cell.line - 1 andColumn:cell.column];
            if (tempCell != nil)
                if (tempCell.currentPiece != nil){
                    if (tempCell.currentPiece.player == cell.currentPiece.player){
                        
                        [tempCell runAction:[SKAction colorizeWithColor:[UIColor whiteColor] colorBlendFactor:1.0f duration:0.0f]];
                        [possibleCellsArray addObject:tempCell];
                    }
                }
        }
        tempCell = nil;
        if (cell.line > 0 && cell.column > 0 ){
            tempCell = [self cellForLine:cell.line - 1 andColumn:cell.column - 1];
            if (tempCell != nil)
                if (tempCell.currentPiece != nil ){
                    if (tempCell.currentPiece.player == cell.currentPiece.player){
                        
                        [tempCell runAction:[SKAction colorizeWithColor:[UIColor whiteColor] colorBlendFactor:1.0f duration:0.0f]];
                        [possibleCellsArray addObject:tempCell];
                    }
                }
        }
    }
    NSLog(@"Count dos amigos: %lu", (unsigned long)possibleCellsArray.count);
}
//  Highlight and count the possible actions that a player can perform

-(BOOL)highlightsPossibleActionCellsOfPlayer:(Player)player{
    
    SKCell *tempCell;
    
    for (int i = 0; i < cellArray.count; i++){
        tempCell = cellArray[i];
        if (tempCell.currentPiece.hasAction && tempCell.currentPiece.player != player){
            
            // Checa para ver se a ação precisa de target
            
            if (tempCell.currentPiece.pieceType == LightMage || tempCell.currentPiece.pieceType == Dragon){
                [self highlightAttackOptionsOfCell:tempCell withRangeMin:tempCell.currentPiece.rangeMin andMax:tempCell.currentPiece.rangeMax];
                if (possibleCellsArray.count == 0){
                    continue;
                }else{
                    [tempCell runAction:[SKAction colorizeWithColor:[UIColor magentaColor] colorBlendFactor:1 duration:0]];
                    [possibleActionCells addObject:tempCell];
                }
            }
            else{
                [tempCell runAction:[SKAction colorizeWithColor:[UIColor magentaColor] colorBlendFactor:1 duration:0]];
                [possibleActionCells addObject:tempCell];
            }
        }
    }
    NSLog(@"Count das Action possivieis : %lu", (unsigned long)possibleActionCells.count);
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

-(void)labelTextForTurnPhase{

    if (blackPlays){
    switch (currentPhase) {
        case ChoseMove:
            mainLabel.text = @"Choose which piece you will move";
            break;
        case ChoseDirection:
            mainLabel.text = @"Choose where you will move";
            break;
        case ChoseAttacker:
            mainLabel.text = @"Choose which piece will attack";
            break;
        case ChoseAttackTarget:
            mainLabel.text = @"Choose which piece will be attacked";
            break;
        case ChoseTowerTarget:
            mainLabel.text = @"Choose which piece the tower will attack";
            break;
        case ChoseAction:
            mainLabel.text = @"Choose which piece will perform the action";
            break;
        case ChoseActionTarget:
            mainLabel.text = @"Choose which piece will suffer the action";
            break;
    }
        mainLabel2.text = @"Wait for your turn!";
    }else{
        switch (currentPhase) {
            case ChoseMove:
                mainLabel2.text = @"Choose which piece you will move";
                break;
            case ChoseDirection:
                mainLabel2.text = @"Choose where you will move";
                break;
            case ChoseAttacker:
                mainLabel2.text = @"Choose which piece will attack";
                break;
            case ChoseAttackTarget:
                mainLabel2.text = @"Choose which piece will be attacked";
                break;
            case ChoseTowerTarget:
                mainLabel2.text = @"Choose which piece the tower will attack";
                break;
            case ChoseAction:
                mainLabel2.text = @"Choose which piece will perform the action";
                break;
            case ChoseActionTarget:
                mainLabel2.text = @"Choose which piece will suffer the action";
                break;
        }
    
        mainLabel.text = @"Wait for your turn!";

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
    
    if (cell.line == 5 ){
        if (cell.column == 5|| cell.column == 10){
            newPiece = [SKPiece initPieceOfType:Tower ofPlayer:player];
            newPiece.zRotation = M_PI;
        }
    }
    
    if (cell.line == 10 ){
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
