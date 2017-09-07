function main_handle = BasePlot( MESH,Field,Labels )
% FigPos is a vector with 3 elements, distrbuting the figure on screen in the same way as subplot works
% Labels is a cell array containing {XLabel,YLabel,ZLabel,Title} - label for quiver plot is just a string defining a title
%
% % turn on anti-aliasing
% opengl('OpenGLLineSmoothingBug',1)

% number of contours
ncont=20;
% contour line width
lcont_grad=1;
lcont_field=1;

% presentation/paper font size
present_fs1=60;
present_fs2=75;

% normal font size
normal_fs1=15;
normal_fs2=20;

% quit plotting if NaNs are present
if any(isnan(Field(:)))
    error('The field consists of NaNs that cant be plotted!');
end

figure;
if ~isempty(FigPos)
    %place the figure on proper position on the screen
    position_figure(FigPos(1),FigPos(2),FigPos(3));
    
    % experimental - round the figure size (codec needs the image to be
    % divisible by 4)
    fig=gcf;
    fig.Position(3:4)=fig.Position(3:4)-mod(fig.Position(3:4),4);
end

% determine whether to plot surface of quiver plot or base plot
if isempty(Field)
    % JUST BACK MESH
    back_surf = trimesh(MESH.Elements(:,1:3),MESH.Nodes(:,1),MESH.Nodes(:,2),zeros(MESH.nnodes,1));
    set(back_surf,'EdgeColor','black',...
        'EdgeAlpha',0.8,...
        'FaceColor',[0.9 0.9 0.9],...
        'FaceAlpha',0.8,...
        'LineSmoothing','on'); % setup line smoothing (turn on anti-aliasing)
    if isempty(Labels)
        set(gca,'XGrid','on','YGrid','on','ZGrid','on','Color',[1 1 1]);
        if strncmpi(mode,'presentation',4)
            set(gca,'FontSize',present_fs1);
            set(get(gca,'XLabel'),'Interpreter','latex','String','$x$','FontSize',present_fs2);
            set(get(gca,'YLabel'),'Interpreter','latex','String','$y$','FontSize',present_fs2);
            set(get(gca,'ZLabel'),'Interpreter','latex','String','$z$','FontSize',present_fs2);
        else
            set(gca,'FontSize',normal_fs1);
            set(get(gca,'XLabel'),'Interpreter','latex','String','$x$','FontSize',normal_fs2);
            set(get(gca,'YLabel'),'Interpreter','latex','String','$y$','FontSize',normal_fs2);
            set(get(gca,'ZLabel'),'Interpreter','latex','String','$z$','FontSize',normal_fs2);
        end
    else
        set(gca,'XGrid','on','YGrid','on','ZGrid','on','Color',[1 1 1]);
        if strncmpi(mode,'presentation',4)
            set(gca,'FontSize',present_fs1);
            set(get(gca,'title'),'Interpreter','latex','String',Labels{4},'FontSize',present_fs2);
            set(get(gca,'XLabel'),'Interpreter','latex','String',Labels{1},'FontSize',present_fs2);
            set(get(gca,'YLabel'),'Interpreter','latex','String',Labels{2},'FontSize',present_fs2);
            set(get(gca,'ZLabel'),'Interpreter','latex','String',Labels{3},'FontSize',present_fs2);
        else
            set(gca,'FontSize',normal_fs1);
            set(get(gca,'title'),'Interpreter','latex','String',Labels{4},'FontSize',normal_fs2);
            set(get(gca,'XLabel'),'Interpreter','latex','String',Labels{1},'FontSize',normal_fs2);
            set(get(gca,'YLabel'),'Interpreter','latex','String',Labels{2},'FontSize',normal_fs2);
            set(get(gca,'ZLabel'),'Interpreter','latex','String',Labels{3},'FontSize',normal_fs2);
        end
    end
elseif any(size(Field)==MESH.nnodes)
    
    max_z=max(Field(:));
    min_z=min(Field(:));
    % SURFACE
    main_handle = trimesh(MESH.Elements(:,1:3),MESH.Nodes(:,1),MESH.Nodes(:,2),Field(:,1));
    set(main_handle,'FaceColor','interp','FaceAlpha',0.8,'EdgeColor','black','EdgeAlpha',0.65,...
        'FaceLighting','gouraud',...,...
        'EdgeLighting','gouraud',...
        'AmbientStrength',0.7,...
        'DiffuseStrength',0.8,...
        'SpecularColorReflectance',1,...
        'SpecularStrength',0.15,...
        'SpecularExponent',10,...
        'LineSmoothing','on'); % setup line smoothing (turn on anti-aliasing)
    
    hold all
    back_surf = trimesh(MESH.Elements(:,1:3),MESH.Nodes(:,1),MESH.Nodes(:,2),min_z*ones(MESH.nnodes,1));
    set(back_surf,'EdgeColor','black','EdgeAlpha',0.9,'FaceColor',[0.9 0.9 0.9],'FaceAlpha',0.9,...
        'FaceLighting','none',...
        'EdgeLighting','none',...
        'LineSmoothing','on'); % setup line smoothing (turn on anti-aliasing)
    set( gca, 'Zlim', [min_z,max_z+eps] );
    contour_handle = tricontour(MESH.Elements(:,1:3),MESH.Nodes(:,1:2),Field(:,1),ncont,min(get(gca,'ZLim'))+1e-3*abs(min(get(gca,'ZLim'))),lcont_field);
    %     contour_handle = tricontour(MESH.Elements(:,1:3),MESH.Nodes(:,1:2),Field(:,1),ncont,min(get(gca,'ZLim')),lcont_field);
