function CallbackTimer(ser,~)
global RSSI;
global NUM_TAGS;
global CountFlag;
global count;
CountFlag = 0;
count = count + 1;
if (count == 10) %after ? seconds clear the array(for plotting)
    CountFlag = 1;
    count = 0;
end;
bar(RSSI);
title('Active RFID Tag RSSI Strength');
xlabel('Tag#');
ylabel('RSSI (dBm)');
grid on;
end