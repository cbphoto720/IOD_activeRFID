function [dt,timezone] = interpUTC(source)
% NOT INTENDED FOR USE OUTSIDE OF timecmp.m
% Determine if ISO 8601 format (YYYYMMDDTHHMMSS) date is UTC time.
% Indicated by an appended 'Z'
%   See timecmp function.
if  source(end)=='Z'
    timezone='UTC';
    dt=datetime(source(1:end-1),'Format','uuuuMMdd''T''HHmmss');
else
    timezone='America/Los_Angeles';
    dt=datetime(source,'Format','uuuuMMdd''T''HHmmss');
end

end