REM program to read all invaders passwords...
REM (C) Copyright 1995 David Lodge
@%=0

A%=OPENIN":0.$.!invasion.misc.invwave"
num=BGET#A%*256+BGET#A%
FOR i=0 TO num-1
PRINT CHR$9;i+1;CHR$9;
A$=""
FOR j=0 TO 9
A=BGET#A%
IF A<>223 A$+=CHR$(255-A)
NEXT
PRINT ;A$
PTR#A%=PTR#A%+134
NEXT
CLOSE#A%
