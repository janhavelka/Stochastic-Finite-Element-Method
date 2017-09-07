function [ XX,YY,ZZ ] = getContours( MESH, zz )
%GETCONTOURS Summary of this function goes here
%   Detailed explanation goes here



% Jan Havelka (jnhavelka@gmail.com)
% Copyright 2016, Czech Technical University in Prague
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.


xx=linspace(min(MESH.Nodes(:,1)),max(MESH.Nodes(:,1)),50);
yy=linspace(min(MESH.Nodes(:,2)),max(MESH.Nodes(:,2)),50);
[XX,YY]=meshgrid(xx,yy);
ZZ=griddata(MESH.Nodes(:,1),MESH.Nodes(:,2),zz,XX,YY);

% idx=~inpoly([XX(:),YY(:)],[Nodes(Boundary.Elements(:,1:2),1),Nodes(Boundary.Elements(:,1:2),2)]);
idx=~inpolygon(XX,YY,MESH.Nodes(MESH.Boundary.Elements(:,1:2),1),MESH.Nodes(MESH.Boundary.Elements(:,1:2),2));
ZZ(idx)=NaN;

end

