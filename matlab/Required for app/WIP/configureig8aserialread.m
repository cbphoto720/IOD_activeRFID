function iG8a_serialobj = configureig8aserialread(COMport)
%Configure an iG8a serial input to read GPS data in real-time

if any(strcmp(COMport,serialportlist('available'))) % Check that COM port is available
    iG8a_serialobj=serialport(COMport,115200);
    configureTerminator(iG8a_serialobj,"CR/LF");
    configureCallback(iG8a_serialobj,"terminator",@ig8aserialread);
else
    error('%s not available, check other connections or choose a different COM port',COMport)
end
end