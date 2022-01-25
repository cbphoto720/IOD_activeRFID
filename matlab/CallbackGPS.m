function CallbackGPS(~,~,mapoffset,plotmode,varargin)
%Update GPS map on CobbleFinder GUI *Optional arguments: ('mop','snail')
%{
    Optional arguments:
        - 'mop'- display mop lines
        - 'snail' - display snail trails (previous GPS line)
%}
    tic
    global GPScord
    global MOPlat
    global MOPlon
    global snail

    clf

    % 'snail' - display snail trails (previous GPS line)
    if any(strcmp(varargin, 'snail')==1)
        snail(end+1,:)=GPScord;
         switch plotmode
            case 'g'
                geoplot(snail(:,1),snail(:,2),'green')
            case 'p'
                plot(snail(:,2),snail(:,1),'green')
         end
         hold on
    else
        hold off
    end

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
        switch plotmode
            case 'g'
                hold on
                geoplot(MOPlat,MOPlon,'red')
            case 'p'
                hold on
                plot(MOPlon,MOPlat,'red')
        end
    end

    drawnow()
    toc
end