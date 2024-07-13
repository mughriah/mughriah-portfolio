#include <stdio.h>
#include "stdlib.h" 
#include "time.h"

/**********************************************************************************************************
	Description : This function will...
	                              > displays the Intro Screen in the beginning of the program.								  							
***********************************************************************************************************/
void displayIntro() //doesn't return a value.
{
	printf("\n============================================================================================="); //Intro Screen
	printf("\n       			             * MASTERMIND GAME *       ");
	printf("\n            		           CCPROG1 Machine Project");
	printf("\n=============================================================================================");
}

/**********************************************************************************************************
	Description : This function will...
	                              > displays the Ending screen in the end of the program.								  							
***********************************************************************************************************/
void endingScreen () //doesn't return a value.
{
	printf("\n============================================================================================="); //Ending Screen
	printf("\n      			  	       * GAME OVER! *       ");
	printf("\n       		                 * Thank You for playing *       ");
	printf("\n=============================================================================================");
}

/**********************************************************************************************************
	Description : This function will...
	                              > displays the 6 numbers with its corresponding colors.								  							
***********************************************************************************************************/
void mastermindColors() //doesn't return a value. 
{ 
	printf("\n\n=============================================================================================\n");
	printf("         COLORS: (1) Red | (2) Green | (3) Blue | (4) Yellow | (5) Pink | (6) Purple");
	printf("\n=============================================================================================\n");
}

/**********************************************************************************************************
	Description : This function will...
	                                   > displays the note when inputting a number of rounds.
                                       > asks the user's preferred number of rounds. 							  							
***********************************************************************************************************/
void askRounds() //doesn't return a value.
{
	printf("\n\n=============================================================================================");
	printf("\n\n\n	    * NOTE: ENTER AN EVEN NUMBER AND SHOULD NOT BE GREATER THAN 10. *");
	printf("\n\n\n		Enter your preferred even number of Rounds for this Game: ");
}

/**********************************************************************************************************
	Description : This function will...
	                              > displays the instructions of the game; 
								    this will show when the user chooses "Y" or "Y".							  							
***********************************************************************************************************/
void displayInstructions() //doesn't return a value.
{
	printf("\n\n=============================================================================================\n");
	printf("\n\n	                                  INSTRUCTIONS: ");
	printf("\n\n	> Even number of games, number of games can be from 2 to 10 games maximum.");
	printf("\n	> A pattern of four code pegs is selected by the codemaker.");
	printf("\n	> Duplication of code pegs will not be allowed.");
	printf("\n	> Accurate in both color and position, a BLACK KEY PEG is inserted.");
	printf("\n	> A valid color code peg that has been misplaced is shown by a WHITE KEY PEG.");	
}

/**********************************************************************************************************
	Description : This function will...
	                              > generates four random numbers;
                                  > ask the user how many rounds will be played;
                                  > The user will enter his or her best guess;
                                  > counts and display the number of white and black pegs;
                                  > computes and displays the human and AI score;
                                  > The secret codes are displayed alongside the congratulations 
								    message or the "you lose" message.
								   
	@param black contains and counts the accurate number and position.
	@param white contains and counts the valid color that has been misplaced.
	@param round is the address where the value given by the user as input will be placed.
	@param randomNum_1 contains the ramdom number.
	@param randomNum_2 contains the ramdom number.
	@param randomNum_3 contains the ramdom number.
	@param randomNum_4 contains the ramdom number.
	@param guess_1 is the address where the first guess value given by the user as input will be placed.
	@param guess_2 is the address where the second guess value given by the user as input will be placed.
	@param guess_3 is the address where the third guess value given by the user as input will be placed.
	@param guess_4 is the address where the fourth guess value given by the user as input will be placed.
	@param rounds contains the number of rounds that will be executed.
	@param aiScore contains the score of AI.
	@param humanScore contains the score of human.
	
	@return 0, exit code of the program.
***********************************************************************************************************/

