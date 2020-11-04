% % example
%  a=[22.5760763   113.9363950];
%  b=[22.5755560   113.9353524];
% 
% % 120.1445614 / 30.2829284	120.137989 / 30.276217
% % 22.5760763 / 113.9363950	22.5755560 / 113.9353524
% distance=distanceCountViaCoordinate(a,b)
function distanceMeters=distanceCountViaCoordinate(coordinate_a,coordinate_b)

%% 计算两点间的距离
distanceMeters = 0;
    %单位：千�?
distanceMeters =1000 * (distance(coordinate_a(1),coordinate_a(2),coordinate_b(1),coordinate_b(2))/180*pi*6371);
end