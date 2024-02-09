% quadratic (nonlinear) constraint that defines sensing radius.  This version is
% specialized for the case of a fixed node s-t path problem.  NOTE: sensing
% node 1 is fixed to the same location as N1, and does not appear in the
% optimization variables.  So, the "SensNodes" input is s2,...,sn
function [lhs] = FixedNodePathSenseConstraint(SenseNodes)
global NumNodes Nodes
global ProblemD

Cvect=zeros((NumNodes-1),1);                 % create the cost vector, and initially set to zero
for i=1:(NumNodes-1)
    n_index = (i-1) * ProblemD +1;
    sx = SenseNodes(n_index);   sy = SenseNodes(n_index+1);  % get location of (i+1)^th sensing node
    nodex = Nodes((i+1),1);  nodey = Nodes((i+1),2);                 % location of nodes to cover
    Cvect(i)= (sx-nodex)^2 + (sy-nodey)^2;                   
end
lhs=Cvect;
end
