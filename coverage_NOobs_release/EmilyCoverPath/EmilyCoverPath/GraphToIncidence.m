%% This section sets up the incidence vector, which is fixed in the Hoogeveen
%  heuristic.  We pass the incidence vector to subroutines by 
%  using the global variable "FixedIncidenceVector".  The incidence vector 
%  framework remains from the original focus of this work on the Opti Toolbox.  
%  For now, it is here for code compatibility and simplicity.
%
function [IVector] = GraphToIncidence(G)
global NumNodes
%
NIncidenceVariables = NumNodes * (NumNodes-1)/2;     % length of incidence vector
IVector = zeros(1, NIncidenceVariables);    % initially set all incidence variables to zero
GraphTable = G.Edges;                         % get edge information as a MATLAB table
nedges = height(GraphTable);                  % get the number of edges
for i=1:nedges                                % loop over the edges
    CurEdge = GraphTable{i,1};                % current edge to process
    s = CurEdge(1);  t = CurEdge(2);          % get indices of this edge
    if (s>t)
        temps = s;
        s = t; t = temps;
    end 
    xi_index = (s-1)*NumNodes - s*(s-1)/2 + (t-s);  % compute index into incidence vector
    IVector(xi_index) = 1;
end
