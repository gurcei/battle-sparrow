    2 t=0:zt=0
    5 goto 50000:rem jump to start of progrm
   10 rem *** title screen ***
   20 bx%=15:sx%=10:print "{clr}";
   25 gosub 1900:o%=22:x%=24:y%=4:ch=$2000:cl=$4000:gosub 500
   26 o%=23:s%=0:x%=12:y%=11:gosub 400:o%=24:x%=30:y%=13:gosub 400
   27 ch=$1000:cl=$1800
   30 gosub 1800:rem clear screen buffer
   31 gosub 4000:rem draw bird
   32 sr=$2000+80:de=$1050:le=$780:tr%=32:gosub 50700:rem transparentdma
   34 sr=$4000+80:de=$1850:le=$780:tr%=0:gosub 50700:rem transparentdma
   40 for s%=0 to 4
   42 o%=20:x%=22+sin(t+s%*0.05)*20*sin(zt):y%=1+s%:gosub 400
   44 next s%
   50 for s%=0 to 4
   52 o%=21:x%=18-sin(t+s%*0.05)*15*sin(zt):y%=19+s%:gosub 400
   54 next s%
   60 gosub 1700:rem copy scrbuf to screen
   80 get a$:if a$<>"" then goto 110
   85 if joy(2) and 128 then goto 110
   87 gosub 61000
   90 if bx%=90 then bx%=-35:sx%=80
   95 t=t+0.05:zt=zt+0.01
  100 goto 30
  110 of%=0
  120 gs%=gs%+1
  130 return
  400 rem *** dma draw slither s% of o% at x%,y% ***
  410 p% = ob%(o%):bank 4
  420 w% = peek(p%):p%=p%+1
  430 dw% = w%+x%-1
  432 h% = peek(p%):p%=p%+1
  435 pc% = p%+h%*w%
  440 sr=p%+s%*w%:de=ch+y%*80+x%:le=w%:tr%=32:gosub 50700
  450 sr=pc%+s%*w%:de=cl+y%*80+x%:le=w%:tr%=0:gosub 50700
  460 return
  500 rem *** draw object o% at x% , y% (with crop and transparency) ***
  510 p% = ob%(o%):bank 4
  520 w% = peek(p%) : p%=p%+1
  525 dw% = w% + x% - 1
  530 h% = peek(p%) : p%=p%+1
  535 dh% = h% + y% - 1
  540 for dy% = y% to dh%
  550 if dy% < 0 then p%=p%+w%:goto 600
  560 for dx% = x% to dw%
  570 if dx% < 0 or dx% > 79 then p%=p%+1:goto 590
  575 bank 4:c% = peek(p%):p%=p%+1
  580 if c%<>32 then bank 4:poke ch + dx% + dy% * 80, c%
  590 next dx%
  600 next dy%
  610 rem now to the colours...
  620 for dy% = y% to dh%
  630 if dy% < 0 then p%=p%+w%:goto 690
  640 for dx% = x% to dw%
  650 if dx% < 0 or dx% >79 then p%=p%+1:goto 680
  660 bank 4:c% = peek(p%):p%=p%+1
  670 bank 4:oc% = peek(ch+dx%+dy%*80):if oc%<>32 then poke cl+dx%+dy%*80,c%
  680 next dx%
  690 next dy%
  695 return
  700 rem *** draw map of tiles ***
  710 for zy% = 0 to 19
  715 if zy%<0 or zy%> 19 then goto 920
  720 for zx% = 1 to 15
  725 gosub 61000
  730 o%=0:c$=mid$(lv$(zy%),zx%,1)
  740 if c$="L" then o%=1
  750 if c$="{SHIFT-@}" then o%=2
  760 if c$="O" then o%=3
  770 if c$="P" then o%=4
  780 if c$="{CBM-P}" then o%=5
  790 if c$="{CBM-T}" then o%=6
  800 if c$="{CBM-G}" then o%=7
  810 if c$="{CBM-M}" then o%=8
  820 if c$="K" then o%=9
  830 if c$="J" then o%=10
  840 if c$="I" then o%=11
  850 if c$="U" then o%=12
  860 if c$="x" then o%=13
  870 if c$="#" then o%=14
  880 if c$="." then o%=19
  900 if o%<>0 then x%=zx%*5:y%=zy%*5-of%:gosub 500
  904 rem print "{home}                                    ";
  905 rem print "{home}zx=";zx%;" zy=";zy%;" c$=";c$;"   ";
  907 rem getkey a$
  910 next zx%
  920 next zy%
  930 return
 1000 rem *** start level ***
 1010 ch=$2000:cl=$4000:ta%=0:tb%=0:tc%=0
 1011 px%=39:py%=21:pe%=10:sc=0:rem player pos, energy, score
 1012 fork=0to5:fx%(k)=0:fy%(k)=0:fv%(k)=0:nextk
 1013 fork=0to10:bx%(k)=0:by%(k)=0:bv%(k)=0:br%(k)=0:ba%(k)=0:bb%(k)=0:bc%(k)=0:nextk:rem reset baddies
 1015 gosub 1900:rem clear map
 1020 s$="loading level 1..."
 1030 print "{clr}";
 1040 x%=33:y%=11:gosub 1500
 1045 gosub 700:rem copy tiles into map
 1047 s$="level 1 ready!    "
 1048 x%=33:y%=11:gosub 1500
 1049 if joy(2) and 128 then goto 1060
 1050 get k$:if k$="" then pk=pk+1:goto 1048
 1060 foreground 1
 1070 gs%=gs%+1
 1075 of%=20*5
 1080 return
 1500 rem *** sub: print rainbow string(x%,y%,pk,s$) ***
 1510 cursor x%,y%
 1520 for k=1 to len(s$)
 1530 c$=mid$(s$,k,1)
 1540 foreground mod(k-1+pk,16)+16:print c$;
 1550 next k
 1560 for k=0 to (20-len(s$))*10:next k
 1570 return
 1700 rem *** dma copy from screen buffer to screen ***
 1710 dma 0, $7d0, $1050, 4, $0850, 0
 1720 dma 0, $7d0, $1850, 4, $f850, 1
 1730 return
 1800 rem *** dma clear screen buffer ***
 1810 dma 3, $7d0, 32, 0, $1000, 4
 1820 dma 3, $7d0, 0, 0, $1800, 4
 1830 return
 1900 rem *** dma clear map ***
 1910 dma 3, $2000, 32, 0, $2000, 4
 1920 dma 3, $2000, 0, 0, $4000, 4
 1930 return
 2000 rem *** draw lives/score/hiscore ***
 2010 print "{home}energy: {rvon}";
 2015 if sc>hi then hi=sc
 2020 for k%=1 to 10
 2030 if k%>pe% then print "{rvof}";
 2040 print " ";
 2050 next k%
 2060 print using "{rvof}  score: %5d";sc;
 2070 print using "  hiscore: %5d ";hi
 2080 return
 3000 rem *** draw background tiles ***
 3020 ex%=0:if of%<0 then ex%=-of%*80:if of%<-23 then return
 3025 xx%=0:if of%>15*5+1 then xx%=(of%-(15*5+1))*80
 3028 if xx%>=$780 then return
 3030 sr=$2000+80*of%+ex%:de=$1050+ex%:le=$780-ex%-xx%:tr%=32:gosub 50700:rem transparentdma
 3040 sr=$4000+80*of%+ex%:de=$1850+ex%:le=$780-ex%-xx%:tr%=0:gosub 50700:rem transparentdma
 3070 return
 4000 rem *** draw stars ***
 4005 bank 4
 4010 for k=0 to 10
 4020 poke $1000+ry%(k)*80+rx%(k),46
 4030 poke $1800+ry%(k)*80+rx%(k),1
 4040 ry%(k)=ry%(k)+rv%(k)
 4050 if ry%(k) > 24 then ry%(k) = ry%(k)-23:rx%(k)=int(rnd(1)*25)*3+1
 4060 next k
 4070 return
 5000 rem *** draw baddies ***
 5005 bank 4
 5010 fork=0to10
 5020 if bv%(k)=1 then begin
 5030 x%=bx%(k):y%=by%(k):o%=bt%(k):gosub5500
 5033 if bt%(k)=17 then by%(k)=by%(k)+1:ifby%(k)>24thenbv%(k)=0
 5034 if bt%(k)=16 then bx%(k)=bx%(k)+1:ifbx%(k)>79thenbv%(k)=0
 5035 if bt%(k)=15 then bx%(k)=bx%(k)-1:ifbx%(k)<-3thenbv%(k)=0
 5036 if (bt%(k)=15 or bt%(k)=16) and df%<>0 and rnd(1)>0.7 then begin:if py%>by%(k)thenby%(k)=by%(k)+1:else if py%<by%(k)thenby%(k)=by%(k)-1:bend
 5037 if bc%(k)=0 and bt%(k)<>17 and df%=1 and int(rnd(1)*8)=4 then bc%(k)=1:ba%(k)=bx%(k)+2:bb%(k)=by%(k)+3:bs%=mod(bs%+3,6):sound2+bs%,10000,10,1,8000,200,0
 5038 if bt%(k)=17 and df%<>0 and rnd(1)>0.5 then begin:if px%>bx%(k) then bx%(k)=bx%(k)+1:else if px%<bx%(k)then bx%(k)=bx%(k)-1:bend
 5040 bend
 5045 bank 4
 5050 ifbc%(k)=1thenbegin
 5060 poke$1000+bb%(k)*80+ba%(k),93
 5070 poke$1800+bb%(k)*80+ba%(k),5
 5075 bb%(k)=bb%(k)+1:if bb%(k)>24 then bc%(k)=0
 5080 bend
 5090 nextk
 5100 rem *** check if we've triggered the next wave? ***
 5101 fz%=of%:do while fz%<0:fz%=fz%+100:loop
 5102 if fz% = lo% then return:rem return if same as last offset
 5104 lo%=fz%
 5110 fork=0to6:rem check each wave
 5120   if wt%(k)=fz% then begin
 5140     forl=0to5:rem initialise baddies in wave
 5150       bt%(l)=wv%(k)
 5160       bp%(l)=0
 5170       if wv%(k)=15 then bx%(l)=80+l*9
 5171       if wv%(k)=16 then bx%(l)=0-l*9
 5180       by%(l)=4
 5182       if wv%(k)=17 then bx%(l)=int(rnd(1)*10)*7+5:by%(l)=-3 - int(rnd(1)*5)*5
 5190       bv%(l)=1
 5200       br%(l)=0
 5210       ba%(l)=0
 5220       bb%(l)=0
 5230       bc%(l)=0
 5240     next l
 5245     k=6
 5250   bend
 5260 nextk
 5270 return
 5500 rem *** dma-draw of baddies(x%,y%,o%) ***
 5510 p%=ob%(o%):bank4
 5520 w%=peek(p%):p%=p%+1
 5525 dw%=w%+x%-1
 5530 h%=peek(p%):p%=p%+1
 5535 dh%=h%+y%-1
 5537 p2%=p%+w%*h%
 5540 df%=1:ifx%>79ordw%<0ory%>24ordh%<0thendf%=0:return:rem completely off screen
 5541 le=w%:ix%=0:xx%=x%:ifxx%<0then xx%=0:ix%=xx%-x%:le=le-ix%:df%=2
 5542 ifdw%>79thenle=le-(dw%-79):dw%=79:df%=2
 5550 fory%=y%todh%
 5560 ify%>0andy%<25thenbegin
 5565 ic%=y%*80+xx%
 5570 sr=p%+ix%:de=$1000+ic%:tr%=32:gosub 50700
 5580 sr=p2%+ix%:de=$1800+ic%:tr%=0:gosub 50700
 5590 bend
 5600 p%=p%+w%:p2%=p2%+w%
 5610 nexty%
 5620 return
 6000 rem *** draw players ***
 6005 ch=$1000:cl=$1800
 6006 dw%=px%+3:dh%=py%+2:bank4
 6007 for y%=py% to dh%:for x%=px% to dw%
 6008 c=peek($1800+y%*80+x%):if c=6 then bs%=mod(bs%+3,6):gosub 6500:x%=dw%:y%=dh%
 6009 next x%:next y%
 6010 o%=18:x%=px%:y%=py%:gosub 5500
 6015 bank 4
 6020 fork=0to5
 6030 iffv%(k)then begin
 6035 ic%=fy%(k)*80+fx%(k)
 6040 poke $1000+ic%,30
 6045 if peek($1800+ic%)=6 then fv%(k)=0:gosub 6700:rem hit birdie
 6046 if peek($1800+ic%)=3 then fv%(k)=0:gosub 6800:rem hit turret
 6050 poke $1800+ic%,2
 6060 fy%(k)=fy%(k)-2
 6062 if fy%(k)=0 then fy%(k)=1:rem edge case nicety
 6064 if fy%(k)<=0 then fv%(k)=0
 6070 bend
 6080 next k
 6090 return
 6500 rem *** player was hit ***
 6510 bs%=mod(bs%+3,6)
 6520 sound3+bs%,4000,20,2,2000,500,3
 6530 pe%=pe%-1:if pe%=0 then gs%=6:rem game over
 6540 ta%=1:rem timer for player hit flashing
 6550 return
 6700 rem *** birdie was hit ***
 6710 ta%=1:rem timer for birdie hit flashing
 6712 sc=sc+800
 6715 sound 5,8000,5*(21-be%),1,5000,500,0
 6720 be%=be%-1
 6730 if be%=0 then gs%=7:rem win game!
 6740 return
 6800 rem *** turret was hit ***
 6805 bs%=mod(bs%+3,6):sound3+bs%,1000,20,1,500,20,3
 6807 sc=sc+500
 6810 rem figure out which turret from current fire
 6820 x%=fx%(k):y%=fy%(k)
 6830 tx%=x%/5:ty%=(of%+y%)/5
 6840 ch=$2000:cl=$4000
 6850 x%=tx%*5:y%=ty%*5
 6860 o%=14:gosub 500
 6900 return
 7000 rem *** draw birdie ***
 7010 if of%>0 then tm=0:be%=20:return
 7020 tm=tm+1
 7025 y%=5+sin(tm/10)*10
 7030 x%=mod(tm,146)-33:o%=22:gosub 5500
 7040 return
 8000 rem *** check input ***
 8010 get k$
 8015 v=joy(2):b=v and 128:v = v and 127
 8020 if v>=6 and v<=8 then px%=px%-2:if px%<0 then px%=0
 8030 if v>=2 and v<=4 then px%=px%+2:if px%>76 then px%=76
 8040 if v=1 or v=2 or v=8 then py%=py%-1:if py%<1 then py%=1
 8050 if v>=4 and v<=6 then py%=py%+1:if py%>21 then py%=21
 8060 if b=128 and pb=0 then begin:rem fire button
 8070   for k=0to5
 8080   if fv%(k)=0 then begin
 8090     fv%(k)=1:fx%(k)=px%+fi%:fy%(k)=py%-1:k=5
 8100     if fi%=0 then s%=1:else s%=4
 8110     sound s%,3000,10,1,1000,200,1
 8120     if fi%=0 then fi%=3:else fi%=0
 8130   bend
 8140   next k
 8150 bend
 8155 pb=b
 8160 return
 9000 rem *** check collisions ***
 9010 rem check player-fire hits enemy
 9020 for pi=0 to 5
 9030   if fv%(pi)=1 then begin
 9035     x%=fx%(pi):y%=fy%(pi)
 9040     for bi=0 to 5
 9050       if bv%(bi) = 1 then begin
 9060         x2%=bx%(bi):y2%=by%(bi)
 9070         if x%>=x2% and x%<=x2%+3 and y%>=y2% and y%<=y2%+2 then begin
 9075           fv%(pi)=0:ty%=bt%(bi)
 9080           if ty%=17 then bs%=mod(bs%+3,6):sound3+bs%,5000,10,1,3000,500,3:sc=sc+200
 9090           if ty%=15 or ty%=16 then bv%(bi)=0:bs%=mod(bs%+3,6):sound3+bs%,1000,20,1,500,20,3:sc=sc+200
 9100           bi=5
 9110         bend
 9120       bend
 9130     next bi
 9140   bend
 9150 next pi
 9170 rem check enemy-fire hits player
 9180 for bi=0 to 5
 9190   if bc%(bi)=1 then begin:rem baddie fire visible?
 9200     x%=ba%(bi):y%=bb%(bi)
 9210     if x%>=px% and x%<=px%+3 and y%>=py% and y%<=py%+2 then begin
 9220       bc%(bi)=0
 9230       gosub 6500:rem player hit
 9250     bend
 9260   bend
 9270 next bi
 9290 rem check if enemy body hit player
 9300 for bi=0 to 5
 9310   if bv%(bi)=1 then begin
 9320     x%=bx%(bi):y%=by%(bi)
 9330     if x%>=px%-3 and x%<=px%+3 and y%>=py%-2 and y%<=py%+2 then begin
 9340       gosub 6500:rem player hit
 9360     bend
 9370   bend
 9380 next bi
 9390 return
 10000 rem *** main game loop ***
 10010 gosub 2000:rem draw lives/score/hiscore
 10015 gosub 1800:rem clear scrbuf
 10020 gosub 4000:rem draw stars
 10030 gosub 3000:rem draw background tiles
 10040 gosub 5000:rem draw baddies
 10050 gosub 7000:rem draw birdie
 10060 gosub 6000:rem draw players
 10070 gosub 8000:rem check input
 10080 gosub 9000:rem check collisions
 10110 rem *** page flip ***
 10120 gosub 1700:rem copy scrbuf to screen
 10125 rem sleep 0.05
 10127 ff%=ff%+1:if ff%>12 then ff%=0:of%=of%-1
 10130 rem *** throttle game speed & poll music segment ***
 10140 t1=ti
 10145 gosub 61000
 10150 if (ti-t1) < 0.02 then gosub 61000:goto 10150
 10160 if ta%>0 then begin
 10170   bank 128:poke 53280,ta%+15
 10180   ta%=ta%+1
 10190   if ta%=16 then ta%=0:poke 53280,0
 10200 bend
 10210 return
 20000 rem *** game over ***
 20005 border 0
 20010 x%=37:y%=12:s$="game over":pk=0
 20020 sound 1,6000,50,1,2000,50,0
 20030 sound 4,6100,50,1,2100,50,0
 20040 gosub 1500
 20050 sleep 0.05
 20055 gosub 61000
 20060 pk=pk+1
 20070 if pk < 40 then goto 20040
 20080 gs%=2
 20090 return
 30000 rem *** win game ***
 30002 border 0
 30005 print "{clr}":zt=ti
 30010 x%=2:y%=12:s$="congratulations! you defeated battle sparrow and brought peace to the galaxy!":gosub 1500
 30020 if mod(pk,10)=0 then bs%=mod(bs%+3,6):sound3+bs%,6000+int(rnd(1)*3000),30,1,2000,100,0
 30030 pk=pk+1
 30035 gosub 61000
 30040 if ti-zt < 10 then goto 30010
 30045 gs%=2
 30050 return
 50000 gs%=1:rem 1=init,2=title,3=startlevel,4=maingame,5=endlevel,6=game over,7=win game
 50005 on gs% gosub 50100,10,1000,10000,15000,20000,30000
 50010 goto 50005
 50100 rem *** init game data ***
 50101 dim wv%(6):rem wave-type, 0=baddie1,1=baddie2,2=rocks,3=sparrow
 50102 wv%(0)=15:wv%(1)=17:wv%(2)=16:wv%(3)=17:wv%(4)=15:wv%(5)=17:wv%(6)=16
 50103 dim wt%(6):rem wave-time trigger
 50104 wt%(0)=90:wt%(1)=80:wt%(2)=70:wt%(3)=60:wt%(4)=50:wt%(5)=40:wt%(6)=20
 50105 bank 4:p = 0:dim lv$(20):gosub 60000
 50106 dim rx%(10):dim ry%(10):dim rv%(10):fork=0to10:rx%(k)=int(rnd(1)*25)*3+1:ry%(k)=rnd(1)*22+2:rv%(k)=rnd(1)*3+1:next k:rem stars
 50107 dim fx%(5),fy%(5),fv%(5):rem player fire x,y,visible
 50108 background 0:border 0
 50109 gosub 50500:rem init transparent dma struct
 50110 dim ob%(24):rem ptrs to object data
 50111 dim bt%(10):rem baddie type
 50112 dim bp%(10):rem baddie pattern type
 50113 dim bx%(10):rem baddie x
 50114 dim by%(10):rem baddie y
 50115 dim bv%(10):rem baddie visible
 50116 dim br%(10):rem baddie timer
 50117 dim ba%(10):rem baddie fire x
 50118 dim bb%(10):rem baddie fire y
 50119 dim bc%(10):rem baddie fire visible
 50120 for k = 1 to 24
 50125 ob%(k)=p
 50130 read w:poke p,w:p=p+1
 50135 read h:poke p,h:p=p+1
 50140 for d = 1 to w*h*2
 50150 read v: poke p, v: p=p+1
 50160 next d
 50170 next k
 50175 gs%=gs%+1
 50180 rem read level data
 50190 for k = 0 to 19
 50200 read lv$(k)
 50210 next k
 50220 return
 50500 rem *** init transparent dma struct ***
 50510 bank 4
 50520 poke $ff0,$07:rem opt = enable transparency
 50530 poke $ff1,$86:rem opt = set transparency
 50540 poke $ff2,$20:rem       (transparency value)
 50550 poke $ff3,$00:rem end of options
 50560 poke $ff4,$00:rem copy
 50565 pokew $ff5,$0000:rem length
 50570 pokew $ff7,$1000:rem source addr
 50580 poke $ff9,$04:rem source bank
 50590 pokew $ffa,$1000:rem dest addr
 50600 poke $ffc,$04:rem dest bank
 50610 poke $ffd,$00:rem cmd msb (ignore)
 50620 pokew $ffe,$0000:rem modulo (ignore)
 50630 return
 50700 rem *** do transparent dma(sr,de,le,tr%) ***
 50710 bank4
 50720 pokew$ff7,sr:rem source addr
 50730 pokew$ffa,de:rem dest addr
 50740 pokew$ff5,le:rem length
 50750 poke$ff2,tr%:rem transparency value
 50755 bank128
 50760 poke$d702,4:rem dma list in bank 4
 50770 poke$d701,$0f:rem dmalist msb
 50780 poke$d705,$f0:rem dmalist lsb
 50790 return
 51000 rem *** obj1 = tile bl ***
 51010 data 5,5:rem w,h
 51020 data 102,174,186,174,186,102,186,174,186,174,102,174,186,174,186,102,186,174,186,174,124,102,102,102,102
 51030 data 9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
 51040 rem *** obj2 = tile br ***
 51050 data 5,5
 51060 data 174,186,174,186,102,186,174,186,174,102,174,186,174,186,102,174,186,174,186,102,102,102,102,102,126
 51070 data 9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
 51080 rem *** obj3 = tile tl ***
 51090 data 5,5
 51100 data 108,102,102,102,102,102,186,174,186,174,102,174,186,174,186,102,186,174,186,174,102,174,186,174,186
 51110 data 9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
 51120 rem *** obj4 = tile tr ***
 51130 data 5,5
 51140 data 102,102,102,102,123,186,174,186,174,102,174,186,174,186,102,186,174,186,174,102,174,186,174,186,102
 51150 data 9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
 51160 rem *** obj5 = tile b ***
 51170 data 5,5
 51180 data 174,186,174,186,174,186,174,186,174,186,174,186,174,186,174,186,174,186,174,186,102,102,102,102,102
 51190 data 9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
 51200 rem *** obj6 = tile t ***
 51210 data 5,5
 51220 data 102,102,102,102,102,186,174,186,174,186,174,186,174,186,174,186,174,186,174,186,174,186,174,186,174
 51230 data 9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
 51240 rem *** obj7 = tile l ***
 51250 data 5,5
 51260 data 102,186,174,186,174,102,174,186,174,186,102,186,174,186,174,102,174,186,174,186,102,186,174,186,174
 51270 data 9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
 51280 rem *** obj8 = tile r ***
 51290 data 5,5
 51300 data 174,186,174,186,102,186,174,186,174,102,174,186,174,186,102,186,174,186,174,102,174,186,174,186,102
 51310 data 9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
 51320 rem *** obj9 = dia br ***
 51330 data 5,5
 51340 data 186,174,186,174,102,174,186,174,102,126,186,174,102,126,32,174,102,126,32,32,102,126,32,32,32
 51350 data 9,9,9,9,9,9,9,9,9,9,9,9,9,9,1,9,9,9,1,1,9,9,1,1,1
 51360 rem *** obj10 = dia bl ***
 51370 data 5,5
 51380 data 102,174,186,174,186,124,102,174,186,174,32,124,102,174,186,32,32,124,102,174,32,32,32,124,102
 51390 data 9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,1,9,9,9,1,1,1,9,9
 51400 rem *** obj11 = dia tr ***
 51410 data 5,5
 51420 data 102,123,32,32,32,174,102,123,32,32,186,174,102,123,32,174,186,174,102,123,186,174,186,174,102
 51430 data 9,9,1,1,1,9,9,9,1,1,9,9,9,9,1,9,9,9,9,9,9,9,9,9,9
 51440 rem *** obj12 = dia tl ***
 51450 data 5,5
 51460 data 32,32,32,108,102,32,32,108,102,174,32,108,102,174,186,108,102,174,186,174,102,174,186,174,186
 51470 data 1,9,9,9,9,1,1,9,9,9,1,9,9,9,9,9,9,9,9,9,9,9,9,9,9
 51480 rem *** obj13 = turret ***
 51490 data 5,5
 51500 data 160,105,120,95,160,105,233,194,223,95,117,195,219,195,118,223,95,194,105,233,160,223,98,233,160
 51510 data 5,5,5,5,5,5,3,3,3,5,5,3,3,3,5,5,3,3,3,5,5,5,5,5,5
 51520 rem *** obj14 = turret shot ***
 51530 data 5,5
 51540 data 160,236,120,251,160,160,108,102,123,160,97,102,32,102,225,160,124,102,126,160,160,252,98,254,160
 51550 data 5,5,5,5,5,5,12,12,12,5,5,12,0,12,5,5,12,12,12,5,5,5,5,5,5
 51560 rem *** obj15 = baddie1 ***
 51570 data 4,3
 51580 data 233,160,160,223,95,209,209,105,85,91,91,73
 51590 data 64,2,2,64,65,65,65,65,67,66,66,67
 51600 rem *** obj16 = baddie2 ***
 51610 data 4,3
 51620 data 107,42,42,115,124,91,91,126,78,66,66,77
 51630 data 76,76,76,76,78,78,78,78,68,67,67,68
 51640 rem *** obj17 = rock ***
 51650 data 4,3
 51660 data 108,174,160,123,230,230,174,160,124,230,230,126
 51670 data 1,15,12,11,1,15,12,11,1,15,12,11
 51680 rem *** obj18 = ship ***
 51690 data 4,3
 51700 data 30,233,223,30,233,195,195,223,105,105,95,95
 51710 data 2,73,74,2,72,73,74,6,72,73,74,75
 51720 rem *** obj19 = tile . ***
 51730 data 5,5
 51740 data 174,186,174,186,174,186,174,186,174,186,174,186,174,186,174,186,174,186,174,186,174,186,174,186,174
 51750 data 9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9
 51760 rem *** obj20 = 'battle' ***
 51770 data 34,5
 51780 data 233,160,160,160,160,32,233,160,160,160,223,32,233,160,160,160,105,32,233,160,160,160,105,32,233,32,32,32,32,233,160,160,160,105
 51790 data 160,32,32,233,160,32,160,105,32,233,160,32,32,32,160,32,32,32,32,32,160,32,32,32,160,32,32,32,32,160,32,32,32,32
 51800 data 160,160,160,160,195,32,160,160,160,160,160,32,32,32,160,32,32,32,32,32,160,32,32,32,160,32,32,32,32,160,160,105,32,32
 51810 data 160,32,32,233,160,32,160,105,32,233,160,32,32,32,160,32,32,32,32,32,160,32,32,32,160,32,32,32,32,160,32,32,32,32
 51820 data 160,160,160,160,105,32,105,32,32,160,105,32,32,32,105,32,32,32,32,32,105,32,32,233,160,160,160,105,233,160,160,160,105,32
 51830 data 64,64,64,64,64,66,64,64,64,64,64,66,64,64,64,64,64,66,64,64,64,64,64,66,64,66,66,66,66,64,64,64,64,64
 51840 data 65,66,66,65,65,66,65,65,66,65,65,66,66,66,65,66,66,66,66,66,65,66,66,66,65,66,66,66,66,65,66,66,66,66
 51850 data 66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66
 51860 data 67,0,0,67,67,0,67,67,0,67,67,0,0,0,67,0,0,0,0,0,67,0,0,0,67,0,0,0,0,67,0,0,0,0
 51870 data 1,1,1,1,1,0,1,0,0,1,1,0,0,0,1,0,0,0,0,0,1,0,0,1,1,1,1,1,1,1,1,1,1,0
 51880 rem *** obj21 = 'sparrow' ***
 51890 data 42,5
 51900 data 233,160,160,160,105,32,233,160,160,160,105,32,233,160,160,160,223,32,233,160,160,160,105,32,233,160,160,160,105,32,233,160,160
 51910 data 160,105,32,233,105,32,32,233,105,160,32,32,32,32,32,160,105,32,160,32,32,160,105,32,233,160,32,160,105,32,160,32,32,160,105,32
 51920 data 160,32,32,160,32,32,160,32,32,160,32,32,32,160,32,160,160,160,160,105,32,160,160,160,105,32,32,160,160,160,160,160,32,160,160
 51930 data 160,105,32,32,160,160,160,105,32,32,160,32,32,160,32,32,160,32,233,32,160,32,32,233,160,105,32,32,160,32,32,32,32,32,160,105,32
 51940 data 233,160,32,160,32,160,223,32,32,160,32,160,223,32,32,160,32,32,160,32,32,160,32,160,32,160,32,160,160,105,32,32,32,105,32,32,32
 51950 data 32,32,105,32,32,160,105,32,105,32,95,160,32,32,105,32,95,160,32,233,160,160,160,105,32,233,160,160,105,160,105,32
 51960 data 64,64,64,64,64,0,64,64,64,64,64,0,64,64,64,64,64,0,64,64,64,64,64,0,64,64,64,64,64,0,64,64,64,64,64,0,64,64,0,0,64,64
 51970 data 65,0,0,0,0,0,65,65,0,65,0,0,65,65,0,65,65,0,65,65,0,65,0,0,65,65,0,65,0,0,65,0,0,65,0,0,65,0,0,0,65,0
 51980 data 66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66
 51990 data 66,67,67,67,66,66,67,66,66,66,66,66,67,67,66,67,67,66,67,66,67,67,66,66,67,66,67,67,66,66,67,66,66,67,66,66,67,66,67,66,67,66
 52000 data 1,1,1,66,66,66,1,66,66,66,66,66,1,66,66,1,1,66,1,66,1,1,66,66,1,66,1,1,66,1,1,1,1,1,66,1,1,1,1,1,1,66
 52010 rem *** obj22 = bird ***
 52020 data 33,17
 52021 data 32,254,255,252,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,108,123,32,98,32,32,98,32,32
 52022 data 254,255,160,255,252,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,254,252,32,160,231,244,160,126,160,160,32,98
 52023 data 160,160,186,160,160,252,252,32,32,32,32,32,32,32,32,32,32,32,98,251,252,251,160,186,160,160,244,160,244,160,175,160,126
 52024 data 32,173,174,174,174,160,160,252,32,32,32,32,32,32,32,32,108,160,255,160,173,174,186,160,186,160,220,186,174,167,160,126,32
 52025 data 32,32,251,160,174,160,160,160,252,32,32,32,32,32,32,108,160,173,174,167,173,174,189,187,160,186,160,160,160,236,32,32,32
 52026 data 32,32,32,32,251,173,173,174,174,160,98,32,32,108,254,167,173,174,174,189,189,189,189,186,186,186,174,173,167,160,126,32,32
 52027 data 32,32,32,32,32,124,251,174,174,174,160,160,205,173,174,160,186,186,186,160,160,160,160,174,174,160,160,120,119,32,32,32,32
 52028 data 32,32,32,32,32,32,32,124,251,160,160,174,174,160,205,173,174,186,186,189,189,173,173,160,174,195,195,98,121,32,32,32,32
 52029 data 32,32,32,32,32,32,32,32,32,32,251,160,160,160,160,160,195,173,174,174,174,174,174,206,160,160,239,160,160,160,252,32,32
 52030 data 32,32,32,32,32,32,32,32,32,32,32,32,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,248,254,174,174,123,32
 52031 data 32,32,32,32,32,32,32,32,32,98,254,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,167,226,120,120,226,126
 52032 data 32,32,111,121,98,248,247,247,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,160,226,119,32,32,32,32,32,32
 52033 data 32,32,32,32,32,32,32,32,120,251,160,160,160,160,160,160,160,160,160,239,249,226,120,119,32,32,32,32,32,32,32,32,32
 52034 data 32,32,32,32,32,32,32,32,32,32,251,160,160,160,239,249,226,120,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32
 52035 data 32,32,32,32,32,32,32,32,32,32,32,124,226,167,195,239,247,248,123,32,32,32,32,32,32,32,32,32,32,32,32,32,32
 52036 data 32,32,32,32,32,32,32,32,32,32,32,32,32,32,160,123,32,32,251,123,32,32,32,32,32,32,32,32,32,32,32,32,32
 52037 data 32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,251,32,32,32,226,123,32,32,32,32,32,32,32,32,32,32,32,32
 52038 data 0,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,6,0,0,6,0,0
 52039 data 6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,6,6,6,6,6,6,6,0,6
 52040 data 6,6,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6
 52041 data 0,6,6,6,6,6,6,6,0,0,0,0,0,0,0,0,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,0
 52042 data 0,0,6,6,6,6,6,6,6,0,0,0,0,0,0,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,0,0,0
 52043 data 0,0,0,0,6,6,6,6,6,74,6,0,0,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,0,0
 52044 data 0,0,0,0,0,6,6,6,6,6,74,74,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,0,0,0,0
 52045 data 0,0,0,0,0,0,0,6,6,6,6,6,6,74,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,0,0,0,0
 52046 data 0,0,0,0,0,0,0,0,0,0,6,6,6,6,74,74,6,6,6,6,6,6,6,6,6,6,6,74,74,6,6,0,0
 52047 data 0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,6,74,74,74,74,74,6,6,74,74,74,6,6,6,74,6,6,0
 52048 data 0,0,0,0,0,0,0,0,0,6,6,6,6,6,74,74,74,74,74,74,74,74,74,74,74,74,6,6,6,6,6,6,6
 52049 data 0,0,6,6,6,6,6,6,6,6,74,74,74,74,74,74,74,74,74,74,74,74,6,6,6,6,6,0,0,0,0,0,0
 52050 data 0,0,0,0,0,0,0,0,6,6,6,74,74,74,74,74,6,6,6,6,6,6,6,6,0,0,0,0,0,0,0,0,0
 52051 data 0,0,0,0,0,0,0,0,0,0,6,6,6,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
 52052 data 0,0,0,0,0,0,0,0,0,0,0,6,6,6,6,6,6,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0
 52053 data 0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,0,0,6,6,0,0,0,0,0,0,0,0,0,0,0,0,0
 52054 data 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,0,0,0,6,6,0,0,0,0,0,0,0,0,0,0,0,0
 52060 rem *** obj23 = text1 ***
 52070 data 55,1
 52080 data 16,18,15,7,18,1,13,13,5,4,32,9,14,32,2,1,19,9,3,32,54,53,32,2,25,32,7,21,18,3,5,32,9,19,9,11,25,9,12,4,9,26,32,40,3,5,32,3,5
 52090 data 41,32,50,48,50,50
 52100 data 71,72,73,74,75,76,77,78,79,64,0,66,67,0,69,70,71,72,73,0,75,76,0,78,79,0,65,66,67,68,69,0,71,72,73,74,75,76,77,78,79,64
 52110 data 0,66,67,68,0,70,71,72,0,74,75,76,77
 52120 rem *** obj24 = text2 ***
 52130 data 23,1
 52140 data 16,18,5,19,19,32,1,14,25,32,11,5,25,32,20,15,32,2,5,7,9,14,33
 52150 data 71,72,73,74,75,0,77,78,79,0,65,66,67,0,69,70,0,72,73,74,75,76,77
 53000 rem *** level 1 ***
 53010 data " O{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}P UI  UI"
 53020 data " {CBM-G}x.{CBM-P}.x{CBM-M} JxIUxK"
 53030 data " J{CBM-P}K J{CBM-P}K  JxxK "
 53040 data "          UxxI "
 53050 data "  U{CBM-T}I    UxKJxI"
 53060 data "  {CBM-G}x{CBM-M}    JK  JK"
 53070 data "  {CBM-G}xxI         "
 53080 data "  J{CBM-P}xxI        "
 53090 data "    Jxx{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}{CBM-T}I"
 53100 data "     J.x.x.x.x{CBM-M}"
 53110 data "      J{CBM-P}{CBM-P}{CBM-P}{CBM-P}{CBM-P}{CBM-P}{CBM-P}K"
 53120 data "O{CBM-T}I            "
 53130 data "{CBM-G}..I   UIUIUIUI"
 53140 data "J.x.P  {CBM-G}.xxxx.{CBM-M}"
 53150 data " L.x.I JKJKJKJK"
 53160 data "  J.x.P        "
 53170 data "   L.x.I O{CBM-T}{CBM-T}{CBM-T}P "
 53180 data "    J{CBM-P}{CBM-P}{SHIFT-@} {CBM-G}x.x{CBM-M} "
 53190 data "         {CBM-G}.x.{CBM-M} "
 53200 data "         L{CBM-P}{CBM-P}{CBM-P}{SHIFT-@} "
 59999 rem *** init music strings ***
 60000 tt=0:envelope 8,1:vv=10
 60010 dim m$(5),m2$(5),b$(5)
 60020 dim mm(27):mm(0)=0:mm(1)=1:mm(2)=1:mm(3)=2:mm(4)=2:mm(5)=1:mm(6)=1:mm(7)=2:mm(8)=2:mm(9)=3:mm(10)=3:mm(11)=1:mm(12)=1:mm(13)=2:mm(14)=2:mm(15)=3:mm(16)=3
 60030 mm(17)=4:mm(18)=5:mm(19)=4:mm(20)=5:mm(21)=4:mm(22)=5:mm(23)=4:mm(24)=5:mm(25)=4:mm(26)=5
 60040 dim sp(27):rem val0=melody with 4 channel echo, val1=two melody with 2 channel echo
 60050 sp(9)=1:sp(10)=1:sp(15)=1:sp(16)=1:sp(17)=1:sp(18)=1:sp(19)=1:sp(20)=1:sp(21)=1:sp(22)=1:sp(23)=1:sp(24)=1:sp(25)=1:sp(26)=1
 60060 tempo 20
 60070 rem *** melody ***
 60080 m$(0)="t2 o4 m5 p0 q.gp5.a.#a.g#a o5d .#c o4.#a m7 h.a m5 iag#f#d
 60090 m$(0)=m$(0)+"o4 q.d .#f .a o5 .#d d c o4 p9 i#a g #a o5 d o4 #a o5 d w.g o6 w.g o3 .g"
 60100 m$(1)="t6m0 o4igdg#ag#ao5do4#ao5dq.g g#a q.a .e .#c o3 .a e #c"
 60110 m$(1)=m$(1)+"o4 ic o3go4c#dc#dg#dgo5q.c c #d .d .#f .a p0o6i#dd#dcd o5#aa"
 60120 m$(2)="t5o4ieo3bo4e#gb#a#go3bo4#g#feo3bo4eo3b#ge
 60130 m$(2)=m$(2)+"o4#g#d#gbo5#d#co4b#do5#co4b#a#db#a#g#a"
 60140 m$(2)=m$(2)+"io4#adf#ao5dco4#ado5f#ddo4do5#g#ff#f"
 60150 m$(2)=m$(2)+"io4g#dg#ao5#co4#ao5#ce#ae#de#c#do4b#a"
 60160 m$(3)="t2o4w#g hg{$a0}ie#deg w.#d"
 60170 m$(3)=m$(3)+"o4ib#abo5#co4w.#a"
 60180 m$(3)=m$(3)+"o5i#gg#g#a wg ire#de#c#do4b#a"
 60190 m$(4)="t2o5i#d#c#des#de#c#dio4b o5#co4bo5#c#ds#c#do4bo5#co4i#a b#abo5#co4sbo5#co4#abi#g sbo5#co4#ab i#gg#g#ab"
 60200 m$(4)=m$(4)+"t2o5i#d#c#des#de#c#dio4b o5#co4bo5#c#ds#c#do4bo5#co4i#a b#abo5#co4sbo5#co4#abi#g sbo5#co4#ab i#gg#g#ab"
 60210 m$(5)="t2o4 q#g#g gie qgge i#d qbb i#a#gg h#g i#deg "
 60220 m$(5)=m$(5)+"t2o4 q#g#g gie qgge i#d qbb i#a#gg h#g i#deg "
 60230 rem *** melody 2 ***
 60240 m2$(3)="t2o5qri#g#ab#a#g#a rgeg re#ce r#do4b#ab#a#grwr iro5e#de#co4b#arwr ir o5ge#co4#ag#dr wr"
 60250 m2$(4)="t3 so0cr cc cr cc o1 grgggr l"
 60260 m2$(5)="t3 so0cr cc cr cc o1 grgggr l"
 60270 rem *** bass line ***
 60280 b$(0)="t8 o1 m0 p1 w.g q #a o2 d w.#c q #c d o1 w.d q a #a h.g w.g .g qgggggg"
 60290 b$(1)="o1 t0 p0iggo2go1go2go1qggigo2go1go2go1go2g#a"
 60300 b$(1)=b$(1)+"o1aao2ao1ao2ao1qaaiao2ao1ao2ao1ao2ao1a
 60310 b$(1)=b$(1)+"o1cco2co1co2co1qccico2co1co2co1co2c#d"
 60320 b$(1)=b$(1)+"o1ddo2do1do2do1qdo2di#dcdo1#ao2co1a#a"
 60330 b$(2)="o1ieeo2eo1eo2eo1qeeo2ieo1eeo2eo1eo2g#g"
 60340 b$(2)=b$(2)+"o1i#g#go2#go1#go2#go1q#g#go2i#go1#g#go3#d#co2b#a"
 60350 b$(2)=b$(2)+"o1#a#ao2#ao1#ao2#ao1q#a#ao2i#ao1#a#ao2#ao1#ao3#cd"
 60360 b$(2)=b$(2)+"o2#d#do3#do2#do3#do2q#d#do3ie#c#do2bo3#co2#ab"
 60370 b$(3)="p3t0o2ieo1bo2e#gb#a#go1bo2#g#feo1bo2eo1b#ge
 60380 b$(3)=b$(3)+"o2#g#d#gbo3#d#co2b#do3#co2b#a#db#a#g#a"
 60390 b$(3)=b$(3)+"io2#adf#ao3dco2#ado3f#ddo2do3p6#gp3#ff#f"
 60400 b$(3)=b$(3)+"io2g#dg#ao3#co2#ao3#ce#ae#de#c#do2b#a"
 60410 b$(4)="o1q#g#go2i#go1q#gl"
 60420 b$(5)="o1q#g#go2i#go1q#gl"
 60422 return
 60999 rem *** poll for play of next music segment ***
 61000 if rplay(1) then return
 61005 ty=mm(tt):if tt=0 then vv=10
 61010 if tt>17 then vv=vv-1
 61020 vol vv,vv
 61030 if sp(tt) = 1 then play m$(ty),b$(ty),m2$(ty):sleep 0.05:play ,,,m$(ty),b$(ty),m2$(ty): goto 61060
 61040 play m$(ty),b$(ty):sleep 0.05:play ,,,m$(ty),b$(ty):sleep0.10:play ,,m$(ty):sleep0.15:play,,,,,m$(ty)
 61060 tt = mod(tt+1,27):return
