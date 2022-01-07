clear all
COM="COM4";

% Import tag list
fid = fopen('taglist.txt');
C = textscan(fid,'%s');
tagID = hex2dec(C{1});
fclose(fid);
num_tags=length(tagID);
clear C fid ans

% Configure Serial
Antenna=serialport(COM,9600);
configureTerminator(Antenna,93); % 93 ascii ]

% Read Serial
a=readline(Antenna);
a=a{1}(2:end);

% Interpret Serial & save data
[A,num_elements] = sscanf(a,'%2x%6x01',2); % parse hex to RSI & tag ID
disp(A)
index = A(2) - tagID(1) + 1; %matlab arrays are one based,not zero based
if num_elements==2 && index <= num_tags && index > 0
    disp('READ!')
end

%% Create Data folder and datalog

% Create data folder, specify filename & path
if ~isfolder('data') %check if data dir exists
    mkdir('data')
end
dtstr=datestr(datetime('now'),'mm-dd-yy'); %get current date
filename=['datalog','_',dtstr,'.txt'];
filename=convertCharsToStrings(filename); %convert to string
outpath=fullfile('data',filename);

% open datalog
[fid, msg]=fopen(outpath,'a');
if fid < 0
  error('Failed to open file "%s" because: "%s"', filename, msg);
end

% write datait
timestamp=datestr(datetime('now'),30); %'yyyymmddTHHMMSS' (ISO 8601)
output=[newline,timestamp];
writecount=fwrite(fid,output);

% close datalog
msg=fclose(fid);
if msg < 0
  error('Failed to close file "%s"', filename);
end
clear fid msg dtstr

%% Write table method

% Create data table
timestamp={datestr(datetime('now'),30)}; %'yyyymmddTHHMMSS' (ISO 8601);
tagID={nan};
RSI=tagID;
GPS=tagID;
heading=tagID;
flag=logical(0);
T=table(timestamp,tagID,RSI,GPS,heading,flag);

% write data table
timestamp=datestr(datetime('now'),30); %'yyyymmddTHHMMSS' (ISO 8601)
% [tagID,RSI]= 
GPS=nan;
heading=nan;
flag=logical(0);

%% Read data from datalog

% open datalog
fid = fopen(outpath,'r');
if fid < 0
  error('Failed to open file "%s" because: "%s"', filename, msg);
end

% read datalog
test=textscan(fid,'%s', 'Delimiter', '');
test=test{1};
test2=sscanf(test{end},'%8dT%6d',2)

%close datalog
msg=fclose(fid);
if msg < 0
  error('Failed to close file "%s"', filename);
end
clear fid msg dtstr