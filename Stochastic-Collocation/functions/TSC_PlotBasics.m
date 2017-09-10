function handles=T_PlotBasics(MESH,PROBLEM,LOAD,RESP,PlotID,handles)

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


% mode='presentation';
mode='normal';
video_pause=0.15;

%% Plot response for currents applied and the response field
if PlotID == 1
    pot_field=BasePlot( MESH,LOAD.M_cf,[1,2,1],{'$x\,\mathrm{[m]}$','$y\,\mathrm{[m]}$','$P\,\mathrm{[V]}$','Potential field'},mode );
    %     view(0,90);
    rhs_field=BasePlot( MESH,full(LOAD.RHS(:,1)),[1,2,2],{'$x\,\mathrm{[m]}$','$y\,\mathrm{[m]}$','$I\,\mathrm{[mA]}$','Applied currents'},mode );
    %     view(0,90);
    pause(0.1);
    
    % iterate over current patterns
    for c_idx=2:size(RESP,2)
        % update the current field
        UpdatePlot( pot_field,RESP(:,c_idx) );
        UpdatePlot( rhs_field,full(LOAD.RHS(:,c_idx)) );
        pause(0.1);
    end;
end













%% Draw response field + gradients
if PlotID == 3
    if isempty(handles)
        % draw the potential field
        pot_field=BasePlot( MESH,LOAD.M_cf,[1,3,1],{'$x\,\mathrm{[m]}$','$y\,\mathrm{[m]}$','$u\quad\mathrm{[^oC]}$','$\mathrm{Potential\,field}$'},mode );
        
        % get coordinates of electrodes and plot them
        X=[MESH.Nodes(LOAD.Electrodes.Elements(:,1),1),MESH.Nodes(LOAD.Electrodes.Elements(:,2),1)]';
        Y=[MESH.Nodes(LOAD.Electrodes.Elements(:,1),2),MESH.Nodes(LOAD.Electrodes.Elements(:,2),2)]';
        Z=[LOAD.M_cf(LOAD.Electrodes.Elements(:,1),1),LOAD.M_cf(LOAD.Electrodes.Elements(:,2),1)]';
        electrode_scheme=plot3(X,Y,Z,'r','LineWidth',3);
        
        % distribute basis derivatives along diagonal of an matrix for
        % gradient calculation without cycle over elements
        r=reshape(repmat(1:2*MESH.nelements,3,1),6,[]);
        c=repmat(reshape(1:3*MESH.nelements,3,[]),2,1);
        GM=sparse(r,c,MESH.B);
        
        % calculate gradients of potential field (to include material -
        % multiply diagonal block elements of GM with corresponding values/tensors)
        q_pot=-GM*LOAD.M_cf(MESH.Elements(:,1:3)',:);
        % plot the gradient and electrodes
        grad_field=BasePlot( MESH,reshape(q_pot(:,1),2,[])',[1,3,2],'Currents',mode );
        plot(X,Y,'r','LineWidth',3);
        % save the matrix for generating gradients
        setappdata(grad_field,'GM',GM);
        
        % plot solution field (material in each iteration)
        sigma_field=BasePlot( MESH,MESH.ETN*RESP.sigma,[1,3,3],{'$x\,\mathrm{[m]}$','$y\,\mathrm{[m]}$','$\sigma\quad\mathrm{[\frac{W}{m^2\cdot ^oC}]}$','$\mathrm{Conductivity\,field}$'},mode );
        
        sigma_true_field = trimesh(MESH.Elements(:,1:3),MESH.Nodes(:,1),MESH.Nodes(:,2),MESH.ETN*RESP.sigma_true);
        set(sigma_true_field,'EdgeColor','black','EdgeAlpha',0.6,'FaceColor',[0.9 0.9 0.9],'FaceAlpha',0.5,...
            'AmbientStrength',0.7,...
            'DiffuseStrength',0.8,...
            'SpecularColorReflectance',1,...
            'SpecularStrength',0.2,...
            'SpecularExponent',10);
        back_mesh=getappdata(sigma_field,'back_surf');
        min_zval=min([RESP.sigma_true(:);RESP.sigma(:)]);
        max_zval=max([RESP.sigma_true(:);RESP.sigma(:)]);
        back_mesh.Vertices(:,3)=min_zval;
        setappdata(sigma_field,'ZMin',min_zval);
        set(gca,'ZLim',[min_zval,max_zval]);
        
        % VIDEO RECORD
        if PROBLEM.Video.Record
            pot = VideoWriter('pot.avi','Motion JPEG AVI');
            pot.Quality=PROBLEM.Video.Quality;
            pot.FrameRate=PROBLEM.Video.FrameRate;
            open(pot);
            
            grad = VideoWriter('grad.avi','Motion JPEG AVI');
            grad.Quality=PROBLEM.Video.Quality;
            grad.FrameRate=PROBLEM.Video.FrameRate;
            open(grad);
            
            mat = VideoWriter('mat.avi','Motion JPEG AVI');
            mat.Quality=PROBLEM.Video.Quality;
            mat.FrameRate=PROBLEM.Video.FrameRate;
            open(mat);
        end
        % VIDEO RECORD
        
        % iterate over current patterns
        UpdatePlot( sigma_field,MESH.ETN*RESP.sigma );
        for c_idx=1:size(LOAD.M_cf,2)
            % update the current field
            UpdatePlot( pot_field,LOAD.M_cf(:,c_idx) );
            UpdatePlot( electrode_scheme,[LOAD.M_cf(LOAD.Electrodes.Elements(:,1),c_idx),LOAD.M_cf(LOAD.Electrodes.Elements(:,2),c_idx)]);
            UpdatePlot( grad_field,reshape(q_pot(:,c_idx),2,[])' );
            % VIDEO RECORD            
            if PROBLEM.Video.Record
                writeVideo(pot,getframe(getappdata(pot_field,'main_figure')));
                writeVideo(grad,getframe(getappdata(grad_field,'main_figure')));
                writeVideo(mat,getframe(getappdata(sigma_field,'main_figure')));
            end
            % VIDEO RECORD
            pause(video_pause);
        end;
        
        % VIDEO RECORD
        if PROBLEM.Video.Record
            setappdata(sigma_field,'video_file',mat);
            setappdata(grad_field,'video_file',grad);
            setappdata(pot_field,'video_file',pot);
        end
        % VIDEO RECORD
        handles={pot_field,electrode_scheme,grad_field,sigma_field};
    else % if you have the handles - just update the fields
        % Gradient of potential field
        q_pot=-getappdata(handles{3},'GM')*LOAD.M_cf(MESH.Elements(:,1:3)',:);
        
        UpdatePlot( handles{4},MESH.ETN*RESP.sigma );
        for c_idx=1:size(LOAD.M_cf,2)
            % update the current field
            UpdatePlot( handles{1},LOAD.M_cf(:,c_idx) );
            UpdatePlot( handles{2},[LOAD.M_cf(LOAD.Electrodes.Elements(:,1),c_idx),LOAD.M_cf(LOAD.Electrodes.Elements(:,2),c_idx)]);
            UpdatePlot( handles{3},reshape(q_pot(:,c_idx),2,[])' );
            pause(video_pause);
            % VIDEO RECORD
            if PROBLEM.Video.Record
                writeVideo(getappdata(handles{1},'video_file'),getframe(getappdata(handles{1},'main_figure')));
                writeVideo(getappdata(handles{3},'video_file'),getframe(getappdata(handles{3},'main_figure')));
                writeVideo(getappdata(handles{4},'video_file'),getframe(getappdata(handles{4},'main_figure')));
            end
            % VIDEO RECORD
        end;
    end
end






%% Draw response field + material + material difference
if PlotID == 4
    if isempty(handles)
        % draw the potential field
        pot_field=BasePlot( MESH,LOAD.M_cf,[1,3,1],{'$x\,\mathrm{[m]}$','$y\,\mathrm{[m]}$','$u\quad\mathrm{[^oC]}$','$\mathrm{Potential\,field}$'},mode );
        
        % get coordinates of electrodes and plot them
        X=[MESH.Nodes(LOAD.Electrodes.Elements(:,1),1),MESH.Nodes(LOAD.Electrodes.Elements(:,2),1)]';
        Y=[MESH.Nodes(LOAD.Electrodes.Elements(:,1),2),MESH.Nodes(LOAD.Electrodes.Elements(:,2),2)]';
        Z=[LOAD.M_cf(LOAD.Electrodes.Elements(:,1),1),LOAD.M_cf(LOAD.Electrodes.Elements(:,2),1)]';
        electrode_scheme=plot3(X,Y,Z,'r','LineWidth',3);
        
        % plot the gradient and electrodes
        err_field=BasePlot( MESH,MESH.ETN*(RESP.sigma./RESP.sigma_true),[1,3,2],{'$x\,\mathrm{[m]}$','$y\,\mathrm{[m]}$','$\lambda_i/\lambda_t$','$\mathrm{Conductivity\,fit}$'},mode );
        set(gca,'ZLim',[0,1.5]);
        
        % plot solution field (material in each iteration)
        sigma_field=BasePlot( MESH,MESH.ETN*RESP.sigma,[1,3,3],{'$x\,\mathrm{[m]}$','$y\,\mathrm{[m]}$','$\sigma\quad\mathrm{[S/m]}$','$\mathrm{Conductivity\,field}$'},mode );
        
        sigma_true_field = trimesh(MESH.Elements(:,1:3),MESH.Nodes(:,1),MESH.Nodes(:,2),MESH.ETN*RESP.sigma_true);
        set(sigma_true_field,'EdgeColor','black','EdgeAlpha',0.6,'FaceColor',[0.9 0.9 0.9],'FaceAlpha',0.5,...
            'AmbientStrength',0.7,...
            'DiffuseStrength',0.8,...
            'SpecularColorReflectance',1,...
            'SpecularStrength',0.2,...
            'SpecularExponent',10);
        back_mesh=getappdata(sigma_field,'back_surf');
        min_zval=min([RESP.sigma_true(:);RESP.sigma(:)]);
        max_zval=max([RESP.sigma_true(:);RESP.sigma(:)]);
        back_mesh.Vertices(:,3)=min_zval;
        setappdata(sigma_field,'ZMin',min_zval);
        set(gca,'ZLim',[min_zval,max_zval]);
        
        % VIDEO RECORD
        if PROBLEM.Video.Record
            pot = VideoWriter('pot.avi','Motion JPEG AVI');
            pot.Quality=PROBLEM.Video.Quality;
            pot.FrameRate=PROBLEM.Video.FrameRate;
            open(pot);
            
            err = VideoWriter('err.avi','Motion JPEG AVI');
            err.Quality=PROBLEM.Video.Quality;
            err.FrameRate=PROBLEM.Video.FrameRate;
            open(err);
            
            mat = VideoWriter('mat.avi','Motion JPEG AVI');
            mat.Quality=PROBLEM.Video.Quality;
            mat.FrameRate=PROBLEM.Video.FrameRate;
            open(mat);
        end
        % VIDEO RECORD
        
        % iterate over current patterns
        UpdatePlot( sigma_field,MESH.ETN*RESP.sigma );
        UpdatePlot( err_field,MESH.ETN*(RESP.sigma./RESP.sigma_true) );
        for c_idx=1:size(LOAD.M_cf,2)
            % update the current field
            UpdatePlot( pot_field,LOAD.M_cf(:,c_idx) );
            UpdatePlot( electrode_scheme,[LOAD.M_cf(LOAD.Electrodes.Elements(:,1),c_idx),LOAD.M_cf(LOAD.Electrodes.Elements(:,2),c_idx)]);
            % VIDEO RECORD            
            if PROBLEM.Video.Record
                writeVideo(pot,getframe(getappdata(pot_field,'main_figure')));
                writeVideo(err,getframe(getappdata(err_field,'main_figure')));
                writeVideo(mat,getframe(getappdata(sigma_field,'main_figure')));
            end
            % VIDEO RECORD
            pause(video_pause);
        end;        
        % VIDEO RECORD
        if PROBLEM.Video.Record
            setappdata(sigma_field,'video_file',mat);
            setappdata(err_field,'video_file',err);
            setappdata(pot_field,'video_file',pot);
        end        
        % VIDEO RECORD
        handles={pot_field,electrode_scheme,err_field,sigma_field};
    else % if you have the handles - just update the fields        
        UpdatePlot( handles{3},MESH.ETN*(RESP.sigma./RESP.sigma_true) );
        UpdatePlot( handles{4},MESH.ETN*RESP.sigma );
        for c_idx=1:size(LOAD.M_cf,2)
            % update the current field
            UpdatePlot( handles{1},LOAD.M_cf(:,c_idx) );
            UpdatePlot( handles{2},[LOAD.M_cf(LOAD.Electrodes.Elements(:,1),c_idx),LOAD.M_cf(LOAD.Electrodes.Elements(:,2),c_idx)]);
            pause(video_pause);
            % VIDEO RECORD
            if PROBLEM.Video.Record
                writeVideo(getappdata(handles{1},'video_file'),getframe(getappdata(handles{1},'main_figure')));
                writeVideo(getappdata(handles{3},'video_file'),getframe(getappdata(handles{3},'main_figure')));
                writeVideo(getappdata(handles{4},'video_file'),getframe(getappdata(handles{4},'main_figure')));
            end
            % VIDEO RECORD
        end;
    end
end






if PlotID == 5
    %  plot electrode and material
    BasePlot( MESH,[],[1,2,1],{'$x\,\mathrm{[m]}$','$y\,\mathrm{[m]}$','',''},mode );
    hold all
    plot([MESH.Nodes(MESH.Boundary.Elements(:,1),1),MESH.Nodes(MESH.Boundary.Elements(:,2),1)]',...
        [MESH.Nodes(MESH.Boundary.Elements(:,1),2),MESH.Nodes(MESH.Boundary.Elements(:,2),2)]','k','LineWidth',1.5);
    % plot the electrodes
    X=[MESH.Nodes(LOAD.Electrodes.Elements(:,1),1),MESH.Nodes(LOAD.Electrodes.Elements(:,2),1)]';
    Y=[MESH.Nodes(LOAD.Electrodes.Elements(:,1),2),MESH.Nodes(LOAD.Electrodes.Elements(:,2),2)]';
    plot(X,Y,'b','LineWidth',4);
    % plot the identifiers
    text(mean(X),mean(Y),num2str((1:LOAD.Electrodes.nelements)'),'FontSize',40,'Color','blue','HorizontalAlignment','center','VerticalAlignment','bottom');
    axis equal
    axis off
    view(0,90);
    
    % plot solution field (material in each iteration)
    sigma_field=BasePlot( MESH,MESH.ETN*RESP.sigma,[1,2,2],{'$x\,\mathrm{[m]}$','$y\,\mathrm{[m]}$','$\sigma\quad\mathrm{[S/m]}$','$\mathrm{Conductivity\,field}$'},mode );
    sigma_true_field = trimesh(MESH.Elements(:,1:3),MESH.Nodes(:,1),MESH.Nodes(:,2),MESH.ETN*RESP.sigma_true);
    set(sigma_true_field,'EdgeColor','black','EdgeAlpha',0.6,'FaceColor',[0.9 0.9 0.9],'FaceAlpha',0.5,...
        'AmbientStrength',0.7,...
        'DiffuseStrength',0.8,...
        'SpecularColorReflectance',1,...
        'SpecularStrength',0.2,...
        'SpecularExponent',10);
    back_mesh=getappdata(sigma_field,'back_surf');
    min_zval=min([RESP.sigma_true(:);RESP.sigma(:)]);
    max_zval=max([RESP.sigma_true(:);RESP.sigma(:)]);
    back_mesh.Vertices(:,3)=min_zval;
    setappdata(sigma_field,'ZMin',min_zval);
    set(gca,'ZLim',[min_zval,max_zval]);
    UpdatePlot( sigma_field,MESH.ETN*RESP.sigma );
    
end



%% Support plots
% Plot the centroids, boundary nodes,elements, node id, element ids
if PlotID == -1
    figure
    back_mesh = trimesh(MESH.Elements(:,1:3),MESH.Nodes(:,1),MESH.Nodes(:,2),zeros(MESH.nnodes,1));
    set(back_mesh,'EdgeColor','black','FaceColor',[0.9 0.9 0.9]);
    hold all
    plot([MESH.Nodes(MESH.Boundary.Elements(:,1),1),MESH.Nodes(MESH.Boundary.Elements(:,2),1)]',...
        [MESH.Nodes(MESH.Boundary.Elements(:,1),2),MESH.Nodes(MESH.Boundary.Elements(:,2),2)]','k','LineWidth',1.5);
    % plot the boundary elements
    X=[MESH.Nodes(MESH.Boundary.Elements(:,1),1),MESH.Nodes(MESH.Boundary.Elements(:,2),1)]';
    Y=[MESH.Nodes(MESH.Boundary.Elements(:,1),2),MESH.Nodes(MESH.Boundary.Elements(:,2),2)]';
    plot(X,Y,'b','LineWidth',2);
    % plot the identifiers
    text(mean(X),mean(Y),num2str((1:MESH.Boundary.nelements)'),'Color','blue','HorizontalAlignment','center','VerticalAlignment','bottom');
    % plot the centers
    plot(MESH.Elements(:,5),MESH.Elements(:,6),'or','MarkerEdgeColor','black','MarkerFaceColor','red','MarkerSize',3);
    text(MESH.Elements(:,5),MESH.Elements(:,6),num2str((1:MESH.nelements)'),'Color','red','HorizontalAlignment','left','VerticalAlignment','bottom')
    % plot nodes and identify them
    text(MESH.Nodes(:,1),MESH.Nodes(:,2),num2str((1:MESH.nnodes)'),'Color','black','HorizontalAlignment','left','VerticalAlignment','bottom')
    axis equal
    axis off
    view(0,90);
    savefig(gcf,fullfile(cd,'mesh',MESH.MeshName));
end

% plot the electrodes and measurements
if PlotID == -2
    figure;
    back_mesh = trimesh(MESH.Elements(:,1:3),MESH.Nodes(:,1),MESH.Nodes(:,2),zeros(MESH.nnodes,1));
    set(back_mesh,'EdgeColor','black','FaceColor',[0.9 0.9 0.9]);
    hold all
    plot([MESH.Nodes(MESH.Boundary.Elements(:,1),1),MESH.Nodes(MESH.Boundary.Elements(:,2),1)]',...
        [MESH.Nodes(MESH.Boundary.Elements(:,1),2),MESH.Nodes(MESH.Boundary.Elements(:,2),2)]','k','LineWidth',1.5);
    % plot the electrodes
    X=[MESH.Nodes(LOAD.Electrodes.Elements(:,1),1),MESH.Nodes(LOAD.Electrodes.Elements(:,2),1)]';
    Y=[MESH.Nodes(LOAD.Electrodes.Elements(:,1),2),MESH.Nodes(LOAD.Electrodes.Elements(:,2),2)]';
    plot(X,Y,'b','LineWidth',2);
    % plot the identifiers
    text(mean(X),mean(Y),num2str((1:LOAD.Electrodes.nelements)'),'Color','blue','HorizontalAlignment','center','VerticalAlignment','bottom');
    
    % plot the measurement nodes
    % any - for ALL inject patterns
    scatter(MESH.Nodes(any(LOAD.Electrodes.m_nodes,2),1),MESH.Nodes(any(LOAD.Electrodes.m_nodes,2),2),10,'MarkerEdgeColor',[.7 .1 .1],...
        'MarkerFaceColor',[0.7 .1 .1],...
        'LineWidth',1.5)
        % plot the identifiers
    text(MESH.Nodes(any(LOAD.Electrodes.m_nodes,2),1),MESH.Nodes(any(LOAD.Electrodes.m_nodes,2),2),num2str((1:sum(any(LOAD.Electrodes.m_nodes,2)))'),'Color','red','HorizontalAlignment','center','VerticalAlignment','bottom');
    
    
    %     % plot the grounding node
    %     plot(MESH.Nodes(LOAD.Electrodes.GN,1),MESH.Nodes(LOAD.Electrodes.GN,2),'or','MarkerEdgeColor','black','MarkerFaceColor','red');
    %     text(MESH.Nodes(LOAD.Electrodes.GN,1),MESH.Nodes(LOAD.Electrodes.GN,2),'GR','Color','red','HorizontalAlignment','left','VerticalAlignment','bottom');
    title('Electrode and measurement scheme')
    axis equal
    axis off
    view(0,90);
    % save figure to outputs
    savefig(gcf,[fullfile(cd,'output',MESH.MeshName),'_electrodes']);
end