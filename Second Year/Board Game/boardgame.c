#include <stdio.h>
#include <stdbool.h>

#define BOARD_ROWS 7
#define BOARD_COLS 5


// Define a Pair struct to represent (x, y) coordinates
typedef struct {
    int x, y;
} Pair;

// Define a Set struct to represent a set of Pairs
typedef struct {
    Pair pairs[35];
    int size;
} Set;

// Function to initialize a Set
/* Function Description - Initializes a Set by setting its size to 0.
   @param set: Pointer to the Set to be initialized.
   @return: None.
*/
void initializeSet(Set *set) {
    set->size = 0;
}

// Function to add a Pair to a Set
/* Function Description - Adds a new Pair with the given (x, y) coordinates to the Set.
   @param set: Pointer to the Set to which the Pair should be added.
   @param x: x-coordinate of the new Pair.
   @param y: y-coordinate of the new Pair.
   @return: None.
*/
void addToSet(Set *set, int x, int y) {
    set->pairs[set->size].x = x;
    set->pairs[set->size].y = y;
    set->size++;
}

// Function to check if a Pair is in a Set
/* Function Description - Checks if the given (x, y) coordinates exist in the Set.
   @param set: Pointer to the Set to be checked.
   @param x: x-coordinate to search for.
   @param y: y-coordinate to search for.
   @return: true if the Pair exists in the Set, false otherwise.
*/
bool isInSet(Set *set, int x, int y) {
    for (int i = 0; i < set->size; i++) {
        if (set->pairs[i].x == x && set->pairs[i].y == y) {
            return true;
        }
    }
    return false;
}

// Function to remove a Pair from a Set
/* Function Description - Removes a Pair with the given (x, y) coordinates from the Set.
   @param set: Pointer to the Set from which the Pair should be removed.
   @param x: x-coordinate of the Pair to be removed.
   @param y: y-coordinate of the Pair to be removed.
   @return: None.
*/
void removeFromSet(Set *set, int x, int y) {
    for (int i = 0; i < set->size; i++) {
        if (set->pairs[i].x == x && set->pairs[i].y == y) {
            // Move the last Pair to the current position and decrement the size
            set->pairs[i] = set->pairs[set->size - 1];
            set->size--;
            break;
        }
    }
}

// Global Sets for the game
Set R, C, P, S, Y, E, Alpha, Beta, Free;
// Game variables
bool aTurn = true;
bool over = false;
bool ok = false;

// Function to initialize the game
/* Function Description - Initializes the game by setting up the initial state of the board and player sets.
   @param: None.
   @return: None.
*/
void initialize() {
    // Initialize Sets R, C, P, S, Y, and E
    initializeSet(&R);
    initializeSet(&C);
    initializeSet(&P);
    initializeSet(&S);
    initializeSet(&Y);
    initializeSet(&E);
    initializeSet(&Free);

    for (int r = 1; r <= 7; r++) {
        for (int c = 1; c <= 5; c++) {
            addToSet(&R, r, 0);
            addToSet(&C, 0, c);
            addToSet(&P, r, c);
        }
    }

    for (int i = 0; i < P.size; i++) {
        Pair pair = P.pairs[i];
        if (pair.x % 2 == pair.y % 2) {
            addToSet(&S, pair.x, pair.y);
            if (pair.x <= 2) {
                addToSet(&Y, pair.x, pair.y);
            }
            if (pair.x >= 6) {
                addToSet(&E, pair.x, pair.y);
            }
        }
    }

    // Add the pair (2, 4) to the choices of player Beta
    addToSet(&Beta, 2, 4);

    // Populate the Free set with cells that are not in Y or E
    for (int r = 1; r <= 7; r++) {
        for (int c = 1; c <= 5; c++) {
            Pair pair = {r, c};
            if (!isInSet(&Y, pair.x, pair.y) && !isInSet(&E, pair.x, pair.y)) {
                addToSet(&Free, r, c);
            }
        }
    }

    // Player Alpha chooses from set E
    Alpha = E;
    // Player Beta chooses from set Y
    Beta = Y;
}


// Function to print the game board
/* Function Description - Prints the current state of the game board, showing the positions of players Alpha and Beta.
   @param: None.
   @return: None.
*/
void printBoard() {
    printf("Board:\n");
    printf("    ");
    for (int c = 1; c <= 5; c++) {
        printf(" %d ", c);
    }
    printf("\n");
    for (int r = 1; r <= 7; r++) {
        printf(" %d |", r);
        for (int c = 1; c <= 5; c++) {
            Pair pair = {r, c};
            if (isInSet(&Alpha, pair.x, pair.y)) {
                printf(" A ");
            } else if (isInSet(&Beta, pair.x, pair.y)) {
                printf(" B ");
            } else {
                printf(" . ");
            }
        }
        printf("\n");
    }
}


// Remaining cells for each player
int remainingAlphaCells;
int remainingBetaCells;
int remainingFreeCells;
int remainingECells;
int remainingYCells;

