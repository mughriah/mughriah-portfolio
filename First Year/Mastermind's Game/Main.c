#include <stdio.h>
#include "stdlib.h" 
#include "time.h"
#include "Machine Project_Function (CAYA).c"

/**********************************************************************************************************
	Description : This will...
	                              > execute all of the functions that are being called in main.
								  
	@param choice contains the user's choice in the function playAgain.
	@param black contains the number of black pegs.
	@param white contains the number of white pegs.
	@param round contains the number of rounds that the user inputted.
	@param letter is the address where the  letter given by the user as input will be placed.
	
	@return 0, exit code of the program. 						  							
***********************************************************************************************************/	
int main()
{
	int black, white, round;
	char choice;
	char letter;
	
	displayIntro(); // shows the intro
	printf("\n\n\n\n\n                                           [Y] YES \n\n\n                                           [N] NO"); // displays the YES or NO
	printf("\n\n\n\n\n\n                                   Are you ready to play? "); // displays the question
	scanf(" %c", &letter); // inputs the choice of letter

	
    switch (letter) // contains the selection of letters
	{
		// This will appear when 'y' or 'Y' is selected. 
		case 'y':
		case 'Y': 
				  displayInstructions();
		          theMastermindGame(black,white,round);
		          playAgain(choice);
				  break;
		
		// However, this will appear when 'n' or 'N' is selected.
		case 'n':
		case 'N':
				 endingScreen ();
				 break;
		
		// This only appears when the user selected letter not included in the selection.		 		 
		default:
		printf("\n                                        Invalid Input!");
	}
	
 return 0; // exit code of the program.
 
}
