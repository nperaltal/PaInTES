#ifndef SPIKEHW_H
#define SPIKEHW_H

#define PROMSTART 0x00000000
#define RAMSTART  0x00000800
#define RAMSIZE   0x400
#define RAMEND    (RAMSTART + RAMSIZE)

#define RAM_START 0x40000000
#define RAM_SIZE  0x04000000

#define FCPU      50000000

#define UART_RXBUFSIZE 32

/****************************************************************************
 * Types
 */
typedef unsigned int  uint32_t;    // 32 Bit
typedef signed   int   int32_t;    // 32 Bit

typedef unsigned char  uint8_t;    // 8 Bit
typedef signed   char   int8_t;    // 8 Bit

/****************************************************************************
 * Interrupt handling
 */
typedef void(*isr_ptr_t)(void);

void     irq_enable();
void     irq_disable();
void     irq_set_mask(uint32_t mask);
uint32_t irq_get_mak();

void     isr_init();
void     isr_register(int irq, isr_ptr_t isr);
void     isr_unregister(int irq);

/****************************************************************************
 * General Stuff
 */
void     halt();
void     jump(uint32_t addr);


/****************************************************************************
 * Timer
 */
#define TIMER_EN     0x08    // Enable Timer
#define TIMER_AR     0x04    // Auto-Reload
#define TIMER_IRQEN  0x02    // IRQ Enable
#define TIMER_TRIG   0x01    // Triggered (reset when writing to TCR)

typedef struct {
	volatile uint32_t tcr0;
	volatile uint32_t compare0;
	volatile uint32_t counter0;
	volatile uint32_t tcr1;
	volatile uint32_t compare1;
	volatile uint32_t counter1;
} timer_t;




/***************************************************************************
 * LCD0
 */
typedef struct {
	volatile uint32_t addr0;//0xF0010000 wr
	volatile uint32_t addr1;//0xF0010004 wr
	volatile uint32_t addr2;//0xF0010008 wr
	volatile uint32_t addr3;//0xF001000C wr
	volatile uint32_t addr4;//0xF0010010 wr
	volatile uint32_t DATA; //0xF0010014 wr
/*	volatile uint32_t data0; //0xF0010018 rd
	volatile uint32_t data1; //0xF001001C rd
	volatile uint32_t data2; //0xF0010020 rd
	volatile uint32_t data3; //0xF0010024 rd
	volatile uint32_t data4; //0xF0010028 rd*/
} LCD_t;

/***************************************************************************
 * UART0
 */
#define UART_DR   0x20                    // RX Data Ready //Rx available
#define UART_ERR  0x02                    // RX Error
#define UART_BUSY 0x10                    // TX Busy

typedef struct {
   volatile uint32_t ucr;
   volatile uint32_t rxtx;
} uart_t;

void uart_init();
void uart_putchar(char c);
void uart_putstr(char *str);
char uart_getchar();


/***************************************************************************
 * PS2
 */
#define PS2_DR    0x20                    // Rx available
#define PS2_BUSY  0x01                    // TX Busy
#define PS2_IRQ   0x10                    // IRQ

typedef struct {
   volatile uint32_t ucr;//0xF0020000
   volatile uint32_t rx; //0xF0020004
   volatile uint32_t tx; //0xF0020008
   volatile uint32_t bitcount;//0xF002000C
} ps2_t;

//void ps2_init();

/***************************************************************************
 * Pointer to actual components
 */
extern timer_t  *timer0;
extern uart_t   *uart0; 
extern uint32_t *sram0;
extern ps2_t 	*ps2; 
extern LCD_t 	*LCD; 
#endif // SPIKEHW_H