/* Function Description - Checks if a move is valid and updates the board accordingly.
   @param x: x-coordinate of the cell to be occupied.
   @param y: y-coordinate of the cell to be occupied.
   @return: true if the move is valid, false otherwise.
*/
bool isValidMove(int x, int y) {
    if (over || x < 1 || x > BOARD_ROWS || y < 1 || y > BOARD_COLS) {
        return false;
    }

    Pair pair = {x, y};
    if (aTurn) {
        if (isInSet(&Beta, pair.x, pair.y)) {
            if (isInSet(&Y, pair.x, pair.y)) {
                removeFromSet(&Y, pair.x, pair.y);
                remainingYCells --;
            }
            
            // Steal the piece from Beta and add it to Alpha            
            removeFromSet(&Beta, pair.x, pair.y);
            addToSet(&Alpha, pair.x, pair.y);
            remainingBetaCells--;
            remainingAlphaCells++;
            
        } else if (isInSet(&Free, pair.x, pair.y)){
            addToSet(&Alpha, pair.x, pair.y);
        }

    } else {
        if (isInSet(&Alpha, pair.x, pair.y)) {
            if (isInSet(&E, pair.x, pair.y)) {
                removeFromSet(&E, pair.x, pair.y);
                remainingECells --;
            }
            // Steal the piece from Alpha and add it to Beta
            removeFromSet(&Alpha, pair.x, pair.y);
            addToSet(&Beta, pair.x, pair.y);
            remainingAlphaCells--;
            remainingBetaCells++;
        } else if (isInSet(&Free, pair.x, pair.y)){
            addToSet(&Beta, pair.x, pair.y);
        }
    }
    removeFromSet(&Free, pair.x, pair.y);
    remainingFreeCells--;
    return true;
}

// Function to play the game
/* Function Description - Plays the game, alternating turns between players Alpha and Beta, until the game is over.
   @param: None.
   @return: None.
*/
void playGame() {
    initialize();

    remainingAlphaCells = E.size;
    remainingBetaCells = Y.size;
    remainingFreeCells = Free.size;
    remainingECells = E.size;
    remainingYCells = Y.size;


    while (!over) {
        printf("\nCurrent State:\n");
        printBoard();
        printf("Player %s's turn.\n", aTurn ? "Alpha" : "Beta");

        if (remainingFreeCells == 0) {
            // If there are no available cells in the Free set, the game is a draw
            over = true;

        } else {
            // Read player's input with error handling
            int x, y;
            if (scanf("%d %d", &x, &y) != 2) {
                printf("Invalid input. Please enter two integers separated by spaces.\n");
                while (getchar() != '\n'); // Clear input buffer
                continue;
            }

            if (isValidMove(x, y)) {
                ok = true;
            } else {
                printf("Invalid move, please try again.\n");
                ok = false;
            }

            // Check if the game is over
            over = (remainingAlphaCells == 0) || (remainingBetaCells == 0) || (remainingFreeCells == 0) || (remainingECells == 0) || (remainingYCells == 0);
            aTurn = !aTurn;
        }
    }

    // Print the final state
    printf("Final State:\n");
    printBoard();

    // Print the result
    printf("Game Over!\n");
    if (Alpha.size == 0 && Beta.size == 0) {
        printf("It's a draw.\n");
    } else if (remainingAlphaCells == 0) {
        printf("Player Beta wins.\n");
    } else if (remainingBetaCells == 0) {
        printf("Player Alpha wins.\n");
    } else if (remainingFreeCells == 0){
        printf("It's a draw.\n");
    } else if (remainingECells == 0){
        printf("Player Beta wins.\n");
    } else if (remainingYCells == 0){
        printf("Player Alpha wins.\n");
    } 
}

bool askToPlayAgain() {
    printf("Do you want to play again? (Y/N): ");
    char answer;
    scanf(" %c", &answer);
    while (getchar() != '\n'); // Clear input buffer
    return (answer == 'Y' || answer == 'y');
}
// Prints Introduction and guidelines
void displayHelp() { 
	printf("-------------------------");
    printf("\n  Welcome to our game!\n");
    printf("-------------------------");
    printf("\nHere are some instructions:\n");
    printf("1. The game is played on a 7x5 grid by two players, Alpha and Beta.\n");
    printf("2. Players take turns choosing a grid cell to occupy.\n");
    printf("3. A player wins by eliminating all cells of the opponent from the set Y or E.\n");
    printf("4. Enter the coordinates of the cell you want to occupy as two numbers separated by a space.\n");
    printf("5. Only positive integer coordinates are accepted.\n");
    printf("6. The game ends when either player has no cells left.\n");
    printf("--------------------------------------------------------------------------------------------");
}

int main() {
	displayHelp();
    bool playAgain;
    do {
        aTurn = true;
        over = false;
        ok = false;
        playGame();
        playAgain = askToPlayAgain();
    } while (playAgain);
    return 0;
}
