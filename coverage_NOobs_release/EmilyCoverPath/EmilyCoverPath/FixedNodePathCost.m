%% function to compute the cost of a coverage tour, given a chosen node path
% ordering.  This version is for the s-t-path problem, with the start and
% goal node are given.  The data passed to this function consists of the
% locations of the "active" sensing nodes, i.e., the ones whose positions
% can be optimized.  It is passed in a "flat" form: a 1 \times (Problem D *
% (number of active nodes))
%%
function[cost] = FixedNodePathCost(CurSenseNodes)
global NumNodes ProblemD
global FixedNodeIncidence
global StartNode
%
% display(transpose(CurSenseNodes));
sum=0.0;
% since s1 is fixed to the StartNode location, find cost from StartNode to
% first sensing node
for j=1:(NumNodes-1)
    if FixedNodeIncidence(j) == 1                   % check to see if link is active
        jindex = (j-1) * ProblemD + 1;
        sensenodej = CurSenseNodes(jindex:(jindex+ProblemD-1));
        sum = sum + norm(sensenodej - StartNode);
    end
end
for i=1:(NumNodes-2)
    isense = (i-1) * ProblemD + 1;    
    si=CurSenseNodes(isense:(isense+ProblemD-1));
    for j=(i+1):(NumNodes-1)
        jarg = (j-1) * ProblemD + 1;
        sj=CurSenseNodes(jarg:(jarg+ProblemD-1));
        xi_arg = i * NumNodes - i*(i+1)/2 + (j-i);
        sum = sum + FixedNodeIncidence(xi_arg) * norm(si-sj); 
    end
end
% fprintf('FixedNodePathCost: %f\n',sum);
cost=sum;
end

