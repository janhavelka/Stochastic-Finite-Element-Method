function [MESH,total_time] = MeshBasics( MESH,varargin )




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


% varargin{1} is the folder to save to
% varargin{1} is the preferred folder to save he figure
if nargin==1
    save_folder='mesh';
else
    save_folder=varargin{1};
end

% check if the MESH variable needs to be updated with new variables
MeshChanges=false;

% MESH.Nodes(:,1:2)=roundto(MESH.Nodes(:,1:2),1e-5);

total_time=0;

% UPDATE MESH: decompose the mesh into edges, boundary, etc
% ADD: element area, element centroid, int_nodes - logicals of interior nodes
% 'VN' - interconnected vertices 'vertex neighbours' (by edge)
% 'EC' - interconnected elements (by edge)
if ~isfield(MESH,'Boundary') || ~isfield(MESH,'EC') || ~isfield(MESH,'int_nodes') || ~isfield(MESH,'nelements') || ~isfield(MESH,'nnodes')% || ~isfield(MESH,'VN')
    [ MESH,eval_time ] = getBasics( MESH,save_folder );
    MeshChanges=true;
    total_time=total_time+eval_time;
end

% add the projections "from" and "to" elements/nodes
if ~isfield(MESH,'NTE') || ~isfield(MESH,'ETN')
    [ MESH,eval_time ] = getENT( MESH );
    MeshChanges=true;
    total_time=total_time+eval_time;
end

% UPDATE MESH.Elements
% ADD gram matrices to all structures,
% Elements = [v_i1,v_i2,v_i3,S_i,x_i,y_i] (v_i -> vertex id), S_i - element area, x_i,y_i - centroid coordinates
if ~isfield(MESH,'G_c') || ~isfield(MESH,'B_c') %|| ~isfield(MESH,'G')
    % Get Gram matrices and code numbers (row,column indexes for sparse(r,c,v)) for all elements
    [ MESH,eval_time ] = getGramElement( MESH );
    MeshChanges=true;
    total_time=total_time+eval_time;
end

% % UPDATE: gram matrices to MESH.Edges
% if ~isfield(MESH.Edges,'G_c') || ~isfield(MESH.Edges,'B_c')
%     % Get Gram matrices and code numbers (row,column indexes for sparse(r,c,v)) for all edges
%     MESH.Edges = EIT_getGramEdge( MESH.Edges );
%     MeshChanges=true;
% end

% UPDATE: gram matrices to MESH.Boundary
if ~isfield(MESH.Boundary,'G_c') %|| ~isfield(MESH.Boundary,'B_c')
    % Get Gram matrices for boundary edges (not necesary)
    [ MESH.Boundary,eval_time ] = getGramEdge( MESH.Boundary );
    MeshChanges=true;
    total_time=total_time+eval_time;
end

if MeshChanges
    movefile([fullfile(cd,save_folder,MESH.MeshName),'.mat'],NameSequence(MESH.MeshName,save_folder,[],'.mat',[]))
    save(fullfile(cd,save_folder,MESH.MeshName),'-struct','MESH');
    disp('MESH file updated');
end



