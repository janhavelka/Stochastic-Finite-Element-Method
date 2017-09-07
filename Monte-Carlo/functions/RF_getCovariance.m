function [dC_F,MATERIAL]=RF_getCovariance(MESH,MATERIAL)

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


% transform MEAN and VAR if i-th field is not normaly distributed
MEAN_t=MATERIAL.Settings.RF.MEAN;
VAR_t=MATERIAL.Settings.RF.VAR;
for i=1:MATERIAL.Settings.RF.N_rf
    if strncmpi(MATERIAL.Settings.RF.sampling{i},'lognormal',7)
        VAR_t(i)=log(1+MATERIAL.Settings.RF.VAR(i)/MATERIAL.Settings.RF.MEAN(i)^2);
        MEAN_t(i)=log(MATERIAL.Settings.RF.MEAN(i))-VAR_t(i)/2;
    end
end

% construct the covariances of each field separately
dC=cell(MATERIAL.Settings.RF.N_rf,1);
% loop over number of fields
for field_idx=1:MATERIAL.Settings.RF.N_rf
    % Calculate matern covariance matrix
    dC{field_idx}=zeros(MESH.nnodes);
    for i=1:MESH.nnodes
        for j=i+1:MESH.nnodes
            node_dist=sqrt((MESH.Nodes(i,1)-MESH.Nodes(j,1))^2+(MESH.Nodes(i,2)-MESH.Nodes(j,2))^2);
            if strncmpi(MATERIAL.Settings.RF.covariance{field_idx},'matern',5)
                modvar=sqrt(2*MATERIAL.Settings.RF.P{field_idx}.nu)*node_dist/MATERIAL.Settings.RF.P{field_idx}.rho;
                dC{field_idx}(i,j)=VAR_t(field_idx)*2^(1-MATERIAL.Settings.RF.P{field_idx}.nu)/gamma(MATERIAL.Settings.RF.P{field_idx}.nu)*modvar^MATERIAL.Settings.RF.P{field_idx}.nu*besselk(MATERIAL.Settings.RF.P{field_idx}.nu,modvar);
            elseif strncmpi(MATERIAL.Settings.RF.covariance{field_idx},'gaussian',4) || strncmpi(MATERIAL.Settings.RF.covariance{field_idx},'SE',2)
                % Squared Exponential/Gaussian (smooth model)
                dC{field_idx}(i,j)=VAR_t(field_idx)*exp(-node_dist^2/(2*MATERIAL.Settings.RF.P{field_idx}.rho^2));
            elseif strncmpi(MATERIAL.Settings.RF.covariance{field_idx},'exponential',4) || strncmpi(MATERIAL.Settings.RF.covariance{field_idx},'Ornstein-Uhlenbeck',5) || strncmpi(MATERIAL.Settings.RF.covariance{field_idx},'OU',2)
                % Exponential/Ornstein-Uhlenbeck
                dC{field_idx}(i,j)=VAR_t(field_idx)*exp(-node_dist/MATERIAL.Settings.RF.P{field_idx}.rho);
            elseif strncmpi(MATERIAL.Settings.RF.covariance{field_idx},'periodical',5)
                % Periodical
                dC{field_idx}(i,j)=VAR_t(field_idx)*exp(-2*sin(node_dist/2)^2/MATERIAL.Settings.RF.P{field_idx}.rho^2);
            elseif strncmpi(MATERIAL.Settings.RF.covariance{field_idx},'constant',5)
                % Constant
                dC{field_idx}(i,j)=VAR_t(field_idx)*MATERIAL.Settings.RF.P{field_idx}.rho;
            end
        end
    end
    % add diagonal and fill the second half of matrix
    dC{field_idx}=dC{field_idx}+dC{field_idx}'+VAR_t(field_idx)*eye(size(dC{field_idx}));
end

% construct the covariances of all fields together
dC_F=cell(MATERIAL.Settings.RF.N_rf);
for i=1:MATERIAL.Settings.RF.N_rf
    for j=1:MATERIAL.Settings.RF.N_rf
        %         dC_F{i,j}=MATERIAL.Settings.RF.C(i,j)*(dC{i}.*dC{j}).^0.5;
        dC_F{i,j}=MATERIAL.Settings.RF.C(i,j).*(dC{i}.*dC{j}).^0.5;
    end
end
dC_F=cell2mat(dC_F);






