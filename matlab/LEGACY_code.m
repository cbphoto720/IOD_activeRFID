% Archived code

%% ________________________________________________________________________
%% Create table method

% Create data folder, specify filename & path
if ~isfolder('data') %check if data dir exists
    mkdir('data')
end
dtstr=datestr(datetime('now'),'mm-dd-yy'); %get current date
filename=['TABLEdatalog','_',dtstr,'.txt'];
filename=convertCharsToStrings(filename); %convert to string
outpath=fullfile('data',filename);

% Create data table
timestamp={datestr(datetime('now'),30)}; %'yyyymmddTHHMMSS' (ISO 8601);
tagID={nan};
RSI=tagID;
GPS=tagID;
heading=tagID;
flag=false;
T=table(timestamp,tagID,RSI,GPS,heading,flag);
writetable(T,outpath,'WriteRowNames',true) 
clear T

%% Write data to table method
% write data table
tic
for i=1:1000
    timestamp={datestr(datetime('now'),30)}; %'yyyymmddTHHMMSS' (ISO 8601)
    [tagID,RSSI] = readARFID(Antenna,tagIDlist, num_tags);
    GPS=nan;
    heading=nan;
    flag=true;
    T=table(timestamp,tagID,RSI,GPS,heading,flag);
    writetable(T,outpath,'WriteMode','Append',...
        'WriteVariableNames',false,'WriteRowNames',true)
    clear T
end
toc
% Elapsed time is 0.008306 seconds for a single write action
% fwrite is 10x faster at 0.000864 seconds.
% even using fopen,fwrite,fclose with safety check if 
% staments was 0.003235 s..  
% the speed discrepancy only increases when reading multiple lines of data

%% Mapping test
global GPScord


figure

% n=input('G or P: ','s')
n='g';
switch n
    case 'g' % Geomap
        t.g=tic;
        geoscatter(GPScord(1),GPScord(2),150,'blue','x','LineWidth',1);
        hold on
        geoscatter(GPScord(1),GPScord(2),250,'blue','o','LineWidth',1);

        geolimits(mapoffset.lat,mapoffset.lon)
        geobasemap topographic
        toc(t.g)
    case 'p' % fast plot
        t.p=tic;
        scatter(GPScord(2),GPScord(1),150,'blue','x','LineWidth',1);
        hold on
        scatter(GPScord(2),GPScord(1),250,'blue','o','LineWidth',1);

        ylim(mapoffset.lat)
        xlim(mapoffset.lon)
        toc(t.p)
end


% MOP code
moprange=[570:600];
switch n
    case 'g'
        hold on
        for i=moprange
            geoplot(MOPkml(i).Lat,MOPkml(i).Lon,'red')
        end
    case 'p'
        hold on
        for i=moprange
            plot(MOPkml(i).Lon,MOPkml(i).Lat,'red')
        end
end

clear n

%% geometry checker

Geometry='Linestring';
supported_geo={'Point' , 'Linestring' , 'Polygon' , 'MultiPoint' , ...
    'MultiLineString' , 'MultiPolygon' , 'MultiGeometry'};

strcmp(supported_geo,Geometry)

%% 'mop' varargin specify mop range
moprange=varargin{find(strcmp(varargin, 'mop')==1)+1};
        if isa(moprange,'double') && all(size(moprange)==[1,2]) %check for MOP range spec
        else
            msg=sprintf('optional argument ''mop'' must be followed by mop range [SMOP, NMOP]')
            error(msg)
        end
