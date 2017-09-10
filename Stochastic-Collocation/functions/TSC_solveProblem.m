function LOAD=TSC_solveProblem(MESH,PROBLEM,MATERIAL,LOAD)


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


% get the global indexes of dirichlet nodes
g_idx=LOAD.Boundary.Dirichlet.idx;
% predefine the solution vector
RESP=zeros(MESH.nnodes,length(MATERIAL.XiWeights));
% fill the solution with dirichlet values
RESP(~g_idx,:)=repmat(LOAD.RESP_d(~g_idx),1,size(RESP,2));

K_t=LOAD.K_t;
RHS_t=LOAD.RHS_t(g_idx);
RHS_f=LOAD.RHS_f(g_idx);
RESP_d=LOAD.RESP_d;
% get the material field
sigma=MATERIAL.RField_elem;

for i=1:length(MATERIAL.XiWeights)
    % get the stiffness matrix
    K_u = getStiffness(MESH,reshape(sigma(:,i),[],3));
    % get the dirichlet rhs
    RHS_d = -(K_u+K_t)*RESP_d;
    % get the solution
    RESP(g_idx,i) = (K_u(g_idx,g_idx)+K_t(g_idx,g_idx))\(RHS_t+RHS_d(g_idx)+RHS_f);
end
%     LOAD.RESP = (K_u+LOAD.K_t)\(LOAD.RHS_t+LOAD.RHS_f);
LOAD.RESP=RESP;


% Project the solution into gPC

% Matrix of multiindices
MI_Matrix = multiindex(size(MATERIAL.XiNodes,2),MATERIAL.Settings.Collocation.DoP);
% Factorial of multiindices
MI_Factorial = multiindex_factorial(MI_Matrix);

PCEval = zeros(size(MATERIAL.XiNodes,1),size(MI_Matrix,1));
for k = 1:size(MI_Matrix,1)
    % Evaluation of Hermite polynomials (Matrix of evaluated PC polynomials in given design points)
    PCEval(:,k) = hermite_val_multi(1,MI_Matrix(k,:),MATERIAL.XiNodes);
end

% Matrix of coefficients size(FEM_nodes,degree_of_polynomial)
LOAD.gPC_RESP = RESP.*repmat(MATERIAL.XiWeights',size(RESP,1),1)*PCEval./repmat(MI_Factorial',size(RESP,1),1);





