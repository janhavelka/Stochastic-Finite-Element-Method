function LOAD=T_getRHS(MESH,PROBLEM,LOAD)

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


% predefine the arrays
LOAD.RHS_t=zeros(MESH.nnodes,1);
LOAD.RHS_d=zeros(MESH.nnodes,1);
LOAD.RHS_f=zeros(MESH.nnodes,1);
LOAD.RESP_d=zeros(MESH.nnodes,1);

% define nodes with dirichlet condition
LOAD.Boundary.Dirichlet.idx=true(MESH.nnodes,1);

% get the transfer rhs
if LOAD.Boundary.Transfer.N_b>0
    r_t=cell2mat(LOAD.Boundary.Transfer.Elements');
    v_t=cell2mat(LOAD.Boundary.Transfer.Value');
    LOAD.RHS_t=full(sparse(r_t(:,1:2),1,repmat(v_t,1,2)/2,MESH.nnodes,1));
end

% get the flux rhs
if LOAD.Boundary.Flux.N_b>0
    r_f=cell2mat(LOAD.Boundary.Flux.Elements');
    v_f=cell2mat(LOAD.Boundary.Flux.Value');
    LOAD.RHS_f=full(sparse(r_f(:,1:2),1,repmat(v_f,1,2)/2,MESH.nnodes,1));
end

% get the "dirichlet rhs"
if LOAD.Boundary.Dirichlet.N_b>0
    r_d=cell2mat(LOAD.Boundary.Dirichlet.Nodes');
    v_d=cell2mat(LOAD.Boundary.Dirichlet.Value');
    % Dirichlet part of the system response
    LOAD.RESP_d = full(sparse(r_d,1,v_d,MESH.nnodes,1));
    LOAD.Boundary.Dirichlet.idx=~logical(full(sparse(r_d,1,1,MESH.nnodes,1)));
end
























