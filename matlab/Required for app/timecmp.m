function boolean = timecmp(inquire,target,precision,precisionunits)
%Compare inquired time to target within  +- the precision value
%   TIME FORMAT IN ISO 8601 format YYYYMMDDTHHMMSS
%   Optional 'Z' appended to date indicates UTC time
%% _____ InputParser _____
p=inputParser;
expectedtime =@(x) validateattributes(sscanf(x,'%8dT%6d%'),{'numeric'},{'numel',2,'nonempty'}); %checks ans is a numeric matrix with 2 entries (date and time)
addRequired(p,'inquire',expectedtime);
addRequired(p,'target',expectedtime);

validprecision = @(x) isnumeric(x) && isscalar(x);
addRequired(p,'precision',validprecision);

expectedDatatypes = {"hours","minutes","seconds"};
unitsfcn=@(x) any(validatestring(x,expectedDatatypes));
defaultunits="seconds";
addOptional(p,'precisionunits',defaultunits,unitsfcn);

parse(p,inquire,target,precision);
%% _____ Interpret _____
% Begin stuct
time1.source=inquire;
time2.source=target;

% Calculate UTC time or PST datetime
[time1.dt,time1.timezone]=interpUTC(inquire);
[time2.dt,time2.timezone]=interpUTC(target);

% ~ Precision ~
if precisionunits=="hours"
    bounds=duration([precision,0,0]);
elseif precisionunits=="minutes"
    bounds=duration([0,precision,0]);
elseif precisionunits=="seconds"
    bounds=duration([0,0,precision]);
end
%% _____ Calculate _____
if time1.dt>time2.dt-bounds
    disp('inquire is within boundry');
else
    disp('False');
end

% Useful stuff from scratch paper
% file=dir('aRFIDcobbleLog_20221006.txt'); %current
% datetime(file.date,"Format","dd-MMM-uuuu HH:mm:ss");
% 
% a=datetime('now','Format','uuuuMMdd''T''HHmmss','TimeZone','UTC')
% disp('...')
% b=datetime('now','Format','uuuuMMdd''T''HHmmss','TimeZone','America/Los_Angeles')
% nowutc=[datestr(datetime('now', 'TimeZone','Z'),30),'Z'];
% a=sscanf(nowutc,'%8dT%6d%');

end