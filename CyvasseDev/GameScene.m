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
#import "RulesViewController.h"


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
    UILabel *detailsLabel;
    UILabel *detailsLabel2;
    turnPhase currentPhase;
    SKPiece *stoneGiant;
    SKPiece *treeGiant;
    SKTexture *red;
    BOOL blackPlays;
    BOOL hasTarget;
    BOOL hasAttacker;
    BOOL hasActivatedTreeGiant;
    BOOL hasActivatedStoneGiant;
    int moveCounter;
    int cells;
}

#pragma mark - DefaultFunctions

-(void)didMoveToView:(SKView *)view {
    
    [self generalInitiation];
    possibleCellsArray = [[NSMutableArray alloc]init];
    possibleAttackers = [[NSMutableArray alloc]init];
    cellArray = [[NSMutableArray alloc]init];
    possibleTowerTargets = [[NSMutableArray alloc]init];
    possibleActionCells = [[NSMutableArray alloc]init];
    red = [SKTexture textureWithImage:[UIImage imageNamed:@"red"]];
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

-(void)generalInitiation{
    blackPlays = false;
    hasTarget = false;
    hasAttacker = false;
    hasActivatedTreeGiant = false;
    currentPhase = ChoseMove;
    cells = 0;
    moveCounter = 0;
    self.backgroundColor = [UIColor colorWithRed:0.027 green:0.388 blue:0.141 alpha:1];
    SKTexture *table = [SKTexture textureWithImage:[UIImage imageNamed:@"redwood.jpg"]];
    SKSpriteNode *bgImage = [SKSpriteNode spriteNodeWithTexture:table];
    bgImage.position = CGPointMake(self.size.width/2, self.size.height/2);
    [self addChild:bgImage];


}

-(void)createHUD{
    
    mainLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - (300 + self.frame.size.width*0.02), self.frame.size.height*0.025, 300, 70)];
    mainLabel.numberOfLines = 2;
    mainLabel.text = @"Wait for your turn!";
    mainLabel.transform = CGAffineTransformMakeScale(-1, -1);
    mainLabel.textAlignment = NSTextAlignmentCenter;
    mainLabel.font = [UIFont fontWithName:@"Superclarendon" size:18];
    mainLabel.backgroundColor = [UIColor colorWithRed:0.933 green:0.875 blue:0.651 alpha:1];
    mainLabel.layer.cornerRadius = 5;
    mainLabel.clipsToBounds = true;
    mainLabel.layer.borderWidth = 2;
    
    mainLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - (300 + self.frame.size.width*0.02), self.frame.size.height - (80 + self.frame.size.height*0.025) ,300, 80)];
    mainLabel2.numberOfLines = 2;
    mainLabel2.text = @"Chose which piece you will move";
    mainLabel2.textAlignment = NSTextAlignmentCenter;
    mainLabel2.font = [UIFont fontWithName:@"Superclarendon" size:18];
    mainLabel2.backgroundColor = [UIColor colorWithRed:0.933 green:0.875 blue:0.651 alpha:1];
    mainLabel2.layer.cornerRadius = 5;
    mainLabel2.clipsToBounds = true;
    mainLabel2.layer.borderWidth = 2;


    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(skipPhaseOfPlayerOne)];

    actionLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width*0.05, self.frame.size.height*0.025, 100, 100)];
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

    actionLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width*0.05, self.frame.size.height - (100 + self.frame.size.height*0.025), 100, 100)];
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
    
    
    detailsLabel = [[UILabel alloc]initWithFrame:CGRectMake(mainLabel.frame.origin.x, mainLabel.frame.origin.y + mainLabel.frame.size.height + self.frame.size.height*0.025, mainLabel.frame.size.width, 130)];
    detailsLabel.backgroundColor = [UIColor colorWithRed:0.933 green:0.875 blue:0.651 alpha:1];
    detailsLabel.numberOfLines = 4;
    detailsLabel.userInteractionEnabled = YES;
    detailsLabel.transform = CGAffineTransformMakeScale(-1, -1);
    detailsLabel.layer.cornerRadius = 5;
    detailsLabel.clipsToBounds = YES;
    detailsLabel.text = @"Swipe left to check piece info";
    detailsLabel.textAlignment = NSTextAlignmentCenter;
    detailsLabel.font = [UIFont fontWithName:@"Superclarendon" size:15];
    detailsLabel.layer.borderWidth = 2;
    
    detailsLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(mainLabel.frame.origin.x, mainLabel2.frame.origin.y - self.frame.size.height*0.025 - detailsLabel.frame.size.height, mainLabel.frame.size.width, 130)];
    detailsLabel2.backgroundColor = [UIColor colorWithRed:0.933 green:0.875 blue:0.651 alpha:1];
    detailsLabel2.numberOfLines = 4;
    detailsLabel2.userInteractionEnabled = YES;
    detailsLabel2.layer.cornerRadius = 5;
    detailsLabel2.clipsToBounds = YES;
    detailsLabel2.text = @"Swipe right to check piece info";
    detailsLabel2.textAlignment = NSTextAlignmentCenter;
    detailsLabel2.font = [UIFont fontWithName:@"Superclarendon" size:15];
    detailsLabel2.layer.borderWidth = 2;
    
    UILabel *rulesLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width *0.02, self.frame.size.height/2 - 50, 100, 100)];
    rulesLabel.backgroundColor = [UIColor colorWithRed:0.863 green:0.078 blue:0.235 alpha:1];
    rulesLabel.userInteractionEnabled = YES;
    rulesLabel.layer.cornerRadius = 50;
    rulesLabel.transform = CGAffineTransformMakeRotation(-M_PI/2);
    rulesLabel.clipsToBounds = YES;
    rulesLabel.text = @"RULES";
    rulesLabel.textAlignment = NSTextAlignmentCenter;
    rulesLabel.font = [UIFont fontWithName:@"Superclarendon" size:20];
    rulesLabel.layer.borderWidth = 2;
    
    UITapGestureRecognizer *showRules = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showRulesScreen)];
    [rulesLabel addGestureRecognizer:showRules];
    
    UILabel *restartLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - self.frame.size.width *0.02 - 100, self.frame.size.height/2 - 50, 100, 100)];
    restartLabel.backgroundColor = [UIColor colorWithRed:0.863 green:0.078 blue:0.235 alpha:1];
    restartLabel.userInteractionEnabled = YES;
    restartLabel.layer.cornerRadius = 50;
    restartLabel.transform = CGAffineTransformMakeRotation(M_PI/2);
    restartLabel.clipsToBounds = YES;
    restartLabel.text = @"RESTART";
    restartLabel.textAlignment = NSTextAlignmentCenter;
    restartLabel.font = [UIFont fontWithName:@"Superclarendon" size:18];
    restartLabel.layer.borderWidth = 2;
    
    UITapGestureRecognizer *restartGame = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(restartGame)];
    [restartLabel addGestureRecognizer:restartGame];
    
    [self.view addSubview:mainLabel];
    [self.view addSubview:actionLabel];
    [self.view addSubview:mainLabel2];
    [self.view addSubview:actionLabel2];
    [self.view addSubview:detailsLabel];
    [self.view addSubview:detailsLabel2];
    [self.view addSubview:rulesLabel];
    [self.view addSubview:restartLabel];
    
}

