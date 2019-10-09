#include<wiringPi.h>
#include<stdio.h>
#include<stdlib.h>

//Header PIN 7
#define PIN_HALL 7

//Header PIN 15
#define PIN_PIR 3


void onHall(void);
void onPIR(void);
void takePicture(void);

static int workInProgress = 0;

int main(void) {
	wiringPiSetup();

	pinMode(PIN_HALL, INPUT);
	pinMode(PIN_PIR, INPUT);

	wiringPiISR(PIN_HALL, INT_EDGE_FALLING, &onHall);
	wiringPiISR(PIN_PIR, INT_EDGE_RISING, &onPIR);
	
	printf("Esperando por eventos\n");

	while(1) {
		delay(1000);
	}
}

void onHall(void) {
	static int previousState = -1;
	if (!workInProgress) {
		int currentState = digitalRead(PIN_HALL);
		if (currentState != previousState) {
			previousState = currentState;
			if (currentState == LOW) {
				printf("\nEfecto hall detectado\n");
				workInProgress = 1;
				takePicture();
				workInProgress = 0;
			}
		}
	}
}

void onPIR(void) {
	if (!workInProgress) {
		int currentState = digitalRead(PIN_PIR);
		if (currentState == HIGH) {
			printf("\nPresencia detectada\n");
			workInProgress = 1;
			takePicture();
			workInProgress = 0;
		}
	}
}

void takePicture(void) {
	FILE *takePicture;
	takePicture = fopen("take_picture", "w");
	fclose(takePicture);
	delay(2000);
}
