%% Cobble weight
clear all; clc
addpath(genpath('C:\Users\ccblack\Documents\Carson\Projects\IOD_activeRFID'))

%% _____Given_____
Pcob=2.75; %g/cm3
Wcob=1331; %g
Vcob=Wcob/Pcob; %g

Rplug=1.3335; %cm
Hplug=11.5; %cm
Vplug=pi*Rplug^2*Hplug; %cm3

Wlead1=310; %g
Plead=11.29; %g/cm3

Rtag1=1.425*2.54; %cm
Rtag2= 0.960*2.54; %cm
Htag=0.405*2.54; %cm
Vtag=(1/3)*pi*(Rtag1^2+Rtag1*Rtag2+Rtag2^2)*Htag; %cm3
Wtag=11; %g
Ptag=Wtag/Vtag; %g/cm3
% Ptag=Pcon;

% Concrete Rock
Wcon=1166.05; %g
% Pcon=2.4; %g/cm3 % -Incorrect
Pcon=(Wcon-Wtag-Wlead1)/(Vcob-Vplug-Vtag-(Wlead1/Plead))

method='Volume';

switch method
% _____Volume Method_____
    case 'Volume'        
        Vlead2=(Pcon*Vcob+(Ptag-Pcon)*Vtag-Wcob) / (Pcon-Plead);
        
        Wlead2=Vlead2*Plead

%  _____Weight Method_____
    case 'Weight'
        % incorrect implementation
%         disp('formula error')
%         Wplug=Vplug*Pcon
%         
%         Wfilledcobble=Wcob-Wplug-Wcon+Wlead1;
%         fprintf('Weight of filled concrete cobble with no lead: %.2fg\n',Wfilledcobble)
%         Vfilledlead=Wfilledcobble/Plead;
%         fprintf('Volume of that amount of lead: %.2fcm^3\n',Vfilledlead)
%         Wfilledconcrete=Vfilledlead*Pcon;
%         fprintf('Weight of %.2fcm^3 of concrete: %.2fg\n',Vfilledlead, Wfilledconcrete)

        % Trial 2
        % Diff in density  *  W original - concrete - plug + lead fill
        % incorrect ... accounting for weight of Wlead1 twice.
        Wlead2=((Plead/Pcon)*(Wcob-Wcon-(Vplug*Pcon)+Wlead1))-Wlead1/(Plead/Pcon-1)
end
%% Stats
fprintf('\n\n')

fprintf('Starting lead (%.fg) - new lead: %.2fg\n',Wlead1,Wlead1-Wlead2)

stat.a=Vtag*Ptag;
stat.b=Vtag*Pcon;

% fprintf('Weight removed by tag: %.2fg\n',stat.b-stat.a)
% fprintf('Difference in Weight of concrete vs cobble plug: %.2fg\n',-Vplug*Pcon+Vplug*Pcob)
% fprintf('Weight of plug (Cobble): %.2fg\n',Vplug*Pcob)

% fprintf('Sanity check: (Weight of stuff in cobble+weight of the rest of the concrete)/Volume of cobble should equal density of a normal cobble: %.2fg == %.2fg\n',...
%     (Wlead2+Wtag+Pcon*(Vcob-Vtag-Vlead2))/Vcob, Pcob)

fprintf('Density of void cobble == Density of normal cobble: %.2fg == %.2fg\n', (Pcon*(Vcob-Vplug-Vtag-(Wlead1/Plead))+Wtag+Wlead1)/Vcob, (Wcob-164)/Vcob)

%%
leaddiff=Wlead2-Wlead1
leadvolcon=(Wlead2-Wlead1)/Plead*Pcon

rockdiff=Vplug*Pcob-Vplug*Pcon

%%

% (Vplug/Vcob+1)*Vcob

% stat.a=(Vplug+Vtag)/Vcob;
% stat.b=(Vplug)/Vcob
% 
% stat.b/stat.a
