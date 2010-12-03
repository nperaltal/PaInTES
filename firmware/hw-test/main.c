#include "soc-hw.h"

//para uso del mouse
volatile uint8_t *p;
volatile unsigned char flag;
//para uso del LCD
int xprima;
char data_ant1=0, data_ant2=0, data_ant3=0, data_ant4=0;



ps2_t   *ps2  = (ps2_t *)       0xF0020000;
LCD_t   *LCD = (LCD_t *)  	0xF0010000;
uart_t  *uart0  = (uart_t *)    0xF0000000;

//********PS/2 RECEPCION********
void irq_handler(uint32_t irq){
	flag=1;
	*p = ps2->rx;
return;
}

//********PS/2 TRANSMISION********
void ps2_tx (char c)
{
	while (ps2->ucr & PS2_BUSY) ;
	ps2->tx = c;
	
return;
}


//********CONVERSION DE POSICIONES EN DIRECCIONES DEL ESPACIO DE DIBUJO********
int conversion(char st2, char posX, char posY){
int temp;
switch(st2){
	case (0x00):  		//if((xprima+posX/4) <= ((xprima/320)*320+320)){ //sin signo
				temp=(xprima+posX/4)-((posY/4)*320);
				//temp=(xprima-((posY/4)*320));				
				if(temp>=0 && temp<=76799) xprima=temp;
				//}
			break; 
	case (0x10): 		posX=posX*(-1); 
				//if((xprima-posX/4) >= ((xprima/320)*320+1)){//x negativo y positivo
				temp=(xprima-posX/4)-((posY/4)*320);
				//temp=(xprima-((posY/4)*320));				
				if(temp>=0 && temp<=76799) xprima=temp;
				//}
			break; 
	case (0x20): 		posY=posY*(-1);
				//if((xprima+posX/4) <= ((xprima/320)*320+320)){//y negativo x positivo
				temp=(xprima+posX/4)+((posY/4)*320);
				//temp=(xprima+((posY/4)*(320)));				
				if(temp>=0 && temp<=76799) xprima=temp;
				//}
			 break; 
	case (0x30): 		posY=posY*(-1);posX=posX*(-1);
				//if((xprima-posX/4) >= ((xprima/320)*320+1)){//y negativo x negativo
				temp=(xprima-posX/4)+((posY/4)*320);
				//temp=(xprima+((posY/4)*(320)));				
				if(temp>=0 && temp<=76799) xprima=temp;
				//}
			 break; 
	default: break;
}
return xprima;
}

void initPuntero(){
xprima=76799;
return;
}



//********PINTAR BLANCO********
void pintarBlanco(char st2, char posX, char posY){
int addr;
char j;
	addr = conversion(st2,posX,posY);
	for(j=0;j<4;j++){
	if(addr>=0 && addr<=16383)   {  if(j==0){LCD->addr0=addr; LCD->DATA = 0x01;}
					if(j==1){LCD->addr0=addr+1;  LCD->DATA = 0x01;}
					if(j==2){LCD->addr0=addr-319;LCD->DATA = 0x01;}
					if(j==3){LCD->addr0=addr-320;LCD->DATA = 0x01;}
					}
	if(addr>16383 && addr<=32766) {  if(j==0){LCD->addr1=addr;   LCD->DATA =0x01;}
					if(j==1){LCD->addr1=addr+1;  LCD->DATA = 0x01;}
					if(j==2){LCD->addr1=addr-319;LCD->DATA = 0x01;}
					if(j==3){LCD->addr1=addr-320;LCD->DATA = 0x01;}
					}
	if(addr>32766 && addr<=49149) { if(j==0){LCD->addr2=addr;   LCD->DATA = 0x01;}
					if(j==1){LCD->addr2=addr+1;  LCD->DATA = 0x01;}
					if(j==2){LCD->addr2=addr-319;LCD->DATA = 0x01;}
					if(j==3){LCD->addr2=addr-320;LCD->DATA = 0x01;}
					}
	if(addr>49149 && addr<=65532) { if(j==0){LCD->addr3=addr;   LCD->DATA = 0x01;}
					if(j==1){LCD->addr3=addr+1;  LCD->DATA = 0x01;}
					if(j==2){LCD->addr3=addr-319;LCD->DATA = 0x01;}
					if(j==3){LCD->addr3=addr-320;LCD->DATA = 0x01;}
					}
	if(addr>65532 && addr<=76799) {if(j==0){LCD->addr4=addr; LCD->DATA = 0x01;}
					if(j==1){LCD->addr4=addr+1;  LCD->DATA = 0x01;}
					if(j==2){LCD->addr4=addr-319;LCD->DATA = 0x01;}
					if(j==3){LCD->addr4=addr-320;LCD->DATA = 0x01;}
					}
			}		
return;
}

