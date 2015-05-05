//
//  RulesViewController.m
//  CyvasseDev
//
//  Created by Lorenzo Saraiva on 5/4/15.
//  Copyright (c) 2015 BEPID-PucRJ. All rights reserved.
//

#import "RulesViewController.h"

@interface RulesViewController ()

@end

@implementation RulesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.view.frame];
    backgroundView.image = [UIImage imageNamed:@"redwood.jpg"];
    [self.view addSubview:backgroundView];
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.05, self.view.frame.size.width*0.05, self.view.frame.size.width*0.9, self.view.frame.size.height*0.9)];
    scrollView.backgroundColor = [UIColor colorWithRed:0.933 green:0.875 blue:0.651 alpha:1];
    scrollView.layer.cornerRadius = 10;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height*2);
    [self.view addSubview:scrollView];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(scrollView.frame.size.width*0.5 - scrollView.frame.size.width*0.25, self.view.frame.size.height*0.1, scrollView.frame.size.width*0.5, self.view.frame.size.height*0.1)];
    title.text = @"The rules of Gigas Bellum";
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont fontWithName:@"Superclarendon" size:25];
    [scrollView addSubview:title];
    
    UILabel *back = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.01, self.view.frame.size.width*0.01, self.view.frame.size.width*0.04, self.view.frame.size.width*0.04)];
    back.backgroundColor = [UIColor colorWithRed:0.863 green:0.078 blue:0.235 alpha:1];
    back.text = @"<";
    back.textAlignment = NSTextAlignmentCenter;
    back.layer.cornerRadius = 20;
    back.userInteractionEnabled = true;
    back.layer.borderWidth = 2;
    back.clipsToBounds = true;
    back.font = [UIFont fontWithName:@"Superclarendon" size:40];
    [self.view addSubview:back];
    
    UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissRules)];
    [back addGestureRecognizer:backTap];

    
    UITextView *general = [[UITextView alloc]initWithFrame:CGRectMake(scrollView.frame.size.width*0.1, scrollView.frame.size.height*0.25, scrollView.frame.size.width*0.8, scrollView.frame.size.height*0.9)];
    general.userInteractionEnabled = false;
    general.backgroundColor = [UIColor colorWithRed:0.933 green:0.875 blue:0.651 alpha:1];
    general.font = [UIFont fontWithName:@"Superclarendon" size:18];
    general.text = @"Gigas Bellum is a board game which RPG-like elements, in which the main objective is to kill the enemy king. You should play it with two players and the Ipad horizontally on flat surface, each player in one side. Each piece has a different amount of hitpoint, attack damage, move speed and so. Also, some pieces have other actions besides attacking, which we will cover later. The turn is divided into three phases. The first one is the move phase, where the player can choose a piece and moves it a number of squares correspondant to the its move speed or less. The second one is the attack phase, where the player can choose a piece to perform the main attack and the target of the attack. When an attack is performed, all allied pieces who are able to attack the target will join. After the main attack, if there is a piece on the range of the towers - which are the only pieces that dont move - they can perform another attack. If there are no possible attacks this phase will be skiped automatically. The last phase is the action phase, where the player can choose a piece to perform an action and, if necessary, chose the action target. If there is no action avaliable, this phase will be skipped automatically. If the player wants to skip a turn phase, he just has to tap the SKIP button. At the sides of the board there are two neutral pieces: the giants. This two pieces are extremely strong, only comparable to the Dragon, but they need to be activated: you need the take a specific to one of the squares near it and the awken action will be avaliable. To awaken the Tree Giant, you need your Light Mage, for the Stone Giant, the fire mage. Even though the giants are very strong, they are not necessary to win the game, and focusing too much on them can lead to a quick fall if the enemy is agressive.";
    [scrollView addSubview:general];

    
    UILabel *actionTitle = [[UILabel alloc]initWithFrame:CGRectMake(scrollView.frame.size.width*0.5 - scrollView.frame.size.width*0.25, general.frame.origin.y + general.frame.size.height + scrollView.frame.size.height*0.05, scrollView.frame.size.width*0.5, self.view.frame.size.height*0.1)];
    actionTitle.text = @"List of Actions";
    actionTitle.textAlignment = NSTextAlignmentCenter;
    actionTitle.font = [UIFont fontWithName:@"Superclarendon" size:25];
    [scrollView addSubview:actionTitle];
    

    // Do any additional setup after loading the view.
}

-(void)dismissRules{
    [self dismissViewControllerAnimated:true completion:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden{
    return true;
}

@end
