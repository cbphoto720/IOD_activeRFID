%% Cobble weight
clear all; clc

%% _____Given_____
Pcob=2.75; %g/cm3
Wcob=1331; %g

Pcon=2.3; %g/cm3
Wcon=1177; %g

Rplug=1.3335; %cm
Hplug=29.718; %cm

Wlead1=310; %g

%% _____Volume_____

Vcob=Wcob/Pcob %g
Vplug=pi*Rplug^2*Hplug %cm3

%% 
Wlead2=Wcob-Wcon+Vplug*Pcon-Wlead1 %g

Plead=11.29; %g/cm3

leadvoid=(Wlead1-Wlead2)/Plead %cm3

leadvoid*Pcon