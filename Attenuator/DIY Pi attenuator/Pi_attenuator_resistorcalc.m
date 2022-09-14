%% Pi attenuator resistor calc
%{
    Maximize resistor usage overlap
%}

targets=[17.615,292.40; 37.352,150.48; 93.247,83.545; 394.65,56.734];

bank=[];


% parallel_formula = 1 / ( 1/R1 + 1/R2 + 1/R3 )

