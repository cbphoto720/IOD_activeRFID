function [loncord,latcord] = MOPelementreducer(MOPkmlpath)
%convert a Mmop.kml into a single graphical element for speed
%plotting.
%{   
    Accomplished by inserting NaN values between line coordinates in order
    to complete independant lines into 1 graphic element to increase
    responsivness.

    Input:
        - MOPkmlpath - file path to MOP.kml

    Output:
        - Latcord - Latitude lines matrix seperated by NaN values
        - Loncord - Longitude lines matrix seperated by NaN values
%}
importkml=kml2struct(MOPkmlpath);
iii=strcmp({importkml.Geometry}, 'Line')==1; % remove excess points
MOPkml=importkml(iii);

% Convert struct to matrix for graphing
loncord=[MOPkml.Lon];
loncord=[loncord;nan(1,size(loncord,2))];
loncord=loncord(:);

latcord=[MOPkml.Lat];
latcord=[latcord;nan(1,size(latcord,2))];
latcord=latcord(:);
end