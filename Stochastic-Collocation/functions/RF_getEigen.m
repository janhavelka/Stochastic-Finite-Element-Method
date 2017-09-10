function [M,S,MS,M_F,S_F]=RF_getEigen(MESH,MATERIAL,dC_F,G_F)

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


% compute eigenvectors & eigenvalues
[M_F,S_F]=eig(full(G_F*dC_F*G_F),full(G_F));

% sort the series
[~,sort_idx]=sort(diag(S_F),'descend');
% [~,sort_idx]=sort(diag(abs(S_F)),'descend');
M_F=M_F(:,sort_idx);
S_F=S_F(sort_idx,sort_idx);

% normalize all fields
M_F=M_F*diag( 1./sqrt(diag(M_F'*G_F*M_F)) );

%% Separate the eigenmodes
% allocate cell arrays for fields
MS=cell(MATERIAL.Settings.RF.N_rf,1);
M=cell(MATERIAL.Settings.RF.N_rf,1);
S=cell(MATERIAL.Settings.RF.N_rf,1);
% separate the fields to different cell arrays
for i=1:MATERIAL.Settings.RF.N_rf
    S{i}=S_F;
    M{i}=M_F(((i-1)*MESH.nnodes+1):(i*MESH.nnodes),:);
    % for uncorrelated fields it might occur that odd or even modes are zero modes - this procedure wipes them out
    valid_idx=~all((M{i}>-eps & M{i}<eps));
    S{i}=S{i}(valid_idx,valid_idx);
    M{i}=M{i}(:,valid_idx);
%     MS{i}=real(M{i}*sqrt(S{i}));
    MS{i}=(M{i}*(S{i}).^0.5);
end







