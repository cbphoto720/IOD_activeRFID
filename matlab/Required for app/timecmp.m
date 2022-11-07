function boolean = timecmp(inquire,target,precision,precisionunits)
%Compare inquired datestr or datetime to target within  +- the precision value
%   TIME FORMAT IN ISO 8601 format YYYYMMDDTHHMMSS
%   Optional 'Z' appended to date indicates UTC time
%% _____ InputParser _____
p=inputParser;
expectedtime =@(x) isstring(x) | isdatetime(x); % validateattributes(sscanf(x,'%8dT%6d%'),{'numeric'},{'numel',2,'nonempty'})     -checks ans is a numeric matrix with 2 entries (date and time)
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
ISO8601valid =@(x) validateattributes(sscanf(x,'%8dT%6d%'),{'numeric'},{'numel',2,'nonempty'});
if isstring(inquire)
    assert(ISO8601valid(inquire),'Datestring is not of valid ISO8601 format')
end
if isstring(target)
    assert(ISO8601valid(target),'Datestring is not of valid ISO8601 format')
end


% Begin stuct
if isdatetime(inquire)
    time1.dt=inquire;
else
    [time1.dt,time1.timezone]=interpUTC(inquire);
end

if isdatetime(target)
    time2.dt=target;
else
    [time2.dt,time2.timezone]=interpUTC(target);
end

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
    boolean=true;
else
    boolean=false;
end

end