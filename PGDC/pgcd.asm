;==========================================================
; ASM Testcase
; flype, 2015-10-03, v1.0
; Greatest Common Divisor
; GCD(15,24)=3
;==========================================================

;==========================================================
; Constants
;==========================================================

ASSERT_ZERO EQU $00D0000C

;==========================================================
; MAIN()
;==========================================================
    
    BRA MAIN

RESULT DS.W 1

MAIN:
    CLR.L   D0             ; Value 1
    CLR.L   D1             ; Value 2
    CLR.L   D2             ; Precalc GCD
    CLR.L   D3             ; Precalc SQRT(GCD)
    CLR.L   D4             ; POW Exponent
    CLR.L   D5             ; Precalc POW(GCD)
    CLR.L   D6             ; Number of values processed
    CLR.L   D7             ; Error counter
    LEA.L   VALUES,A0
MAIN_LOOP:
    MOVE.L  (A0)+,D0       ; Value 1
    BEQ.W   MAIN_EXIT      ; Exit if no more value
    MOVE.L  (A0)+,D1       ; Value 2
    MOVE.L  (A0)+,D2       ; Precalc GCD
    MOVE.L  (A0)+,D3       ; Precalc SQRT(GCD)
    MOVE.L  (A0)+,D4       ; POW Exponent
    MOVE.L  (A0)+,D5       ; Precalc POW(GCD)
    ADDQ.L  #1,D6          ; Increment Number of values processed
    JSR     GCD            ; GCD(D0,D1)
    SUB.W   D1,D2          ; D2 = Precalc GCD - Calc
    MOVE.W  D1,RESULT      ; 
    BEQ     MAIN_ASSERT    ; Branch to Assert if D2 = 0
    ADDQ.L  #1,D7          ; Increment Error counter
MAIN_ASSERT:
    MOVE.L  D2,ASSERT_ZERO ; Assert D2 = 0
    MOVE.W  D1,D0
    JSR     SQRT           ; SQRT(D1)
    SUB.W   D2,D3          ; D3 = Precalc SQRT(GCD) - Calc
    MOVE.L  D3,ASSERT_ZERO ; Assert D3 = 0
    MOVE.W  RESULT,D0      ; 
    MOVE.W  D4,D1          ; 
    JSR     POW            ; POW(D0, D1)
    SUB.L   D7,D5          ; D5 = Precalc POW(GCD) - Calc
    MOVE.L  D5,ASSERT_ZERO ; Assert D5 = 0
    BRA     MAIN_LOOP      ; Continue
MAIN_EXIT:
    SUB.L   #200,D6        ; D6 - Number of values processed
    MOVE.L  D6,ASSERT_ZERO ; Assert D6 = 0
    MOVE.L  D7,ASSERT_ZERO ; Assert D7 = 0
    STOP    #-1            ; Stop on Sim

;==========================================================
; D1 = GCD(D0,D1)
;==========================================================

GCD:
    TST.W   D0
    BEQ     GCD_EXIT
    CMP.W   D1,D0
    BGT     GCD_SKIP
    EXG     D0,D1
GCD_SKIP:
    SUB.W   D1,D0
    BRA     GCD
GCD_EXIT:
    RTS

;===================================================
; D2 = SQRT(D0)
;===================================================

SQRT:
    CLR.L   D1             ; D1 = 0
    CLR.L   D2             ; D2 = 0
SQRT_LOOP:
    ADDI.L  #1,D2          ; D2 + 1
    MOVE.L  D2,D1          ; D1 = D2
    MULU.W  D1,D1          ; D1 * D1
    CMP.L   D0,D1          ; If D1 <= D0
    BLE     SQRT_LOOP      ; Then continue
    SUBI.L  #1,D2          ; D2 - 1
    RTS                    ; Exit SubRoutine

;===================================================
; D7 = POW(D0, D1)
;===================================================

POW:
    MOVEM.L D0-D3,-(SP) ; Save registers
    CLR.L   D2          ; D2 = 0
    CLR.L   D3          ; D3 = 0
    CLR.L   D7          ; D7 = 0
    CMPI.L  #0,D0       ; Test Number
    BEQ     POWX        ; If D0 = 0 Then Exit
    MOVE.L  #1,D7       ; D7 = 1
POWE:
    CMPI.L  #0,D1       ; Test Exponent
    BEQ     POWX        ; If D1 = 0 Then Exit
    SUBI.L  #1,D1       ; D1 = D1 - 1
    MOVE.L  D0,D2       ; D2 = D0
    MOVE.L  D7,D3       ; D3 = D7
POWN:
    CMPI.L  #1,D2       ; Test Number
    BEQ     POWE        ; If D2 = 1 Then branch to PowE
    SUBI.L  #1,D2       ; D2 = D2 - 1
    ADD.L   D3,D7       ; D7 = D7 + D3
    BRA     POWN        ; Branch to PowN
