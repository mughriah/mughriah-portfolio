#include <stdio.h>

void DisplayTitle(){
	
	printf("\n");
	printf("==============================================================================\n");
	printf("                               ROOM RESERVATION SYSTEM\n");
	printf("==============================================================================\n");
}

void Menu(){
	
	printf("\n");
	printf("                                      MENU\n");
	printf("\n");
	printf("                                1. Admin Module\n");
    printf("                                2. User Module\n");
    printf("                                3. Exit\n");
	printf("\n");
    printf("                               Enter your choice: ");	
}

void DisplayAdmin(){
	
	printf("\n");
	printf("==============================================================================\n");
	printf("                               ADMIN MODULE MENU\n");
	printf("==============================================================================\n");
}

void adminModuleMenu(){
	
	printf("\n");
	printf("                            1. Add Room\n");
    printf("                            2. Display Available Rooms\n");
    printf("                            3. Mark Reservation as Completed\n");
    printf("                            4. Delete Rooms\n");
    printf("                            5. Back\n");
    printf("\n");
    printf("                            Enter your choice: ");	
}

void DisplayUser(){
	
	printf("\n");
	printf("==============================================================================\n");
	printf("                               USER MODULE MENU\n");
	printf("==============================================================================\n");
}

void userModuleMenu(){
	
	printf("\n");
	printf("                            1. Guidelines in Reserving\n");
	printf("                            2. Make Reservation\n");
    printf("                            3. Edit Reservation\n");
    printf("                            4. Cancel Reservation\n");
    printf("                            5. Display Reservations\n");
    printf("                            6. Save to File\n");    
    printf("                            7. Back\n");
    printf("\n");
    printf("                            Enter your choice: ");	
}


void DisplayReservation(){
	
	printf("\n");
	printf("==============================================================================\n");
	printf("                               MAKE RESERVATION\n");
	printf("==============================================================================\n");
}

void Display(){
	
	printf("\n");
	printf("==============================================================================\n");
	printf("                               DISPLAY RESERVATION\n");
	printf("==============================================================================\n");
}


void DisplayEdit(){
	
	printf("\n");
	printf("==============================================================================\n");
	printf("                               EDIT RESERVATION\n");
	printf("==============================================================================\n");
}

void DisplayDetails(){
	
	printf("\n");
	printf("==============================================================================\n");
	printf("                             RESERVATION DETAILS\n");
	printf("==============================================================================\n");
	
}

void DisplayAddroom(){
	
	printf("\n");
	printf("==============================================================================\n");
	printf("                                  ADD ROOMS\n");
	printf("==============================================================================\n");
	
}

void DisplayDisplay(){
	
	printf("\n");
	printf("==============================================================================\n");
	printf("                               DISPLAY ADDED ROOMS\n");
	printf("==============================================================================\n");
	
}

void DisplayDelete(){
	
	printf("\n");
	printf("==============================================================================\n");
	printf("                               DISPLAY DELETE\n");
	printf("==============================================================================\n");
	
}

void DisplayReservations(){
	
	printf("\n");
	printf("==============================================================================\n");
	printf("                               MARK RESERVATION\n");
	printf("==============================================================================\n");
	
}

void DisplayCurrentReservation(){
	
	printf("\n\n");
	printf("+-------------------------+----------------------------------------+\n");
    printf("| FIELD                   | DETAILS                                |\n");
    printf("+-------------------------+----------------------------------------+\n");

}


void DisplayCancel(){
	
	printf("\n");
	printf("==============================================================================\n");
	printf("                               CANCEL RESERVATION\n");
	printf("==============================================================================\n");
}

void DisplayTimeSlot(){
	
	printf("                                          AVAILABLE TIME SLOTS:\n");
	printf("                             +-------------------+--------------------------+\n");
	printf("                             |        Day        |        Start Time        |\n");
	printf("                             +-------------------+--------------------------+\n");
	printf("                             |                   |    09:15 AM - 10:45 AM   |\n");
	printf("                             |                   |    11:00 AM - 12:30 PM   |\n");
	printf("                             |  Monday, Tuesday, |    12:45 PM - 14:15 PM   |\n");
	printf("                             | Thursday, Friday  |    14:30 PM - 16:00 PM   |\n");
	printf("                             |                   |    16:15 PM - 17:45 PM   |\n");
	printf("                             |                   |    18:00 PM - 19:00 PM   |\n");
	printf("                             +-------------------+--------------------------+\n");
	printf("                             |                   |    09:00 AM - 12:00 PM   |\n");
	printf("                             |    Wednesday,     |    13:00 PM - 16:00 PM   |\n");
	printf("                             |    Saturday       |    16:15 PM - 19:15 PM   |\n");
	printf("                             +-------------------+--------------------------+\n");
}

void DisplayGuidelines(){
	
	printf("n                             Here are the guidelines on Reserving a Room:\n");
	printf("\n                             1.) ID Number should be 8 digits.\n");
	printf("\n                             2.) Room and Capacity:\n");
	printf("                                                   > Classroom - 45\n");
	printf("                                                   > Seminar Room - 60\n");
	printf("                                                   >  Auditorium - 150\n");
	printf("                                                   > Training Room - 30\n");
	printf("\n                             3.) Timeslot Available: \n");
																 printf("\n"); 
	                                                             DisplayTimeSlot();
																 printf("\n");
																 printf("\n");                              
	printf("\n                             4.) There's only 1 timeslot per room.\n");
	printf("\n                             5.) Student can only have 3 pending reservations.\n");
	printf("\n                             6.) Building is closed on Sunday.\n");
	printf("\n                             7.) Time Extension must be consecutive from the original reservation time.\n");
	printf("\n                             8.) You can not cancel a reservation that is on the same day you reserved a room.\n");
}
