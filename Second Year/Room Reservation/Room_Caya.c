/******************************************************************************
This is to certify that this project is my own & partners work, based on
my/our personal efforts in studying and applying the concepts learned. I/we
have constructed the functions and their respective algorithms and
corresponding code by me (and my partner). The program was run, tested, and
debugged by my own efforts. I further certify that I have not copied in
part or whole or otherwise plagiarized the work of other students and/or
persons.

CAYA, Mary Faye Q. - 12141422 - S12

******************************************************************************/

#include <stdio.h>
#include <string.h>
#include "Room_Display.c"

#define MAX_SLOTS 1
#define MAX_LENGTH 50
#define MAX_RESERVATIONS 50
#define MAX_RESERVATIONS_PER_USER 3
#define MAX_ROOMS 100
#define MAX_SLOTS_PER_DAY 1

// This is the struct for reservation

struct Reservation {
    int idNum;                   // ID number of the reservation
    char name[MAX_LENGTH];       // Full name of the person making the reservation
    char yearprogram[MAX_LENGTH]; // Year and program of the person making the reservation
    char dateTime[MAX_LENGTH];   // Date and time for the reservation in "YYYY-MM-DD HH:MM" format
    int participants;            // Number of participants for the reservation
    char roomType[MAX_LENGTH];   // Type of room to reserve (e.g., classroom, seminar room, auditorium)
    char activity[MAX_LENGTH];   // Description of the activity for the reservation
    int completed;               // Flag indicating if the reservation is completed (1) or not (0)
    char roomName[MAX_LENGTH];   // Name of the reserved room
    int roomCapacity;            // Capacity of the reserved room
    int isPending;               // Flag indicating if the reservation is pending (1) or not (0)
    int numReservations;         // Number of reservations for the same room
    int roomNumber;              // Room number or identifier
    int isExtended;              // Flag indicating if the reservation has been extended (1) or not (0)
    char extensionDateTime[MAX_LENGTH]; // Date and time of the extension for the reservation
};

// This is the struct for room

struct Room {
    char roomType[MAX_LENGTH];   // Type of room (e.g., classroom, seminar room, auditorium)
    char roomName[MAX_LENGTH];   // Name or identifier of the room
    int roomCapacity;            // Capacity of the room (maximum number of participants)
    int isReserved;              // Flag indicating if the room is currently reserved (1) or not (0)
    int completed;               // Flag indicating if the reservation for the room is completed (1) or not (0)
};


int numRooms = 0;
int totalReservations = 0;

/************************** A D M I N M O D U L E ******************************/
//TODO: Implementing the adminModuleSwitch function for admin module actions.

/*******************************************************************************

TO DO: Implement the validateRoomName function to validate the format of the given 
	   room name.
	   
DESCRIPTION: Checks whether the provided room name follows
			 a specific format or not.
			 
@param roomName: Pointer to a character array representing name follows a specific 
				 format.

@return: Integer value indicating the validation result.
		 > If the room name is valid, returns 1.
		 > If it is not, returns 0.
		 
*******************************************************************************/

// Function to validate a room name

int 
validateRoomName (char* roomName) {

    // Check if the room name has exactly 5 characters
    if (strlen(roomName) != 5) {
        return 0; // Return 0 (invalid) if the length is not 5
    }

    // Check if the first character of the room name is 'A'
    if (roomName[0] != 'A') {
        return 0; // Return 0 (invalid) if the first character is not 'A'
    }

    // Extract the floor number (characters 2 and 3) from the room name
    int floorNumber = (roomName[1] - '0') * 10 + (roomName[2] - '0');

    // Check if the floor number is within the valid range (1 to 20)
    if (floorNumber < 1 || floorNumber > 20) {
        return 0; // Return 0 (invalid) if the floor number is out of range
    }

    // Extract the room number (characters 4 and 5) from the room name
    int roomNumber = (roomName[3] - '0') * 10 + (roomName[4] - '0');

    // Check if the room number is within the valid range (1 to 10)
    if (roomNumber < 1 || roomNumber > 10) {
        return 0; // Return 0 (invalid) if the room number is out of range
    }

    // If all checks pass, the room name is valid
    return 1; // Return 1 (valid) if the room name meets all the criteria
}

/*******************************************************************************

TO DO: Check the uniqueness of a given room name among an array of rooms.

Description: Iterates through an array of Room structures 
			 to check whether the provided room name already exists or not.

@param rooms: A pointer to an array of Room structures representing the existing rooms.
@param numRooms: An integer representing the number of rooms in the rooms array.
@param roomName: A pointer to a character array (string) representing the room name to be 
				checked for uniqueness.

@return: Integer value indicating the validation result.
		 > Roomname is unique, returns 1.
		 > If it is not, returns 0.
		 
*******************************************************************************/

// Function to check if a room name is unique among an array of Room structures

int 
isRoomNameUnique (struct Room* rooms, int numRooms, char* roomName) {
	
    for (int i = 0; i < numRooms; i++) {
        // Compare the current room's name with the given roomName
        if (strcmp(rooms[i].roomName, roomName) == 0) {
            return 0; // Return 0 (not unique) if the room name already exists
        }
    }
    
    return 1; // Return 1 (unique) if the room name is not found in the array
}


/*******************************************************************************

TO DO: Check if the given room type is valid or not.

Description: Checks if the provided roomType matches any of the predefined valid 
			 room types: "classroom", "seminar room", "auditorium", or "training room".

@param roomType: A pointer to a character array (string) representing the room type 
				to be validated.

@return: Integer value indicating the validation result.
		 > If valid, returns 1.
		 > If it is not, returns 0.
		 
*******************************************************************************/

// Function to validate if a room type is one of the specified valid types

int 
validateRoomType (char* roomType) {
	
    // Compare the roomType with the valid room types
    if (strcmp(roomType, "classroom") == 0 ||
        strcmp(roomType, "seminar room") == 0 ||
        strcmp(roomType, "auditorium") == 0 ||
        strcmp(roomType, "training room") == 0) {
        return 1; // Return 1 (valid) if the roomType matches any of the valid types
    }

    return 0; // Return 0 (invalid) if the roomType does not match any of the valid types
}


/*******************************************************************************

TO DO: Check if the given room type and capacity is valid or not.

Description: Checks if the provided roomType and roomCapacity meet the minimum 
			 capacity requirements for each room type.

@param roomType: A pointer to a character array (string) representing the room type 
			     to be validated.
@param roomCapacity: An integer representing the capacity of the room to be validated.

@return: Integer value indicating the validation result.
		 > If valid, returns 1.
		 > If it is not, returns 0.
		 
ROOM AND CAPACITY:
Classroom - 45
Seminar Room - 60
Auditorium - 150
Training Room 30
		 
*******************************************************************************/

// Function to validate if a room capacity is valid for the corresponding room type

int 
validateRoomCapacity (char* roomType, int roomCapacity) {
	
    // Compare the roomType with the valid room types and their corresponding capacities
    if (strcmp(roomType, "classroom") == 0 && roomCapacity == 45) {
        return 1; // Return 1 (valid) if the roomType is "classroom" and the roomCapacity is 45
    }

    if (strcmp(roomType, "seminar room") == 0 && roomCapacity == 60) {
        return 1; // Return 1 (valid) if the roomType is "seminar room" and the roomCapacity is 60
    }

    if (strcmp(roomType, "auditorium") == 0 && roomCapacity == 150) {
        return 1; // Return 1 (valid) if the roomType is "auditorium" and the roomCapacity is 150
    }

    if (strcmp(roomType, "training room") == 0 && roomCapacity == 30) {
        return 1; // Return 1 (valid) if the roomType is "training room" and the roomCapacity is 30
    }

    return 0; // Return 0 (invalid) if none of the valid combinations are found
    
	}


/*******************************************************************************

TO DO: Check if room is completed.

Description: Takes a Room structure as input and checks whether the room's completion
             status is marked as completed or not.

@param room: A Room structure representing the room to be checked. 

@return: Integer value indicating the validation result.
		 > If completed, returns 1.
		 > If it is not, returns 0.
		 
*******************************************************************************/

// Function to check if a room is completed

int 
isRoomCompleted(struct Room room) {
    
	return room.completed; // Return the value of the 'completed' field from the 'room' struct
}


/*******************************************************************************

TO DO: Add a new room to the list of rooms.

Description:  prompts the user to input details of a new room and performs various
			  validations to ensure that the room name, room type, and capacity are entered correctly.

@param rooms: A pointer to an array of Room structures representing the existing rooms.

@return: Does not return any value.
		 
*******************************************************************************/

// Function to add a new room to the array of rooms

