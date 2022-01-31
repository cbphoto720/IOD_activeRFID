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
% serialportlist('all')

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
disp('done!')

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
% tic
% test=textscan(fid,'%s', 'Delimiter', '');
% test=test{1};
% toc
% 
% tic
% test_dateandtime=sscanf(test{end},'%8dT%6d',2); % Seperate date & time
% toc

% tic
% test_readline=textscan(test{end},'%s', 'Delimiter', ','); % read full line
% test_readline=test_readline{1};
% toc

% tic
% test2=readtable('datalog_01-11-22.txt'); % slower way to read data
% toc

% Example read:
tline = fgetl(fid);
headers = strsplit(tline, ',');     %a cell array of strings
datacell = textscan(fid, '%8dT%6d%f%f', 'Delimiter',',', 'CollectOutput', 1);
datavalues = datacell{1};    %as a numeric array

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
% importkml=kml2struct('MOPs_SD_County.kml');
% iii=strcmp({importkml.Geometry}, 'Line')==1; % remove excess points
% 
% global MOPkml
% MOPkml=importkml(iii);
% % clear importkml iii
% 
% % Convert struct to matrix for graphing
% global a
% global b
% a=[MOPkml.Lon];
% a=[a;nan(1,size(a,2))];
% a=a(:);
% 
% b=[MOPkml.Lat];
% b=[b;nan(1,size(b,2))];
% b=b(:);

%% Initialize MOP lines
global MOPlat
global MOPlon
[MOPlon,MOPlat]=MOPelementreducer('MOPs_SD_County.kml');

global GPScord
GPScord=[32.927981236100734, -117.25985543852305];

global snail
snail=GPScord;

%% Initialize Timer moving callback

% fixed timer (FASTER)
n='g'
switch n
    case 'g'
        tmr=timer('ExecutionMode', 'FixedRate', 'Period', 0.5, ...
            'TimerFcn', "CallbackGPS('','',0.001,'g','mop','snail');", ...
            'StopFcn',"disp('GPS timer stopped')",'ErrorFcn',"disp('GPS erorr!')")
    case 'p'
        tmr=timer('ExecutionMode', 'FixedRate', 'Period', 0.12, ...
            'TimerFcn', "CallbackGPS('','',0.001,'p','mop','snail');", ...
            'StopFcn',"disp('GPS timer stopped')",'ErrorFcn',"disp('GPS erorr!')")
end
%% Start timer func
start(tmr)

%% Stop timer
% stop(timerfind) % stop all timers
stop(tmr)

%% Delete timer(reset)
delete(tmr)
clear tmr

%% Single callback map test
CallbackGPS('','',0.001,'p','mop',[570,600]);
% CallbackGPS('','',0.001,'g') % no mops

%% moving mapping tests
switch n
    case 'g'
        for i=1:200
        c=0.000001;
        GPScord(1)=GPScord(1)-c;
        pause(0.01)
        end
        clear i c
    case 'p'
        for i=1:500
        c=0.000001;
        GPScord(1)=GPScord(1)-c;
        pause(0.01)
        end
        clear i c
end

%% Moving sample 2
t = timer('TimerFcn',"stat=false;disp('stopping!')",...
    'StartFcn',"disp('moving!')",'StartDelay',5);
start(t)

stat=true;
while(stat==true)
    c=0.0000005;
    GPScord(1)=GPScord(1)+c;
    c2=-1+2*rand();
    GPScord(2)=GPScord(2)-c*c2*3;
    pause(0.001)
end
clear i c stat
delete(t)

%% stop t
stop(t)

%% stop everything
stop(timerfind) % stop all timers
delete(t)
clear t tmr

%% statistics
figure
subplot(211)
histogram(T)
mean(T)

subplot(212)
plot(T)

%% Struct test
% cell2mat(struct2cell(MOPkml.Lon))
global a
global b
a=[MOPkml.Lon];
a=[a;nan(1,size(a,2))];
a=a(:);

b=[MOPkml.Lat];
b=[b;nan(1,size(b,2))];
b=b(:);

%% color 1 bar of historgram
n = [4,2,2,2,2,2,2,3,2,6,4,2,2,3];
h = histogram(n);
b = bar(2:6,h.Values);
b.FaceColor = 'flat';
b.CData(2,:) = [.5 0 .5];