-(void)createMap{
    
    BOOL blackOrWhite = false;
    
        [self createHUD];
    
    treeGiant = [SKPiece initPieceOfType:TreeGiant ofPlayer:2];
    treeGiant.position = CGPointMake(CGRectGetMidX(self.frame) - 360,CGRectGetMidY(self.frame));
    treeGiant.size = CGSizeMake(40, 40);
    [self addChild:treeGiant];

    stoneGiant = [SKPiece initPieceOfType:StoneGiant ofPlayer:2];
    stoneGiant.position = CGPointMake(CGRectGetMidX(self.frame) + 355,CGRectGetMidY(self.frame));
    stoneGiant.size = CGSizeMake(40, 40);
    [self addChild:stoneGiant];
    
    for (int g = 0; g < 4; g++){
        for (int h = 0; h < 6; h++){
            SKCell *cell = [SKCell initWithColor:blackOrWhite];
            [self addChild:cell];
            [cellArray addObject:cell];
            cell.index = cells;
            cell.line = g;
            cell.column = h + 5;
            cells++;
            int a = CGRectGetMidX(self.frame) - 105;
            int b = CGRectGetMidY(self.frame) + 305;
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
            
           
            SKCell *cell = [SKCell initWithColor:blackOrWhite];
            cell.line = i + 4;
            cell.column = j + 4;
            [self addChild:cell];
            [cellArray addObject:cell];
            int a = CGRectGetMidX(self.frame) - 145;
            int b = CGRectGetMidY(self.frame) + 145;
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
            
            SKCell *cell = [SKCell initWithColor:blackOrWhite];
            [self addChild:cell];
            [cellArray addObject:cell];
            cell.index = cells;
            cell.line = g + 12;
            cell.column = h + 5;
            cells++;
            int a = CGRectGetMidX(self.frame) - 105;
            int b = CGRectGetMidY(self.frame) - 175;
            cell.position = CGPointMake(a + h * 40, b - g * 40);
            [self pieceForCell:cell];
            blackOrWhite = !blackOrWhite;
        }
        blackOrWhite = !blackOrWhite;
    }
    
    for (int g = 0; g < 6; g++){
        for (int h = 0; h < 4; h++){
           
            SKCell *cell = [SKCell initWithColor:blackOrWhite];
            [self addChild:cell];
            [cellArray addObject:cell];
            cell.index = cells;
            cell.line = g + 5;
            cell.column = h + 12;
            cells++;
            int a = CGRectGetMidX(self.frame) + 175;
            int b = CGRectGetMidY(self.frame) + 105;
            cell.position = CGPointMake(a + h * 40, b - g * 40);
            blackOrWhite = !blackOrWhite;
        }
        blackOrWhite = !blackOrWhite;
    }
    
    for (int g = 0; g < 6; g++){
        for (int h = 0; h < 4; h++){
            SKCell *cell = [SKCell initWithColor:blackOrWhite];
            [self addChild:cell];
            [cellArray addObject:cell];
            cell.index = cells;
            cell.line = g + 5;
            cell.column = h;
            cells++;
            int a = CGRectGetMidX(self.frame) - 305;
            int b = CGRectGetMidY(self.frame) + 105;
            cell.position = CGPointMake(a + h * 40, b - g * 40);
            blackOrWhite = !blackOrWhite;
        }
        blackOrWhite = !blackOrWhite;
    }
    
    UISwipeGestureRecognizer *checkPiece = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(showPieceInfo:)];
    checkPiece.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:checkPiece];
}

