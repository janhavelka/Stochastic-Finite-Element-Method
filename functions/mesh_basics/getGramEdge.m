function [EDGES,eval_time] = getGramEdge( EDGES )





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
% get gram matrix for boundary edges

% allocate GD_c for [3 x 3 x nelements] matrices of integrated shape functions
EDGES.G_c=zeros(4,EDGES.nelements);
for i=1:EDGES.nelements
    % gram matrix - (linear bases on edges)
    EDGES.G_c(:,i)=EDGES.Elements(i,3)*1/6*[2 1 1 2]';
end

nDOFs=2;
col_mat=repmat(eye(nDOFs),nDOFs,1);
row_mat=kron(eye(nDOFs),ones(nDOFs,1));

EDGES.R_s=row_mat*EDGES.Elements(:,1:2)';
EDGES.C_s=col_mat*EDGES.Elements(:,1:2)';

% EDGES.G=sparse(EDGES.R_s,EDGES.C_s,EDGES.G_c);












% % allocate BD_c for [2 x 3 x nelements] matrices of integrated derivatives of shape funs
% EDGES.B_c=cell(EDGES.nelements,1);
% % allocate GD_c for [3 x 3 x nelements] matrices of integrated shape functions
% EDGES.G_c=cell(EDGES.nelements,1);
% for i=1:EDGES.nelements
%     % get nodes coordinates
%     x1=EDGES.Nodes(EDGES.Elements(i,1),1);        y1=EDGES.Nodes(EDGES.Elements(i,1),2);
%     x2=EDGES.Nodes(EDGES.Elements(i,2),1);        y2=EDGES.Nodes(EDGES.Elements(i,2),2);
% 
%     % integrate derivatives of basis functions (linear bases on edges)
%     EDGES.B_c{i}=[y1-y2 x2-x1]'/EDGES.Elements(i,3);
%     % gram matrix - (linear bases on edges)
%     EDGES.G_c{i}=EDGES.Elements(i,3)*1/6*[2 1 1 2]';
% end;


% time required to evalate function
eval_time=toc;