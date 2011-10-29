//
//  GameScene.m
//  HangmanMP
//
//  Created by Shawn Grimes on 10/29/11.
//  Copyright (c) 2011 Shawn's Bits, LLC. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene
@synthesize labelDifficulty;
@synthesize textFieldGuess;
@synthesize textViewGuesses;
@synthesize labelGuessedLetters;
@synthesize imageViewHanger;
@synthesize labelLettersInWord;
@synthesize scrollViewContent;
@synthesize arrayGuesses;
@synthesize stringDifficulty;
@synthesize stringHiddenWord;
@synthesize badGuessCount;

int scoreMultiplier;
int playerScore;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        scoreMultiplier=1;
        playerScore=0;
        
       
    }
    return self;
}

-(NSString *) getMagicWord{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"wordlist" 
                                                     ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];

    NSArray *lines = [content componentsSeparatedByString:@"\n"]; 
    NSLog(@"Content Length: %i", [lines count]);
    NSString *magicWord=@"";
    while(magicWord.length<4 || magicWord.length>8){
        magicWord=[lines objectAtIndex:(arc4random() % [lines count])];
    }
    
    return magicWord;
    
}

-(void) processGuess:(NSString *)guessedLetter{
    NSRange letterInWord=[self.stringHiddenWord rangeOfString:guessedLetter];
    if(letterInWord.location==NSNotFound){
        ++self.badGuessCount;
        [self.arrayGuesses addObject:guessedLetter];
        
        self.imageViewHanger.image=[UIImage imageNamed:[NSString stringWithFormat:@"Hangman%i.png", self.badGuessCount]];
        
        NSLog(@"Bad Guesses: %i", self.badGuessCount);
        if(self.badGuessCount>5){
            [[[UIAlertView alloc] initWithTitle:@"Game Over" message:@"Too many bad guesses" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            self.labelLettersInWord.text=self.stringHiddenWord;
        }
        [self.arrayGuesses sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        self.textViewGuesses.text=@"";
        for( int i=0;i<[self.arrayGuesses count];i++){
            self.textViewGuesses.text=[self.textViewGuesses.text stringByAppendingString:[NSString stringWithFormat:@" %@",[self.arrayGuesses objectAtIndex:i]]];
        }
        scoreMultiplier=1;
    }else{
        scoreMultiplier++;
        playerScore=playerScore+(10*scoreMultiplier);
        NSLog(@"Good Guess");
        NSRange foundInWord=letterInWord;
        foundInWord.location=letterInWord.location*2;
        NSLog(@"location in word: %i", letterInWord.location);
        self.labelLettersInWord.text=[self.labelLettersInWord.text stringByReplacingCharactersInRange:foundInWord withString:guessedLetter];
        
        while(letterInWord.location!=NSNotFound){
            NSRange searchRange=letterInWord;
            ++searchRange.location;
            searchRange.length=[self.stringHiddenWord length]-searchRange.location;
            letterInWord=[self.stringHiddenWord rangeOfString:guessedLetter options:NSCaseInsensitiveSearch range:searchRange];
            
            if(letterInWord.location!=NSNotFound){
                foundInWord.location=letterInWord.location*2;
                self.labelLettersInWord.text=[self.labelLettersInWord.text stringByReplacingCharactersInRange:foundInWord withString:guessedLetter];
                
                
            }
        }
        NSRange unfoundLetters=[self.labelLettersInWord.text rangeOfString:@"_"];
        if(unfoundLetters.location==NSNotFound){
            [[[UIAlertView alloc] initWithTitle:@"WINNER!" message:[NSString stringWithFormat:@"You Win!\nScore:%i", playerScore] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        
    }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textViewGuesses.text=@"";
    self.labelDifficulty.text=self.stringDifficulty;
    self.stringHiddenWord=[self getMagicWord];
    self.labelLettersInWord.text=[NSString stringWithFormat:@"%i", self.stringHiddenWord.length];
    NSString *wordPlaceHolder=@"";
    for(int i=0; i<self.stringHiddenWord.length;i++){
        wordPlaceHolder=[wordPlaceHolder stringByAppendingString:@"_ "];
    }
    self.labelLettersInWord.text=wordPlaceHolder;
     NSLog(@"Magic word is:%@", self.stringHiddenWord);
    self.scrollViewContent.contentSize=CGSizeMake(320, 960);
    
    self.arrayGuesses=[NSMutableArray arrayWithCapacity:26];

}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self.scrollViewContent scrollRectToVisible:CGRectMake(0, self.labelLettersInWord.frame.origin.y, 320, 420) animated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if([textField.text length]>1){
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Too many letters typed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return NO;
        
    }else if([textField.text length]==0){
        [textField resignFirstResponder];
        return YES;
    }else if([textField.text length]==1){
        if([[NSCharacterSet letterCharacterSet] characterIsMember:[textField.text characterAtIndex:0]]){
            NSLog(@"Letter entered");
            [self processGuess:textField.text];
            textField.text=@"";
        }else{
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"You must enter a letter" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            return NO;
        }
    }
    return YES;
}



- (void)viewDidUnload
{
    [self setLabelDifficulty:nil];
    [self setTextFieldGuess:nil];
    [self setTextViewGuesses:nil];
    [self setLabelGuessedLetters:nil];
    [self setImageViewHanger:nil];
    [self setLabelLettersInWord:nil];
    [self setScrollViewContent:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
