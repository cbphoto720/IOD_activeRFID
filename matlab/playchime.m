function [a,fs] = playchime(freq,duration)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
amp=10; 
fs=20500;  % sampling frequency (min for human ear)
values=0:1/fs:duration/length(freq);
if length(freq)>1
    for i=1:length(freq)
        a(i,:)=amp*sin(2*pi* freq(i)*values);
    end
else
    a=amp*sin(2*pi* freq*values);
end
a=a(:);
end