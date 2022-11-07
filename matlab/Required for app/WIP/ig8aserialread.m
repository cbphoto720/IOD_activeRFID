function varargout = ig8aserialread(iG8a_serialobj,varargin)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    tic
    % _____ Input Parser _____
    defaultoptionalinput = {'serialline'};
    expectedoptionalinput = {'serialline','LatLonTimeSats'};

    if length(varargin)>1 %check that there is only 1 optional input
        errvars='''';
        for i=1:length(expectedoptionalinput)
            if i==length(expectedoptionalinput)
                errvars=errvars+string(expectedoptionalinput{i})+'''';
            else
                errvars=errvars+string(expectedoptionalinput{i})+''', ''';
            end
        end
        error('Too many input options! Expected input to match one of these values:\n\n\t%s',errvars);
    end

    p = inputParser;
    addRequired(p,'serialobj',@(x) strcmp(class(iG8a_serialobj),'internal.Serialport'));
    addOptional(p,'options',defaultoptionalinput,...
             @(x) any(validatestring(x,expectedoptionalinput)));
    parse(p,iG8a_serialobj,varargin{:});
    toc

    % _____ Read iG8 data _____
    scandata=readline(iG8a_serialobj);
    %   - Validate through checksum that data is correct
    %   - Omit bootup mssgs, only publish coordinates
    %   - error handling for loss of satellites

if isempty(varargin) | strcmp(varargin,expectedoptionalinput{1})
    % Run default iG8a output (pass an output string of the full read line)
    % read the serial data and output the full string

    varargout={scandata};
    
elseif strcmp(varargin,expectedoptionalinput{2})
    % only ouput Lat, Lon, Time, # Sats

    fprintf('LatLonTimeSats: only ouput Lat, Lon, Time, # Sats\n')
end
end