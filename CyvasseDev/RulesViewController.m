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
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height*3.3);
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
    general.text = @"Gigas Bellum is a board game which RPG-like elements, in which the main objective is to kill the enemy king. You should play it with two players and the Ipad layed horizontally on flat surface, each player in one side of it. Each piece has a different amount of hitpoints, attack damage, move speed and so. Also, some pieces have other actions besides attacking, which we will cover later. The turn is divided into three phases. The first one is the move phase, where the player can choose a piece and moves it a number of squares correspondant to its move speed or less. The second one is the attack phase, where the player can choose a piece to perform the main attack and the target of that attack. When an attack is performed, all allied pieces who are able to attack the target will join. After the main attack, if there is an enemy piece on the range of the towers - which are the only pieces that dont move - they can perform another attack. If there are no possible attacks this phase will be skiped automatically. The last phase is the action phase, where the player can choose a piece to perform an action and, if necessary, chose the action target. If there is no action avaliable, this phase will be skipped automatically. If the player wants to skip a turn phase, he just has to tap the SKIP button. At the sides of the board there are two neutral pieces: the giants. This two pieces are extremely strong, only comparable to the Dragon, but they need to be activated: you need the take a specific to one of the squares near it and the awken action will be avaliable. To awaken the Tree Giant, you need your Light Mage, for the Stone Giant, the fire mage. Even though the giants are very strong, they are not necessary to win the game, and focusing too much on them can lead to a quick fall if the enemy is agressive.";
    [scrollView addSubview:general];

    
    UILabel *actionTitle = [[UILabel alloc]initWithFrame:CGRectMake(scrollView.frame.size.width*0.5 - scrollView.frame.size.width*0.25, general.frame.origin.y + general.frame.size.height + scrollView.frame.size.height*0.05, scrollView.frame.size.width*0.5, self.view.frame.size.height*0.1)];
    actionTitle.text = @"Most important Pieces";
    actionTitle.textAlignment = NSTextAlignmentCenter;
    actionTitle.font = [UIFont fontWithName:@"Superclarendon" size:25];
    [scrollView addSubview:actionTitle];
    
    float initialY = actionTitle.frame.origin.y + actionTitle.frame.size.height/2;
    
    for (int i = 0; i<9; i++){
        
    UIView *actionView = [[UIView alloc]initWithFrame:CGRectMake(general.frame.origin.x, initialY + (i*scrollView.frame.size.height * 0.2 + scrollView.frame.size.height *0.1) , general.frame.size.width, scrollView.frame.size.height *0.2)];
    [scrollView addSubview:actionView];
    
    UIImageView *actionImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, actionView.frame.size.width*0.2, actionView.frame.size.height)];
    [actionView addSubview:actionImage];
    
    UITextView *actionText = [[UITextView alloc]initWithFrame:CGRectMake(actionImage.frame.size.width, 0, actionView.frame.size.width * 0.8, actionView.frame.size.height)];
    actionText.textAlignment = NSTextAlignmentCenter;
    actionText.font = [UIFont fontWithName:@"Superclarendon" size:18];
    
    actionText.userInteractionEnabled = false;
    actionText.backgroundColor = [UIColor colorWithRed:0.933 green:0.875 blue:0.651 alpha:1];
    [actionView addSubview:actionText];
        
        switch (i) {
            case 0:
                actionText.text = @" Dragon - The strongest piece. Besides his fierce claws, it has Firebreathing as action. In this action, you chose one target up to 2 units of distance, and the Dragon will deal 7 fire damage. It's important you remember some pieces take extra fire damage!";
                actionImage.image =[UIImage imageNamed:@"dragon.png"];
                break;
            case 1:
                actionText.text = @"Fire Mage - It has very low amount of hitpoints and is slow. Its main action is to summon a wall of fire around him, burning every enemy. The secondary action is to awaken the Stone Giant.";
                actionImage.image =[UIImage imageNamed:@"firemage.png"];
                break;
            case 2:
                actionText.text = @"Light Mage - Like the other mage, it has low amount of hitpoints and movespeed. Its main action is to send a light beam on a single unit up to 2 squares away. The secondary action is to awaken the Tree Giant ";
                actionImage.image =[UIImage imageNamed:@"lightmage.png"];
                break;
            case 3:
                actionText.text = @"Royal Guard - This piece is the sworn protector of the King. It has a big amount of hitpoints and it's imune to fire and arrows. Its main action is to heal an adjecent friendly unit by 5 hitpoints.";
                actionImage.image =[UIImage imageNamed:@"royalguard"];
                break;
            case 4:
                actionText.text = @"Saboteur - Even though this pawn looks the same as others, it's a saboteur. Its action is to blow himself up, and it deals 10 fire damage to everyone around him. Be careful, this is the only action that can damage allied pieces!";
                actionImage.image =[UIImage imageNamed:@"pawn"];
                break;
            case 5:
                actionText.text = @"King - Your main piece! He is weak, but he runs fast. Not much of a warrior king. If this piece is killed, the game is over.";
                actionImage.image =[UIImage imageNamed:@"king.png"];
                break;
            case 6:
                actionText.text = @"Dragon Slayer - Your secret weapon versus the Dragon. This piece is fast, strong and fireproof. And the best part: it has an spear which can be thrown only at the Dragon, once per game, that deals great damage and makes the Dragon slow.";
                actionImage.image =[UIImage imageNamed:@"dragonslayer.png"];
                break;
            case 7:
                actionText.text = @"Tree Giant - The Tree Giant is a very versatile unit. It's strong, fast and has the action of attacking with long branches, dealing 5 damage. Just be careful because it is weak to fire!";
                actionImage.image =[UIImage imageNamed:@"tree.png"];
                break;
            case 8:
                actionText.text = @"Stone Giant - This one is a bit more massive. It has a huge hitpoints amount and it's invulnerable to fire or arrows, but it's slower than the Tree Giant and it doesn't have an action.";
                actionImage.image =[UIImage imageNamed:@"mountain.png"];
                break;
            default:
                break;
        }
    }
    

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
