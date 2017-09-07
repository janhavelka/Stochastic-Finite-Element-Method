%   Similar to subplot(), position_figure() divides the screen into rectangular
%   panes to position figures in.
%
%   Syntax:
%            position_figure(no_rows, no_columns, fig_no)
%
%      where  
%               'no_rows' is the total number of figure-rows
%            'no_columns' is the total number of figure-columns
%                'fig_no' is the running number of the current figure
%                                (numbered row-wise)
%
%   Example: position_figure(2, 3, 4) divides the screen into 6 rectangles that
%            are arranged in 2 rows and 3 columns. The current figure is placed
%            in the lower left corner of the screen.
%
%   See also SUBPLOT.
%
%   Copyright Christoph Feenders, 2012


function position_figure(no_rows, no_columns, fig_no)

    % handle absurd parameters
    assert(no_rows > 0, 'Number of rows "no_rows" must be a positive integer.')
    assert(no_columns > 0, 'Number of colums "no_columns" must be a positive integer.')

    % determine figure-position in terms of row and column
    [col,row] = ind2sub([no_columns no_rows], mod(fig_no-1, no_rows*no_columns) + 1);
    
    % calculate figure position and dimensions according to screen
    scrsz = get(0, 'ScreenSize');
    
    if strcmp(get(gcf, 'MenuBar'), 'figure')
        pos =  [ 1 + scrsz(3)*(   col-1  )/no_columns ... % left
                 6 + scrsz(4)*(no_rows-row)/no_rows ...   % bottom
                 scrsz(3)/no_columns - 1 ...              % width
                 scrsz(4)/no_rows - 87 ];                 % height
    else % if plot-icons are switched off
        pos =  [ 1 + scrsz(3)*(   col-1  )/no_columns ... % left
                 6 + scrsz(4)*(no_rows-row)/no_rows ...   % bottom
                 scrsz(3)/no_columns - 1 ...              % width
                 scrsz(4)/no_rows - 33 ];                 % height
    end
         
	% reposition and resize current figure
    set(gcf, 'Position', pos);
   
end
