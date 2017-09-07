function [ MESH,eval_time ] = getENT( MESH )





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
% Get the transformation "Elements To Nodes" - ETN and its inverse

% create consistet projection matrix "from NodesToElements"
NTE=zeros(MESH.nelements,MESH.nnodes);
% create non-consistent projection matrix "from ElementsToNodes"
ETN=zeros(MESH.nelements,MESH.nnodes);
for i=1:MESH.nelements
    % weights for "to elements" is proportional to number of elements
    NTE(i,MESH.Elements(i,1:3))=1/3;
    % divide weight proportionally to the area of element
    ETN(i,MESH.Elements(i,1:3))=MESH.Elements(i,4);
%         ETN(i,MESH.Elements(i,1:3))=1;
end
ETN=(ETN*diag(1./sum(ETN)))';

MESH.ETN=sparse(ETN);
MESH.NTE=sparse(NTE);


% time required to evalate function
eval_time=toc;