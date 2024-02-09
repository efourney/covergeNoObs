%% Function to visualize a "graph solution." It plots the target nodes and sensing radius
%  around each target node.  This version of the plotting routine uses a
%  graph representation of the solution.  It assumes that the Start Node is
%  the first node in the graph.
%  
function [] = PlotPathGraphSolution_Alt
(G)
global Nodes NumNodes
global SenseRadius
%
hold on;                             % make sure all of the following graphics goes on the same plot
%% plot the problem input data: target nodes & boundary of sensing region constraints
for iplot=1:NumNodes
    CurNode=[Nodes(iplot,1), Nodes(iplot,2)];
        % plot target nodes as "dots"
    plot(CurNode(1),CurNode(2),'.','color','red','MarkerSize',20);
    hold on;
        % plot sensing range as circles
    viscircles(CurNode,SenseRadius,'LineStyle','--');
end  
hold on;
%% Now plot the solution encoded in the input graph
GraphTable = G.Edges;                     % get edge information as a MATLAB table
nedges = height(GraphTable);              % get the number of edges
fprintf(' In Plot Graph, there are %i edges\n',nedges);
for i=1:nedges                            % loop over the edges
    CurEdge = GraphTable{i,1};            % current edge to process
    CurIndex = CurEdge(1);  NextIndex = CurEdge(2);   % get indices of this edge
    CurNode = G.Nodes.Location{CurIndex};   NextNode = G.Nodes.Location{NextIndex};
    fprintf('At step %i, processing edge (%i,%i)\n',i,CurIndex,NextIndex);
    line([CurNode(1),NextNode(1)],[CurNode(2),NextNode(2)],'Color','green','LineWidth',3);    
    plot(CurNode(1),CurNode(2),'.','color','blue','MarkerSize',30);   % put dot at sensing locations
    plot(NextNode(1),NextNode(2),'.','color','blue','MarkerSize',30);   % put dot at sensing locations
    end
hold off;
end
