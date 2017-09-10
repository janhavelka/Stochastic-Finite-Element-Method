function [M_trunc,S_trunc,MS_trunc,nmodes]=RF_getTruncate(M,S,MATERIAL)


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


%% Truncate the eigenvectors
% create truncated series
MS_trunc=cell(MATERIAL.Settings.RF.N_rf,1);
M_trunc=cell(MATERIAL.Settings.RF.N_rf,1);
S_trunc=cell(MATERIAL.Settings.RF.N_rf,1);

for i=1:MATERIAL.Settings.RF.N_rf
    % determine to choose between number of N_rv or wanted precision
    dS_sum=cumsum(diag(S{i}));
    % variance precision
    var_prec=1-dS_sum/dS_sum(end);
    % take n-modes in order to satisfy 'var_prec'
    nmodes=find(var_prec<(1-MATERIAL.Settings.RF.N_rv_prec),1);
    
    if nmodes<MATERIAL.Settings.RF.N_rv
        S_trunc{i}=S{i}(1:MATERIAL.Settings.RF.N_rv,1:MATERIAL.Settings.RF.N_rv);
        M_trunc{i}=M{i}(:,1:MATERIAL.Settings.RF.N_rv);
        %     MS_trunc{i}=real(M_trunc{i}*sqrt(S_trunc{i}));
        MS_trunc{i}=M_trunc{i}*(S_trunc{i}).^0.5;
        nmodes=MATERIAL.Settings.RF.N_rv;
    else
        S_trunc{i}=S{i}(1:nmodes,1:nmodes);
        M_trunc{i}=M{i}(:,1:nmodes);
        %     MS_trunc{i}=real(M_trunc{i}*sqrt(S_trunc{i}));
        MS_trunc{i}=M_trunc{i}*(S_trunc{i}).^0.5;
    end
end





