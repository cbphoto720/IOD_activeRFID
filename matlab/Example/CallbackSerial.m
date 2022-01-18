function CallbackSerial(ser,~)
%Min RFID Tag#074A44 = 477764
%Max RFID Tag#074A61 = 477793
RSSI_OFFSET = 255;  %RSSI values are inverse to power
global RSSI;
global NUM_TAGS;
global CountFlag;
if (CountFlag == 1) %after x seconds clear the array(for plotting)
    RSSI = zeros(NUM_TAGS,1);
    CountFlag = 0;
end;
line = fscanf(ser);
[A,NumElements] = sscanf(line,'[%2x%6x01]',2);
disp(A);
Index = A(2) - 477764 + 1; %matlab arrays are one based,not zero based
if (Index <= NUM_TAGS && Index > 0)
    RSSI(Index) = RSSI_OFFSET - A(1);
end
end