function MATERIAL=RF_getModes(MESH,MATERIAL)

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


% Get the covariances for every field and its combinations
dC_F=RF_getCovariance(MESH,MATERIAL);
% Get extended Gram matrix 
G_F=kron(eye(MATERIAL.Settings.RF.N_rf),sparse(MESH.R_s,MESH.C_s,MESH.G_c));
% Get sorted and normalized eigenvectors and eigenvalues
[M,S]=RF_getEigen(MESH,MATERIAL,dC_F,G_F);
% Separate and truncate the modes
[M_trunc,S_trunc,MS_trunc,nmodes]=RF_getTruncate(M,S,MATERIAL);

%% write vars into MATERIAL field

% modal matrix
MATERIAL.M=M_trunc;
% spectral matrix
MATERIAL.S=S_trunc;
% modal*sqrt(spectral)
MATERIAL.MS=MS_trunc;

% number of distinct random fields
MATERIAL.nfields=length(M_trunc);
% number of distinct modes
MATERIAL.nmodes=nmodes;






