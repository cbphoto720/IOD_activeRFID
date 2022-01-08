function [tagID,RSSI] = readARFID(Antenna,tagIDlist, num_tags)
%Read antenna values from com port to convert to RSI and tagID
    % antenna = serialport()
    % tagIDlist = list of active tag IDs
    % num_tags = length of tagIDlist
    
RSSI_OFFSET = 255;  %RSSI values are inverse to power

% Read Serial
a=readline(Antenna);
a=a{1}(2:end);

% Interpret Serial & save data
[A,num_elements] = sscanf(a,'%2x%6x01',2); % parse hex to RSI & tag ID
index = A(2) - tagIDlist(1) + 1; %matlab arrays are one based,not zero based
if num_elements==2 && index <= num_tags && index > 0
    RSSI=RSSI_OFFSET-A(1);
    tagID=A(2);
end
end