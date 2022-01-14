#ifndef _IO_RW_H
#define _IO_RW_H

#include <inttypes.h>

#define io_read(base_addr, offset) \
   (*(volatile uint32_t *)((base_addr) + 4*(offset)))

#define io_write(base_addr, offset, data) \
   (*(volatile uint32_t *)((base_addr) + 4*(offset)) = (data))

#define get_slot_addr(base, slot) \
		((uint32_t)((base) + (slot)*8*4))

#endif
