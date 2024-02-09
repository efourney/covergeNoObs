%% Simple function to check if a graph is disconnected.  This function is REALLY
%  inefficient due to MATLAB's way of dealing with graphs.  It is easy to
%  check if an undirected graph is disconnected by using the conncomp function.  
%  BUT, conncomp applied to a directed graph divides the graph into
%  components that are all connected by TWO way connections.  Hence, we
%  convert the directed graph temporarily to an undirected graph, and then
%  check for discontinuity.  Perhaps there is a more efficient way in MATLAB?
%
function [status] = disconnected(G)
[s,t]=findedge(G);
unG = graph(s,t);
partvect = conncomp(unG) - 1;          
if find(partvect)>0
    fprintf('ERROR:  Graph is disconnected in Hamiltonian ShortCut\n\n');
    status = true;                              % exists=false is maintained;
else
    status = false;
end
end