#include <stdio.h>
#include <stdlib.h>
#include <termios.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/wait.h>
#include <netinet/in.h>
#include <wiringPi.h>

#define PIN_HALL 7
#define PIN_PIR 3

static int workInProgress = 0;
int fd;
short startH = 0;
short endH = 0;
char PIR  = 0;
char HALL = 0;

typedef struct message{
        char id;
        char number[11];
        char data[100];
} Message;

ssize_t writeCommand(char * message,char * waited,char tam);
int readAllResponse(char *output,char *waited,char tam);
void iniGSM(void);
void sendMessage(char *number, char *message);
int config_serial ( char *, speed_t );
void getNumber(char* number);
void readMessages(void);
Message getMessage(char *raw);
void deleteMessage(char id);
void deleteAllMessages(void);
void printMessage(Message m);
int processMessage(Message m);
void setUser(char * inst, char *ptr);
int isConfigured(void);
void setSchedule(char* inst);
void createFile(char* name, char* value);
void onHall(void);
void onPIR(void);
void takePicture(void);
void getSchedule(void );

int main(){

	fd = config_serial( "/dev/ttyACM0", B9600 );
	iniGSM(fd);
	deleteAllMessages(fd);
	while(!isConfigured()){
		readMessages(fd);
		sleep(1);
	}
    getSchedule();
	while(1){
        workInProgress = 1;
		readMessages(fd);
        workInProgress = 0;
		delay(2000);	
	}
}