-(void)showPieceInfo:(UISwipeGestureRecognizer*)recognizer{
    CGPoint touchLocation = [recognizer locationInView:recognizer.view];
    touchLocation = [self convertPointFromView:touchLocation];
    SKCell *temp;
    for (int i = 0; i < cellArray.count; i++){
        temp = cellArray[i];
        if ([temp containsPoint:touchLocation] && temp.currentPiece != nil){
            NSString *text = [[NSString alloc]initWithFormat:@"%@ \n Hp: %d \n Damage: %d \n Movespeed: %d", temp.currentPiece.convertToString, temp.currentPiece.hitPoints, temp.currentPiece.attackDamage, temp.currentPiece.moveSpeed];
            if(!temp.currentPiece.player)
                detailsLabel.text = text;
            else
                detailsLabel2.text = text;
        }
    }


}

-(void)skipPhaseOfPlayerOne{
    if (blackPlays){
        NSLog(@"Start of skipPhase, turnPhase is %d", currentPhase);
        detailsLabel.text = @"Swipe left to check piece info";
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
        if (currentPhase == ChoseAttacker){
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
        NSLog(@"Start of skipPhase, turnPhase is %d", currentPhase);
        detailsLabel2.text = @"Swipe right to check piece info";

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
                NSLog(@"bug4");
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
                NSLog(@"bug5");
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
                NSLog(@"bug6");
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

-(void)showRulesScreen{

    UIViewController *mainView = self.view.window.rootViewController;
    RulesViewController *rulesView = [[RulesViewController alloc]init];
    [mainView presentViewController:rulesView animated:YES completion:nil];
}

-(void)restartGame{
    [cellArray removeAllObjects];
    [self removeAllChildren];
    [self generalInitiation];
    [self createMap];
    [self createHUD];
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
    if ((currentPhase == ChoseMove || currentPhase == ChoseDirection ) && lastCell != nil){
        SKAction * unSelect = [SKAction setTexture:lastCell.cellTexture];
        [currentCell runAction:unSelect];
        [currentCell runAction:[SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:0.0f duration:0.0f]];
    }
    currentCell = cell;
    NSString *text = [[NSString alloc]initWithFormat:@"%@ \n Hp: %d \n Damage: %d \n Movespeed: %d", currentCell.currentPiece.convertToString, currentCell.currentPiece.hitPoints, currentCell.currentPiece.attackDamage, currentCell.currentPiece.moveSpeed];
    if(!currentCell.currentPiece.player)
        detailsLabel.text = text;
    else
        detailsLabel2.text = text;
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
    
    SKAction * unSelect = [SKAction setTexture:lastCell.cellTexture];
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
            SKTexture *white = [SKTexture textureWithImage:[UIImage imageNamed:@"white.png"]];
            [tempCell runAction:[SKAction setTexture:white]];
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
    SKAction * unSelect = [SKAction setTexture:lastCell.cellTexture];
    [lastCell runAction:unSelect];
    [self unHighlightAllCells];
    
    if ([self showTowerTargetsOfPlayer:blackPlays]){
        currentPhase = ChoseTowerTarget;
        [self labelTextForTurnPhase];

    }
    else if ([self highlightsPossibleActionCellsOfPlayer:blackPlays]){
        NSLog(@"bug7");
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
    BOOL clickOnMap = false;
    for (int i = 0; i < cellArray.count; i++){
        tempCell = [cellArray objectAtIndex:i];
        if ([tempCell containsPoint:positionInScene]){
            clickOnMap = true;
            break;
        }
    }
    if (!clickOnMap)
        return;
    for (int i = 0; i < cellArray.count; i++){
        towerCell = cellArray[i];
        if (towerCell.currentPiece.pieceType == Tower)
            break;
    }
    
    for (int i = 0; i < possibleTowerTargets.count; i++){
        tempCell = [possibleTowerTargets objectAtIndex:i];
        if ([tempCell containsPoint:positionInScene]){
            [self damageFromCell:towerCell toCell:tempCell];
        }
    }
    
    [possibleAttackers removeAllObjects];
    [self unHighlightAllCells];
    
    if ([self highlightsPossibleActionCellsOfPlayer:blackPlays]){
        currentPhase = ChoseAction;
        [self labelTextForTurnPhase];
    }
    else{
    currentPhase = ChoseMove;
    blackPlays = !blackPlays;
    [self labelTextForTurnPhase];
    }
    
    SKAction * unSelect = [SKAction setTexture:lastCell.cellTexture];
    [lastCell runAction:unSelect];
    
}


/* Ve quais pecas atacarão o alvo escolhido */

-(void)checkAttackersOnCell:(SKCell*)targetCell{
    SKCell *tempCell;
    SKAction * unSelect = [SKAction setTexture:lastCell.cellTexture];
    [lastCell runAction:unSelect];
    [possibleCellsArray removeAllObjects];
    for (int i = 0; i < possibleAttackers.count; i++){
        tempCell = [possibleAttackers objectAtIndex:i];
        [self highlightAttackOptionsOfCell:tempCell withRangeMin:tempCell.currentPiece.rangeMin andMax:tempCell.currentPiece.rangeMax];
        if ([possibleCellsArray containsObject:targetCell])
            [self damageFromCell:tempCell toCell:targetCell];
        }
        [targetCell runAction:[SKAction setTexture:targetCell.cellTexture]];
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
    SKCell * targetCell;
    for (int i = 0; i < possibleTowerTargets.count; i++){
        targetCell = possibleTowerTargets[i];
        [targetCell runAction:[SKAction setTexture:red]];
    
    }
    NSLog(@"Tower targets are %ld",(unsigned long) possibleTowerTargets.count);
    if (possibleTowerTargets.count == 0){
        return false;
    }
    return true;
}


-(void)damageFromCell: (SKCell*)attacker toCell: (SKCell*)target{
    int temp = target.currentPiece.hitPoints;
    int damage;
    if (attacker.currentPiece.fireDamage){
        if (attacker.currentPiece.mainClass == Archer){
            damage = attacker.currentPiece.attackDamage * target.currentPiece.arrowDamageMultiplier * target.currentPiece.fireDamageMultiplier;
            target.currentPiece.hitPoints -= damage;
        }
        else{
            damage = attacker.currentPiece.attackDamage * attacker.currentPiece.fireDamageMultiplier;
            target.currentPiece.hitPoints -= damage;
        }
    }
    
    /* Dano sem fogo */
    else{
        if (attacker.currentPiece.mainClass == Archer){
            damage = attacker.currentPiece.attackDamage * target.currentPiece.arrowDamageMultiplier;
            target.currentPiece.hitPoints -= damage;
        }
        else{
            damage = attacker.currentPiece.attackDamage;
            target.currentPiece.hitPoints -= damage;
        }
        
        
    }
    NSString *attackerClass = attacker.currentPiece.convertToString;
    NSString *targetClass = target.currentPiece.convertToString;
    NSString *text = [[NSString alloc] initWithFormat:@"%@ attacks %@ with %d damage! %d hp left.",attackerClass, targetClass, temp, target.currentPiece.hitPoints > 0? target.currentPiece.hitPoints:0];
    if(blackPlays)
        detailsLabel.text = text;
    else
        detailsLabel2.text = text;
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
                [self unHighlightAllCells];
                [self selectCell:destinyCell];
                moveCounter++;
                if (moveCounter >= piece.moveSpeed){
                    if (blackPlays){
                        NSString *text = [[NSString alloc]initWithFormat:@"Swipe left to check piece info"];
                        detailsLabel.text = text;
                    }
                    else{
                        NSString *text = [[NSString alloc]initWithFormat:@"Swipe right to check piece info"];
                        detailsLabel2.text = text;
                    }
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
                            NSLog(@"bug");
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
                NSString *text;
                if (currentCell.currentPiece.moveSpeed - moveCounter == 1){
                    text = [[NSString alloc]initWithFormat:@"You have %d move left",currentCell.currentPiece.moveSpeed - moveCounter];
                }else{
                    text = [[NSString alloc]initWithFormat:@"You have %d moves left",currentCell.currentPiece.moveSpeed - moveCounter];
                }
                if (blackPlays)
                    detailsLabel.text = text;
                else
                    detailsLabel2.text = text;
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
        [self unHighlightCellsOfAction];
        [currentCell runAction:[SKAction colorizeWithColor:[UIColor magentaColor] colorBlendFactor:1.0 duration:0]];
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
            if (currentCell.column == 15 && (currentCell.line == 8 || currentCell.line == 7)){
                if (!hasActivatedStoneGiant){
                    SKCell* tempCell;
                    if (currentCell.line == 8)
                        tempCell = [self cellForLine:7 andColumn:15];
                    if (currentCell.line == 7)
                        tempCell = [self cellForLine:8 andColumn:16];
                    [tempCell removeAllChildren];
                    [stoneGiant removeFromParent];
                    SKPiece *playableStoneGiant = [SKPiece initPieceOfType:StoneGiant ofPlayer:0];
                    tempCell.currentPiece = playableStoneGiant;
                    [tempCell addChild:playableStoneGiant];
                    playableStoneGiant.player = !blackPlays;
                    playableStoneGiant.zPosition = 0.1f;
                    actionIsSimple = true;
                    hasActivatedStoneGiant = true;
                    NSString *text = @"The mage has awaken the Stone Giant!";
                    if (blackPlays)
                        detailsLabel.text = text;
                    else
                        detailsLabel2.text = text;
                    break;
                    
                }
            }
            actionIsSimple = true;
            [self highlightAttackOptionsOfCell:actionCell withRangeMin:1 andMax:1];
            SKAction *burnUp = [SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:1 duration:0.2f];
            SKCell * tempCell;
            for (int i = 0; i < possibleCellsArray.count; i++){
                tempCell = possibleCellsArray[i];
                SKAction *burnDown = [SKAction setTexture:tempCell.cellTexture];
                [tempCell runAction:burnUp completion:^{[tempCell runAction:burnDown];}];
                if (tempCell.currentPiece != nil && tempCell.currentPiece.player != actionCell.currentPiece.player){
                    tempCell.currentPiece.hitPoints -= 5 * tempCell.currentPiece.fireDamageMultiplier;
                    NSString *text = [[NSString alloc]initWithFormat:@"The Fire Mage has burned every enemy around him with 5 fire damage!"];
                    if (blackPlays)
                        detailsLabel.text = text;
                    else
                        detailsLabel2.text = text;
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
            if (currentCell.column == 0 && (currentCell.line == 8 || currentCell.line == 7)){
                if (!hasActivatedTreeGiant){
                    SKCell* tempCell;
                    if (currentCell.line == 8)
                        tempCell = [self cellForLine:7 andColumn:0];
                    if (currentCell.line == 7)
                        tempCell = [self cellForLine:8 andColumn:0];
                        [tempCell removeAllChildren];
                        [treeGiant removeFromParent];
                        SKPiece *playableTreeGiant = [SKPiece initPieceOfType:TreeGiant ofPlayer:0];
                        tempCell.currentPiece = playableTreeGiant;
                        [tempCell addChild:playableTreeGiant];
                        playableTreeGiant.player = !blackPlays;
                        playableTreeGiant.zPosition = 0.1f;
                        actionIsSimple = true;
                        hasActivatedTreeGiant = true;
                        NSString *text = @"The mage has awaken the Tree Giant!";
                        if (blackPlays)
                            detailsLabel.text = text;
                        else
                            detailsLabel2.text = text;
                        break;
                    
                }
            }
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
                SKAction *burnDown = [SKAction colorizeWithColor:[UIColor redColor] colorBlendFactor:0 duration:0.2f];
                [tempCell runAction:burnUp completion:^{[tempCell runAction:burnDown];}];
                if (tempCell.currentPiece != nil){
                    int temp = tempCell.currentPiece.hitPoints;
                    tempCell.currentPiece.hitPoints -= 10 * tempCell.currentPiece.fireDamageMultiplier;
                    NSString *text = @"The Saboteur has exploded, dealing 10 fire damage to everyone around him!";
                    if (blackPlays)
                        detailsLabel.text = text;
                    else
                        detailsLabel2.text = text;
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
                SKAction *lightDown = [SKAction colorizeWithColor:[UIColor whiteColor] colorBlendFactor:0 duration:0.2f];
                [tempCell runAction:lightUp completion:^{[tempCell runAction:lightDown];}];
                NSMutableString *text = [[NSMutableString alloc]initWithFormat:@"The Light Mage has nuked  %@ with 10 damage. ",tempCell.currentPiece.convertToString];
                
                if (tempCell.currentPiece.hitPoints <= 0){
                    [tempCell removeAllChildren];
                    tempCell.currentPiece = nil;
                    [text appendString:@"He's dead!"];
                }
                if (blackPlays)
                    detailsLabel.text = text;
                else
                    detailsLabel2.text = text;
            }
        
        }
    
    }
    
    if (actionCell.currentPiece.pieceType == RoyalGuard){
        SKCell * tempCell;
        for (int i = 0; i < possibleCellsArray.count; i++){
            tempCell = possibleCellsArray[i];
            if ([tempCell containsPoint:positionInScene]){
                SKAction *healUp = [SKAction colorizeWithColor:[UIColor yellowColor] colorBlendFactor:1 duration:0.4f];
                SKAction *healDown = [SKAction setTexture:tempCell.cellTexture];
                [tempCell runAction:healUp completion:^{[tempCell runAction:healDown];}];
                tempCell.currentPiece.hitPoints += 5;
                NSString *text = [[NSString alloc]initWithFormat:@"The Royal Guard has healed %@ with 5 hitpoints",tempCell.currentPiece.convertToString];
                if (blackPlays)
                    detailsLabel.text = text;
                else
                    detailsLabel2.text = text;
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
                SKAction *burnDown = [SKAction setTexture:tempCell.cellTexture];
                [tempCell runAction:burnUp completion:^{[tempCell runAction:burnDown];}];
                tempCell.currentPiece.hitPoints -= 5 * tempCell.currentPiece.fireDamageMultiplier;
                NSMutableString *text = [[NSMutableString alloc]initWithFormat:@"The Dragon has burned %@ with 5 fire damage. ",tempCell.currentPiece.convertToString ];
               
                if (tempCell.currentPiece.hitPoints <= 0){
                    [tempCell removeAllChildren];
                    tempCell.currentPiece = nil;
                    [text appendString:@"He's dead!"];
                }
                if (blackPlays)
                    detailsLabel.text = text;
                else
                    detailsLabel2.text = text;
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
    SKTexture *blue = [SKTexture textureWithImage:[UIImage imageNamed:@"blue.png"]];
    SKCell *tempCell;
    NSLog(@"Index da celula principal : %d", cell.index);
    if (cell.column != 0){
        tempCell = [self cellForLine:cell.line andColumn:cell.column - 1];
        if (tempCell != nil)
            if (tempCell.currentPiece == nil && (tempCell.line == cell.line)){
                [tempCell runAction:[SKAction setTexture:blue]];
                [possibleCellsArray addObject:tempCell];
            }
    }
    
    
    
    if (cell.column < 16){
        tempCell = [self cellForLine:cell.line andColumn:cell.column + 1];
        if (tempCell != nil)
            if (tempCell.currentPiece == nil && (tempCell.line == cell.line)){
                [tempCell runAction:[SKAction setTexture:blue]];
                [possibleCellsArray addObject:tempCell];
                
            }
    }
    
    if (cell.line != 15 ){
        tempCell = [self cellForLine:cell.line + 1 andColumn:cell.column];
        if (tempCell != nil)
            if (tempCell.currentPiece == nil){
                [tempCell runAction:[SKAction setTexture:blue]];
                [possibleCellsArray addObject:tempCell];
            }
    }
    
    if (cell.column != 16 && cell.line != 15 ){
        tempCell = [self cellForLine:cell.line + 1 andColumn:cell.column + 1];
        if (tempCell != nil)
            if (tempCell.currentPiece == nil ){
                [tempCell runAction:[SKAction setTexture:blue]];
                [possibleCellsArray addObject:tempCell];
            }
    }
    
    if (cell.column > 0 && cell.line != 15 ){
        tempCell = [self cellForLine:cell.line + 1 andColumn:cell.column - 1];
        if (tempCell != nil)
            if (tempCell.currentPiece == nil ){
                [tempCell runAction:[SKAction setTexture:blue]];
                [possibleCellsArray addObject:tempCell];
            }
    }
    
    if (cell.line > 0 && cell.column != 15 ){
        tempCell = [self cellForLine:cell.line - 1 andColumn:cell.column + 1];
        if (tempCell != nil)
            if (tempCell.currentPiece == nil ){
                [tempCell runAction:[SKAction setTexture:blue]];
                
                [possibleCellsArray addObject:tempCell];
            }
    }
    
    if (cell.line > 0 ){
        tempCell = [self cellForLine:cell.line - 1 andColumn:cell.column];
        if (tempCell != nil)
            if (tempCell.currentPiece == nil){
                [tempCell runAction:[SKAction setTexture:blue]];
                [possibleCellsArray addObject:tempCell];
            }
    }
    
    if (cell.line > 0 && cell.column > 0 ){
        tempCell = [self cellForLine:cell.line - 1 andColumn:cell.column - 1];
        if (tempCell != nil)
            if (tempCell.currentPiece == nil  ){
                [tempCell runAction:[SKAction setTexture:blue]];
                [possibleCellsArray addObject:tempCell];
            }
    }
    
    if (possibleCellsArray.count == 0){
        SKAction * unSelect = [SKAction setTexture:cell.cellTexture];
        [cell runAction:unSelect];
        
    }
}

-(void)highlightSurroundingsOfCell:(SKCell*)cell{
    
    SKTexture *blue = [SKTexture textureWithImage:[UIImage imageNamed:@"blue.png"]];
    SKCell *tempCell;
    NSLog(@"Index da celula principal : %d", cell.index);
    if (cell.column != 0){
        tempCell = [self cellForLine:cell.line andColumn:cell.column - 1];
        if (tempCell != nil)
                [tempCell runAction:[SKAction setTexture:blue]];
                [possibleCellsArray addObject:tempCell];
    }
    
    
    
    if (cell.column < 16){
        tempCell = [self cellForLine:cell.line andColumn:cell.column + 1];
        if (tempCell != nil)
                [tempCell runAction:[SKAction setTexture:blue]];
                [possibleCellsArray addObject:tempCell];
            }
    
    if (cell.line != 15 ){
        tempCell = [self cellForLine:cell.line + 1 andColumn:cell.column];
        if (tempCell != nil)
                [tempCell runAction:[SKAction setTexture:blue]];
                [possibleCellsArray addObject:tempCell];
        
    }
    
    if (cell.column != 16 && cell.line != 15 ){
        tempCell = [self cellForLine:cell.line + 1 andColumn:cell.column + 1];
        if (tempCell != nil)
                [tempCell runAction:[SKAction setTexture:blue]];
                [possibleCellsArray addObject:tempCell];
    }
    
    if (cell.column > 0 && cell.line != 15 ){
        tempCell = [self cellForLine:cell.line + 1 andColumn:cell.column - 1];
        if (tempCell != nil)
                [tempCell runAction:[SKAction setTexture:blue]];
                [possibleCellsArray addObject:tempCell];
    }
    
    if (cell.line > 0 && cell.column != 15 ){
        tempCell = [self cellForLine:cell.line - 1 andColumn:cell.column + 1];
        if (tempCell != nil)
                [tempCell runAction:[SKAction setTexture:blue]];
                [possibleCellsArray addObject:tempCell];
        
    }
    
    if (cell.line > 0 ){
        tempCell = [self cellForLine:cell.line - 1 andColumn:cell.column];
        if (tempCell != nil)
                [tempCell runAction:[SKAction setTexture:blue]];
                [possibleCellsArray addObject:tempCell];
        
    }
    
    if (cell.line > 0 && cell.column > 0 ){
        tempCell = [self cellForLine:cell.line - 1 andColumn:cell.column - 1];
        if (tempCell != nil)
                [tempCell runAction:[SKAction setTexture:blue]];
                [possibleCellsArray addObject:tempCell];
    }
    
    if (possibleCellsArray.count == 0){
        SKAction * unSelect = [SKAction setTexture:cell.cellTexture];
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
                        [tempCell runAction:[SKAction setTexture:red]];
                        [possibleCellsArray addObject:tempCell];
                    }
                }
        }
        
        
        
        
        if (cell.column < 16){
            tempCell = [self cellForLine:cell.line andColumn:cell.column + 1];
            if (tempCell != nil)
                if (tempCell.currentPiece != nil && (tempCell.line == cell.line)){
                    if (tempCell.currentPiece.player != cell.currentPiece.player){
                        
                        [tempCell runAction:[SKAction setTexture:red]];
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
                        
                        [tempCell runAction:[SKAction setTexture:red]];
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
                        
                        [tempCell runAction:[SKAction setTexture:red]];
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
                        
                        [tempCell runAction:[SKAction setTexture:red]];
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
                        
                        [tempCell runAction:[SKAction setTexture:red]];
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
                        
                        [tempCell runAction:[SKAction setTexture:red]];
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
                        
                        [tempCell runAction:[SKAction setTexture:red]];
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
                        [tempCell runAction:[SKAction setTexture:red]];
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
                        [tempCell runAction:[SKAction setTexture:red]];
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
                        [tempCell runAction:[SKAction setTexture:red]];
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
                        [tempCell runAction:[SKAction setTexture:red]];
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
                        [tempCell runAction:[SKAction setTexture:red]];
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
                        [tempCell runAction:[SKAction setTexture:red]];
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
                        [tempCell runAction:[SKAction setTexture:red]];
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
                        [tempCell runAction:[SKAction setTexture:red]];
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
                        [tempCell runAction:[SKAction setTexture:red]];
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
                        [tempCell runAction:[SKAction setTexture:red]];
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
                        [tempCell runAction:[SKAction setTexture:red]];
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
                        [tempCell runAction:[SKAction setTexture:red]];
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
    SKTexture *white = [SKTexture textureWithImage:[UIImage imageNamed:@"white.png"]];
        if (cell.column != 0){
            tempCell = [self cellForLine:cell.line andColumn:cell.column - 1];
            if (tempCell != nil)
                if (tempCell.currentPiece != nil && (tempCell.currentPiece.hitPoints < tempCell.currentPiece.maxHitPoints)){
                    if (tempCell.currentPiece.player == cell.currentPiece.player){
                        [tempCell runAction:[SKAction setTexture:white]];
                        [possibleCellsArray addObject:tempCell];
                    }
                }
        
        
        if (cell.column < 16){
            tempCell = [self cellForLine:cell.line andColumn:cell.column + 1];
            if (tempCell != nil)
                if (tempCell.currentPiece != nil && (tempCell.currentPiece.hitPoints < tempCell.currentPiece.maxHitPoints)){
                    if (tempCell.currentPiece.player == cell.currentPiece.player){
                        
                        [tempCell runAction:[SKAction setTexture:white]];
                        [possibleCellsArray addObject:tempCell];
                    }
                }
        }
        tempCell = nil;
        if (cell.line != 15 ){
            tempCell = [self cellForLine:cell.line + 1 andColumn:cell.column];
            if (tempCell != nil)
                if (tempCell.currentPiece != nil && (tempCell.currentPiece.hitPoints < tempCell.currentPiece.maxHitPoints)){
                    if (tempCell.currentPiece.player == cell.currentPiece.player){
                        
                        [tempCell runAction:[SKAction setTexture:white]];
                        [possibleCellsArray addObject:tempCell];
                    }
                }
        }
        tempCell = nil;
        if (cell.column != 16 && cell.line != 15 ){
            tempCell = [self cellForLine:cell.line + 1 andColumn:cell.column + 1];
            if (tempCell != nil)
                if (tempCell.currentPiece != nil && (tempCell.currentPiece.hitPoints < tempCell.currentPiece.maxHitPoints)){
                    if (tempCell.currentPiece.player == cell.currentPiece.player){
                        
                        [tempCell runAction:[SKAction setTexture:white]];
                        [possibleCellsArray addObject:tempCell];
                    }
                }
        }
        tempCell = nil;
        if (cell.column > 0 && cell.line != 15 ){
            tempCell = [self cellForLine:cell.line + 1 andColumn:cell.column - 1];
            if (tempCell != nil)
                if (tempCell.currentPiece != nil && (tempCell.currentPiece.hitPoints < tempCell.currentPiece.maxHitPoints)){
                    if (tempCell.currentPiece.player == cell.currentPiece.player){
                        
                        [tempCell runAction:[SKAction setTexture:white]];
                        [possibleCellsArray addObject:tempCell];
                    }
                }
        }
        tempCell = nil;
        
        if (cell.line > 0 && cell.column != 15 ){
            tempCell = [self cellForLine:cell.line - 1 andColumn:cell.column + 1];
            if (tempCell != nil)
                if (tempCell.currentPiece != nil && (tempCell.currentPiece.hitPoints < tempCell.currentPiece.maxHitPoints)){
                    if (tempCell.currentPiece.player == cell.currentPiece.player){
                        
                        [tempCell runAction:[SKAction setTexture:white]];
                        [possibleCellsArray addObject:tempCell];
                    }
                }
        }
        tempCell = nil;
        if (cell.line > 0 ){
            tempCell = [self cellForLine:cell.line - 1 andColumn:cell.column];
            if (tempCell != nil)
                if (tempCell.currentPiece != nil && (tempCell.currentPiece.hitPoints < tempCell.currentPiece.maxHitPoints)){
                    if (tempCell.currentPiece.player == cell.currentPiece.player){
                        
                        [tempCell runAction:[SKAction setTexture:white]];
                        [possibleCellsArray addObject:tempCell];
                    }
                }
        }
        tempCell = nil;
        if (cell.line > 0 && cell.column > 0 ){
            tempCell = [self cellForLine:cell.line - 1 andColumn:cell.column - 1];
            if (tempCell != nil)
                if (tempCell.currentPiece != nil && (tempCell.currentPiece.hitPoints < tempCell.currentPiece.maxHitPoints)){
                    if (tempCell.currentPiece.player == cell.currentPiece.player){
                        
                        [tempCell runAction:[SKAction setTexture:white]];
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
            
            switch (tempCell.currentPiece.pieceType) {
                case Dragon:
                    [self highlightAttackOptionsOfCell:tempCell withRangeMin:tempCell.currentPiece.rangeMin andMax:tempCell.currentPiece.rangeMax];
                    if (possibleCellsArray.count == 0){
                        continue;
                    }
                    [tempCell runAction:[SKAction setTexture:red]];
                    [possibleActionCells addObject:tempCell];
                    break;
                case LightMage:
                    if (tempCell.column != 0 || (tempCell.line != 7 && tempCell.line != 8) || hasActivatedTreeGiant){
                        [self highlightAttackOptionsOfCell:tempCell withRangeMin:tempCell.currentPiece.rangeMin andMax:tempCell.currentPiece.rangeMax];
                        if (possibleCellsArray.count == 0){
                            continue;
                        }
                    }
                    [tempCell runAction:[SKAction setTexture:red]];
                    [possibleActionCells addObject:tempCell];
                    break;
                case FireMage:
                    [self highlightAttackOptionsOfCell:tempCell withRangeMin:1 andMax:1];
                    if (possibleCellsArray.count == 0){
                        continue;
                    }
                    [tempCell runAction:[SKAction setTexture:red]];
                    [possibleActionCells addObject:tempCell];
                    break;
                case RoyalGuard:
                    [self highlightFriendlyOptionsOfCell:tempCell];
                    if (possibleCellsArray.count == 0){
                        continue;
                    }
                    [tempCell runAction:[SKAction setTexture:red]];
                    [possibleActionCells addObject:tempCell];
                    break;
                default:
                    [tempCell runAction:[SKAction setTexture:red]];
                    [possibleActionCells addObject:tempCell];
                    break;
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
        [tempCell runAction:[SKAction colorizeWithColor:[UIColor magentaColor] colorBlendFactor:0 duration:0]];
        [tempCell runAction:[SKAction setTexture:tempCell.cellTexture]];
    }
    [possibleCellsArray removeAllObjects];
}

-(void)unHighlightAllCells{
    SKCell *tempCell;
    for (int i = 0; i < cellArray.count; i++){
        tempCell = [cellArray objectAtIndex:i];
        [tempCell runAction:[SKAction colorizeWithColor:[UIColor magentaColor] colorBlendFactor:0 duration:0]];
        [tempCell runAction:[SKAction setTexture:tempCell.cellTexture]];
    }
}

-(void)unHighlightCellsOfAction{
    SKCell *tempCell;
    for (int i = 0; i < possibleActionCells.count; i++){
        tempCell = [possibleActionCells objectAtIndex:i];
        [tempCell runAction:[SKAction colorizeWithColor:[UIColor magentaColor] colorBlendFactor:0 duration:0]];
        [tempCell runAction:[SKAction setTexture:tempCell.cellTexture]];
    }
    [possibleActionCells removeAllObjects];
}

-(void)unHighlightAttackersCells{
    SKCell *tempCell;
    for (int i = 0; i < possibleAttackers.count; i++){
        tempCell = [possibleAttackers objectAtIndex:i];
        [tempCell runAction:[SKAction colorizeWithColor:[UIColor magentaColor] colorBlendFactor:0 duration:0]];
        [tempCell runAction:[SKAction setTexture:tempCell.cellTexture]];
    }
    [possibleAttackers removeAllObjects];
}

#pragma mark - DataPairing Functions

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
                mainLabel2.text = @"Choose which piece will be targeted by the action";
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
                newPiece = [SKPiece initPieceOfType:FireMage ofPlayer:player];
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
        cell.currentPiece.zPosition = 0.1f;
        [cell addChild:newPiece];
    }
}


@end
