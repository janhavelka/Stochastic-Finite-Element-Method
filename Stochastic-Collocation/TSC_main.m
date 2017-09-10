

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

% Initiate the calculation (include folders, clear vars etc)
TSC_Initialize;

Input_lshape;
% InpuTSC_simple_wall;

% Edit MESH variables if needed (precompute necessary variables if they are missing)
MESH = MeshBasics( MESH );

% generate material fields according to MATERIAL.Settings
MATERIAL = TSC_getMaterial( MESH,PROBLEM,MATERIAL );

% get LOAD (right hand side vectors, transfer matrices, etc)
LOAD = TSC_getLoad( MESH,PROBLEM );

% solve problem
LOAD = TSC_solveProblem(MESH,PROBLEM,MATERIAL,LOAD);

BasePlot(MESH,mean(LOAD.RESP,2),[],{},'');
BasePlot(MESH,var(LOAD.RESP,1,2),[],{},'');







