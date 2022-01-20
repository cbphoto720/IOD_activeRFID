function CallbackGPS(src,~,mapoffset,varargin)
%Update GPS map on CobbleFinder GUI
%{
    Optional arguments:
        - 'mop' - display mop lines
        - 'snail' - display snail trails (previous GPS line)
%}
    global GPScord

    % calc map limits
    lat=[GPScord(1)-mapoffset,GPScord(1)+mapoffset];
    lon=[GPScord(2)-mapoffset,GPScord(2)+mapoffset];

    % Plot map
    gs=geoscatter(GPScord(1),GPScord(2),'*');
    geolimits(lat,lon)
    geobasemap topographic

    % Optional arguments (varargin)
    if any(strcmp(varargin, 'mop')==1)
        disp('mop working')
    end
    if any(strcmp(varargin, 'snail')==1)
        disp('snail working')
    end
    drawnow()
end