int theMastermindGame (int black, int white, int round) 
{
 
	int randomNum_1, randomNum_2, randomNum_3, randomNum_4;
	int guess_1, guess_2, guess_3, guess_4;
	int rounds, aiScore, humanScore;
	 
    	srand(time(NULL));
    	//Problem: Have the same digits when being generated.
   		randomNum_1 = rand() % 6 + 1; // generates a code from 1-6, randomly.
        randomNum_2 = rand() % 6 + 1; // generates a code from 1-6, randomly.
       	randomNum_3 = rand() % 6 + 1; // generates a code from 1-6, randomly.
        randomNum_4 = rand() % 6 + 1; // generates a code from 1-6, randomly.
    
     printf("\n%d%d%d%d\n\n",randomNum_1,randomNum_2,randomNum_3,randomNum_4); // displays the secret code.
    
	askRounds(); // displays the note and asks the user for their preferred rounds to play.
	scanf("%d",&round); // user inputs a number of round.
		
	while (round % 2 !=0 || round > 10) //The number of rounds should be divisible by 2 and not greater than 10, or else the question will be repeated.
	{
		printf("\n\n			INVALID INPUT! Enter a number of Rounds again: "); // When the user enters odd numbers or numbers greater than 10, the program asks the user. 
		scanf("%d",&round);	// Inputs the number of rounds.
	} 
	
    for (rounds=1; rounds<=round; rounds++) // rounds will be set to one and executed once.
                                            // If rounds=round is set to true, rounds will be incremented.
                                            // for loops will only be terminated if the number of rounds is greater than one.
	{
		mastermindColors();
		printf("\n\n\n      			  	             | ROUND %d |\n\n",rounds); // display number of rounds

  		black = 0; // black is initialized to 0, it will not produce unpredictably unpredictable results. 
   	    white = 0; // white is initialized to 0, it will not produce unpredictably unpredictable results. 
  
        printf("\n      			  	Please enter your guess: "); // display the words.
        scanf("%d %d %d %d",&guess_1,&guess_2,&guess_3,&guess_4); // allows you to accept inputs.
         
        if (guess_1==randomNum_1)
        {
        black++; // If guess_1 and randomNum_1 have the same digit, the "black" will increment.     
		}  
		       
        else if (guess_1==randomNum_2||guess_1==randomNum_3||guess_1==randomNum_4)
        {
        white++; // else, if guess_1 has the same digit as randomNum_2, randomNum_3, or randomNum_4, the "white" will increment.                                                    
        }
        
        if (guess_2==randomNum_2)
        {
        black++; // If guess_2 and randomNum_2 have the same digit, the "black" will increment.    
		} 
		      
        else if (guess_2==randomNum_1||guess_2==randomNum_3||guess_2==randomNum_4)
        {
        white++; // else, if guess_2 has the same digit as randomNum_1, randomNum_3, or randomNum_4, the "white" will increment.                                                     
        }
        
        if (guess_3==randomNum_3)
        {
        black++; // If guess_3 and randomNum_3 have the same digit, the "black" will increment.
        }
        
        else if (guess_3==randomNum_1||guess_3==randomNum_2||guess_3==randomNum_4)
        {
        white++; // else, if guess_3 has the same digit as randomNum_1, randomNum_2, or randomNum_4, the "white" will increment.                                              
        }
        
        if (guess_4==randomNum_4)
        {
        black++; // If guess_4 and randomNum_4 have the same digit, the "black" will increment.
		}  
		     
        else if (guess_4==randomNum_1||guess_4==randomNum_2||guess_4==randomNum_3)
        {
        white++; // else, if guess_4 has the same digit as randomNum_1, randomNum_2, or randomNum_3, the "white" will increment.
        }
        
        printf("\n      			  	          BLACK KEY PEG: %d\n",black); // It will show all of the black that has been counted. 
        printf("      			  	          WHITE KEY PEG: %d\n\n",white); // It will show all of the white that has been counted. 
		
		if (guess_1==guess_2 || guess_1==guess_3 || guess_1==guess_4 || guess_2==guess_3 || guess_2==guess_4 || guess_3==guess_4) 
        {                                    
         printf("\n      			    Number should not contain repeated digits.\n"); // If there are two digits that are similar, this will be displayed. 
		}   
		
		if (black==4) // If black is equivalent to 4, the program will stop.
		{	
		humanScore = round - rounds + 1; // computes the score of human player, (example: 1 + 2 - 1 = 2).
 		humanScore++; // When a guess is correct, increment by one and add an additional human score. (+ 1) 
 		printf("\n\n=============================================================================================\n");
 		printf("\n      			  	          Human score is %d",humanScore); // display the score of human.
 		}
 		
		if (black==4)
		{
		aiScore = rounds; // will count the rounds executed.
		aiScore--; // decrement by 1.
	    
		printf("\n      			  	            AI score is %d\n", aiScore); // displays the rounds executed minus the aiScore--.
		printf("\n      			  	             WINNER: Human");
 		printf("\n      			     Congratulations! You guessed the secret code.\n"); // display when user guessed the secret codes.
 		printf("\n\n=============================================================================================");
	    return 0; // terminates the if condition.
	}
	
		if (rounds==round)  
		{
		humanScore= rounds - round; // computes the score of human.
		printf("\n\n=============================================================================================");
		printf("\n\n      			  	          Human score is %d", humanScore); // displays the score.
		aiScore = round; // will count the rounds executed
		aiScore++; // increment by 1
		printf("\n      			  	            AI score is %d\n", aiScore); // displays the score.
		printf("\n      			  	             WINNER: AI\n");
		printf("\n      			     You lose! You didn't get the secret code.\n"); // displays when user didn't get the code.
		printf("\n      			  	      The secret code is %d%d%d%d\n\n",randomNum_1,randomNum_2,randomNum_3,randomNum_4); // displays the secret code.
		printf("\n=============================================================================================");
		}

}
 return 0; // Exit code of the program.
}

/**********************************************************************************************************
	Description : This function will...
	                              > Ask the user whether he or she wants to play again.
								  
	@param choice is the address where the  letter given by the user as input will be placed.
	@param black contains the number of black pegs.
	@param white contains the number of white pegs.
	@param round contains the number of rounds that the user inputted.
	
	@return 0, exit code of the program. 						  							
***********************************************************************************************************/	
char playAgain (char choice) 
{
	int black, white, round;
	printf("\n\n      			       Would you like to play? Enter Y or N: ");
    scanf(" %c", &choice);
 
	while (choice == 'y' || choice == 'Y') { // The game will be replayed if the user enters y or Y.
                                             // However, if the user enters an incorrect character or n/N, the final screen will be displayed. 
    theMastermindGame(black,white,round);     // replay the game.
    
    printf("\n\n      			       Do you want to play again? Y or N: "); // Outputs the question to the user.
	scanf(" %c", &choice);  // Inputs the user's answer.			       
}
	while (choice!='n' || choice!='N') // If the user enters n or N, the game will end. 
{
	endingScreen (); // Displays the Ending screen.
	return 0;	// terminates.
}
}