void 
addRoom(struct Room* rooms) {
	
    // Declare Variables
    int floorNumber; // Variable to store the floor number extracted from the room name
    int validCapacity = 0; // Flag to indicate if the room capacity entered is valid
    struct Room addRoom; // Temporary struct to store the details of the room to be added
    int goBackOption = 0; // Flag to indicate if the user wants to go back

    // Display the add room interface
    printf("\n");
    DisplayAddroom(); // Assuming there is a function called DisplayAddroom() to show the add room interface
    printf("\n\n\n");

    // Check if the maximum number of rooms has been reached
    if (numRooms >= MAX_ROOMS) {
        printf("\n                            MAXIMUM NUMBER OF RESERVATIONS REACHED.\n");
        return; // Exit the function since the maximum number of rooms is reached
    }

    // Ask the user if they want to go back
    printf("\n                            DO YOU WANT TO GO BACK? (Y/N): ");
    char backChoice;
    scanf(" %c", &backChoice);

    if (backChoice == 'y' || backChoice == 'Y') {
        goBackOption = 1; // Set the goBackOption flag to indicate the user wants to go back
        return; // Exit the function since the user wants to go back
    }

    printf("\n");
    printf("\n");

    // Flag to ensure unique room name
    int uniqueRoomName = 0;
    while (!uniqueRoomName) {
        // Prompt the user to enter the room name
        printf("\n                            Enter room name (XYYYY): ");
        scanf("%s", addRoom.roomName);

        // Validate the room name format and uniqueness
        if (!validateRoomName(addRoom.roomName)) {
            printf("\n                            INVALID ROOM FORMAT. Room name must start with 'A' followed by a 2-digit floor number (01-20) "
                   "and a 2-digit room number (01-10).\n");
        } else if (isRoomNameUnique(rooms, numRooms, addRoom.roomName) == 0) {
            printf("\n                            Room name '%s' is not unique. Please enter a different room name.\n", addRoom.roomName);
        } else {
            // Extract the floor number from the room name and check its availability
            sscanf(addRoom.roomName + 1, "%2d", &floorNumber);
            if (floorNumber == 1 || floorNumber == 6) {
                printf("\n                            Floor number is not available.\n");
            } else {
                uniqueRoomName = 1; // Set the uniqueRoomName flag to indicate the room name is valid and unique
            }
        }
    }

    // Flag to ensure valid room type
    int validRoomType = 0;
    while (!validRoomType) {
        // Prompt the user to enter the room type
        printf("\n                            Enter room type: ");
        scanf(" %[^\n]", addRoom.roomType);

        // Validate the room type
        if (validateRoomType(addRoom.roomType)) {
            validRoomType = 1; // Set the validRoomType flag to indicate the room type is valid
        } else {
            printf("\n                            Invalid room type. Room type must be one of the following: classroom, seminar room, auditorium, training room.\n");
        }
    }

    // Loop to ensure valid room capacity
    while (!validCapacity) {
        // Prompt the user to enter the room capacity
        printf("\n                            Enter room capacity: ");
        if (scanf("%d", &addRoom.roomCapacity) == 1) {
            // Validate the room capacity
            if (validateRoomCapacity(addRoom.roomType, addRoom.roomCapacity)) {
                validCapacity = 1; // Set the validCapacity flag to indicate the room capacity is valid
            } else {
                printf("\n                            INVALID RPPM CAPACITY. ROOM CAPACITY MUST NOT TO BE BELOW THE FIXED CAPACITY FOR %s.\n", addRoom.roomType);
            }
        } else {
            printf("\n                            INVALID ROOM CAPACITY. TRY AGAIN!\n");
            while (getchar() != '\n'); // Clear the input buffer in case of invalid input
        }
    }

    // Set the completed status of the room to 0 (not completed)
    addRoom.completed = 0;

    // Add the new room to the array of rooms
    rooms[numRooms] = addRoom;

    // Increment the number of rooms
    (numRooms)++;

    // Print a success message
    printf("\n                            ROOM %s ADDED SUCCESSFULLY!\n", addRoom.roomName);
}



/*******************************************************************************

TO DO: Display a list of available rooms.

Description: Takes an array of Room structures as input and prints the details of 
			 each available room, including room name, room type, and room capacity. 
			 If there are no rooms available (i.e., numRooms is 0), it displays a message 
			 indicating that there are no available rooms.

@param room: A pointer to an array of Room structures representing the available rooms.

@return: Does not return any value.
		 
*******************************************************************************/

// Function to display the available rooms

void 
displayAvailable(struct Room* rooms) {
	
    // Display the display interface
    printf("\n");
    DisplayDisplay(); // Assuming there is a function called DisplayDisplay() to show the display interface
    printf("\n\n\n");

    // Check if there are no rooms available
    if (numRooms == 0) {
        printf("\n                            NO ROOMS AVAILABLE.\n"); // Print a message indicating that there are no rooms available
        return; // Exit the function since there are no rooms to display
    }

    // Print the table header
    printf("\n                                         AVAILABLE ROOMS:\n");
    printf("                             ---------------------------------------------\n");
    printf("                             Room Name   |   Room Type   |   Room Capacity\n");
    printf("                             ---------------------------------------------\n");

    // Loop through each room and print its details
    for (int i = 0; i < numRooms; i++) {
        printf("                             %-11s | %-13s | %d\n", rooms[i].roomName, rooms[i].roomType, rooms[i].roomCapacity);
        // Print room details in a formatted table with each field left-aligned with fixed widths
    }

    printf("                             ---------------------------------------------\n");
}



/*******************************************************************************

TO DO: Allow the user to delete a room reservation based on the provided room name.

Description:  takes an array of Room structures as input and prompts the user to 
enter the room name they want to delete. If the room name is found in the array, the 
function displays the details of the room reservation and asks for confirmation to proceed 
with the deletion. If confirmed, the function removes the room reservation from the array. 
If the provided room name is not found, an appropriate message is displayed.

@param rooms: A pointer to an array of Room structures representing the existing room reservations.

@return: Does not return any value.
		 
*******************************************************************************/

// Function to delete a room reservation

void 
deleteRoom(struct Room* rooms) {
	
    // Declare variables
    char roomNameToDelete[6]; // Buffer to store the room name to be deleted (assuming room names have 5 characters + null terminator)
    int foundRoom = 0; // Flag to indicate if the room to be deleted is found
    int goBackOption = 0; // Flag to indicate if the user wants to go back

    // Display the delete interface
    printf("\n");
    DisplayDelete(); // Assuming there is a function called DisplayDelete() to show the delete interface
    printf("\n\n\n");

    // Ask if the user wants to go back
    printf("\n                             DO YOU WANT TO GO BACK? (Y/N): ");
    char backChoice;
    scanf(" %c", &backChoice);

    if (backChoice == 'y' || backChoice == 'Y') {
        goBackOption = 1; // Set the goBackOption flag to indicate the user wants to go back
        return; // Exit the function since the user wants to go back
    }

    printf("\n");
    printf("\n");

    // Ask for the room name to delete
    printf("\n                             Enter the room name to delete (XYYYY): ");
    scanf("%s", roomNameToDelete); // Read the room name from the user input
    getchar(); // Consume the newline character from the buffer

    // Loop through the rooms to find the one to delete
    for (int i = 0; i < numRooms && !foundRoom; i++) {
        if (strcmp(rooms[i].roomName, roomNameToDelete) == 0) {
            foundRoom = 1; // Set the foundRoom flag to indicate that the room to be deleted is found

            // Display room reservation details
            // (Assuming the struct Room contains the necessary fields for room reservation details)
            printf("                             +-------------------------+------------------------------+\n");
            printf("                             |      Room Reservation   |    Room Reservation Details  |\n");
            printf("                             +-------------------------+------------------------------+\n");
            printf("                             | %-22d |                              |\n", i + 1);
            printf("                             |-------------------------+------------------------------|\n");
            printf("                             |        Room Name        | %-30s |\n", rooms[i].roomName);
            printf("                             |-------------------------+------------------------------|\n");
            printf("                             |       Room Type         | %-30s |\n", rooms[i].roomType);
            printf("                             |-------------------------+------------------------------|\n");
            printf("                             |      Room Capacity      | %-30d |\n", rooms[i].roomCapacity);
            printf("                             +-------------------------+------------------------------+\n");
            printf("\n");

            // Ask for confirmation to delete
            printf("\n                             Are you sure you want to delete this room reservation? (Y/N): ");
            char choice;
            scanf(" %c", &choice); // Read the user's choice for confirmation
            getchar(); // Consume the newline character from the buffer

            if (choice == 'Y' || choice == 'y') {
                // Shift the array to delete the room
                for (int j = i; j < (numRooms) - 1; j++) {
                    rooms[j] = rooms[j + 1]; // Move the elements one position left to overwrite the room to be deleted
                }

                (numRooms)--; // Decrement the total number of rooms

                printf("\n                             ROOM RESERVATION HAS BEEN SUCCESSFULLY CANCELED!\n");
            } else {
                printf("\n                             ROOM RESERVATION CANCELLATION ABORTED.\n");
            }
        }
    }

    // Check if the room was found or not
    if (!foundRoom) {
        printf("\n                             ROOM RESERVATION NOT FOUND\n");
    }
}



/*******************************************************************************

TO DO: Mark a reservation as completed based on the provided reservation ID and room number.

Description:  allows the user to mark a reservation as completed by providing the reservation 
			  ID and the number of the room to mark as completed. It takes an array of Reservation
			  structures and a pointer to the total number of reservations as input. The function 
			  displays the list of reservations with the provided reservation ID and prompts the user 
			  to enter the room number they want to mark as completed. If the provided input is invalid, 
			  appropriate error messages are displayed.

@param reservations: A pointer to an array of Reservation structures representing the existing reservations.
@param totalReservations: A pointer to an integer representing the total number of reservations in the reservations array.

@return: Does not return any value.
		 
*******************************************************************************/

// Function to mark a reservation as completed

