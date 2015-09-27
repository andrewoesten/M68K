;===========================
; Bcc test
; S C:\Users\FORMATION\Desktop\output12.txt 402718a8 40
;===========================

assert_zero EQU $00D0000C ; magical register

;===========================

start:
    clr.l   d0
    clr.l   d1
    clr.l   d2
    clr.l   d3
    clr.l   d6
    clr.l   d7
    lea     values,a0
    lea     buffer,a1
    lea     precalc,a6
label:
    move.l (a2,d2,label),d0
    move.l (a6,a3.w*4),d2
    move.l (a4,d5.l,[end-begin]),d5
    jsr    selftest
exit:
    stop    #-1

selftest:
    rts

;===========================

begin:  dc.l 0
end:    dc.l 0

;===========================

values:
    dc.b $11,$22,$33,$44
    dc.b $55,$66,$77,$88
    dc.b $11,$22,$33,$44
    dc.b $55,$66,$77,$88
    dc.b $11,$22,$33,$44
    dc.b $55,$66,$77,$88
    dc.b $11,$22,$33,$44
    dc.b $55,$66,$77,$88
    dc.b $11,$22,$33,$44
    dc.b $55,$66,$77,$88
    dc.b $11,$22,$33,$44
    dc.b $55,$66,$77,$88
    dc.b $11,$22,$33,$44
    dc.b $55,$66,$77,$88
    dc.b $11,$22,$33,$44
    dc.b $55,$66,$77,$88

buffer:
    ds.b 4*16

precalc:
    dc.b $12,$23,$34,$45
    dc.b $54,$65,$76,$89
    dc.b $12,$23,$34,$45
    dc.b $54,$65,$76,$89
    dc.b $12,$23,$34,$45
    dc.b $54,$65,$76,$89
    dc.b $12,$23,$34,$45
    dc.b $54,$65,$76,$89
    dc.b $12,$23,$34,$45
    dc.b $54,$65,$76,$89
    dc.b $12,$23,$34,$45
    dc.b $54,$65,$76,$89
    dc.b $12,$23,$34,$45
    dc.b $54,$65,$76,$89
    dc.b $12,$23,$34,$45
    dc.b $54,$65,$76,$89

;===========================
