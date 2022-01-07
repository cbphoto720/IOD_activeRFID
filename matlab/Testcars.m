clear all
COM="COM4";

% Import tag list
fid = fopen('taglist.txt');
C = textscan(fid,'%s');
tagID = hex2dec(C{1});
fclose(fid);
num_tags=length(tagID);
clear C fid ans

% Configure Serial & save location
Antenna=serialport(COM,9600);
configureTerminator(Antenna,93); % 93 ascii ]
% 1/6/22 Make data directory and save interpreted serial to it
% if [status,~]=mkdir('data')
% else
%     mkdir data
% end

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