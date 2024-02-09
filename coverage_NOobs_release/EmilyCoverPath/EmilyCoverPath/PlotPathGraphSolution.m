% Function to visualize an s-t-path "graph solution." It plots the target 
%  nodes.  Then we step along the path, ploting the path edges between
%  nodes, and then the sensing circles around the optimized sensing
%  locations.
%  It assumes that the Start Node is the first node in the graph.
%  
function [] = PlotPathGraphSolution(G)
global Nodes NumNodes
global SenseRadius
%
hold on;                             % make sure all of the following graphics goes on the same plot
%% plot the problem input data: target nodes & boundary of sensing region constraints
for iplot=1:NumNodes
    CurNode=[Nodes(iplot,1), Nodes(iplot,2)];
        % plot target nodes as "dots"
    plot(CurNode(1),CurNode(2),'.','color','red','MarkerSize',40);
    hold on;
        % plot sensing range as circles
end  
hold on;
%% Now plot the solution encoded in the input graph
CurIndex = 1;
done = false;
while ~done
    CurXY = G.Nodes.Location{CurIndex};
    NextIndex = successors(G,CurIndex);
        % check if we are at the end of the path
    if isempty(NextIndex)
        plot(CurXY(1),CurXY(2),'.','color','blue','MarkerSize',30);   % put dot at sensing locations
        done = true;
        fprintf('   PlotGraphSolution:  finishing\n');
        % viscircles(CurNode,SenseRadius,'LineStyle','--');
    else         % if not at the end, plot
        NextXY = G.Nodes.Location{NextIndex(1)};
        fprintf('   CurIndex = %i, NextIndex = %i\n',CurIndex,NextIndex);
        line([CurXY(1),NextXY(1)],[CurXY(2),NextXY(2)],'Color','green','LineWidth',3);    
        plot(CurXY(1),CurXY(2),'.','color','blue','MarkerSize',30);   % put dot at sensing locations
        CurIndex = NextIndex(1);
        viscircles([CurXY(1),CurXY(2)],SenseRadius,'LineStyle','--');
        viscircles([NextXY(1),NextXY(2)],SenseRadius,'LineStyle','--');
    end
end
hold off;
end     % function