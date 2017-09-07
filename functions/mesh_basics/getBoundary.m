function Boundary = getBoundary(MESH)




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



DT=triangulation(MESH.Elements(:,1:3),MESH.Nodes);

% get the free boundary and number of boundary elements (edges)
Boundary.Elements=DT.freeBoundary;










% get number of elements on boundaries
Boundary.nelements=size(Boundary.Elements,1);
% calculate the length of each element on boundary - extend the matrix
Boundary.Elements(:,3)=sum((MESH.Nodes(Boundary.Elements(:,1),:)-MESH.Nodes(Boundary.Elements(:,2),:)).^2,2).^(1/2);