void 
markReservation(struct Reservation* reservations, int* totalReservations) {
	
    // Declare variables
    int reservationID;  // Variable to store the reservation ID entered by the user
    int foundReservation = 0; // Flag to indicate if the reservation with given ID is found
    int goBackOption = 0; // Flag to indicate if the user wants to go back

    // Display the reservations interface
    printf("\n");
    DisplayReservations(); // Assuming there is a function called DisplayReservations() to show existing reservations
    printf("\n\n\n");

    // Ask if the user wants to go back
    printf("\n                             DO YOU WANT TO GO BACK (Y/N): ");
    char backChoice;
    scanf(" %c", &backChoice);

    if (backChoice == 'y' || backChoice == 'Y') {
        goBackOption = 1; // Set the goBackOption flag to indicate the user wants to go back
        return; // Exit the function since the user wants to go back
    }

    // Ask for the reservation ID to mark as completed
    printf("\n                             Enter the reservation ID to mark as completed: ");
    if (scanf("%d", &reservationID) != 1) {
        printf("\n                             INVALID INPUT. PLEASE ENTER A VALID RESERVATION ID.\n");
        return; // Exit the function due to invalid input
    }

    // Display reservations with the given ID
    printf("                             %d Reservations:\n\n", *totalReservations);
    int count = 1; // Counter to keep track of matching reservations with the given ID
    for (int i = 0; i < *totalReservations; i++) {
        if (reservations[i].idNum == reservationID) {
            foundReservation = 1; // Set the foundReservation flag to indicate that a reservation with the given ID is found
            printf("\n                             %d. Room: %s\n", count, reservations[i].roomType);
            if (reservations[i].completed) {
                printf("                             Status: Completed\n\n");
            } else {
                printf("                             Status: Not Completed\n\n");
            }
            count++; // Increment the counter for each matching reservation
        }
    }

    // Check if reservations with the given ID were found
    if (!foundReservation) {
        printf("\n                             No reservations found with ID %d.\n", reservationID);
        return; // Exit the function since no matching reservations were found
    }

    // Ask for the room number to mark as completed
    int roomNumberToMark;
    printf("\n                             Enter the number of the room to mark as completed: ");
    if (scanf("%d", &roomNumberToMark) != 1 || roomNumberToMark < 1 || roomNumberToMark >= count) {
        printf("\n                             INVALID INPUT. PLEASE ENTER A VALID ROOM NUMBER.\n");
        return; // Exit the function due to invalid room number selection
    }

    // Mark the reservation with the given ID and room number as completed
    count = 1; // Reset the counter
    for (int i = 0; i < *totalReservations; i++) {
        if (reservations[i].idNum == reservationID) {
            if (count == roomNumberToMark) {
                if (reservations[i].completed) {
                    printf("\n                             THIS RESERVATION IS ALREADY MARKED AS COMPLETED. DELETING THE RESERVATION...\n");

                    // Shift the array to delete the reservation
                    for (int j = i; j < *totalReservations - 1; j++) {
                        reservations[j] = reservations[j + 1];
                    }
                    
                    (*totalReservations)--; // Decrement the total number of reservations

                    return; // Exit the function after deleting the reservation
                }
                
                // Mark the reservation as completed
                reservations[i].completed = 1;
                printf("\n                             Reservation with ID %d, Room %s has been marked as completed.\n",
                       reservationID, reservations[i].roomType);
                return; // Exit the function after marking the reservation as completed
            }
            
            count++; // Increment the counter for each matching reservation
        }
    }

    printf("\n                             INVALID ROOM NUMBER SELECTION.\n");
    // If the function reaches this point, the room number selection was invalid.
}


/************************** U S E R M O D U L E ******************************/
//TODO: Implementing the userModuleSwitch function for user module actions.

/*******************************************************************************

TO DO: checks if the provided hour and minute values represent a valid time in the 24-hour format.
	   
DESCRIPTION:  takes two integers, hour and minute, as input and checks if they form a valid time in 
			  the 24-hour format. It returns 1 (true) if the provided hour is between 0 and 23 (inclusive)
			   and the minute is between 0 and 59 (inclusive). Otherwise, it returns 0 (false), indicating 
			   that the time is not valid.
			 
@param hour: An integer representing the hour of the time (between 0 and 23).
@param minute: An integer representing the minute of the time (between 0 and 59).

@return: Integer value indicating the validation result.
		 > If both hour and minute are within the range, returns 1.
		 > If it is not, returns 0.
		 
*******************************************************************************/

int 
isTimeValid(int hour, int minute) {
	
    // The return statement checks if the hour is between 0 (inclusive) and 24 (exclusive)
    // and the minute is between 0 (inclusive) and 60 (exclusive).
    // If both conditions are true, it returns 1 (true) indicating a valid time, otherwise, it returns 0 (false).
    return (hour >= 0 && hour < 24 && minute >= 0 && minute < 60);
}

/*******************************************************************************

TO DO: check if the provided date and time string is valid and extract the individual date and time components.
	   
DESCRIPTION:  takes a date and time string in the format "YYYY-MM-DD HH:MM" as input and attempts to extract the 
			 year, month, day, hour, and minute components.
			 
@param dateTime: A pointer to a character array (string) representing the date and time in the format "YYYY-MM-DD HH:MM".
@param year: A pointer to an integer variable to store the extracted year value.
@param month: A pointer to an integer variable to store the extracted month value.
@param day: A pointer to an integer variable to store the extracted day value.
@param hour: A pointer to an integer variable to store the extracted hour value.
@param minute: A pointer to an integer variable to store the extracted minute value.

@return: Integer value indicating the validation result.
		 > If extraction is successful, returns 1.
		 > If it is not, returns 0.
		 
*******************************************************************************/

// Function to check if the provided hour and minute values represent a valid time.

// Function to validate the format of a date and time string in the format "YYYY-MM-DD HH:MM"
// It extracts the year, month, day, hour, and minute components from the input string using sscanf
// If all components are successfully extracted, it returns 1 (true) to indicate a valid format
// Otherwise, it returns 0 (false) to indicate an invalid format.

int 
isTimeDateValid(char* dateTime, int* year, int* month, int* day, int* hour, int* minute) {
	
	// The code uses sscanf to extract year, month, day, hour, and minute components from the dateTime string.
    if (sscanf(dateTime, "%d-%d-%d %d:%d", year, month, day, hour, minute) != 5) {
    	
        return 0; // Return 0 if not all five components are successfully extracted
    }
    return 1; // Return 1 if the date and time format is valid
}



/*******************************************************************************

TO DO: check if a time slot is available for a given date and time.
	   
DESCRIPTION:  function takes an array of Reservation structures, the total number of 
			  reservations, and a date-time string as input. It checks if the given 
			  date-time slot is available based on the existing reservations.
			 
@param reservations: An array of Reservation structures representing the existing reservations.
@param totalReservations: An integer representing the total number of reservations in the reservations array.
@param dateTime: A pointer to a constant character array (string) representing the date and time in the 
format "YYYY-MM-DD HH:MM".


@return: Integer value indicating the validation result.
		 > If timeslot is available, returns 1.
		 > If it is not, returns 0.
		 
*******************************************************************************/

// Function to check if a time slot is available for a given date and time.
// Returns 1 (true) if there is an available slot, and 0 (false) if the maximum number of slots per day is reached.

int 
isTimeSlotAvailable(struct Reservation reservations[], int totalReservations, const char* dateTime) {
	
    int count = 0; // Counter to keep track of the number of reservations with the given date and time

    // Loop through each reservation to count how many match the given date and time
    for (int i = 0; i < totalReservations; i++) {
        if (strcmp(reservations[i].dateTime, dateTime) == 0) {
            count++; // Increment count for each matching reservation
        }
    }

    // Check if the number of reservations with the given date and time is less than the maximum slots per day
    // If it is less, return 1 (true), indicating that a time slot is available.
    // Otherwise, return 0 (false), indicating that the maximum number of slots per day is reached.
    return count < MAX_SLOTS_PER_DAY;
}

/*******************************************************************************

TO DO: check if the provided date (year, month, day) is a valid day of the week.
	   
DESCRIPTION:  function takes integers representing the year, month, and day as input. 
			  It uses the Zeller's Congruence algorithm to calculate the day of the week 
			  for the given date. 
			 
@param year: An integer representing the year of the date.
@param month: An integer representing the month of the date (1 for January, 2 for February, and so on).
@param day: An integer representing the day of the date.

@return: An integer representing the day of the week for the provided date according to the 
		 Zeller's Congruence algorithm:
		 > 0, Saturday.
		 > 1, Sunday.
		 > 2, Monday.
		 > 3, Tuesday.
		 > 4, Wednesday.
		 > 5, Thursday.
		 > 6, Friday.
		 
*******************************************************************************/

// Function to check if a given date is valid (falls on a valid day of the week).
// It returns an integer representing the day of the week where 0 is Sunday, 1 is Monday, etc.
// If the input date is invalid, the returned value will be between 0 and 6 (inclusive).

int 
isDayValid(int year, int month, int day) {
	
    int zellers[] = {0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4}; // Zeller's congruence values for each month

    // Zeller's congruence formula to calculate the day of the week.
    // Note: The result is an integer representing the day of the week,
    // where 0 is Sunday, 1 is Monday, and so on, with 6 being Saturday.
    int isDayValid = (year + year / 4 - year / 100 + year / 400 + zellers[month - 1] + day) % 7;

    // Adjust the year for January and February to match Zeller's formula requirements.
    // This is needed because January and February are treated as months 13 and 14 of the previous year.
    year -= month < 3;

    // Return the day of the week as calculated by Zeller's formula.
    return isDayValid;
}

/*******************************************************************************

TO DO: check if the number of participants for a reservation is within the capacity of the room.

DESCRIPTION:  The validateParticipants function takes two integers, participants and roomCapacity, 
			  as input. It checks if the number of participants for a reservation does not exceed the 
			  capacity of the room.
			 
@param participants: An integer representing the number of participants for the reservation.
@param roomCapacity: An integer representing the capacity of the room.

@return: An integer value indicating the validity:
		 > Reservation is valid, returns 1.
		 > If it is not, returns 0.
		 
*******************************************************************************/

// Function to validate if the number of participants is valid for the given room capacity.
// Returns 1 (true) if the number of participants is less than or equal to the room capacity.
// Returns 0 (false) otherwise.

int 
validateParticipants(int participants, int roomCapacity) {
	
    // Check if the number of participants is less than or equal to the room capacity.
    // If true, it means the number of participants is valid, and the function returns 1 (true).
    // Otherwise, if the number of participants exceeds the room capacity, it returns 0 (false).
    return participants <= roomCapacity;
}


/*******************************************************************************

TO DO: check if a room is available for a given date and time.

DESCRIPTION:  function takes an array of Room structures representing the available rooms, an 
			  array of Reservation structures representing the existing reservations, the total 
			  number of rooms, the name of the room to check availability, the day of the week, 
			  and the hour and minute of the requested time slot as input. It checks if the specified 
			  room is available at the given date and time, considering the existing reservations..
			 
@param rooms: An array of Room structures representing the available rooms.
@param reservations: An array of Reservation structures representing the existing reservations.
@param totalRooms: An integer representing the total number of available rooms in the rooms array.
@param roomName: A pointer to a character array (string) representing the name of the room to check availability.
@param dayOfWeek: An integer representing the day of the week (0 for Saturday, 1 for Sunday, and so on).
@param hour: An integer representing the hour of the requested time slot (in the 24-hour format).
@param minute: An integer representing the minute of the requested time slot.

@return: An integer value indicating the validity:
		 > Room available iat the specified date and time, returns 1.
		 > If it is not, returns 0.
		 
*******************************************************************************/

