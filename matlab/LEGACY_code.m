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
%% ________________________________________________________________________
% Find numbers in range

r = [1, 10];
xRange = [5 2 1 -1 5 67 3];
ii = xRange >= r(1) & xRange <= r(2)
out = xRange;
out(~ii) = nan;

% Find a struct field
a.b.c = 1;
isfield(a.b,'c')