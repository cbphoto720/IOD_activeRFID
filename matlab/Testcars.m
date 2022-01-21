%% Initialize

clear all
COM="COM4";
addpath(genpath('C:\Users\ccblack\Documents\Carson\IOD_activeRFID'))
pause(0.05)
%% 
% Import tag list
[fid, msg]=fopen('taglist.txt','r');
if fid < 0
    error('Failed to open file "%s" because: "%s"', filename, msg);
end
C = textscan(fid,'%s');
tagIDlist = hex2dec(C{1});
fclose(fid);
num_tags=length(tagIDlist);
clear C fid ans

% Configure Serial
Antenna=serialport(COM,9600);
configureTerminator(Antenna,93); % 93 ascii = ']'
% Antenna.BytesAvailableFcn

%% Read Serial _/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_/\
[tagID,RSSI] = readARFID(Antenna,tagIDlist, num_tags)

%% Create Data folder and datalog _/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_/\

% Create data folder, specify filename & path
if ~isfolder('data') %check if data dir exists
    mkdir('data')
end
dtstr=datestr(datetime('now'),'mm-dd-yy'); %get current date
filename=['datalog','_',dtstr,'.txt'];
filename=convertCharsToStrings(filename); %convert to string
outpath=fullfile('data',filename);

% create datalog
if ~isfile(outpath) % check if file does not exist
    [fid, msg]=fopen(outpath,'w');
    if fid < 0
        error('Failed to open file "%s" because: "%s"', filename, msg);
    end
    writecount=fwrite(fid,'timestamp,tagID,RSSI'); %write headers
else % open file if it exists
    [fid, msg]=fopen(outpath,'a');
    if fid < 0
      error('Failed to open file "%s" because: "%s"', filename, msg);
    end
end

% write data
timestamp=datestr(datetime('now'),30); %'yyyymmddTHHMMSS' (ISO 8601)
[tagID,RSSI] = readARFID(Antenna,tagIDlist, num_tags);
output=[newline,timestamp,',',sprintf('%d',tagID),',',sprintf('%d',RSSI)];
writecount=fwrite(fid,output);

% close datalog
msg=fclose(fid);
if msg < 0
  error('Failed to close file "%s"', filename);
end
clear msg dtstr

%% Speed test _/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_/\

% open datalog
[fid, msg]=fopen(outpath,'a');
if fid < 0
  error('Failed to open file "%s" because: "%s"', filename, msg);
end

% write data loop
for i=1:100
    timestamp=datestr(datetime('now'),30); %'yyyymmddTHHMMSS' (ISO 8601)
    [tagID,RSSI] = readARFID(Antenna,tagIDlist, num_tags);
    output=[newline,timestamp,',',sprintf('%d',tagID),',',sprintf('%d',RSSI)];
    writecount=fwrite(fid,output);
end

% close datalog
msg=fclose(fid);
if msg < 0
  error('Failed to close file "%s"', filename);
end
% clear fid msg dtstr


%% Read data from datalog _/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_/

% open datalog
fid = fopen(outpath,'r');
if fid < 0
  error('Failed to open file "%s" because: "%s"', filename, msg);
end

% read datalog
test=textscan(fid,'%s', 'Delimiter', '');
test=test{1};
test2=sscanf(test{end},'%8dT%6d',2)
test3=textscan(test{end},'%s', 'Delimiter', ',');
test3=test3{1};
test4=readtable('datalog_01-11-22.txt');t

%close datalog
msg=fclose(fid);
if msg < 0
  error('Failed to close file "%s"', filename);
end
clear fid msg dtstr
%% Read a specific cobble _/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_/
close all;
i=27;
if i<=num_tags && i>0
    cobbleID=tagIDlist(i);
else
    error('Index out of bounds of tag list')
end
Returns=test4(ismember(test4.tagID,cobbleID),"RSSI");
histogram(Returns{:,:})

%% Mapping tests _/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_/\_/\
%% Load KML
importkml=kml2struct('MOPs_SD_County.kml');
iii=find(strcmp({importkml.Geometry}, 'Line')==1); % remove excess points

global MOPkml
MOPkml=importkml(iii);
clear importkml iii

global GPScord
GPScord=[32.927981236100734, -117.25985543852305];


% Initialize Timer moving callback

% fixed timer
% tmr=timer('ExecutionMode', 'FixedRate', 'Period', 1, ...
%     'TimerFcn', "CallbackGPS('','',0.001,'g','mop',[570,600]);")
% Speed timer
tmr=timer('ExecutionMode', 'fixedSpacing', ...
    'TimerFcn', "CallbackGPS('','',0.001,'g','mop',[570,600]);", ...
    'StopFcn',"disp('GPS timer stopped')")

start(tmr)
%% delete timer
%stop(timerfind) % stop all timers
stop(tmr)
delete(tmr)
clear tmr

%% Single callback map test
CallbackGPS('','',0.001,'g','mop',[570,600]);
% CallbackGPS('','',0.001,'g') % no mops

%% moving mapping tests
for i=1:100
    c=0.0001;
    GPScord(1)=GPScord(1)+c;
    pause(0.1)
end
clear i c

%% statistics
figure
subplot(211)
histogram(T)
mean(T)

subplot(212)
plot(T)