// Function to check if a room is available for a given date, day of the week, and time.
// Returns 1 (true) if the room is available, and 0 (false) otherwise.

int 
isRoomAvailable(struct Room* rooms, struct Reservation* reservations, int totalRooms, int totalReservations, char* roomName, int dayOfWeek, int hour, int minute) {
    
	// Loop through each room to find the matching room by its name.
    for (int i = 0; i < totalRooms; i++) {
        if (strcmp(rooms[i].roomName, roomName) == 0) {
            // Once the room is found, loop through each reservation to check for conflicts.
            for (int j = 0; j < totalReservations; j++) {
                // Check if the reservation matches the room name.
                if (strcmp(reservations[j].roomType, roomName) == 0) {

                    // Extract the day, hour, and minute from the existing reservation's dateTime.
                    int existingDay, existingHour, existingMinute;
                    sscanf(reservations[j].dateTime, "%*d-%*d-%d %d:%d", &existingDay, &existingHour, &existingMinute);

                    // Check if there is a direct conflict with the given day, hour, and minute.
                    if (existingDay == dayOfWeek && existingHour == hour && existingMinute == minute) {
                        return 0; // Room is not available due to direct conflict.
                    }

                    // Check if there is a 90-minute overlap with an existing reservation.
                    if (existingDay == dayOfWeek && existingHour == hour) {
                        if ((existingMinute >= minute && existingMinute <= minute + 90) ||
                            (existingMinute + 90 >= minute && existingMinute + 90 <= minute + 90)) {
                            return 0; // Room is not available due to a 90-minute overlap.
                        }
                    }

                    // Check if there is a 15-minute overlap with an extended reservation.
                    if (reservations[j].isExtended && existingDay == dayOfWeek && existingHour == hour) {
                        if ((existingMinute >= minute && existingMinute <= minute + 15) ||
                            (existingMinute + 15 >= minute && existingMinute + 15 <= minute + 15)) {
                            return 0; // Room is not available due to a 15-minute overlap with an extended reservation.
                        }
                    }
                }
            }
            return 1; // Room is available as no conflicts were found.
        }
    }
    return 0; // Room is not found in the list of rooms.
}


/*******************************************************************************

TO DO: check if a user has reached the maximum number of pending or incomplete reservations

DESCRIPTION: takes an array of Reservation structures representing the user's reservations, 
			 the total count of the user's reservations, and the user ID as input. It counts the 
			 number of pending or incomplete reservations for the given user and returns a boolean value.
			 
@param userReservations: An array of Reservation structures representing the user's reservations.
@param userReservationCount: An integer representing the total number of reservations for the user in the 
	   userReservations array.
@param userID: An integer representing the unique identifier of the user.

@return: An integer value indicating the validity:
		 > If user has 3 pending, returns 1.
		 > If it is not, returns 0.
		 
*******************************************************************************/

// Function to check if a user has reached the maximum number of reservations.
// Returns 1 (true) if the user has reached or exceeded 3 pending or incomplete reservations.
// Returns 0 (false) otherwise.

int 
hasReachedMaxReservations(struct Reservation userReservations[], int userReservationCount, int userID) {
	
    int totalReservations = 0; // Counter to keep track of the user's pending or incomplete reservations.

    // Loop through each reservation of the user to count the pending or incomplete ones.
    for (int i = 0; i < userReservationCount; i++) {
        // Check if the reservation belongs to the specified user (identified by the userID)
        // and if the reservation is either pending or not completed.
        if (userReservations[i].idNum == userID && (userReservations[i].isPending || !userReservations[i].completed)) {
            totalReservations++; // Increment the totalReservations counter.
        }
    }

    // Check if the total number of pending or incomplete reservations is greater than or equal to 3.
    // If true, it means the user has reached or exceeded the maximum number of reservations,
    // and the function returns 1 (true).
    // Otherwise, if the total number of pending or incomplete reservations is less than 3,
    // the function returns 0 (false) to indicate the user can make more reservations.
    return totalReservations >= 3;
}



/*******************************************************************************

TO DO:  save reservations data to a file.

DESCRIPTION:  takes an array of Reservation structures representing the reservations 
			  and the total number of reservations as input. It creates a new file named 
			  "records.txt" and writes the reservation details to the file in a formatted manner. 
			  If the file cannot be opened for writing, it displays an error message and returns 
			  without saving the data.
			 
@param reservations: An array of Reservation structures representing the reservations to be saved.
@param totalReservations: An integer representing the total number of reservations in the reservations array.

@return: Does not return any value.
		 
*******************************************************************************/

// Function to save reservations data to a file.

void 
saveReservationsToFile(struct Reservation reservations[], int totalReservations) {
	
    // Open the file "records.txt" in write mode ("w").
    FILE* file = fopen("records.txt", "a");

    // Check if the file opening was successful.
    if (file == NULL) {
        printf("\n                             ERROR OPENING THE FILE FOR SAVING RESERVATIONS\n");
        return;
    }

    // Loop through each reservation and write its data to the file.
    for (int i = 0; i < totalReservations; i++) {
        // Write each reservation detail to the file in a specific format using fprintf.
        fprintf(file, "ID Number: %d\nName: %s\nYear and Program: %s\nDate and Time: %s\nNumber of Participants: %d\nRoom: %s\nActivity: %s\nComplete (1) or Pending (0): %d\n",
            reservations[i].idNum,
            reservations[i].name,
            reservations[i].yearprogram,
            reservations[i].dateTime,
            reservations[i].participants,
            reservations[i].roomType,
            reservations[i].activity,
            reservations[i].completed);

        // If the reservation has an extension, write the extension date and time to the file.
        if (reservations[i].isExtended) {
            fprintf(file, "Extension Date and Time: %s\n", reservations[i].extensionDateTime);
        }

        // Add an empty line to separate each reservation entry in the file.
        fprintf(file, "\n");
    }

    // Close the file after writing all the reservations.
    fclose(file);
}

/*******************************************************************************

TO DO: allow users to make room reservations.

DESCRIPTION:   facilitates the process of making a room reservation. It takes an array 
			   of Reservation structures representing existing reservations and an array 
			   of Room structures representing the available rooms as input. 
			 
@param reservations: An array of Reservation structures representing the existing reservations.
@param rooms: An array of Room structures representing the available rooms.
@param totalReservations: An integer representing the total number of existing reservations.

@return: Does not return any value.
		 
*******************************************************************************/

