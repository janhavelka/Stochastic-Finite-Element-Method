function [ MESH,eval_time ] = getBasics( MESH,save_folder )





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



tic


% UPDATE MESH: number of nodes and elements
MESH.nelements=size(MESH.Elements,1);
MESH.nnodes=size(MESH.Nodes,1);

% allocate A_el for [nelements x 1] the area of elements
A_el=zeros(MESH.nelements,1);
% allocate C_el for [nelements x 2] the centroid of elements
C_el=zeros(MESH.nelements,2);
for i=1:MESH.nelements
    % node 1-3 coords
    x1=MESH.Nodes(MESH.Elements(i,1),1);        y1=MESH.Nodes(MESH.Elements(i,1),2);
    x2=MESH.Nodes(MESH.Elements(i,2),1);        y2=MESH.Nodes(MESH.Elements(i,2),2);
    x3=MESH.Nodes(MESH.Elements(i,3),1);        y3=MESH.Nodes(MESH.Elements(i,3),2);
    
    % triangular area
    A_el(i)=1/2*(x1*y2 - x2*y1 - x1*y3 + x3*y1 + x2*y3 - x3*y2);
    C_el(i,:)=[x1+x2+x3 y1+y2+y3]/3;
end
MESH.Elements=[MESH.Elements(:,1:3) A_el C_el];

% DT=delaunayTriangulation(MESH.Nodes);
DT=triangulation(MESH.Elements(:,1:3),MESH.Nodes);


MESH.Boundary=getBoundary(MESH);

% Sort elements so separate boundaries are listed consecutively



% divide mesh "Boundary Segments" -> i.e. BS:
% each segment should be in a 1D cell array containing [x1,y1;x2,y2]
% coordinates of segment start [x1,y1] and segment end [x2,y2]
if isfield(MESH,'BS') && ~isempty(MESH.BS) && iscell(MESH.BS)
    % initiate array for "Boundary Segments Elements", i.e. edges belonging
    % to certain boundary segment
    MESH.Boundary.BSE=cell(size(MESH.BS));
    for i=length(MESH.BS)
        inpoly
        MESH.Boundary.BSE{i}=1;
    end
end

% get the interior nodes logicals
MESH.int_nodes=true(MESH.nnodes,1);
MESH.int_nodes(MESH.Boundary.Elements(:,1))=false;

%
% % get vertex neighbors
% % triangles attached to a vertex
% attachedTriangles = vertexAttachments(DT);
% % get vertex neighbours - each row "i" is a vertex and each element in
% % VN{i} is vertex id connected by edge with vertex "i"
% MESH.VN=cell(MESH.nnodes,1);
% for i = 1:MESH.nnodes
%     % get all vertex indices for all triangles
%     TVert = MESH.Elements(attachedTriangles{i},1:3);
%     % unique vertices (excluding the current vertex)
%     MESH.VN{i} = setdiff(unique(TVert), i);
% end

% get element edge attachments
MESH.EC=neighbors(DT);

% % get all the edges of mesh
MESH.Edges.Elements=DT.edges;
MESH.Edges.nelements=size(MESH.Edges.Elements,1);
% % calculate the length of each element on boundary - extend the matrix
MESH.Edges.Elements(:,3)=sum((MESH.Nodes(MESH.Edges.Elements(:,1),:)-MESH.Nodes(MESH.Edges.Elements(:,2),:)).^2,2).^(1/2);
% MESH.Edges.Nodes=MESH.Nodes;

% plot centroids, identify nodes, elements, edge elements, save fig
PlotMesh( MESH,save_folder )


% time required to evalate function
eval_time=toc;




