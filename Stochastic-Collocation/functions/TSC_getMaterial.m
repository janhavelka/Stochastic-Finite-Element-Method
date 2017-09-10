function MATERIAL = TSC_getMaterial(MESH,PROBLEM,MATERIAL)
% not complete function, should contain sophistical functions to get
% various material fields etc

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


% define real material conductvity
% true_mat=@(x,y) 1./(5+3*x.^2+2*y-y.*x)*100;
% MATERIAL.sigma=true_mat(MESH.Elements(:,5),MESH.Elements(:,6));

% Get randomfield(s) modes (normalized)
MATERIAL=RF_getModes(MESH,MATERIAL);

% Get randomfield(s) itself
MATERIAL=RF_getField(MESH,PROBLEM,MATERIAL);


