// Function to make a new reservation
void 
makeReservation (struct Reservation reservations[], struct Room rooms[]) {
	
    struct Reservation addReservation; // Temporary struct to store the new reservation data
    struct Reservation reservation; // Unused variable (can be removed)
    char dateTime[MAX_LENGTH]; // Buffer to store date and time input
    int year, month, day, hour, minute; // Variables to store parsed date and time components
    int validDateTime = 0; // Flag to check if the entered date and time are valid
    int validRoomType = 0; // Flag to check if the entered room type is valid
    int reservationCount = 0; // Unused variable (can be removed)
    int hasPendingReservation = 0; // Unused variable (can be removed)
    int validID = 0; // Flag to check if the entered ID is valid
    int attempts = 0; // Unused variable (can be removed)
    int userID = 0; // Variable to store the user's ID
    int pendingReservations = 0; // Unused variable (can be removed)
    int terminateProgram = 0; // Unused variable (can be removed)
    char idNum[MAX_LENGTH]; // Buffer to store ID input
    int goBackOption = 0; // Variable to handle the "go back" option

    // Display the reservation menu
	printf("\n");
	DisplayReservation();

	// Check if all available reservations have been booked
	if (totalReservations >= MAX_RESERVATIONS) {
    	printf("\n                             ALL AVAILABLE RESERVATIONS HAVE BEEN BOOKED.\n");
    	return; // Exit the function if all reservations are booked
	}

	// Ask the user if they want to go back
	printf("\n                             DO YOU WANT TO GO BACK? (Y/N): ");
	char backChoice;
	scanf(" %c", &backChoice);

	// If the user wants to go back, set the goBackOption flag and exit the function
	if (backChoice == 'y' || backChoice == 'Y') {
    	goBackOption = 1; // Set the flag to indicate the user wants to go back
    	return; // Exit the function
	}

	// Create an array to store the user's reservations
	struct Reservation userReservations[MAX_RESERVATIONS_PER_USER];

    
	while (!validID) { // Loop until a valid ID number is entered
    	int userReservationCount = 0; // Number of reservations for the current user
    	printf("\n");
    	printf("\n");
    	printf("\n                             ID Number: "); // Prompt the user to enter their ID number
    	
    if (scanf("%d", &addReservation.idNum) != 1) { // Check if the input is valid
        printf("\n                            INVALID INPUT. PLEASE ENTER A VALID 8-DIGIT ID NUMBER.\n"); // If not, print an error message
        while (getchar() != '\n'); // Clear the input buffer
    } else {
        getchar(); // Get rid of the newline character from the input buffer
        int validIDPrefix = addReservation.idNum / 100000; // Get the first 3 digits of the ID number
        if (validIDPrefix >= 118 && validIDPrefix <= 122 && addReservation.idNum >= 10000000 && addReservation.idNum <= 99999999) { // Check if the ID number is valid
            validID = 1; // Set the validID flag to true
            userID = addReservation.idNum; // Save the ID number for the current user

            for (int i = 0; i < totalReservations; i++) { // Loop through all the reservations
                if (reservations[i].idNum == userID) { // Check if the current user has any existing reservations
                    userReservations[userReservationCount] = reservations[i]; // Add the existing reservation to the user's list of reservations
                    userReservationCount++; // Increment the user's reservation count
                }
            }

            if (hasReachedMaxReservations(userReservations, userReservationCount, userID)) { // Check if the user has reached the maximum number of reservations
                printf("                            YOU CAN'T RESERVE A ROOM AS YOU HAVE ALREADY REACHED THE MAXIMUM NUMBER OF RESERVATIONS.\n"); // If so, print an error message and return
                return;
            } else {
                int pendingReservationsCount = 0; // Number of pending reservations for the current user
                for (int i = 0; i < userReservationCount; i++) { // Loop through the user's reservations
                    if (userReservations[i].idNum == userID) { // Check if the reservation is pending
                        pendingReservationsCount++; // Increment the pending reservation count
                    }
                }

                if (pendingReservationsCount == 3) { // Check if the user has 3 pending reservations
                    printf("                            YOU CAN'T RESERVE A ROOM AS YOU ALREADY HAVE 3 PENDING RESERVATIONS.\n"); // If so, print an error message and return
                    return;
                } else {
                    userReservations[userReservationCount].idNum = addReservation.idNum; // Add the new reservation to the user's list of reservations
                    userReservationCount++; // Increment the user's reservation count
                }
            }
        } else {
            printf("                            INVALID ID NUMBER. TRY AGAIN!\n"); // If the ID number is invalid, print an error message
        }
    }
}
    // Prompt the user to enter their name and read the input
	printf("\n                             Name: ");
	fgets(addReservation.name, MAX_LENGTH, stdin);

	// Remove the trailing newline character from the name
	addReservation.name[strcspn(addReservation.name, "\n")] = '\0';

	// Prompt the user to enter their year and program and read the input
	printf("\n                             Year and Program: ");
	fgets(addReservation.yearprogram, MAX_LENGTH, stdin);

	// Remove the trailing newline character from the year and program
	addReservation.yearprogram[strcspn(addReservation.yearprogram, "\n")] = '\0';
	
		// Continue the loop until a valid date and time format is entered
	do {
    	// Prompt the user to enter the date and time for the reservation (in the format: YYYY-MM-DD HH:MM)
    	printf("\n                             Date and Time Reservation: (YYYY-MM-DD HH:MM): ");
    	fgets(dateTime, MAX_LENGTH, stdin);

    	// Remove the trailing newline character from the input
   	 	dateTime[strcspn(dateTime, "\n")] = '\0';

    	// Check if the entered date and time are in a valid format and retrieve the parsed components
    	if (!isTimeDateValid(dateTime, &year, &month, &day, &hour, &minute)) {
       		 // If the format is invalid, notify the user and repeat the loop to ask for input again
        	printf("\n                             INVALID DATE AND TIME FORMAT. TRY AGAIN! (YYYY-MM-DD HH:MM).\n");
    	} else if (year < 2023) {
        	// If the year is earlier than 2023, notify the user and repeat the loop to ask for input again
        	printf("\n                             INVALID DATE. TRY AGAIN!\n");
    	} else if (!isDayValid(year, month, day)) {
        	// If the day is invalid (e.g., Sunday when the building is closed), notify the user and repeat the loop
        	printf("\n                             SORRY, IT IS SUNDAY. THE BUILDING IS CLOSED.\n");
    	} else {
        	// Check if the chosen day of the week has available time slots
        	if (isDayValid(year, month, day) == 3 || isDayValid(year, month, day) == 6) {
            	// If it's Wednesday or Saturday, check if the selected time slot is available
            	if ((hour >= 9 && minute == 0) || (hour >= 13 && minute == 0) || (hour == 16 && minute <= 15)) {
                	// If the time slot is available, set the `validDateTime` flag to true and notify the user
                	printf("\n                             TIME SLOT IS AVAILABLE FOR WEDNESDAY AND SATURDAY.\n");
                	validDateTime = 1;
            	} else {
                	// If the time slot is not available, inform the user and repeat the loop
                	printf("\n                             INVALID TIME SLOT FOR WEDNESDAY AND SATURDAY.\n");
            	}
        	} else {
            	// If it's Monday, Tuesday, Thursday, or Friday, check if the selected time slot is available
            	if ((hour == 9 && minute >= 15) || (hour == 11) ||
                	(hour == 12 && minute == 45) || (hour == 14 && minute == 30) ||
                	(hour == 16 && minute == 15) || (hour == 18)) {
                	// If the time slot is available, set the `validDateTime` flag to true and notify the user
                	printf("\n                             TIME SLOT IS AVAILABLE FOR MONDAY, TUESDAY, THURSDAY, AND FRIDAY.\n");
                	validDateTime = 1;
            	} else {
                	// If the time slot is not available, inform the user and repeat the loop
                	printf("\n                             INVALID TIME SLOT FOR MONDAY, TUESDAY, THURSDAY, AND FRIDAY.\n");
            	}
        	}
    	}

    // Check if the chosen date and time slot is available (not already booked)
    if (validDateTime) {
        if (!isTimeSlotAvailable(reservations, totalReservations, dateTime)) {
            // If the time slot is already booked, notify the user and repeat the loop to ask for input again
            printf("\n                             TIME SLOT IS ALREADY BOOKED FOR THE SELECTED DATE AND TIME. PLEASE CHOOSE ANOTHER SLOT.\n");
            validDateTime = 0; // Reset the validDateTime flag to allow the user to try again
        	}
    	}

	} while (!validDateTime);

	// If the loop exits, it means a valid date and time were entered, so copy the dateTime to the reservation's dateTime field
	strcpy(addReservation.dateTime, dateTime);


	// Variable to count how many rooms were found (not used here, might be used elsewhere in the code)
	int roomFoundCount = 0;

	// Variable to store the day of the week (not initialized here, might be initialized elsewhere in the code)
	int dayOfWeek;

	// Loop until a valid room type is entered (validRoomType is initially set to 0)
	while (!validRoomType) {
    	// Prompt the user to enter the room name and read the input
    	printf("\n                             Enter Room Name: ");
    	fgets(addReservation.roomType, MAX_LENGTH, stdin);

    // Remove the trailing newline character from the room name
    addReservation.roomType[strcspn(addReservation.roomType, "\n")] = '\0';

    // Check if the entered room is available for reservation
    if (!isRoomAvailable(rooms, reservations, numRooms, totalReservations, addReservation.roomType, dayOfWeek, hour, minute)) {
        // If the room is not available, inform the user and continue the loop to prompt for another room name
        printf("\n                             INVALID ROOM NAME. PLEASE CHOOSE A ROOM THAT IS AVAILABLE FOR RESERVATION.\n");
    } else {
        // If the room is available, set validRoomType to 1 to exit the loop
        validRoomType = 1;
    }
}

	int foundRoom = 0; // Flag to indicate if a room has been found.
	for (int i = 0; i < numRooms && !foundRoom; i++) { // Loop through all rooms.
   	 if (strcmp(rooms[i].roomName, addReservation.roomType) == 0) { // Check if the room name matches the user's input.
        addReservation.participants = 0; // Initialize the number of participants to 0.
       	 do { // Loop until the user enters a valid number of participants.
            printf("\n                            Enter the number of participants (up to %d): ", rooms[i].roomCapacity);
            scanf("%d", &addReservation.participants);
            getchar(); // Clear the input buffer.
        } while (addReservation.participants <= 0 || addReservation.participants > rooms[i].roomCapacity); // Check if the number of participants is valid.

        foundRoom = 1; // Set the foundRoom flag to true.
    }
}

	// Declare a variable to store the user's response to extending the reservation time.
	char extendTimeResponse;

	// Prompt the user to choose whether they want to extend their reservation time.
	printf("\n                             DO YOU WANT TO EXTEND YOUR TIME? (Y/N): ");
	scanf(" %c", &extendTimeResponse);
	getchar(); // Clear the newline character from the input buffer.

	// If the response is 'y' or 'Y', proceed to extend the reservation time.
	if (extendTimeResponse == 'y' || extendTimeResponse == 'Y') {
    	int extensionValid = 0;

    // Loop until a valid extension date and time is entered.
    while (!extensionValid) {
        // Declare variables to store the components of the extension date and time.
        char extensionDateTime[MAX_LENGTH];
        int extensionYear, extensionMonth, extensionDay, extensionHour, extensionMinute;

        // Prompt the user to enter the extension date and time.
        printf("\n                             Extension Time for Reservation (YYYY-MM-DD HH:MM): ");
        fgets(extensionDateTime, MAX_LENGTH, stdin);

        // Remove the trailing newline character from the input.
        extensionDateTime[strcspn(extensionDateTime, "\n")] = '\0';

        // Check if the entered extension date and time are in a valid format and retrieve the parsed components.
        if (!isTimeDateValid(extensionDateTime, &extensionYear, &extensionMonth, &extensionDay, &extensionHour, &extensionMinute)) {
            // If the format is invalid, notify the user and repeat the loop to ask for input again.
            printf("\n                             INVALID EXTENSION DATE AND TIME FORMAT. TRY AGAIN! (YYYY-MM-DD HH:MM).\n");
        } else if (extensionYear != year || extensionMonth != month || extensionDay != day) {
            // If the extension date is not on the same day as the original reservation, notify the user and repeat the loop.
            printf("\n                             INVALID EXTENSION. EXTENSION TIME SHOULD BE ON THE SAME DAY AS THE ORIGINAL RESERVATION.\n");
        } else if ((hour == 9 && minute == 15 && extensionHour == 11 && extensionMinute == 0) ||
                   (hour == 9 && minute == 0 && extensionHour == 13 && extensionMinute == 0) ||
                   (hour == 11 && minute == 0 && extensionHour == 12 && extensionMinute == 45) ||
                   (hour == 12 && minute == 45 && extensionHour == 14 && extensionMinute == 30) ||
                   (hour == 13 && minute == 0 && extensionHour == 16 && extensionMinute == 15) ||
                   (hour == 14 && minute == 30 && extensionHour == 16 && extensionMinute == 15) ||
                   (hour == 16 && minute == 15 && extensionHour == 18 && extensionMinute == 0)) {
            // If the extension time is in valid consecutive slots, mark the extension as valid.
            extensionValid = 1;

            // Mark the reservation as extended and store the extension date and time.
            addReservation.isExtended = 1;
            strcpy(addReservation.extensionDateTime, extensionDateTime);
        } else if (hour > 19 && minute == 0) {
            // If the original reservation time is close to the building's closing time, notify the user of an invalid extension.
            printf("\n                             INVALID! BUILDING WILL BE CLOSING WITHIN THIS TIME.\n");
        } else {
            // If the extension time is not in consecutive slots, notify the user of an invalid extension.
            printf("                             INVALID! TIME EXTENSION SHOULD BE CONSECUTIVE TO THE ORIGINAL RESERVED TIME.\n");
        }
  	  }
	}

	// Proceed to prompt the user to enter the activity for the reservation.
	printf("\n                             Activity: ");
	fgets(addReservation.activity, MAX_LENGTH, stdin);

	// Remove the trailing newline character from the input.
	addReservation.activity[strcspn(addReservation.activity, "\n")] = '\0';

	// Mark the reservation as not completed (assuming there is a completion status in the struct).
	addReservation.completed = 0;

	// Add the completed reservation to the 'reservations' array and increase the total reservation count.
	reservations[totalReservations] = addReservation;
	totalReservations++;

	// Inform the user that the reservation has been successfully booked.
	printf("\n                             RESERVATION HAS BEEN SUCCESSFULLY BOOKED!\n");

}

