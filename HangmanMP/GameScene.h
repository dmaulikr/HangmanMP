//
//  GameScene.h
//  HangmanMP
//
//  Created by Shawn Grimes on 10/29/11.
//  Copyright (c) 2011 Shawn's Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameScene : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labelDifficulty;
@property (weak, nonatomic) IBOutlet UITextField *textFieldGuess;
@property (weak, nonatomic) IBOutlet UITextView *textViewGuesses;
@property (weak, nonatomic) IBOutlet UILabel *labelGuessedLetters;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewHanger;
@property (weak, nonatomic) IBOutlet UILabel *labelLettersInWord;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewContent;


@property(strong, nonatomic) NSMutableArray *arrayGuesses;
@property(strong, nonatomic) NSString *stringDifficulty;
@property(strong, nonatomic) NSString *stringHiddenWord;
@property(nonatomic) int badGuessCount;


-(NSString *) getMagicWord;

@end
