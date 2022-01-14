function CallbackGPS(src,,~,mapoffset)
%Update GPS map on CobbleFinder GUI
global GPScord
    mapoffset.lat=[GPScord(1)-mapoffset.val,GPScord(1)+mapoffset.val];
    mapoffset.lon=[GPScord(2)-mapoffset.val,GPScord(2)+mapoffset.val];

    gs=geoscatter(GPScord(1),GPScord(2),'*');
    geolimits(mapoffset.lat,mapoffset.lon)
    drawnow()
end