/*******************************************************************************

TO DO: allow users to edit their existing room reservations.

DESCRIPTION: enables users to modify the details of their existing room reservations.
			 
@param reservations: An array of Reservation structures representing the existing reservations.
@param totalReservations: An integer representing the total number of existing reservations.

@return: Does not return any value.
		 
*******************************************************************************/

// Function to edit
void 
editReservation(struct Reservation reservations[], int totalReservations) {
	
    // Variables to handle user input and navigation
    int goBackOption = 0; // This variable is not used in the current code
    int extensionHour; // Variables to store the extension date and time
    int original_year; // Variables to store the original date and time of the reservation
    int original_month;
    int original_day;
    int extensionMinute;
    
    // Ask the user if they want to go back
    printf("\n                             DO YOU WANT TO GO BACK? (Y/N): ");
    char backChoice;
    scanf(" %c", &backChoice);

    // If the user wants to go back, set the goBackOption flag and return from the function
    if (backChoice == 'y' || backChoice == 'Y') {
        goBackOption = 1;
        return; 
    }
    
    // Ask the user to enter the ID number of the reservation to edit
    int reservationID;
    printf("\n                             Enter the ID number of the reservation to edit: ");
    scanf("%d", &reservationID);
    getchar();

    // Variable to track if the reservation with the given ID was found
    int foundReservation = 0;
    int choice;

    // Loop through all reservations to find the one with the given ID
    for (int i = 0; i < totalReservations; i++) {
        // Check if the current reservation has the same ID as the one the user wants to edit
        if (reservations[i].idNum == reservationID) {
            foundReservation = 1; // Set the flag to indicate that the reservation was found
            // Print the details of the reservation for editing
            printf("                        +----------------------------+----------------------------------------+\n");
            printf("                        |      Reservation Number    |      %-34s|\n", "Reservation Details");
            printf("                        +----------------------------+----------------------------------------+\n");
            printf("                        | %-22d     |                                        |\n", i + 1);
            printf("                        |----------------------------+----------------------------------------|\n");
            printf("                        |       ID Number            | %-38d |\n", reservations[i].idNum);
            printf("                        |----------------------------+----------------------------------------|\n");
            printf("                        |       Full Name            | %-38s |\n", reservations[i].name);
            printf("                        |----------------------------+----------------------------------------|\n");
            printf("                        |    Year & Program          | %-38s |\n", reservations[i].yearprogram);
            printf("                        |----------------------------+----------------------------------------|\n");
            printf("                        |    Date and Time           | %-38s |\n", reservations[i].dateTime);
            printf("                        |----------------------------+----------------------------------------|\n");
            printf("                        |  Number of Participants    | %-38d |\n", reservations[i].participants);
            printf("                        |----------------------------+----------------------------------------|\n");
            printf("                        |    Room to Reserve         | %-38s |\n", reservations[i].roomType);
            printf("                        |----------------------------+----------------------------------------|\n");
            printf("                        | Description of Activity    | %-38s |\n", reservations[i].activity);
            printf("                        +----------------------------+----------------------------------------+\n");
            printf("                        |    Extended Date and Time  | %-38s |\n", reservations[i].extensionDateTime);
            printf("                        +---------------------------------------------------------------------+\n");
            printf("\n");

            // Ask the user to select the field to edit
            printf("\n\n                             Select the field to edit:\n");
            printf("                             1. ID NUMBER\n");
            printf("                             2. NAME\n");
            printf("                             3. YEAR AND PROGRAM\n");
            printf("                             4. DATE AND TIME FOR RESERVATION\n");
            printf("                             5. NO. OF PARTICIPANTS\n");
            printf("                             6. ROOM TYPE\n");
            printf("                             7. ACTIVITY\n");
            printf("                             8. TIME EXTENSION\n");
            printf("                             Enter your choice: ");
            scanf("%d", &choice);
            getchar();

            // Switch statement to handle the user's choice for editing
            switch (choice) {
                case 1:
                    // Edit the ID number of the reservation
                    printf("\n                             ID Number: ");
                    scanf("%d", &reservations[i].idNum);
                    break;
                    
                case 2:
                    // Edit the name of the reservation
                    printf("\n                             Name: ");
                    fgets(reservations[i].name, MAX_LENGTH, stdin);
                    reservations[i].name[strcspn(reservations[i].name, "\n")] = '\0';
                    break;
                    
                case 3:
                    // Edit the year and program of the reservation
                    printf("\n                             Year and Program: ");
                    fgets(reservations[i].yearprogram, MAX_LENGTH, stdin);
                    reservations[i].yearprogram[strcspn(reservations[i].yearprogram, "\n")] = '\0';
                    break;
                    
                case 4: {
                    // Edit the date and time of the reservation
                    int validDateTime = 0; // Flag to check if the entered date and time is valid
                    int isLeap = 0; // Flag to check if the year is a leap year
                    int year, month, day, hour, minute;

                    // Loop until the user enters a valid date and time
                    do {
                        // Ask the user to enter the new date and time for the reservation
                        printf("\n                             Date and Time for Reservation (YYYY-MM-DD HH:MM): ");
                        fgets(reservations[i].dateTime, MAX_LENGTH, stdin);
                        reservations[i].dateTime[strcspn(reservations[i].dateTime, "\n")] = '\0';

                        // Check if the entered date and time is valid
                        if (!isTimeDateValid(reservations[i].dateTime, &year, &month, &day, &hour, &minute)) {
                            printf("\n                             INVALID DATE AND TIME FORMAT. TRY AGAIN! (YYYY-MM-DD HH:MM).\n");
                            validDateTime = 0; // The entered date and time is not valid
                        } else {
                            // Check if the year is a leap year
                            if (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)) {
                                isLeap = 1;
                            }

                            // Check if the year is before 2023
                            if (year < 2023) {
                                printf("\n                             INVALID DATE. TRY AGAIN!\n");
                                validDateTime = 0; // The entered date and time is not valid
                            } else if (!isTimeValid(hour, minute) && !isLeap && (month == 2 && day == 29)) {
                                printf("\n                             YEAR HAS NO LEAP AND INVALID TIME FORMAT. TRY AGAIN!\n");
                                validDateTime = 0; // The entered date and time is not valid
                            } else if (!isTimeValid(hour, minute)) {
                                printf("\n                             INVALID TIME. TRY AGAIN!\n");
                                validDateTime = 0; // The entered date and time is not valid
                            } else if (!isLeap && (month == 2 && day == 29)) {
                                printf("\n                             YEAR HAS NO LEAP. TRY AGAIN!\n");
                                validDateTime = 0; // The entered date and time is not valid
                            } else {
                                // Check if the building is closed on Sundays
                                if (isDayValid(year, month, day) == 0) {
                                    printf("\n                             SORRY, IT IS SUNDAY. BUILDING IS CLOSED.\n");
                                    validDateTime = 0; // The entered date and time is not valid
                                } else if ((isDayValid(year, month, day) == 3 || isDayValid(year, month, day) == 6) &&
                                           ((hour >= 9 && hour < 12) || (hour >= 13 && hour < 16) || (hour == 16 && minute <= 0))) {
                                    // Check if the time slot is available on Wednesdays and Saturdays
                                    printf("\n                             TIME SLOT IS AVAILABLE FOR WEDNESDAY AND SATURDAY:\n");
                                    validDateTime = 1; // The entered date and time is valid
                                } else if ((hour >= 9 && hour < 10 && minute >= 15) || (hour >= 11 && hour < 12) ||
                                           (hour >= 12 && hour < 14) || (hour >= 14 && hour < 15 && minute <= 30) ||
                                           (hour >= 15 && hour < 16 && minute <= 45) || (hour >= 16 && hour < 17 && minute <= 45) ||
                                           (hour >= 18 && hour < 19)) {
                                    // Check if the time slot is available on Mondays, Tuesdays, Thursdays, and Fridays
                                    printf("\n                             TIME SLOT IS AVAILABLE FOR MONDAY, TUESDAY, THURSDAY, AND FRIDAY:\n");
                                    validDateTime = 1; // The entered date and time is valid
                                } else {
                                    printf("\n                             INVALID TIME SLOT. TRY AGAIN!\n");
                                    validDateTime = 0; // The entered date and time is not valid
                                }

                                // Check if the time slot is already booked
                                if (validDateTime) {
                                    int count = 0;
                                    for (int j = 0; j < totalReservations; j++) {
                                        if (strcmp(reservations[j].dateTime, reservations[i].dateTime) == 0) {
                                            count++;
                                        }
                                    }

                                    if (count >= MAX_SLOTS) {
                                        printf("\n                             MAXIMUM NUMBER OF RESERVATIONS FOR THE GIVEN DATE AND TIME HAS BEEN REACHED.\n");
                                        validDateTime = 0; // The entered date and time is not valid
                                    }
                                }
                            }
                        }
                    } while (!validDateTime); // Repeat the loop until the date and time is valid
                    break;
                }
                
                case 5:
                    // Edit the number of participants for the reservation
                    do {
                        printf("\n                             Number of Participants: ");
                        scanf("%d", &reservations[i].participants);
                        getchar();

                        // Check if the number of participants is valid for the selected room type
                        if (strcmp(reservations[i].roomType, "classroom") == 0 && reservations[i].participants > 45) {
                            printf("\n                             INVALID NUMBER OF PARTICIPANTS. Maximum participants for classroom is 45. TRY AGAIN!\n");
                        } else if (strcmp(reservations[i].roomType, "seminar room") == 0 && reservations[i].participants > 60) {
                            printf("\n                             INVALID NUMBER OF PARTICIPANTS. Maximum participants for seminar room is 60. TRY AGAIN!\n");
                        } else if (strcmp(reservations[i].roomType, "auditorium") == 0 && reservations[i].participants > 150) {
                            printf("\n                             INVALID NUMBER OF PARTICIPANTS. Maximum participants for auditorium is 150. TRY AGAIN!\n");
                        } else if (strcmp(reservations[i].roomType, "training room") == 0 && reservations[i].participants > 30) {
                            printf("\n                             INVALID NUMBER OF PARTICIPANTS. Maximum participants for training room is 30. TRY AGAIN!\n");
                        } else {
                            break;
                        }
                    } while (1); // Repeat the loop until the number of participants is valid for the room type
                    break;
                    
                case 6:
                    // Edit the room type for the reservation
                    do {
                        printf("\n                             Room Type (classroom, seminar room, auditorium, training room): ");
                        fgets(reservations[i].roomType, MAX_LENGTH, stdin);
                        reservations[i].roomType[strcspn(reservations[i].roomType, "\n")] = '\0';

                        // Check if the room type is valid and update the number of participants accordingly
                        if (strcmp(reservations[i].roomType, "classroom") == 0) {
                            printf("\n                             NUMBER OF PARTICIPANTS (up to 45): ");
                            scanf("%d", &reservations[i].participants);
                            getchar();

                            if (reservations[i].participants <= 45) {
                                break;
                            } else {
                                printf("\n                             INVALID ROOM TYPE. Maximum participants for classroom is 45. TRY AGAIN!\n");
                            }
                        } else if (strcmp(reservations[i].roomType, "seminar room") == 0) {
                            printf("\n                             NUMBER OF PARTICIPANTS (up to 60): ");
                            scanf("%d", &reservations[i].participants);
                            getchar();

                            if (reservations[i].participants <= 60) {
                                break;
                            } else {
                                printf("\n                             INVALID ROOM TYPE. Maximum participants for seminar room is 60. TRY AGAIN!\n");
                            }
                        } else if (strcmp(reservations[i].roomType, "auditorium") == 0) {
                            printf("\n                             NUMBER OF PARTICIPANTS (up to 150): ");
                            scanf("%d", &reservations[i].participants);
                            getchar();

                            if (reservations[i].participants <= 150) {
                                break;
                            } else {
                                printf("\n                             INVALID ROOM TYPE. Maximum participants for auditorium is 150. TRY AGAIN!\n");
                            }
                        } else if (strcmp(reservations[i].roomType, "training room") == 0) {
                            printf("\n                             NUMBER OF PARTICIPANTS (up to 30): ");
                            scanf("%d", &reservations[i].participants);
                            getchar();

                            if (reservations[i].participants <= 30) {
                                break;
                            } else {
                                printf("\n                             INVALID ROOM TYPE. Maximum participants for training room is 30. TRY AGAIN!\n");
                            }
                        } else {
                            printf("\n                             INVALID ROOM TYPE. TRY AGAIN!\n");
                        }
                    } while (1); // Repeat the loop until the room type is valid and the number of participants is updated
                    break;
                case 7:
                    // Edit the activity for the reservation
                    printf("\n                             Activity: ");
                    fgets(reservations[i].activity, MAX_LENGTH, stdin);
                    reservations[i].activity[strcspn(reservations[i].activity, "\n")] = '\0';
                    break;
                case 8: {
                    // Edit the time extension for the reservation
                    int validDateTime = 0; // Flag to check if the entered extension date and time is valid
                    int year, month, day, hour, minute, extensionHour, extensionMinute;
                    sscanf(reservations[i].dateTime, "%d-%d-%d %d:%d", &year, &month, &day, &hour, &minute);
                    int original_year = year; // Store the original date and time of the reservation
                    int original_month = month;
                    int original_day = day;

                    // Loop until the user enters a valid extension date and time
                    do {
                        // Ask the user to enter the new extension date and time for the reservation
                        printf("\n                             Extension Time for Reservation (YYYY-MM-DD HH:MM): ");
                        fgets(reservations[i].extensionDateTime, MAX_LENGTH, stdin);
                        reservations[i].extensionDateTime[strcspn(reservations[i].extensionDateTime, "\n")] = '\0';

                        // Check if the entered extension date and time is valid
                        if (!isTimeDateValid(reservations[i].extensionDateTime, &year, &month, &day, &extensionHour, &extensionMinute)) {
                            printf("\n                             INVALID DATE AND TIME FORMAT. TRY AGAIN! (YYYY-MM-DD HH:MM).\n");
                            validDateTime = 0; // The entered extension date and time is not valid
                        } else if (year != original_year || month != original_month || day != original_day) {
                            printf("\n                             INVALID EXTENSION. EXTENSION TIME SHOULD BE ON THE SAME DAY AS THE ORIGINAL RESERVATION.\n");
                            validDateTime = 0; // The entered extension date and time is not valid
                        } else {
                            // Check if the extension time is consecutive to the original reserved time
                            if (isTimeValid(extensionHour, extensionMinute)) {
                                if (hour == 9 && minute == 15 && extensionHour == 11 && extensionMinute == 0) {
                                    validDateTime = 1; // The entered extension date and time is valid
                                } else if (hour == 9 && minute == 0 && extensionHour == 13 && extensionMinute == 0) {
                                    validDateTime = 1; // The entered extension date and time is valid
                                } else if (hour == 11 && minute == 0 && extensionHour == 12 && extensionMinute == 45) {
                                    validDateTime = 1; // The entered extension date and time is valid
                                } else if (hour == 12 && minute == 45 && extensionHour == 14 && extensionMinute == 30) {
                                    validDateTime = 1; // The entered extension date and time is valid
                                } else if (hour == 13 && minute == 0 && extensionHour == 16 && extensionMinute == 15) {
                                    validDateTime = 1; // The entered extension date and time is valid
                                } else if (hour == 14 && minute == 30 && extensionHour == 16 && extensionMinute == 15) {
                                    validDateTime = 1; // The entered extension date and time is valid
                                } else if (hour == 16 && minute == 15 && extensionHour == 18 && extensionMinute == 0) {
                                    validDateTime = 1; // The entered extension date and time is valid
                                } else {
                                    printf("\n                             INVALID! TIME EXTENSION SHOULD BE CONSECUTIVE TO THE ORIGINAL RESERVED TIME.\n");
                                    validDateTime = 0; // The entered extension date and time is not valid
                                }
                            } else {
                                printf("\n                             INVALID TIME. TRY AGAIN!\n");
                                validDateTime = 0; // The entered extension date and time is not valid
                            }
                        }
                    } while (!validDateTime); // Repeat the loop until the extension date and time is valid
                    break;
                }
                default:
                    printf("\n                             INVALID CHOICE!\n");
                    return;
            }

            printf("\n                             RESERVATION HAS BEEN SUCCESSFULLY UPDATED!\n");
            break; // Exit the loop once the reservation is found and edited
        }
    }

    if (!foundReservation) {
        printf("\n                             RESERVATION NOT FOUND!\n");
    }
}