%         contour_handle = tricontour(MESH.Elements(:,1:3),MESH.Nodes(:,1:2),Field(:,1),ncont,2.659e5,lcont_field);
    
    % save all data to main handle
    setappdata(main_handle,'back_surf',back_surf);
    setappdata(main_handle,'contour',contour_handle);
    setappdata(main_handle,'ZMin',min(get(gca,'ZLim')));
    setappdata(main_handle,'Elements',MESH.Elements(:,1:3));
    setappdata(main_handle,'Nodes',MESH.Nodes(:,1:2));
    setappdata(main_handle,'main_figure',gcf);
    
    if isempty(Labels)
        set(gca,'XGrid','on','YGrid','on','ZGrid','on','Color',[1 1 1]);
        if strncmpi(mode,'presentation',4)
            set(gca,'FontSize',present_fs1);
            set(get(gca,'XLabel'),'Interpreter','latex','String','$x$','FontSize',present_fs2);
            set(get(gca,'YLabel'),'Interpreter','latex','String','$y$','FontSize',present_fs2);
            set(get(gca,'ZLabel'),'Interpreter','latex','String','$z$','FontSize',present_fs2);
        else
            set(gca,'FontSize',normal_fs1);
            set(get(gca,'XLabel'),'Interpreter','latex','String','$x$','FontSize',normal_fs2);
            set(get(gca,'YLabel'),'Interpreter','latex','String','$y$','FontSize',normal_fs2);
            set(get(gca,'ZLabel'),'Interpreter','latex','String','$z$','FontSize',normal_fs2);
        end
    else
        set(gca,'XGrid','on','YGrid','on','ZGrid','on','Color',[1 1 1]);
        if strncmpi(mode,'presentation',4)
            set(gca,'FontSize',present_fs1);
            set(get(gca,'title'),'Interpreter','latex','String',Labels{4},'FontSize',present_fs2);
            set(get(gca,'XLabel'),'Interpreter','latex','String',Labels{1},'FontSize',present_fs2);
            set(get(gca,'YLabel'),'Interpreter','latex','String',Labels{2},'FontSize',present_fs2);
            set(get(gca,'ZLabel'),'Interpreter','latex','String',Labels{3},'FontSize',present_fs2);
        else
            set(gca,'FontSize',normal_fs1);
            set(get(gca,'title'),'Interpreter','latex','String',Labels{4},'FontSize',normal_fs2);
            set(get(gca,'XLabel'),'Interpreter','latex','String',Labels{1},'FontSize',normal_fs2);
            set(get(gca,'YLabel'),'Interpreter','latex','String',Labels{2},'FontSize',normal_fs2);
            set(get(gca,'ZLabel'),'Interpreter','latex','String',Labels{3},'FontSize',normal_fs2);
        end
    end
    %     view(40,55);
    %   lighting gouraud
    %     material dull
    
    % turn the light :)
    camlight head
    
    
elseif any(size(Field)==MESH.nelements) && any(size(Field)==2)
    % GRADIENTS
    % plot back surface
    back_surf = trimesh(MESH.Elements(:,1:3),MESH.Nodes(:,1),MESH.Nodes(:,2),zeros(MESH.nnodes,1));
    set(back_surf,'EdgeColor','black',...
        'EdgeAlpha',0.9,...
        'FaceColor',[0.9 0.9 0.9],...
        'FaceAlpha',0.9,...
        'LineSmoothing','on'); % setup line smoothing (turn on anti-aliasing)
    hold all
    % plot gradient contours
    contour_handle = tricontour(MESH.Elements(:,1:3),MESH.Nodes(:,1:2),MESH.ETN*sqrt(Field(:,1).^2+Field(:,2).^2),ncont,0,lcont_grad);
    % plot gradients
    main_handle=quiver(MESH.Elements(:,5),MESH.Elements(:,6),Field(:,1),Field(:,2),'LineWidth',1.0,'Color',[0 0 1]);
    
    % save all data to main handle
    setappdata(main_handle,'back_surf',back_surf);
    setappdata(main_handle,'contour',contour_handle);
    setappdata(main_handle,'Elements',MESH.Elements(:,1:3));
    setappdata(main_handle,'Nodes',MESH.Nodes(:,1:2));
    setappdata(main_handle,'ETN',MESH.ETN);
    setappdata(main_handle,'main_figure',gcf);
    
    axis equal
    axis off
    view(0,90);
    set(gca,'XGrid','on','YGrid','on','Color',[1 1 1]);
    if strncmpi(mode,'presentation',4)
        set(gca,'FontSize',present_fs1);
        xlabel('$x\,\mathrm{[m]}$','Interpreter','latex','FontSize',present_fs2);
        ylabel('$y\,\mathrm{[m]}$','Interpreter','latex','FontSize',present_fs2);
        title(Labels,'Interpreter','latex','FontSize',present_fs2);
    else
        set(gca,'FontSize',normal_fs1);
        xlabel('$x\,\mathrm{[m]}$','Interpreter','latex','FontSize',normal_fs2);
        ylabel('$y\,\mathrm{[m]}$','Interpreter','latex','FontSize',normal_fs2);
        title(Labels,'Interpreter','latex','FontSize',normal_fs2);
    end
    set( gca, 'Xlim', [min(MESH.Nodes(:,1)),max(MESH.Nodes(:,1))] );
    set( gca, 'Ylim', [min(MESH.Nodes(:,2)),max(MESH.Nodes(:,2))] );
else
    error('Wrong input field');
end

if strncmpi(mode,'presentation',4)
    % ---------------------------------------
    set(gca,'color','w');
    set(gcf,'color','w');
    % ---------------------------------------
        axis off
    title('');
end
