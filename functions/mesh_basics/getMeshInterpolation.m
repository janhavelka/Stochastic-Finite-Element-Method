function MESH_fine = getMeshInterpolation(MESH_fine,MESH_coarse)
% get the interpolation for elements and nodes between two meshes in a form
% of transpormation matrices
% In order to maintain all the data, the interpolation should be done in a
% way that coarse mesh will be projected into fine mesh.



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

%% FOR NODES
DT_n=triangulation(MESH_fine.Elements(:,1:3),MESH_fine.Nodes);

% triangles corresponding to coarse mesh nodes
ti = pointLocation(DT_n,MESH_coarse.Nodes(:,1:2));
% triangle nodes
ti_nodes=MESH_fine.Elements(ti,1:3);

dX=reshape(MESH_fine.Nodes(ti_nodes,1),MESH_coarse.nnodes,[])-repmat(MESH_coarse.Nodes(:,1),1,3);
dY=reshape(MESH_fine.Nodes(ti_nodes,2),MESH_coarse.nnodes,[])-repmat(MESH_coarse.Nodes(:,2),1,3);

% inverse distance between points
d=1./((dX.^2+dY.^2).^(1/2));
% normalized distance
nd=d./repmat(sum(d,2),1,3);
% replace NaNs with ones
nd(isnan(nd))=1;

MESH_fine.NTN=sparse(repmat([1:MESH_coarse.nnodes]',1,3),ti_nodes,nd,MESH_coarse.nnodes,MESH_fine.nnodes);

%% FOR ELEMENTS
DT_e=delaunayTriangulation(MESH_fine.Elements(:,5:6));

% triangles corresponding to coarse mesh nodes
ei = pointLocation(DT_e,MESH_coarse.Elements(:,5:6));
% triangle nodes
ei_nodes=DT_e.ConnectivityList(ei,1:3);

dX=reshape(MESH_fine.Elements(ei_nodes,5),MESH_coarse.nelements,[])-repmat(MESH_coarse.Elements(:,5),1,3);
dY=reshape(MESH_fine.Elements(ei_nodes,6),MESH_coarse.nelements,[])-repmat(MESH_coarse.Elements(:,6),1,3);

% inverse distance between points
d=1./((dX.^2+dY.^2).^(1/2));
% normalized distance
nd=d./repmat(sum(d,2),1,3);
% replace NaNs with ones
nd(isnan(nd))=1;

MESH_fine.ETE=sparse(repmat([1:MESH_coarse.nelements]',1,3),ei_nodes,nd,MESH_coarse.nelements,MESH_fine.nelements);