/*******************************************************************************

TO DO: display the details of a user's reservations.

DESCRIPTION:  It prompts the user to enter their ID number to view their reservations. 
			  If the user's ID matches any existing reservation, it displays the details 
			  of all their reservations, including the reservation number, ID number, full 
			  name, year & program, date & time, number of participants, room to reserve, 
			  description of the activity, and reservation status (completed or pending). 
			  If the provided ID number does not match any reservation, it informs the user 
			  that no reservation was found.

@param reservations: An array of Reservation structures representing the existing reservations.

@return: Does not return any value.
		 
*******************************************************************************/

// Function to display
void 
displayReservation(struct Reservation reservations[]) {
	
    // Variables to handle user input and navigation
    int goBackOption = 0; // This variable is not used in the current code

    // Display the header and menu
    printf("\n");
    Display();
    printf("\n\n\n");

    // Ask the user if they want to go back
    printf("                             DO YOU WANT TO GO BACK? (Y/N): ");
    char backChoice;
    scanf(" %c", &backChoice);

    // If the user wants to go back, set the goBackOption flag and return from the function
    if (backChoice == 'y' || backChoice == 'Y') {
        goBackOption = 1;
        return; // Return 1 to indicate going back to the main menu
    }

    // Check if there are any reservations
    if (totalReservations == 0) {
        printf("\n                             NO RESERVATIONS FOUND.\n");
        return;
    }

    // Ask the user to enter their ID number
    int id;
    printf("\n                             Enter your ID number: ");
    scanf("%d", &id);
    getchar();

    // Variable to track if the reservation with the given ID was found
    int found = 0;

    // Loop through all reservations to find the one with the given ID
    for (int i = 0; i < totalReservations; i++) {
        struct Reservation reservation = reservations[i];
        // Check if the current reservation has the same ID as the one the user entered
        if (reservation.idNum == id) {
            found = 1; // Set the flag to indicate that the reservation was found
            // Print the details of the reservation
            printf("                             +----------------------------+----------------------------------------+\n");
            printf("                             |      Reservation Number    |       %-34                                 |\n", "Reservation Details");
            printf("                             +----------------------------+----------------------------------------+\n");
            printf("                             |             %-15d|                                        |\n", i + 1);
            printf("                             |----------------------------+----------------------------------------|\n");
            printf("                             |       ID Number            | %-38d |\n", reservation.idNum);
            printf("                             |----------------------------+----------------------------------------|\n");
            printf("                             |       Full Name            | %-38s |\n", reservation.name);
            printf("                             |----------------------------+----------------------------------------|\n");
            printf("                             |    Year & Program          | %-38s |\n", reservation.yearprogram);
            printf("                             |----------------------------+----------------------------------------|\n");
            printf("                             |    Date and Time           | %-38s |\n", reservation.dateTime);
            printf("                             |----------------------------+----------------------------------------|\n");
            printf("                             |    Time Extension          | %-38s |\n", reservations[i].extensionDateTime);
            printf("                             |----------------------------+----------------------------------------|\n");
            printf("                             |  Number of Participants    | %-38d |\n", reservation.participants);
            printf("                             |----------------------------+----------------------------------------|\n");
            printf("                             |    Room to Reserve         | %-38s |\n", reservation.roomType);
            printf("                             |----------------------------+----------------------------------------|\n");
            printf("                             | Description of Activity    | %-38s |\n", reservation.activity);
            printf("                             |----------------------------+----------------------------------------|\n");
            printf("                             |    Extended Date and Time  | %-38s |\n", reservations[i].extensionDateTime);
            printf("                             +---------------------------------------------------------------------+\n");
            // Check if the reservation is completed or pending and display the status accordingly
            if (reservation.completed == 1) {
                printf("                             | Reservation Status         | %-38s |\n", "Completed");
            } else {
                printf("                             | Reservation Status         | %-38s |\n", "Pending");
            }
            printf("                             +----------------------------+----------------------------------------+\n");
            printf("\n");
        }
    }
	
	
    if (!found) {
        printf("\n                             NO RESERVATION FOUND FOR THE GIVEN ID NUMBER.\n");
    }
}

