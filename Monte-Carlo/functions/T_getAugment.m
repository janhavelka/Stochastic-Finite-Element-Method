function LOAD=T_getAugment(MESH,PROBLEM,LOAD)
% NEED TO FIX DIFFERENT TRANSFER CODENUMBERS FOR EACH LOADING
% NEED TO FIX WRONG STIFFNESS MATRIX FOR ELECTRODES (OVERLAPS)

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


r_t=cell(1,LOAD.Boundary.Transfer.N_b);
c_t=cell(1,LOAD.Boundary.Transfer.N_b);
v_t=cell(1,LOAD.Boundary.Transfer.N_b);

% index of transfer bc
i_t=0;
for i=1:size(PROBLEM.LoadDef.BC,1)
    if strncmpi(PROBLEM.LoadDef.BC{i,2},'trans',5)
        i_t=i_t+1;
        r_t{i_t}=MESH.Boundary.R_s(:,LOAD.Boundary.Transfer.idx{i_t});
        c_t{i_t}=MESH.Boundary.C_s(:,LOAD.Boundary.Transfer.idx{i_t});
        v_t{i_t}=MESH.Boundary.G_c(:,LOAD.Boundary.Transfer.idx{i_t})*PROBLEM.LoadDef.BC{i,4};
    end
end
LOAD.K_t=sparse(cell2mat(r_t),cell2mat(c_t),cell2mat(v_t),MESH.nnodes,MESH.nnodes);