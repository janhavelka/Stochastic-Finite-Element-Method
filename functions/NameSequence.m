function out_name = NameSequence( in_name,in_folder,in_delimiter,in_suffix,level_up )





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


if ~isempty(level_up) && level_up>0
    for i=1:level_up
        cd ..
    end
end

if isempty(in_delimiter)
    in_delimiter='_';
end
if isempty(in_folder)
    in_folder='';
end
if isempty(in_name)
    in_name='new_file';
end
if isempty(in_suffix)
    in_suffix='';
end

out_name=fullfile(cd,in_folder,[in_name,in_suffix]);
if exist(out_name,'file')~=0
    count=1;
    while exist(out_name,'file')~=0
        new_name=fullfile(cd,in_folder,[in_name,in_delimiter,sprintf('%d',count),in_suffix]);
        count=count+1;
        out_name=new_name;
    end
else
    out_name=fullfile(cd,in_folder,[in_name,in_suffix]);
end

end

