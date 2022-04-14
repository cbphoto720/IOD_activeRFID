%% Read iG8 GPS datastream

%% Initialize

close all; clear all; clc
addpath(genpath('C:\Users\ccblack\Documents\Carson\Projects\IOD_activeRFID'))

%%
COM="COM1";
iG8=serialport(COM,115200);
configureTerminator(iG8,"CR");
%%
a=readline(iG8)

%% 
read(iG8,20,"char") 

%% Turn on callback
configureCallback(iG8,"terminator",@iG8CallbackSerial)
% iG8.BytesAvailableFcn={@iG8CallbackSerial}

%% Turn off callback
configureCallback(iG8,"off")

%% close COM port
clear iG8 COM

%% Parse data tests
data2=["$GPGGA,220055.00,3252.02728572,N,11715.11190040,W,1,20,0.7,51.133,M,-35.060,M,,*65";...
"$GPGGA,220056.00,3252.02728441,N,11715.11189917,W,1,20,0.7,51.145,M,-35.060,M,,*65";...
"$GPGGA,220057.00,3252.02728180,N,11715.11189732,W,1,20,0.7,51.159,M,-35.060,M,,*68";...
"$GPGGA,220058.00,3252.02727891,N,11715.11189503,W,1,20,0.7,51.173,M,-35.060,M,,*69";...
"$GPGGA,220059.00,3252.02727684,N,11715.11189372,W,1,20,0.7,51.185,M,-35.060,M,,*6B";...
"$GPGGA,220100.00,3252.02727495,N,11715.11189225,W,1,20,0.7,51.195,M,-35.060,M,,*66";...
"$GPGGA,220101.00,3252.02727332,N,11715.11189091,W,1,20,0.7,51.205,M,-35.060,M,,*6A";...
"$GPGGA,220102.00,3252.02727176,N,11715.11188947,W,1,20,0.7,51.215,M,-35.060,M,,*69";...
"$GPGGA,220103.00,3252.02727115,N,11715.11188874,W,1,20,0.7,51.221,M,-35.060,M,,*6B"];

scandata=data2(1,:);
scandata=convertStringsToChars(scandata);

% [A,NumElements,errmsg,nextindex] = sscanf(scandata,'$GPGGA,%6d.%2d,%6d.%8d,%c,');
[A,NumElements,errmsg,nextindex] = sscanf(scandata,'%[,]');
fprintf('A %d\n',A)
fprintf('errmsg %s\n',errmsg)
fprintf('nextindex %d\nrest of var %s\n',nextindex,scandata(nextindex:end))

%% easy mode
%WIP 04142022 - read out GPS variables and convert to usable numbers.  see
%GPGGA format as reference (in readme)

splitvar=strsplit(scandata,',')
if splitvar{1}=="$GPGGA"
    splitvar{2}
else
    % GPS read error
end

%% Functions
function iG8CallbackSerial(src,~)
    data = readline(src);
    disp(data)
end


% function readant(app,src,~,~)
%     a=readline(src);
%     a=a{1}(2:end);
%     
%     % Interpret Serial & output data
%     RSSI_OFFSET=255;
%     
%     [A,num_elements] = sscanf(a,'%2x%6x01',2); % parse hex to RSI & tag ID
%     index = A(2) - app.taglist(1) + 1; %matlab arrays are one based,not zero based
%     if num_elements==2 && index <= app.numtags && index > 0
%         app.RSSI(index)=RSSI_OFFSET-A(1);
%     end
% end