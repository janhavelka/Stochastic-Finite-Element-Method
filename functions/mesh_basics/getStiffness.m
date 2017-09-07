
function K=getStiffness(MESH,lambda)




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


if size(lambda,2)==1
    % isotropic case
    K=sparse(MESH.R_s,MESH.C_s,MESH.B_c.*lambda(:,ones(1,9))');
elseif size(lambda,2)==3
    % anisotropic case
    phi=lambda(:,3);
    m1=lambda(:,1);
    m2=lambda(:,2);
    d1=cos(phi./180*pi).^2.*m1+sin(phi./180*pi).^2.*m2;
    d2=sin(phi./180*pi).^2.*m1+cos(phi./180*pi).^2.*m2;
    d3=cos(phi./180*pi).*sin(phi./180*pi).*m1-cos(phi./180*pi).*sin(phi./180*pi).*m2;
    
%     k_1=MESH.B(1:3,:).*repmat(d1,1,3)'+MESH.B(4:6,:).*repmat(d3,1,3)';
%     k_1=MESH.B(1:3,:).*d1(:,[1 1 1])'+MESH.B(4:6,:).*d3(:,[1 1 1])';
    k_1=bsxfun(@times,d1',MESH.B(1:3,:))+bsxfun(@times,d3',MESH.B(4:6,:));
%     k_2=MESH.B(1:3,:).*repmat(d3,1,3)'+MESH.B(4:6,:).*repmat(d2,1,3)';
%     k_2=MESH.B(1:3,:).*d3(:,[1 1 1])'+MESH.B(4:6,:).*d2(:,[1 1 1])';
    k_2=bsxfun(@times,d3',MESH.B(1:3,:))+bsxfun(@times,d2',MESH.B(4:6,:));
    
%     val=k_1([1 2 3 1 2 3 1 2 3],:).*MESH.B([1 1 1 2 2 2 3 3 3],:)+k_2([1 2 3 1 2 3 1 2 3],:).*MESH.B([4 4 4 5 5 5 6 6 6],:);
    val_dummy=k_1([1 1 1 2 2 3],:).*MESH.B([1 2 3 2 3 3],:)+k_2([1 1 1 2 2 3],:).*MESH.B([4 5 6 5 6 6],:);
    val=val_dummy([1 2 3 2 4 5 3 5 6],:);
    
    K=sparse(MESH.R_s,MESH.C_s,val);
end










