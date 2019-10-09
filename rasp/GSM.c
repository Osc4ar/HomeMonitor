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

typedef struct message{
        char id;
        char number[11];
        char data[100];
} Message;

ssize_t writeCommand(char * message,int fd,char * waited,char tam);
int readAllResponse(char *output,int fd,char *waited,char tam);
void iniGSM(int fd);
void sendMessage(int fd,char *number, char *message);
int config_serial ( char *, speed_t );
void getNumber(char* number);
void readMessages( int fd );
Message getMessage(char *raw);
void deleteMessage(int fd, char id);
void deleteAllMessages(int fd);
void printMessage(Message m);
int processMessage(Message m);
void setUser(char * inst, char *ptr);
int isConfigured();
void setSchedule(char* inst);
void createFile(char* name, char* value);

int main()
{
	int fd_serie;
	char number[12];
	getNumber(number);
	fd_serie = config_serial( "/dev/ttyACM0", B9600 );
	iniGSM(fd_serie);
	deleteAllMessages(fd_serie);
	while(!isConfigured()){
		readMessages(fd_serie);
		sleep(1);
	}
	while(1){
		readMessages(fd_serie);
		sleep(1);
//		if(no cumple el horario){
//			continue;
//		}

//		Comienza a sensar.		
	}
}

int config_serial( char *dispositivo_serial, speed_t baudios )
{
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
void sendMessage(int fd,char *number, char *message){
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
void iniGSM(int fd){
	writeCommand("AT\r\n",fd, "OK\r\n",4);	
	writeCommand("ATE0\r\n",fd, "OK\r\n",6);	
}
ssize_t writeCommand(char * message,int fd,char * waited, char tam){
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
int readAllResponse(char *output,int fd,char *waited,char tam){
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
void readMessages(int fd){
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

void deleteMessage(int fd, char id){
	char delete_ins[] = "AT+CMGD=X\r\n";
	memcpy(delete_ins + 8, &id, 1);
	write(fd,delete_ins,sizeof(char)*12);
	read(fd,delete_ins,sizeof(char)*12);
}

void deleteAllMessages(int fd){
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
	createFile("horario",schedule);
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
	