/*******************************************************************************

TO DO: allow users to cancel their reservations.

DESCRIPTION:  It prompts the user to enter the ID number of the reservation they want to cancel. 
              If the provided ID number matches an existing reservation, it displays the details 
			  of the reservation and asks for confirmation before canceling it. If the user confirms 
			  the cancellation, the function removes the reservation from the array of reservations and 
			  updates the totalReservations variable.

@param reservations: An array of Reservation structures representing the existing reservations.

@return: Does not return any value.
		 
*******************************************************************************/


// Function to cancel
void cancelReservation(struct Reservation reservations[]) {
    int goBackOption = 0; // This variable is not used in the current code

    // Display the header and cancel menu
    printf("\n");
    DisplayCancel();
    printf("\n\n\n");

    // Ask the user if they want to go back
    printf("\n                             DO YOU WANT TO GO BACK (Y/N): ");
    char backChoice;
    scanf(" %c", &backChoice);

    // If the user wants to go back, set the goBackOption flag and return from the function
    if (backChoice == 'y' || backChoice == 'Y') {
        goBackOption = 1;
        return; // Return 1 to indicate going back to the main menu
    }

    // Ask the user to enter the ID number of the reservation to cancel
    int reservationID;
    printf("\n                            Enter the ID number of the reservation to cancel: ");
    scanf("%d", &reservationID);
    getchar();

    // Variables to track if the reservation is found and its index
    int foundReservation = 0;
    int foundIndex = -1; // Initialize to -1 to indicate that the reservation is not found

    // Loop through all reservations to find the one with the given ID
    for (int i = 0; i < totalReservations; i++) {
        if (reservations[i].idNum == reservationID) {
            foundReservation = 1; // Set the flag to indicate that the reservation was found
            foundIndex = i; // Save the index where the reservation is found
            break; // We found the reservation, so we can break the loop
        }
    }

    if (foundReservation) {
        // Ask the user to enter the current date in the format "YYYY-MM-DD"
        char currentDate[11];
        printf("\n                             Enter the current date (YYYY-MM-DD): ");
        scanf("%10s", currentDate);

        // Extract the date components (year, month, and day) from the current date
        int currentYear, currentMonth, currentDay;
        sscanf(currentDate, "%4d-%2d-%2d", &currentYear, &currentMonth, &currentDay);

        // Extract the date components (year, month, and day) from the reservation date
        int reservationYear, reservationMonth, reservationDay;
        sscanf(reservations[foundIndex].dateTime, "%4d-%2d-%2d", &reservationYear, &reservationMonth, &reservationDay);

        // Compare the dates to prevent cancellation on the same day
        if (currentYear == reservationYear && currentMonth == reservationMonth && currentDay == reservationDay) {
            printf("\n                             CANNOT CANCEL RESERVATION ON THE SAME DAY AS THE RESERVATION DATE.\n");
            return;
        }
        // Print the details of the reservation to be canceled
        printf("                             +-------------------------+----------------------------------------+\n");
        printf("                             |      Reservation Number |     %-34s |\n", "Reservation Details");
        printf("                             +-------------------------+----------------------------------------+\n");
        printf("                             |             %-10d  |                                        |\n", foundIndex + 1);
        printf("                             |-------------------------+----------------------------------------|\n");
        printf("                             |       ID Number         | %-38d |\n", reservations[foundIndex].idNum);
        printf("                             |-------------------------+----------------------------------------|\n");
        printf("                             |       Full Name         | %-38s |\n", reservations[foundIndex].name);
        printf("                             |-------------------------+----------------------------------------|\n");
        printf("                             |    Year & Program       | %-38s |\n", reservations[foundIndex].yearprogram);
        printf("                             |-------------------------+----------------------------------------|\n");
        printf("                             |    Date and Time        | %-38s |\n", reservations[foundIndex].dateTime);
        printf("                             |-------------------------+----------------------------------------|\n");
        printf("                             |  Number of Participants | %-38d |\n", reservations[foundIndex].participants);
        printf("                             |-------------------------+----------------------------------------|\n");
        printf("                             |    Room to Reserve      | %-38s |\n", reservations[foundIndex].roomType);
        printf("                             |-------------------------+----------------------------------------|\n");
        printf("                             | Description of Activity | %-38s |\n", reservations[foundIndex].activity);
        printf("		             +-------------------------+----------------------------------------+\n");
 printf("                             |  Extended Date and Time | %-37s  |\n", reservations[foundIndex].extensionDateTime);
            printf("                             +------------------------------------------------------------------+\n");
        printf("\n");

        // Ask the user for confirmation to cancel the reservation
        printf("\n                             Are you sure you want to cancel this reservation? (Y/N): ");
        char choice;
        scanf(" %c", &choice);
        getchar();

        if (choice == 'Y' || choice == 'y') {
            // Move all reservations after the canceled one one index back in the array
            for (int j = foundIndex; j < totalReservations - 1; j++) {
                reservations[j] = reservations[j + 1];
            }

            // Reduce the total number of reservations by 1
            (totalReservations)--;

            printf("\n                             RESERVATION HAS BEEN SUCCESSFULLY CANCELED!\n");
        } else {
            printf("\n                             RESERVATION CANCELLATION ABORTED.\n");
        }
    } else {
        printf("\n                             RESERVATION NOT FOUND.\n");
    }
}

/* This program is a reservation system for a conference room.

The program has two modules:

* Admin module: The admin module allows the user to add rooms, display available rooms, mark reservations as complete, and delete rooms.
* User module: The user module allows the user to make a reservation, edit a reservation, cancel a reservation, display all reservations, and save all reservations to a file.

The program terminates when the user chooses option 3 from the main menu.
*/

int main() {
	int goBackOption = 0;
    struct Reservation reservations[MAX_RESERVATIONS];
    struct Room rooms[MAX_RESERVATIONS];
    int numReservations = 0;
    int numRooms = 0;
    int menu;

    int userChoice;

    do {
        DisplayTitle();
        Menu();
        scanf("%d", &menu);

        /* This switch statement controls the flow of the program.

        The user can choose from three options:

        1: Admin module
        2: User module
        3: Exit the program
        */
        switch (menu) {
        
            case 1:
                // Admin module
                do {
                    DisplayAdmin();
                    adminModuleMenu();
                    scanf("%d", &menu);

                    /* This switch statement controls the flow of the admin module.

                    The admin can choose from five options:

                    1: Add a room
                    2: Display available rooms
                    3: Mark a reservation as complete
                    4: Delete a room
                    5: Go back to the main menu
                    */
                    switch (menu) {
                        case 1:
                            addRoom(rooms);
                            break;

                        case 2:
                            displayAvailable(rooms);
                            break;

                        case 3:
                            markReservation(reservations, &totalReservations);
                            break;

                        case 4:
                            deleteRoom(rooms);
                            break;

                        case 5:
                            break;

                        default:
                            printf("                            INVALID CHOICE. PLEASE TRY AGAIN!\n");
                    }
                } while (menu != 5);
                break;

            case 2:
                // User module
    
                do {
                    DisplayUser();
                    userModuleMenu();
                    scanf("%d", &userChoice);

                    /* This switch statement controls the flow of the user module.

                    The user can choose from six options:

                    1: Make a reservation
                    2: Edit a reservation
                    3: Cancel a reservation
                    4: Display all reservations
                    5: Save all reservations to a file
                    6: Go back to the main menu
                    */
                    switch (userChoice) {
                    	
                    	case 1:
                    		DisplayGuidelines();
                    		break;
                    	
                        case 2:
                            makeReservation(reservations, rooms);
                            break;

                        case 3:
                            editReservation(reservations, totalReservations);
                            break;

                        case 4:
                            cancelReservation(reservations);
                            break;

                        case 5:
                            displayReservation(reservations);
                            break;

                        case 6:
                            saveReservationsToFile(reservations,totalReservations);
                            break;

                        case 7:
                            break;

                        default:
                            printf("                            INVALID CHOICE. PLEASE TRY AGAIN!\n");
                    }
                } while (userChoice != 7);
                break;

            default:
                printf("                            INVALID CHOICE. PLEASE TRY AGAIN!\n");

        }
    } while (menu != 7);

    return 0;
}
