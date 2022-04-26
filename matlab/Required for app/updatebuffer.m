function outupdate = updatebuffer(update,src)
% aquire new entry for a matrix with a fixed number of entries
%   src should be a column vector or matrix.  (rows of the vector represent
%   data 

%{ 
_/\__/\__/\__/\_ Work in Progress! _/\__/\__/\__/\_
- function input should not have to pass itself (callback?)
- input parsing should check:
    - update is a row vector of the # columns as src
    - src is a matrix with at least 2 rows
%}

% arguments
%     update double {mustBeVector} % row vector of new data
%     src double % buffer of past values
% end
% issrcmat = numel(src)~=1;
% 
% if issrcmat && size(src,2)==length(update)
%     outupdate=[update;src(1:end-1,:)]; % values are organized by row newest -> oldest
% end

    p = inputParser;
    numchk = {'numeric'};
    updateatrr = {'nonempty','ncols',size(src,2),'row'};
    srcatrr = {'nonempty'};
    
    addRequired(p,'update',@(x)validateattributes(x,numchk,updateatrr))
    addRequired(p,'src',1,@(x)validateattributes(x,numchk,srcatrr))
    
    parse(p,shape,dim1,varargin{:})

end