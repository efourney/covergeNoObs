%% function to make a maximally connected graph from the covering nodes for the 
%  s-t path case.  Node, nodes s and t are not connected.  Note that the
%  Node (x,y) locations are added as attributes to the Nodes--this is not
%  really necessary for the STP tour, but is done for even compatibility
%  with parts of code.
%
function [MaxGraph] = MaximallyConnectedPathGraph()
global StartNode
global Nodes NumNodes
global ProblemD
%
NodeLocations = {};                     % initialize cell array for node locations
n_total = NumNodes;                     % total number of nodes, including Start node
    % now build the graph
s = []; t = []; w = [];                 % allocated space
    % build edges between StartNode and all nodes, except Goal Node.
for i=2:(NumNodes -1)                   % make connections between s and all nodes except t
    s = [s,1]; t = [t,i];
    wsi = norm(Nodes(i,:)-StartNode);   % weight of the edge is Euclidean distance between nodes
    w = [w,wsi];
end
    % Now build edges between nodes N_2,...,N_n
for i=2:(NumNodes-1)
    for j=(i+1):NumNodes
        s = [s, i];
        t = [t, j];
        Nodei = Nodes(i,:);
        Nodej = Nodes(j,:);
        wij = norm(Nodei-Nodej);
        w = [w, wij];
    end
end
for j=1:NumNodes
    NodeLocations{j} = Nodes(j,:);
end
MaxGraph = graph(s,t,w);
MaxGraph.Nodes.Location = transpose(NodeLocations);
end

