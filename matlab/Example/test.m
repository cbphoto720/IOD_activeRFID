clear all
global RSSI;
global NUM_TAGS;
global CountFlag;
global count;
RSSI = zeros(NUM_TAGS,1);
NUM_TAGS = 30;
count = 0;
fid = fopen('taglist.txt');
C = textscan(fid,'%s');
TagID = hex2dec(C{1});
fclose(fid);
SerialObj = serial('COM4');    % define serial port
SerialObj.BaudRate=9600;               % define baud rate
%SerialObj.TimerPeriod=0.1;
SerialObj.Terminator=']';
SerialObj.BytesAvailableFcn = {@CallbackSerial};
fopen(SerialObj);
tmr = timer('ExecutionMode', 'FixedRate', ...
    'Period', 1, ...
    'TimerFcn', {@CallbackTimer});
start(tmr);


%% stop everything
fclose(fid)
stop(timerfind) % stop all timers
delete(timerfind)
clear timerfind

clear SerialObj