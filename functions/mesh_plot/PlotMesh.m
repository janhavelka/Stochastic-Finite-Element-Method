function PlotMesh( MESH,save_folder )

%PLOTMESH Summary of this function goes here
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


%% Support plots
% Plot the centroids, boundary nodes,elements, node id, element ids
    figure
    back_mesh = trimesh(MESH.Elements(:,1:3),MESH.Nodes(:,1),MESH.Nodes(:,2),zeros(MESH.nnodes,1));
    set(back_mesh,'EdgeColor','black','FaceColor',[0.9 0.9 0.9]);
    hold all
    plot([MESH.Nodes(MESH.Boundary.Elements(:,1),1),MESH.Nodes(MESH.Boundary.Elements(:,2),1)]',...
        [MESH.Nodes(MESH.Boundary.Elements(:,1),2),MESH.Nodes(MESH.Boundary.Elements(:,2),2)]','k','LineWidth',1.5);
    % plot the boundary elements
    X=[MESH.Nodes(MESH.Boundary.Elements(:,1),1),MESH.Nodes(MESH.Boundary.Elements(:,2),1)]';
    Y=[MESH.Nodes(MESH.Boundary.Elements(:,1),2),MESH.Nodes(MESH.Boundary.Elements(:,2),2)]';
    plot(X,Y,'b','LineWidth',2);
    % plot the identifiers
    text(mean(X),mean(Y),num2str((1:MESH.Boundary.nelements)'),'Color','blue','HorizontalAlignment','center','VerticalAlignment','bottom');
    % plot the centers
    plot(MESH.Elements(:,5),MESH.Elements(:,6),'or','MarkerEdgeColor','black','MarkerFaceColor','red','MarkerSize',3);
    text(MESH.Elements(:,5),MESH.Elements(:,6),num2str((1:MESH.nelements)'),'Color','red','HorizontalAlignment','left','VerticalAlignment','bottom')
    % plot nodes and identify them
    text(MESH.Nodes(:,1),MESH.Nodes(:,2),num2str((1:MESH.nnodes)'),'Color','black','HorizontalAlignment','left','VerticalAlignment','bottom')
    axis equal
    axis off
    view(0,90);
    savefig(gcf,fullfile(cd,save_folder,MESH.MeshName));

end

