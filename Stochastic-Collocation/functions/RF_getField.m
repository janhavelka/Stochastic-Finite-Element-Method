function MATERIAL=RF_getField(MESH,PROBLEM,MATERIAL)

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


%% Moments transofmration for each field which needs to be transformed
% transform MEAN and VAR if i-th field is not normaly distributed (once again)
MEAN_t=MATERIAL.Settings.RF.MEAN;
VAR_t=MATERIAL.Settings.RF.VAR;
for i=1:MATERIAL.Settings.RF.N_rf
    if strncmpi(MATERIAL.Settings.RF.sampling{i},'lognormal',7)
        VAR_t(i)=log(1+MATERIAL.Settings.RF.VAR(i)/MATERIAL.Settings.RF.MEAN(i)^2);
        MEAN_t(i)=log(MATERIAL.Settings.RF.MEAN(i))-VAR_t(i)/2;
    end
end

%% Separate fields and determine number of random variables
% get distinct (totaly independent) fields "compare matrix"
CM=arrayfun(@(i,j) isequal(MATERIAL.S{i},MATERIAL.S{j}),repmat(1:MATERIAL.Settings.RF.N_rf,MATERIAL.Settings.RF.N_rf,1),repmat(1:MATERIAL.Settings.RF.N_rf,MATERIAL.Settings.RF.N_rf,1)','UniformOutput',true);

% "FieldRandomVariable" info
FRV=zeros(MATERIAL.nfields,2);
% pick and enumerate field indexes by distinguishing different rows of CM
% by this one can say how many SETS of RV one needs and with what fields
% these sets are associated
[~,~,FRV(:,1)]=unique(CM,'rows');
% asociate all fields with its number of eigenmodes and ID of a SET of RVs
FRV(:,2)=cellfun(@(A) size(A,2),MATERIAL.S);
% unique fields
uF=unique(FRV,'rows');
% total number of distinctive random variables needed (second entry)
nRV=sum(uF(:,2));

%% Generate samples of random variables
% Get samples by generating a sparse-grid
[MATERIAL.XiNodes, MATERIAL.XiWeights] = nwspgr(MATERIAL.Settings.Collocation.QuadRule, nRV, MATERIAL.Settings.Collocation.Accuracy);
% Check whether the accuracy is sufficent
while nchoosek(nRV+MATERIAL.Settings.Collocation.DoP,nRV)>size(MATERIAL.XiNodes,1)
    MATERIAL.Settings.Collocation.Accuracy=MATERIAL.Settings.Collocation.Accuracy+1;
    [MATERIAL.XiNodes, MATERIAL.XiWeights] = nwspgr(MATERIAL.Settings.Collocation.QuadRule, nRV, MATERIAL.Settings.Collocation.Accuracy);
end

% separate the random variables for each field to cell arrays
RV_F=mat2cell(MATERIAL.XiNodes,length(MATERIAL.XiWeights),uF(:,2));

% Generate normal/lognormal distributed randomfield
MATERIAL.RField_node=cell(MATERIAL.Settings.RF.N_rf,1);
RField_elem=cell(MATERIAL.Settings.RF.N_rf,1);
for i=1:MATERIAL.Settings.RF.N_rf
    if strncmpi(MATERIAL.Settings.RF.sampling{i},'lognormal',6)
        MATERIAL.RField_node{i}=exp(MEAN_t(i)+MATERIAL.MS{i}*RV_F{FRV(i,1)}');
        RField_elem{i}=MESH.NTE*exp(MEAN_t(i)+MATERIAL.MS{i}*RV_F{FRV(i,1)}');
    else
        MATERIAL.RField_node{i}=(MEAN_t(i)+MATERIAL.MS{i}*RV_F{FRV(i,1)}');
        RField_elem{i}=MESH.NTE*(MEAN_t(i)+MATERIAL.MS{i}*RV_F{FRV(i,1)}');
    end
end

MATERIAL.RField_elem=cell2mat(RField_elem);




