function [cout,hout] = surfc(xin,yin,zin,N)

% Contouring and surface function for functions defined on triangular meshes
%
% xin, yin, zin, are arrays of x,y,z values of the points for your surface.
% So [x(1) y(1) z(1)] defines the first point, etc.
%
% The last input N defines the contouring levels. There are several
% options:
%
%   N scalar - N number of equally spaced contours will be drawn
%   N vector - Draws contours at the levels specified in N


[X,Y]=meshgrid(min(min(xin)):max(max(xin)),min(min(yin)):max(max(yin)));

figure1 = figure;
% figure
surf(xin,yin,zin,'FaceColor','interp');

axes1 = axes('Parent',figure1,'PlotBoxAspectRatio',[1 1 1],'FontSize',20,...
    'DataAspectRatio',[10 10 1],...
    'CameraViewAngle',10.4968811688479);
view(axes1,[-37.5 32]);
grid(axes1,'on');
hold(axes1,'all');
% mesh(xin,yin,zin);
hold all

mesh(X,Y,Y.*0,'EdgeColor','k','FaceColor','none','LineWidth',0.05);

contour(xin,yin,zin,N,'LineWidth',1.5)


% set(m,'facecolor','none');