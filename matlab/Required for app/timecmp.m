function boolean = timecmp(inquire,target,precision,precisionunits)
%Compare inquired time to target within  +- the precision value
%   TIME FORMAT IN ISO 8601 format YYYYMMDDTHHMMSS
% _____ INPUTPARSER _____
p=inputParser;
expectedtime =@(x) validateattributes(sscanf(x,'%8dT%6d%'),{'numeric'},{'numel',2,'nonempty'}); %checks ans is a numeric matrix with 2 entries (date and time)
addRequired(p,'inquire',expectedtime);
addRequired(p,'target',expectedtime);

validprecision = @(x) isnumeric(x) && isscalar(x);
addRequired(p,'precision',validprecision);

expectedDatatypes = {'years','months','days','hours','minutes','seconds'};
unitsfcn=@(x) any(validatestring(x,expectedDatatypes));
addOptional(p,'precisionunits','days',unitsfcn);

parse(p,inquire,target,precision);

%% _____ Calculate _____

%{
IF inquire(end)=='Z'
    -treat as utc time
else
    -treat as PST time
end

%}
datetime(nowutc(1:end-1),'Format','uuuuMMdd''T''HHmmss')


% Useful stuff from scratch paper
file=dir('aRFIDcobbleLog_20221006.txt'); %current
datetime(file.date,"Format","dd-MMM-uuuu HH:mm:ss");

a=datetime('now','Format','uuuuMMdd''T''HHmmss','TimeZone','UTC')
disp('...')
b=datetime('now','Format','uuuuMMdd''T''HHmmss','TimeZone','America/Los_Angeles')
nowutc=[datestr(datetime('now', 'TimeZone','Z'),30),'Z'];
a=sscanf(nowutc,'%8dT%6d%');

end