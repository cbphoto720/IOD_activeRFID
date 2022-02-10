%% Refrence dictionary (example) Code
%% ________________________________________________________________________
% Find numbers in range

r = [1, 10];
xRange = [5 2 1 -1 5 67 3];
ii = xRange >= r(1) & xRange <= r(2)
out = xRange;
out(~ii) = nan;

% Find a struct field
a.b.c = 1;
isfield(a.b,'c')