//********PINTAR NEGRO***********
void pintarNegro(char st2, char posX, char posY){
int addr;
char j;
	addr= conversion(st2,posX,posY);
	for(j=0;j<4;j++){
	if(addr>=0 && addr<=16383)   {  if(j==0){LCD->addr0=addr; LCD->DATA = 0x00;}
					if(j==1){LCD->addr0=addr+1;  LCD->DATA = 0x00;}
					if(j==2){LCD->addr0=addr-319;LCD->DATA = 0x00;}
					if(j==3){LCD->addr0=addr-320;LCD->DATA = 0x00;}
					}
	if(addr>16383 && addr<=32766) {  if(j==0){LCD->addr1=addr;   LCD->DATA =0x00;}
					if(j==1){LCD->addr1=addr+1;  LCD->DATA = 0x00;}
					if(j==2){LCD->addr1=addr-319;LCD->DATA = 0x00;}
					if(j==3){LCD->addr1=addr-320;LCD->DATA = 0x00;}
					}
	if(addr>32766 && addr<=49149) { if(j==0){LCD->addr2=addr;   LCD->DATA = 0x00;}
					if(j==1){LCD->addr2=addr+1;  LCD->DATA = 0x00;}
					if(j==2){LCD->addr2=addr-319;LCD->DATA = 0x00;}
					if(j==3){LCD->addr2=addr-320;LCD->DATA = 0x00;}
					}
	if(addr>49149 && addr<=65532) { if(j==0){LCD->addr3=addr;   LCD->DATA = 0x00;}
					if(j==1){LCD->addr3=addr+1;  LCD->DATA = 0x00;}
					if(j==2){LCD->addr3=addr-319;LCD->DATA = 0x00;}
					if(j==3){LCD->addr3=addr-320;LCD->DATA = 0x00;}
					}
	if(addr>65532 && addr<=76799) {if(j==0){LCD->addr4=addr; LCD->DATA = 0x00;}
					if(j==1){LCD->addr4=addr+1;  LCD->DATA = 0x00;}
					if(j==2){LCD->addr4=addr-319;LCD->DATA = 0x00;}
					if(j==3){LCD->addr4=addr-320;LCD->DATA = 0x00;}
					}
			}		

return;
}

/********MOVER PUNTERO*******
void MoverPuntero(unsigned char st2, char posX, char posY){	
	Escritura();

	addr_ant = conversion(st2,posX,posY);

	data_ant1 = Lectura (addr_ant);
	data_ant2 = Lectura (addr_ant+1);
	data_ant3 = Lectura (addr_ant-319);
	data_ant4 = Lectura (addr_ant-320);
	
	pintar(addr_ant,0x00,0xFF);

return;
}*/
//********EVALUAR LA TRAMA DE 3 BYTES DEL MOUSE********
void mouse_status(char status, char posX, char posY)
{
char 	digit2, digit3;
	digit2 = (status & 0x30); //Evalua signos del bit de estatus
	digit3 = (status & 0x03); //Evalua el estado de los botones

switch(digit3) {		
		case (0x00): break;//MoverPuntero(digit2,posX,posY);break; 
		case (0x01): pintarNegro(digit2,posX,posY);break;
		case (0x02): pintarBlanco(digit2,posX,posY);break;// B
		default:  break;//D
		}

return;  
} 
//**********MAIN***********
int main(int argc, char **argv)
{	char j=0,i=0, byte_1=0,byte_2=0,byte_3=0,DoneFrame=0;
	flag=0;
	uart_putstr("iniciando \r\n");
	irq_enable();
	irq_set_mask( 0x00000004); 
	initPuntero();//inicializa el puntero en el medio de la pantalla
//Cada vez que se halla pulsado el Reset del SIE, el mouse se reseteará nuevamente y se habilitará el envío de datos	
	ps2_tx(0xFF);
	for(i=0;i<200;i++);//Un delay por si acaso
	ps2_tx(0xF4);
	for(i=0;i<100;i++);
	flag=0;i=0;


flag=0;i=0;

for(;j<1;){     while(!flag);
		switch(i){
			case 0: byte_1=*p;i++;break;
			case 1: byte_2=*p;i++;break;
			default: i=0; break;
			}
		if(i==2) {j=1;i=0;break;}
		flag=0;
	}


flag=0;i=0;
//Despues de la activación se reciben paquetes de 3 bytes
for(;;){	
		
		while(!flag);
		switch(i){
			case 0:  byte_1=*p;i++;break;
			case 1:  byte_2=*p;i++;break;
			case 2:  byte_3=*p;DoneFrame=1;break;
			default: byte_1=0;break;
		}
		if(DoneFrame){ DoneFrame=0;i=0;mouse_status(byte_1, byte_2, byte_3);} // put P
		flag=0;
	}

return 0;
}
