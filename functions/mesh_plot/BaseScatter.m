function [main_handle,tendency_handle,text_handle] = BaseScatter( ERR,FigPos,Labels,Flag,step )
% FigPos is a vector with 3 elements, distrbuting the figure on screen in the same way as subplot works
% Labels is a cell array containing {XLabel,YLabel,ZLabel,Title} - label for quiver plot is just a string defining a title




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


figure;
if ~isempty(FigPos)
    %place the figure on proper position on the screen
    position_figure(FigPos(1),FigPos(2),FigPos(3));
end

if isempty(step)
    step=1;
end
% determine whether to plot surface of quiver plot
% X=ERR.X(step,:,:);
X=(1./ERR.Y(:,step,:));
if Flag==0
    temp=ERR.temp_err(:,step,:);
    % plot scatter
    main_handle = scatter(X(:),temp(:));
    set( gca, 'Ylim', [min(ERR.temp_err(:)),max(ERR.temp_err(:))] );
    set(gca,'xscale','log');
    set(gca,'yscale','log');
    
    if isempty(Labels)
        set(gca,'XGrid','on','YGrid','on','Color',[1 1 1]);
        set(gca,'FontSize',15);
        set(get(gca,'XLabel'),'Interpreter','latex','String','$N$','FontSize',20);
        set(get(gca,'YLabel'),'Interpreter','latex','String','$err$','FontSize',20);
    else
        set(gca,'XGrid','on','YGrid','on','ZGrid','on','Color',[1 1 1]);
        set(gca,'FontSize',15);
        set(get(gca,'title'),'Interpreter','latex','String',Labels{3},'FontSize',20);
        set(get(gca,'XLabel'),'Interpreter','latex','String',Labels{1},'FontSize',20);
        set(get(gca,'YLabel'),'Interpreter','latex','String',Labels{2},'FontSize',20);
    end
    
elseif Flag==1
    moist=(ERR.moist_err(:,step,:));
    % plot scatter
    main_handle = scatter(X(:),moist(:));
    set( gca, 'Ylim', [min(ERR.moist_err(:)),max(ERR.moist_err(:))] );
    set(gca,'xscale','log');
    set(gca,'yscale','log');
    
    if isempty(Labels)
        set(gca,'XGrid','on','YGrid','on','Color',[1 1 1]);
        set(gca,'FontSize',15);
        set(get(gca,'XLabel'),'Interpreter','latex','String','$N$','FontSize',20);
        set(get(gca,'YLabel'),'Interpreter','latex','String','$err$','FontSize',20);
    else
        set(gca,'XGrid','on','YGrid','on','ZGrid','on','Color',[1 1 1]);
        set(gca,'FontSize',15);
        set(get(gca,'title'),'Interpreter','latex','String',Labels{3},'FontSize',20);
        set(get(gca,'XLabel'),'Interpreter','latex','String',Labels{1},'FontSize',20);
        set(get(gca,'YLabel'),'Interpreter','latex','String',Labels{2},'FontSize',20);
    end
elseif Flag==2
    temp=ERR.temp_err(:,step,:);
    % plot scatter
    main_handle = scatter(X(:),temp(:));
    set( gca, 'Ylim', [min(ERR.temp_err(:)),max(ERR.temp_err(:))] );
    set(gca,'xscale','log');
    set(gca,'yscale','log');
    hold all
    x_point=[X(round(size(X,1)/4),1,1),X(round(size(X,1)*3/4),1,1)];
    y_point=[mean(ERR.temp_err(round(size(X,1)/4),step,:),3),mean(ERR.temp_err(round(size(X,1)*3/4),step,:),3)];
    rate=log10(x_point(2)/x_point(1))/log10(y_point(2)/y_point(1));
    c=y_point(2)-rate*x_point(2);
    tendency_handle = plot(x_point,y_point,'--r','LineWidth',2);
    text_handle=text(x_point(1),y_point(1)*1000,sprintf('c=%e, rate %.3f',c,rate),'VerticalAlignment','top');
    
    if isempty(Labels)
        set(gca,'XGrid','on','YGrid','on','Color',[1 1 1]);
        set(gca,'FontSize',15);
        set(get(gca,'XLabel'),'Interpreter','latex','String','$N$','FontSize',20);
        set(get(gca,'YLabel'),'Interpreter','latex','String','$err$','FontSize',20);
    else
        set(gca,'XGrid','on','YGrid','on','ZGrid','on','Color',[1 1 1]);
        set(gca,'FontSize',15);
        set(get(gca,'title'),'Interpreter','latex','String',Labels{3},'FontSize',20);
        set(get(gca,'XLabel'),'Interpreter','latex','String',Labels{1},'FontSize',20);
        set(get(gca,'YLabel'),'Interpreter','latex','String',Labels{2},'FontSize',20);
    end
    
elseif Flag==3
    moist=(ERR.moist_err(:,step,:));
    % plot scatter
    main_handle = scatter(X(:),moist(:));
    set( gca, 'Ylim', [min(ERR.moist_err(:)),max(ERR.moist_err(:))] );
    set(gca,'xscale','log');
    set(gca,'yscale','log');
    hold all
    x_point=[X(round(size(X,1)/4),1,1),X(round(size(X,1)*3/4),1,1)];
    y_point=[mean(ERR.moist_err(round(size(X,1)/4),step,:),3),mean(ERR.moist_err(round(size(X,1)*3/4),step,:),3)];
    rate=log10(x_point(2)/x_point(1))/log10(y_point(2)/y_point(1));
    c=y_point(2)-rate*x_point(2);
    tendency_handle = plot(x_point,y_point,'--r','LineWidth',2);
    text_handle=text(x_point(1),y_point(1)*1000,sprintf('c=%e, rate %.3f',c,rate),'VerticalAlignment','top');
    
    if isempty(Labels)
        set(gca,'XGrid','on','YGrid','on','Color',[1 1 1]);
        set(gca,'FontSize',15);
        set(get(gca,'XLabel'),'Interpreter','latex','String','$N$','FontSize',20);
        set(get(gca,'YLabel'),'Interpreter','latex','String','$err$','FontSize',20);
    else
        set(gca,'XGrid','on','YGrid','on','ZGrid','on','Color',[1 1 1]);
        set(gca,'FontSize',15);
        set(get(gca,'title'),'Interpreter','latex','String',Labels{3},'FontSize',20);
%         set(get(gca,'title'),'Interpreter','latex','String',[Labels{3} ', rate' sprintf('%.3f',rate)],'FontSize',20);
        set(get(gca,'XLabel'),'Interpreter','latex','String',Labels{1},'FontSize',20);
        set(get(gca,'YLabel'),'Interpreter','latex','String',Labels{2},'FontSize',20);
    end
end

if Flag==0 || Flag==1
    tendency_handle=handle(0);
    text_handle=handle(0);
end
