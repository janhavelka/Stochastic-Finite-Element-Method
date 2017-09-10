function LOAD = TSC_getBoundary(MESH,PROBLEM,LOAD)

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


% number of distict transfer boundaries
N_bt=0;
% number of distict dirichlet boundaries
N_bd=0;
% number of distict flux boundaries
N_bf=0;

% extract boundary node coords
nc=MESH.Nodes(MESH.Boundary.Elements(:,1),:);

% identify the boundary nodes belonging to specific boundary condition
for i=1:size(PROBLEM.LoadDef.BC,1)
    % get logical array of nodes on boundary
    %     [~,node_map]=inpolygon(nc(:,1),nc(:,2),PROBLEM.LoadDef.BC{i,1}(:,1),PROBLEM.LoadDef.BC{i,1}(:,2));
    [~,node_map]=inpoly(nc,PROBLEM.LoadDef.BC{i,1});
    if strncmpi(PROBLEM.LoadDef.BC{i,2},'trans',5)
        N_bt=N_bt+1;
        % get the real node numbers
        LOAD.Boundary.Transfer.Nodes{N_bt}=MESH.Boundary.Elements(node_map,1);
        LOAD.Boundary.Transfer.Elements{N_bt}=MESH.Boundary.Elements(node_map,:);
        % cut off the overlapping elements (results into valid idxs - vidx)
        vidx = all(ismember(MESH.Boundary.Elements(node_map,1:2),MESH.Boundary.Elements(node_map,1)),2);
        LOAD.Boundary.Transfer.Elements{N_bt}=LOAD.Boundary.Transfer.Elements{N_bt}(vidx,:);
        
        % (element length)*(transfer coefficient)*(outside temperature)
        LOAD.Boundary.Transfer.Value{N_bt}=LOAD.Boundary.Transfer.Elements{N_bt}(:,3)*PROBLEM.LoadDef.BC{i,3}*PROBLEM.LoadDef.BC{i,4};
        
        LOAD.Boundary.Transfer.idx{N_bt} = all(ismember(MESH.Boundary.R_s(2:3,:)',LOAD.Boundary.Transfer.Nodes{N_bt}'),2);
    elseif strncmpi(PROBLEM.LoadDef.BC{i,2},'dirich',6)
        N_bd=N_bd+1;
        % get the real node numbers
        LOAD.Boundary.Dirichlet.Nodes{N_bd}=MESH.Boundary.Elements(node_map,1);
        % prescribed temperature
        LOAD.Boundary.Dirichlet.Value{N_bd}=PROBLEM.LoadDef.BC{i,3}(ones(length(LOAD.Boundary.Dirichlet.Nodes{N_bd}),1));
    elseif strncmpi(PROBLEM.LoadDef.BC{i,2},'flux',4)
        N_bf=N_bf+1;
        % get the real node numbers
        LOAD.Boundary.Flux.Nodes{N_bf}=MESH.Boundary.Elements(node_map,1);
        LOAD.Boundary.Flux.Elements{N_bf}=MESH.Boundary.Elements(node_map,:);
        % cut off the overlapping elements (results into valid idxs - vidx)
        vidx = all(ismember(MESH.Boundary.Elements(node_map,1:2),MESH.Boundary.Elements(node_map,1)),2);
        LOAD.Boundary.Flux.Elements{N_bf}=LOAD.Boundary.Flux.Elements{N_bf}(vidx,:);
        
        % (element length)*(flux coefficient)
        LOAD.Boundary.Flux.Value{N_bf}=LOAD.Boundary.Flux.Elements{N_bf}(:,3)*PROBLEM.LoadDef.BC{i,3};
        
        LOAD.Boundary.Flux.idx{N_bf} = all(ismember(MESH.Boundary.R_s(2:3,:)',LOAD.Boundary.Flux.Nodes{N_bf}'),2);
    else
        warning('Wrong input boundary condition type');
    end
end

% write the number of distinct boundaries
LOAD.Boundary.Transfer.N_b=N_bt;
LOAD.Boundary.Dirichlet.N_b=N_bd;
LOAD.Boundary.Flux.N_b=N_bf;




