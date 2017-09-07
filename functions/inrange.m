function out=inrange( mainVal,compareVal,tol )
% This function takes the mainVal and compares it with compareVal, with
% tolerance +-tol.
% The output is than 0 is mainVal doesnt lie in the range or 1 if it does
% example: inrange(5,4,0.5) gives 1, because 5 lies in range of 2 and 6

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

compMax=compareVal*(1+tol);
compMin=compareVal*(1-tol);

if compMin<mainVal && compMax>mainVal
    out=true;
else
    out=false;
end


end

