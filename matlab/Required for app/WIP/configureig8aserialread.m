function iG8a_serialobj = configureig8aserialread(COMport)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if any(strcmp(COMport,serialportlist('available')))
    iG8a_serialobj=serialport(COMport,115200);
    configureTerminator(iG8a_serialobj,"CR/LF");
    configureCallback(iG8a_serialobj,"terminator",@ig8aserialread);

else
    error('%s not available, check other connections or choose a different COM port',COMport)
end
end