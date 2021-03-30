ONERRORREPORT:PRINT" @ "ERL:END
PRINT "Speculator Cheat Module maker"
PRINT "© Dave Lodge"
PROCinitialise
INPUT "Name of game";name$
INPUT "Name of author";author$
INPUT "Other info";other$
REPEAT
INPUT "# of cheats ";a
UNTIL a>0 AND a<13
FOR i=1 TO a
INPUT "Cheat Name";cheat$(i)
INPUT "Address";a$
addr(i)=EVAL(a$)
INPUT "Value";value(i)
NEXT
PROCassemble
SYS "OS_File",10,"Cheat",&FFA,,code%,O%
END

DEFPROCassemble
FOR pass=4 TO 6 STEP 2
P%=0:O%=code%
[OPT pass
                &0:&InitCode:&FinalCode:&0:&TitleString:&HelpString:&0:&0
.TitleString    :=name$+CHR$0
.HelpString     :=name$+CHR$9+"1.00 ("+MID$(TIME$,5,11)+") "+author$:align

.InitCode       stmfd   13!,{0-3,14}
                adr     1,modname
                mov     0,#&12
                swi     "XOS_Module"
                bvs     nomod
                add     4,4,#&4100
                str     4,base
                mov     0,#16
                adr     1,keyhandler
                mov     2,#0
                swi     "XOS_Claim"
                swi     "XOS_WriteS"
                ="Cheat for "+name$+" by "+author$+CHR$13+CHR$10
                ="This cheat allows you to do the following:"+CHR$13+CHR$10
]
FOR i=1 TO a
[OPT pass:      ="   F"+STR$i+"   "+cheat$(i)+CHR$13+CHR$10:]:NEXT
[OPTpass
                =other$:=0:align
                ldmfd   13!,{0-3,pc}^

.FinalCode      stmfd   13!,{0-3,14}
                mov     0,#16
                adr     1,keyhandler
                mov     2,#0
                swi     "XOS_Release"
                ldmfd   13!,{0-3,15}^

.nomod          ldmfd   13!,{0-3,14}
                adr     0,error
                orr     14,14,#&10000000
                mov     pc,14

.keyhandler     teq     0,#11
                teqeq   1,#1
                movnes  15,14
]
FOR i=1 TO a
[OPTpass:       teqeq   2,#i
                beq     routines+(i-1)*28
]:NEXT
[OPT pass:      mov     pc,14
.routines:]
FOR i=1 TO a
[OPTpass:       ldr     0,addrs+(i-1)*8
                ldr     1,base
                add     0,0,1
                ldr     1,addrs+(i-1)*8+4
                strb    1,[0],#1
                strb    1,[0]
                b       end
]:NEXT
[OPT pass
.end            mov     0,#11
                mov     1,#1
                movs    15,14

.addrs:]
FOR i=1 TO a
[OPT pass:      &addr(i)
                &value(i)
]:NEXT

[OPT pass

.base           :&0
.modname        :="Speculator":=0:align
.error          :&0
                :="Speculator Module not present":=0:align
]:NEXT
ENDPROC
:
DEFPROCinitialise
DIM cheat$(12)
DIM addr(12)
DIM value(12)
DIM code% 2000
name$="Spec Module"
author$="Fred"
other$=""
ENDPROC