POWX:
    MOVEM.L (SP)+,D0-D3 ; Restore registers
    RTS                 ; Exit SubRoutine

;==========================================================
; Data Section
;==========================================================

VALUES:
    DC.L 316,790,158,12,3,3944312
    DC.L 963,535,107,10,2,11449
    DC.L 371,424,53,7,3,148877
    DC.L 966,759,69,8,2,4761
    DC.L 594,648,54,7,3,157464
    DC.L 287,984,41,6,2,1681
    DC.L 938,402,134,11,1,134
    DC.L 756,567,189,13,1,189
    DC.L 48,144,48,6,2,2304
    DC.L 989,645,43,6,1,43
    DC.L 82,820,82,9,2,6724
    DC.L 98,882,98,9,2,9604
    DC.L 182,546,182,13,2,33124
    DC.L 389,778,389,19,2,151321
    DC.L 685,411,137,11,2,18769
    DC.L 98,637,49,7,2,2401
    DC.L 240,192,48,6,3,110592
    DC.L 800,720,80,8,2,6400
    DC.L 904,678,226,15,1,226
    DC.L 234,780,78,8,3,474552
    DC.L 972,567,81,9,1,81
    DC.L 950,285,95,9,3,857375
    DC.L 795,530,265,16,3,18609625
    DC.L 840,392,56,7,2,3136
    DC.L 129,344,43,6,3,79507
    DC.L 705,987,141,11,3,2803221
    DC.L 847,242,121,11,1,121
    DC.L 963,642,321,17,3,33076161
    DC.L 168,336,168,12,1,168
    DC.L 891,729,81,9,2,6561
    DC.L 427,793,61,7,3,226981
    DC.L 540,360,180,13,3,5832000
    DC.L 944,649,59,7,2,3481
    DC.L 573,955,191,13,3,6967871
    DC.L 528,484,44,6,3,85184
    DC.L 181,543,181,13,1,181
    DC.L 836,924,44,6,2,1936
    DC.L 624,912,48,6,1,48
    DC.L 780,104,52,7,1,52
    DC.L 224,448,224,14,3,11239424
    DC.L 572,792,44,6,3,85184
    DC.L 210,490,70,8,2,4900
    DC.L 816,884,68,8,3,314432
    DC.L 783,174,87,9,1,87
    DC.L 132,660,132,11,2,17424
    DC.L 188,752,188,13,1,188
    DC.L 424,742,106,10,3,1191016
    DC.L 270,486,54,7,1,54
    DC.L 318,477,159,12,2,25281
    DC.L 392,896,56,7,2,3136
    DC.L 765,867,51,7,1,51
    DC.L 119,595,119,10,3,1685159
    DC.L 336,420,84,9,1,84
    DC.L 682,372,62,7,1,62
    DC.L 804,938,134,11,3,2406104
    DC.L 858,936,78,8,1,78
    DC.L 920,828,92,9,2,8464
    DC.L 315,270,45,6,3,91125
    DC.L 756,588,84,9,1,84
    DC.L 495,396,99,9,2,9801
    DC.L 318,212,106,10,3,1191016
    DC.L 760,912,152,12,2,23104
    DC.L 756,630,126,11,2,15876
    DC.L 343,980,49,7,3,117649
    DC.L 864,270,54,7,3,157464
    DC.L 242,605,121,11,1,121
    DC.L 793,732,61,7,3,226981
    DC.L 166,498,166,12,2,27556
    DC.L 605,484,121,11,2,14641
    DC.L 48,624,48,6,2,2304
    DC.L 728,224,56,7,2,3136
    DC.L 817,559,43,6,2,1849
    DC.L 63,693,63,7,1,63
    DC.L 468,702,234,15,1,234
    DC.L 740,555,185,13,1,185
    DC.L 759,345,69,8,2,4761
    DC.L 284,568,284,16,3,22906304
    DC.L 731,688,43,6,2,1849
    DC.L 420,630,210,14,2,44100
    DC.L 880,352,176,13,3,5451776
    DC.L 456,342,114,10,3,1481544
    DC.L 415,249,83,9,2,6889
    DC.L 572,88,44,6,3,85184
    DC.L 676,312,52,7,3,140608
    DC.L 368,920,184,13,3,6229504
    DC.L 294,966,42,6,2,1764
    DC.L 220,176,44,6,1,44
    DC.L 306,663,51,7,1,51
    DC.L 416,520,104,10,3,1124864
    DC.L 423,564,141,11,3,2803221
    DC.L 852,639,213,14,2,45369
    DC.L 561,102,51,7,2,2601
    DC.L 50,150,50,7,3,125000
    DC.L 282,423,141,11,1,141
    DC.L 988,936,52,7,2,2704
    DC.L 720,864,144,12,2,20736
    DC.L 804,670,134,11,1,134
    DC.L 55,935,55,7,1,55
    DC.L 329,188,47,6,2,2209
    DC.L 101,606,101,10,3,1030301
    DC.L 759,138,69,8,2,4761
    DC.L 230,184,46,6,3,97336
    DC.L 244,976,244,15,2,59536
    DC.L 96,912,48,6,3,110592
    DC.L 133,798,133,11,1,133
    DC.L 1000,350,50,7,2,2500
    DC.L 626,939,313,17,2,97969
    DC.L 810,945,135,11,2,18225
    DC.L 957,522,87,9,1,87
    DC.L 612,748,68,8,2,4624
    DC.L 468,676,52,7,2,2704
    DC.L 195,130,65,8,2,4225
    DC.L 558,837,279,16,1,279
    DC.L 700,770,70,8,2,4900
    DC.L 957,609,87,9,2,7569
    DC.L 495,198,99,9,2,9801
    DC.L 128,448,64,8,2,4096
    DC.L 833,539,49,7,1,49
    DC.L 984,451,41,6,3,68921
    DC.L 132,792,132,11,2,17424
    DC.L 65,715,65,8,3,274625
    DC.L 186,837,93,9,3,804357
    DC.L 952,168,56,7,3,175616
    DC.L 666,962,74,8,1,74
    DC.L 912,988,76,8,3,438976
    DC.L 420,560,140,11,2,19600
    DC.L 657,876,219,14,3,10503459
    DC.L 987,470,47,6,1,47
    DC.L 196,637,49,7,3,117649
    DC.L 779,861,41,6,2,1681
    DC.L 52,520,52,7,3,140608
    DC.L 560,392,56,7,3,175616
    DC.L 880,960,80,8,3,512000
    DC.L 981,436,109,10,2,11881
    DC.L 413,295,59,7,1,59
    DC.L 986,232,58,7,1,58
    DC.L 197,985,197,14,2,38809
    DC.L 322,460,46,6,3,97336
    DC.L 396,88,44,6,3,85184
    DC.L 425,340,85,9,2,7225
    DC.L 860,774,86,9,1,86
    DC.L 260,676,52,7,3,140608
    DC.L 462,528,66,8,3,287496
    DC.L 492,943,41,6,1,41
    DC.L 585,225,45,6,1,45
    DC.L 940,705,235,15,1,235
    DC.L 750,1000,250,15,2,62500
    DC.L 441,882,441,21,2,194481
    DC.L 330,660,330,18,3,35937000
    DC.L 602,215,43,6,3,79507
    DC.L 552,483,69,8,1,69
    DC.L 572,468,52,7,3,140608
    DC.L 635,762,127,11,1,127
    DC.L 61,366,61,7,1,61
    DC.L 588,336,84,9,2,7056
    DC.L 70,350,70,8,1,70
    DC.L 193,579,193,13,2,37249
    DC.L 512,384,128,11,3,2097152
    DC.L 240,160,80,8,3,512000
    DC.L 658,517,47,6,1,47
    DC.L 672,576,96,9,3,884736
    DC.L 665,570,95,9,2,9025
    DC.L 715,858,143,11,1,143
    DC.L 504,224,56,7,1,56
    DC.L 260,364,52,7,1,52
    DC.L 69,207,69,8,2,4761
    DC.L 512,384,128,11,3,2097152
    DC.L 144,432,144,12,3,2985984
    DC.L 432,336,48,6,1,48
    DC.L 316,948,316,17,2,99856
    DC.L 82,902,82,9,3,551368
    DC.L 293,879,293,17,2,85849
    DC.L 750,450,150,12,3,3375000
    DC.L 292,438,146,12,1,146
    DC.L 702,780,78,8,1,78
    DC.L 47,188,47,6,2,2209
    DC.L 572,858,286,16,3,23393656
    DC.L 207,552,69,8,1,69
    DC.L 994,852,142,11,1,142
    DC.L 406,116,58,7,3,195112
    DC.L 840,392,56,7,1,56
    DC.L 952,504,56,7,2,3136
    DC.L 819,189,63,7,3,250047
    DC.L 975,375,75,8,2,5625
    DC.L 440,748,44,6,3,85184
    DC.L 279,186,93,9,2,8649
    DC.L 196,882,98,9,2,9604
    DC.L 490,931,49,7,3,117649
    DC.L 226,791,113,10,2,12769
    DC.L 291,970,97,9,2,9409
    DC.L 935,385,55,7,3,166375
    DC.L 676,507,169,13,2,28561
    DC.L 962,296,74,8,1,74
    DC.L 50,550,50,7,3,125000
    DC.L 779,287,41,6,3,68921
    DC.L 212,371,53,7,2,2809
    DC.L 350,900,50,7,1,50
    DC.L 846,564,282,16,2,79524
    DC.L 258,774,258,16,2,66564
    DC.L 663,918,51,7,2,2601
    DC.L 0

;==========================================================
; End of file
;==========================================================
    
    END