int config_serial( char *dispositivo_serial, speed_t baudios ){
	struct termios newtermios;
  	int fd;
  	fd = open( dispositivo_serial, (O_RDWR | O_NOCTTY) & ~O_NONBLOCK );
	if( fd == -1 )
	{
		printf("Error al abrir el dispositivo tty \n");
		exit( EXIT_FAILURE );
  	}
	newtermios.c_cflag 	= CBAUD | CS8 | CLOCAL | CREAD;
  	newtermios.c_iflag 	= IGNPAR;
  	newtermios.c_oflag	= 0;
  	newtermios.c_lflag 	= TCIOFLUSH | ~ICANON;
  	newtermios.c_cc[VMIN]	= 1;
  	newtermios.c_cc[VTIME]	= 0;

  	if( cfsetospeed( &newtermios, baudios ) == -1 )
	{
		printf("Error al establecer velocidad de salida \n");
		exit( EXIT_FAILURE );
  	}
	if( cfsetispeed( &newtermios, baudios ) == -1 )
	{
		printf("Error al establecer velocidad de entrada \n" );
		exit( EXIT_FAILURE );
	}
	if( tcflush( fd, TCIFLUSH ) == -1 )
	{
		printf("Error al limpiar el buffer de entrada \n" );
		exit( EXIT_FAILURE );
	}
	if( tcflush( fd, TCOFLUSH ) == -1 )
	{
		printf("Error al limpiar el buffer de salida \n" );
		exit( EXIT_FAILURE );
	}
	if( tcsetattr( fd, TCSANOW, &newtermios ) == -1 )
	{
		printf("Error al establecer los parametros de la terminal \n" );
		exit( EXIT_FAILURE );
	}
	return fd;
}
void sendMessage(char *number, char *message){
	char salida[26];
	char number_cmd[26] = "AT+CMGS=\"+520000000000\"\r\n";
        memcpy(number_cmd + 12, number, 10);
	write(fd,"AT+CMGF=1\r\n",sizeof(char)*12);
	read(fd,salida,sizeof(char)*12);
	memset(salida,0,sizeof(char)*26);
	write(fd,number_cmd,sizeof(char)*26);
	read(fd,salida,sizeof(char)*26);
        memset(salida,0,sizeof(char)*26);
	write(fd,message,sizeof(char)*strlen(message));
        write(fd,"\r\n",sizeof(char)*2);
	read(fd,salida,sizeof(char)*26);
        memset(salida,0,sizeof(char)*26);
	int n = 26;
        write(fd,&n,sizeof(char));
        read(fd,salida,sizeof(char));
}
void iniGSM(){
	writeCommand("AT\r\n",fd, "OK\r\n",4);	
	writeCommand("ATE0\r\n",fd, "OK\r\n",6);	
}
ssize_t writeCommand(char * message,char * waited, char tam){
	char output[tam];
	memset(output,0,sizeof(char)*tam);
	ssize_t written;
	written = write(fd,message,sizeof(message) + 1);
	if(!readAllResponse(output,fd,waited,tam)){
		memset(output,0,sizeof(char)*tam);
		written = write(fd,message,sizeof(message) + 1);
	}
	return written;

}
int readAllResponse(char *output,char *waited,char tam){
	read(fd,output,sizeof(char)*tam);
	if(strstr(output, waited) != NULL) {
		return 1;	
	}
	if(strstr(output, "ERROR") != NULL) {
                return 0;
        }
}
void getNumber(char *number){
	FILE *arch;
	arch = fopen("number", "r");
	fgets(number, sizeof(int)*12, arch);
}
int isConfigured(){
	if( access( "name", F_OK ) != -1 ) 
		return 1;
	return 0;
}
void readMessages(){
	char raw_message[200] = "";
	write(fd,"AT+CMGF=1\r\n",sizeof(char)*12);
	write(fd,"AT+CPMS=\"ME\"\r\n",sizeof(char)*15);
	write(fd,"AT+CMGL=1\r\n",sizeof(char)*10);
	sleep(2);
	read(fd,raw_message,sizeof(char) * 200);
	Message m = getMessage(raw_message);
	if(m.id != '0'){
		deleteMessage(fd,'1');
		switch(processMessage(m)){
		case 1:
			sendMessage(fd, m.number, "Usuario Creado Correctamente");
			break;
		case 2:
			sendMessage(fd,m.number, "Capturando Fotografia");
			break;
		case 3:
			sendMessage(fd,m.number, "Horario Asignado");
			break;
		default:
			sendMessage(fd,m.number, "Comando Invalido"); 
			break;	
		}
	sleep(1);
	}
	memset(raw_message,0,sizeof(char)*100);			
}
Message getMessage(char *raw){
	Message m;
	char *ptr = strstr(raw, "+CMGL");
	if(ptr == NULL){
		m.id = '0';
		return m;
	}
	m.id =  *(ptr + 7);
	ptr = strstr(raw, "+52");
	strncpy(m.number, ptr + 3,10);
	m.number[10] = 0;
	ptr = strstr(raw, "Data:");
	int i = 0;
	while(1){
		m.data[i] = *(ptr + 5 + i);
		if(m.data[i] == '\n'){
			m.data[i] = 0;
			break;
		}
		i++;	
	}
	return  m;
}
void deleteMessage(char id){
	char delete_ins[] = "AT+CMGD=X\r\n";
	memcpy(delete_ins + 8, &id, 1);
	write(fd,delete_ins,sizeof(char)*12);
	read(fd,delete_ins,sizeof(char)*12);
}
void deleteAllMessages(){
        char delete_ins[] = "AT+CMGD=1,1\r\n";
        write(fd,delete_ins,sizeof(char)*14);
        read(fd,delete_ins,sizeof(char)*14);
}
void printMessage(Message m){
	printf("ID: %c\n",m.id);
	printf("Number: %s\n",m.number);
	printf("Data: %s\n",m.data);
}
int processMessage(Message m){
	char *ptr;
	if((ptr = strstr(m.data, "INIT"))!=NULL){
		setUser(m.data,ptr);
		createFile("number",m.number);
		return 1;
	}
	if((ptr = strstr(m.data, "PHOTO"))!=NULL){
		//llamada a python
                printf("PHOTO");
		return 2;
        }
	if((ptr = strstr(m.data, "SCHEDULE"))!=NULL){
		setSchedule(m.data);
                printf("SCHEDULE");
		return 3;
        }
        return 0;
}
void setSchedule(char* inst){
	char schedule [11];
	memcpy(schedule,inst + 8, sizeof(char)*10);
	schedule[10] = 0;
	createFile("schedule",schedule);
}
void setUser(char * inst, char *ptr){
	char name[30] =  "";
	char user[30] =  "";
	int i = 0;	
	ptr = ptr+4;
	while( *ptr != '&'){
		name[i++] = *ptr; 
		ptr++;
	}
	name[i] = 0;
	ptr++;
	i = 0;
	while( *ptr != '&'){
                user[i++] = *ptr;
                ptr++;
        }
        user[i] = 0;
	createFile("user",user);
	createFile("name",name);
}
void createFile(char* name, char* value){
        FILE *arch;
        arch = fopen(name,"w");
	fputs(value, arch);
	fclose(arch);
}
void onHall(void) {
    if(HALL){
        static int previousState = -1;
        if (!workInProgress) {
            int currentState = digitalRead(PIN_HALL);
            if (currentState != previousState) {
                previousState = currentState;
                if (currentState == LOW) {
                    char number[12];
                    getNumber(number);
                    sendMessage(char *number, "Presencia detectada con sensor HALL")
                    workInProgress = 1;
                    takePicture();
                    workInProgress = 0;
                }
            }
        }
    }
}
void onPIR(void) {
    if(PIR){
        static int previousState = -1;
        if (!workInProgress) {
            int currentState = digitalRead(PIN_PIR);
            if (currentState != previousState) {
                previousState = currentState;
                if (currentState == LOW) {
                    char number[12];
                    getNumber(number);
                    sendMessage(char *number, "Presencia detectada con sensor PIR")
                    workInProgress = 1;
                    takePicture();
                    workInProgress = 0;
                }
            }
        }
    }
}
void takePicture(void) {
	system("python3 take_picture.py");
}
void getSchedule(){
    char handle[4];
    FILE *arch;
	arch = fopen("schedule", "r");
	fgets(handle, sizeof(char)*5, arch);
    start = (int) strtol(handle, (char **)NULL, 10);
    fgets(handle, sizeof(char)*5, arch);
    endH = (int) strtol(handle, (char **)NULL, 10);
    fgets(handle, sizeof(char)*2, arch);
    PIR = (int) strtol(handle, (char **)NULL, 10);
    fgets(handle, sizeof(char)*2, arch);
    HALL = (int) strtol(handle, (char **)NULL, 10);
}