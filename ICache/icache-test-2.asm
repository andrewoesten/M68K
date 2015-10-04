;==========================================================
; ASM Testcase
; flype, 2015-10-04, v1.1
;==========================================================
; https://github.com/flype44/M68K/blob/master/ICache/icache-test-2.asm
;==========================================================
; 2015-10-04 21:17:50
; Apollo Core Version : 2626 to 2631
; One bug revealed in ICache.
; 21:17:50 BigGun Flype : your testcase 2 triggers a FAILURE in ICache.
; 21:18:17 BigGun Only problem is that it takes like 1 hour to sim 
; 21:27:29 BigGun If we find bug this is good. 
; 21:27:41 BigGun As soon as I see bug in sim - we can quickly fix it 
; 21:28:28 BigGun Flype : its good I another bug in SIM! 
; 21:28:41 BigGun I need to review this now
; 21:53:13 BigGun The testcase triggers a SIM-failure of the Icache and a Warning in CPU 
; 21:53:22 BigGun So two thinks for me to review and fix now 
; 21:53:37 BigGun I think tomorrow we have some new image 
;==========================================================

;==========================================================
    
    bra     Start

;==========================================================

size  equ 10    ; Number of bytes in routines
count equ $1987 ; Number of times we copy the routine

assert_zero equ $00D0000C

;==========================================================
; Copy Routine
; Input : A0 = Source Address
; Input : A1 = Destination Address
; Input : D0 = Source Size
; Input : D1 = Copy Count
;==========================================================

CopyRoutine:
    move.l  d1,d7
CopyRoutineLines:
    move.l  a0,a2
    move.l  d0,d6
CopyRoutineLine:
    move.b  (a2)+,(a1)+
    dbra    d6,CopyRoutineLine
    dbra    d7,CopyRoutineLines
    rts

;==========================================================
; Main Routine
;==========================================================

Start:
    move.l  #CodeAEnd,d0
    sub.l   #CodeABegin,d0
    move.l  #CodeBEnd,d0
    sub.l   #CodeBBegin,d0
    lea     OutsideRoutine1,a3
    lea     OutsideRoutine2,a4
    move.l  #size-1,d0
    move.l  #count-1,d1
    lea     CodeABegin,a0
    lea     CodeAHolder,a1
    jsr     CopyRoutine
    lea     CodeBBegin,a0
    lea     CodeBHolder,a1
    jsr     CopyRoutine
    clr.l   d0
    clr.l   d1
    clr.l   d5
    move.l  #%01010101010101010101010101,d2
    bra     CodeAHolder
InsideRoutine1:
    mulu.l  d0,d1:d2
    addq    #1,d5
    rts
InsideRoutine2:
    divu.l  d0,d1:d2
    addq    #1,d5
    rts
CodeAHolder:
    ds.b    (size*count)
CodeBHolder:
    ds.b    (size*count)
Exit:
    add.l   d1,d0
    add.l   d2,d0
    sub.l   #$d95a3d60,d0
    move.l  d0,assert_zero
    sub.l   #$00206198,d1
    move.l  d6,assert_zero
    sub.l   #$d9394ab0,d2
    move.l  d6,assert_zero
    sub.l   #$330e,d5
    move.l  d6,assert_zero
    sub.l   #$0000ffff,d6
    move.l  d6,assert_zero
    sub.l   #$0000ffff,d7
    move.l  d7,assert_zero
    stop    #-1

;==========================================================
    
    section .fastram

Spacer1:
    ds.b    $2000

CodeABegin:
    add.w   #502,d0
    addq    #8,d1
    nop
    jsr     (a4)
CodeAEnd

Spacer2:
    ds.b    $2000

CodeBBegin:
    addq    #7,d0
    addi.l  #302,d1
    jsr     (a3)
CodeBEnd

Spacer3:
    ds.b    $2000

OutsideRoutine1:
    add.w   #11,d0
    add.l   #22,d1
    addq    #7,d2
    subx    d2,d0
    jsr     InsideRoutine2
    rts

Spacer4:
    ds.b    $2000

OutsideRoutine2:
    subi.b  #1,d0
    subq    #2,d1
    addx    d1,d0
    sub.l   #3,d2
    jsr     InsideRoutine1
    rts

;==========================================================

    END   START

;==========================================================
