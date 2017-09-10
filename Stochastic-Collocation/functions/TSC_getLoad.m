function LOAD = TSC_getLoad( MESH,PROBLEM )

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


% get the boundary data according to boundary conditions defined in input file
LOAD = TSC_getBoundary(MESH,PROBLEM,struct());

% get augmented matrices
LOAD = TSC_getAugment(MESH,PROBLEM,LOAD);

% get Current Patterns (CP) in each electrode in each cycle and RHS
LOAD = TSC_getRHS(MESH,PROBLEM,LOAD);

end

