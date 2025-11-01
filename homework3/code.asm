.data
ARRAY:  .space 80

COUNT:  .space 80


.text
.globl main

main:
    #adresleri atama
    lui t0, %hi(ARRAY)
    addi t0, t0, %lo(ARRAY)
    lui a0, %hi(COUNT)
    addi a0, a0, %lo(COUNT)
    
    addi t2, zero, 0   # i = 0


    #0x00000000
    addi t1, x0, 0
    sw t1, 0(t0)

    # 0x00000001
    addi t1, x0, 1
    sw t1, 4(t0)

    # 0x00000200
    lui t1, 0x00000
    addi t1, t1, 0x200
    sw t1, 8(t0)

    #  0x00400000
    lui t1, 0x00400
    addi t1, t1, 0
    sw t1, 12(t0)

    #  0x80000000
    lui t1, 0x80000
    addi t1, t1, 0
    sw t1, 16(t0)

    #  0x51C06460
    lui t1, 0x51C06
    addi t1, t1, 0x460
    sw t1, 20(t0)

    #  0xDEC287D9
    lui t1, 0xDEC28
    addi t1, t1, 0x7D9    
    sw t1, 24(t0)

    #  0x6C896594
    lui t1, 0x6C896
    addi t1, t1, 0x594 
    sw t1, 28(t0)

    #  0x99999999
    lui t1, 0x9999A
    addi t1, t1, -0x667   
    sw t1, 32(t0)

    #  0xFFFFFFFF
    addi t1, zero, -1     
    sw t1, 36(t0)

    #  0x7FFFFFFF
    lui t1, 0x80000
    addi t1, t1, -1
    sw t1, 40(t0)

    # 0xFFFFFFFE
    addi t1, zero, -2
    sw t1, 44(t0)

    # 0xC7B52169
    lui t1, 0xC7B52
    addi t1, t1, 0x169   
    sw t1, 48(t0)

    # 0x8CEFF731
    lui t1, 0x8CEFF
    addi t1, t1, 0x731     
    sw t1, 52(t0)

    # 0xA550921E
    lui t1, 0xA5509
    addi t1, t1, 0x21E     
    sw t1, 56(t0)

    #  0x0DB01F33
    lui t1, 0x0DB02
    addi t1, t1, -0x0CD
    sw t1, 60(t0)

    #  0x24BB7B48
    lui t1, 0x24BB8
    addi t1, t1, -0x4B8     
    sw t1, 64(t0)

    #  0x98513914
    lui t1, 0x98514
    addi t1, t1, -0x6EC   
    sw t1, 68(t0)

    #  0xCD76ED30
    lui t1, 0xCD76F
    addi t1, t1, -0x2D0     
    sw t1, 72(t0)

    # 0xC0000003
    lui t1, 0xC0000
    addi t1, t1, 3        
    sw t1, 76(t0)

loopElemanlar:
    addi t3, zero, 0   #0 sayac
    addi t4, zero, 32  # bit sayacı
    slli t5, t2, 2     # ARRAY sayacı
    add t6, t0, t5    #kontrol edilecek eleman adresi
    lw a1, 0(t6)       #a1e elemanı yükler

loopBitler:
    andi a2, a1, 1     
    add t3, t3, a2    
    srli a1, a1, 1     
    addi t4, t4, -1    
    bne t4, zero, loopBitler
    
    add a3, a0, t5     
    sw t3, 0(a3)      
    addi t2, t2, 1     
    addi a4, zero, 20
    blt t2, a4, loopElemanlar
