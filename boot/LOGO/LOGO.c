#include <stdint.h>
#define PG_BASE 0x00060000
extern void idt_init();
extern void paging_enable();
extern void load_logo();
extern void load_kernel();
uint32_t *PG_address = (uint32_t*)0x00060000;
void paging_init(){
    for(int i=0;i<1024;i++){
        uint32_t *pte_address = (uint32_t*)(PG_BASE+(i+1)*0x1000);
        PG_address[i] = ((uint32_t)pte_address) | 0x3;
        for(int j=0;j<1024;j++){
            pte_address[j] = (i*0x400000 + j*0x1000) | 0x3;
        }
    }
    paging_enable();
}
void C(){
    idt_init();
    paging_init();
    load_logo();
    load_kernel();
}