function CallbackGPS(src,~,mapoffset)
%Update GPS map on CobbleFinder GUI
global GPScord
    lat=[GPScord(1)-mapoffset,GPScord(1)+mapoffset];
    lon=[GPScord(2)-mapoffset,GPScord(2)+mapoffset];

    gs=geoscatter(GPScord(1),GPScord(2),'*');
    geolimits(lat,lon)
    geobasemap topographic
    drawnow()
end