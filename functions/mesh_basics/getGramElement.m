function [MESH,eval_time] = getGramElement( MESH )






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
% allocate BD_c for [2 x 3 x nelements] matrices of integrated derivatives of shape funs
MESH.B_c=zeros(9,MESH.nelements);
MESH.B=zeros(6,MESH.nelements);
% allocate GD_c for [3 x 3 x nelements] matrices of integrated shape functions
MESH.G_c=zeros(9,MESH.nelements);
for i=1:MESH.nelements
    x1=MESH.Nodes(MESH.Elements(i,1),1);        y1=MESH.Nodes(MESH.Elements(i,1),2);
    x2=MESH.Nodes(MESH.Elements(i,2),1);        y2=MESH.Nodes(MESH.Elements(i,2),2);
    x3=MESH.Nodes(MESH.Elements(i,3),1);        y3=MESH.Nodes(MESH.Elements(i,3),2);
    % appears because it has to be K=1/4*1/A*B*D*B)
    MESH.B(:,i)=[y2-y3,y3-y1,y1-y2   x3-x2,x1-x3,x2-x1]'/sqrt(4*MESH.Elements(i,4));
    
    MESH.B_c(:,i)=reshape([y2-y3,y3-y1,y1-y2;
        x3-x2,x1-x3,x2-x1]'*[y2-y3,y3-y1,y1-y2;
        x3-x2,x1-x3,x2-x1]/(4*MESH.Elements(i,4)),[],1);
    % gram matrix - 2D base functions
    MESH.G_c(:,i)=MESH.Elements(i,4)/12*[2 1 1 , 1 2 1 , 1 1 2]';
end;


% Mapping matrix
nDOFs=3;
col_mat=repmat(eye(nDOFs),nDOFs,1);
row_mat=kron(eye(nDOFs),ones(nDOFs,1));

MESH.R_s=row_mat*MESH.Elements(:,1:3)';
MESH.C_s=col_mat*MESH.Elements(:,1:3)';

% MESH.G=sparse(MESH.R_s,MESH.C_s,MESH.G_c);

% r=reshape(repmat(1:2*MESH.nelements,3,1),6,[]);
% c=repmat(reshape(1:3*MESH.nelements,3,[]),2,1);

% r=repmat(1:2*MESH.nelements,3,1)';
% dummy=reshape(repmat(1:3:3*MESH.nelements,2,1),[],1);
% c=[dummy,dummy+1,dummy+2];
% v=cell2mat(B_c);
% BB=sparse(r,c,a);


% time required to evalate function
eval_time=toc;