%% add Scale bar to plot
% https://www.mathworks.com/matlabcentral/answers/151248-add-a-scale-bar-to-my-plot

% Create Data —
t = linspace(10,34);           % ‘t’ (ms)
y = [20+5*sin(2*pi*3*t/24)+2*randn(1,100);  60+5*cos(2*pi*3*t/24)+2*randn(1,100)];
figure(1)
plot(t, y)
hold on
plot([12; 12], [-40; -20], '-k',  [12; 22], [-40; -40], '-k', 'LineWidth', 2)
hold off
axis([[10  34]    -60  140])
text(11.8,-30, '10 mA', 'HorizontalAlignment','right')
text(17,-45, '10 ms', 'HorizontalAlignment','center')
set(gca, 'XTick', [10:2:34], 'XTickLabel',  {[] 12:2:32 []})    % Used temporarily to get the ‘text’ positions correct
% set(gca, 'Visible', 'off')

%% Handle Optional arguments with parameter-value pairs
% https://www.mathworks.com/matlabcentral/answers/164496-how-to-create-an-optional-input-parameter-with-special-name
% a solution I like for skipping functions with large inputs


% for optional arguments with small input size (or none at all) use strcmp:
% ii= strcmp(varargin, 'mop')==1
% if any(ii)
%   dataidx=varargin{find(ii)+1}
%   do stuff..
% end


%result
% myFunc('-param1', 10, '-param3', 30)

% function test_params(varargin)
%     % Defaults
%     param1 = 1;
%     param2 = 2;
%     param3 = 3;
%     
%     % Optionals
%     for ii = 1:2:nargin
%         if strcmp('-param1', varargin{ii})
%             param1 = varargin{ii+1};
%         elseif strcmp('-param2', varargin{ii})
%             param2 = varargin{ii+1};
%         elseif strcmp('-param3', varargin{ii})
%             param3 = varargin{ii+1};
%         end
%     end
%     
%     % Test!
%     disp(param1)
%     disp(param2)
%     disp(param3)
%     
%     % More stuff here
%     % ...
%     
% end

%% Lat/Lon to meters
global GPScord
GPScord=[32.927981236100734, -117.25985543852305]; %[Lat, Lon]

lat_m=111e3;
lon_m=111e3*cosd(GPScord(1));

mapoffset=0.001*3;

horziscale=mapoffset*2*lon_m
vertscale=mapoffset*2*lat_m

timerfactor=0.05;
walkspeed=1*timerfactor; % m/s
walkdistlat=walkspeed/lat_m
walkdistlon=walkspeed/lon_m

%% Write data test 2 - RSSI Matrix method

% Create data folder, specify filename & path
if ~isfolder('data') %check if data dir exists
    mkdir('data')
end
dtstr=datestr(datetime('now'),'mm-dd-yy'); %get current date
filename=['datalog2','_',dtstr,'.txt'];
filename=convertCharsToStrings(filename); %convert to string
outpath=fullfile('data',filename);

%open datalog
fid = fopen(outpath,'a');
if fid < 0
  error('Failed to open file "%s" because: "%s"', filename, msg);
end

% write data
RSSI=[100,80,40,30,nan,5,160];
output=[newline,sprintf(['[%d',repmat('t %d',[1,length(RSSI)-1]),']'],RSSI)];
output = regexprep(output, 't', char(9));
writecount=fwrite(fid,output);

% close datalog
msg=fclose(fid);
if msg < 0
  error('Failed to close file "%s"', filename);
end

%% Read data

fid = fopen(outpath,'r');
if fid < 0
  error('Failed to open file "%s" because: "%s"', filename, msg);
end

% Example read
tline = fgetl(fid);
headers = strsplit(tline, ',');     %a cell array of strings
% flag have delimiter be a space instead of tab to save a line of code.
% is this important though?  This works and is more clear
datacell = textscan(fid,['[',repmat('%d',[1,length(RSSI)]),']'], 'Delimiter','/t', 'CollectOutput', 1);
datavalues = datacell{1};    %as a numeric array

% close datalog
msg=fclose(fid);
if msg < 0
  error('Failed to close file "%s"', filename);
end

%%
cdfid = cdflib.open('example.cdf');

