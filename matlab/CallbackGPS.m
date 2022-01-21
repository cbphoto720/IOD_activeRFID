function CallbackGPS(~,~,mapoffset,plotmode,varargin)
%Update GPS map on CobbleFinder GUI *Optional arguments: ('mop','snail')
%{
    Optional arguments:
        - 'mop', [SMOP , NMOP] - display mop lines in range [SMOP,NMOP]
        - 'snail' - display snail trails (previous GPS line)
%}
    tic
    global GPScord
    global MOPkml
    global a %test
    global b %test

    clf
    % calc map limits
    lat=[GPScord(1)-mapoffset,GPScord(1)+mapoffset];
    lon=[GPScord(2)-mapoffset,GPScord(2)+mapoffset];

    % Plot map
    switch plotmode
        case 'g' % Geomap
            geoscatter(GPScord(1),GPScord(2),150,'blue','x','LineWidth',1);
            hold on
            geoscatter(GPScord(1),GPScord(2),250,'blue','o','LineWidth',1);
    
            geolimits(lat,lon)
            geobasemap topographic
        case 'p' % fast plot
            scatter(GPScord(2),GPScord(1),150,'blue','x','LineWidth',1);
            hold on
            scatter(GPScord(2),GPScord(1),250,'blue','o','LineWidth',1);
    
            ylim(lat)
            xlim(lon)
    end

    %% Optional arguments (varargin)
    % 'mop' - display mop lines
    if any(strcmp(varargin, 'mop')==1)
        moprange=varargin{find(strcmp(varargin, 'mop')==1)+1};
        if isa(moprange,'double') && all(size(moprange)==[1,2]) %check for MOP range spec
        else
            msg=sprintf('optional argument ''mop'' must be followed by mop range [SMOP, NMOP]')
            error(msg)
        end
        switch plotmode
            case 'g'
                hold on
%                 for i=moprange(1):moprange(2)
%                     geoplot(MOPkml(i).Lat,MOPkml(i).Lon,'red')
%                 end
                geoplot(b,a,'red')
            case 'p'
                hold on
%                 for i=moprange(1):moprange(2)
%                     plot(MOPkml(i).Lon,MOPkml(i).Lat,'red')
%                 end
                plot(a,b,'red')
        end
    end

    % 'snail' - display snail trails (previous GPS line)
    if any(strcmp(varargin, 'snail')==1)
        disp('snail working')
    end

    hold off
    drawnow()
    toc
end