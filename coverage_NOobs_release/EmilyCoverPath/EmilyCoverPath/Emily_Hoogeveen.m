%% Verion of Hoogeveen algorithm to find sub-optimal s-t Path that calls a new
%  Hamiltonian ShortCut algorithm
%  Takes input of a MATLAB graph describing the covering nodes and a candidate 
%  set of edges.  The output is a directed graph that describes the
%  Covering Path
%
function [PathGraph] = Emily_Hoogeveen(StartGraph)
global StartNode
global NumNodes Nodes 
global MyMplusT
global testmode
global stats
   % first find the minimum spanning tree
MST = minspantree(StartGraph);                % find the minimum spanning tree, MST 
   % now find the "wrong degree nodes."  These are the odd degree nodes for
   % nodes N2,...,N_(n-1), and the nodes s and/or t if they have even degree
match_nodes = [];                                    % list of nodes that need perfect matching
node_degrees = degree(MST);
odd_inner_nodes = find(mod(node_degrees(2:(NumNodes-1)),2));   % find the odd-degree nodes in N2,...,N(n-1)
adjusted_odd_inner_nodes = odd_inner_nodes + 1;      % indices are off by one, since we dropped the StartNode, GoalNode
if find(adjusted_odd_inner_nodes)~= 0                % add any odd degree nodes to the matching list
    try
        match_nodes = [match_nodes,adjusted_odd_inner_nodes];
    catch
        match_nodes = [match_nodes',adjusted_odd_inner_nodes];
    end
end
   % next check the start and goal node degrees
if (mod(node_degrees(1),2)==0)                % if start node has even degree, it must be matched
    fprintf('  Hoogeveen:  start node must be matched\n');
    try
        match_nodes = [match_nodes', 1];
    catch
        match_nodes = [match_nodes, 1];
    end
end
if (mod(node_degrees(NumNodes),2)==0)             % if goal node has even degree, it must be matched
    % match_nodes = [match_nodes, (NumNodes+1)];  % ERRROR due to change in NumNodes concept
    try
        match_nodes = [match_nodes', NumNodes];
    catch
         match_nodes = [match_nodes, NumNodes];
    end

end
%% now check to see if Perfect Matching is necessary
if length(match_nodes) == 0                           % no matches required 
    fprintf('Hoogeveen (path): no perfect matching required');
    MplusT = MST;                                     % the min span tree is the tour
else
    if mod(length(match_nodes),2) ==1
        fprintf('Hoogeveen (path):  ERROR--odd number of nodes to match\n');
        return;
    else                                              % if we get this far, matches are needed
        fprintf('Hoogeveen: Number of match nodes = %i\n',length(match_nodes));
        EdgeListCA = Min_Perfect_Match(match_nodes);  % find the minimum perfect matching, returned as cell array
        Nedges = length(EdgeListCA);                  % how many matched edges were found
        %fprintf('Nedges = %i\n',Nedges);
        MplusT = MST;                                 % start with the MST
        for i=1:Nedges
            edge=EdgeListCA{i};                       % an edge to be added to MST
            try
                Node1 = Nodes(edge(1),:);
                Node2 = Nodes(edge(2),:);
                edgeweight=norm(Node1-Node2);             % calculate edge weight
                MplusT=addedge(MplusT,edge(1),edge(2),edgeweight);  % add edge from perfect match to MST grap
            catch
            end
        end
    end
end
MyMplusT   = MplusT;

[EulerGraph,exists] = Directed_Euler_Trail_STP(MplusT);        % find the Eulerian tour of MplusT

if (exists==0)
    fprintf('  Hoogeveen: problem in Directed Euler Trail STP\m');
end
%remove weights hack
EulerGraph = digraph(EulerGraph.Edges.EndNodes(:,1),EulerGraph.Edges.EndNodes(:,2));
PathGraph  = Emily_HamiltonianShortcut(EulerGraph);
end
