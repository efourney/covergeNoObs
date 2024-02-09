%% script to test the Hoogeveen Heuristic for the s-t Path problem
Path_Global                         % Load in global variables and the Nodes definitions
global OptCounter
   % Create an initial graph to modify with the heuristic.
StartGraph = MaximallyConnectedPathGraph();
plot(StartGraph);           % choose the complete graph on the nodes
   % apply Christofides s-t path heuristic
HoogeveenPath = Emily_Hoogeveen(StartGraph);                 % use the s-t path Christofides heuristic to get a graph
%Emilys addition   
% HoogeveenPath.Nodes.Location = Nodes;
% figure
% hold on
% for i = 1:NumNodes-1
%     p1 = HoogeveenPath.Nodes.Location(i,:);
%     ind = find(HoogeveenPath.Edges.EndNodes(:,1) == i); 
%     p2 = HoogeveenPath.Nodes.Location(HoogeveenPath.Edges.EndNodes(ind,2),:);
%     plot([p1(1) p2(1)],[p1(2) p2(2)],'r')
% end

%UNCOMMENT TO WORK ON FULL SUITE
% Convert data in graph form to Incidence Vector form
FixedNodeIncidence = GraphToIncidence(HoogeveenPath);  % convert graph path to Incidence vector 
    % set up the initial guess of the sensing node locations needed by the optimizer
    %  Note that the optimizer works with a "flat" representation of the
    %  sensing nodes: S = (S_1x, S_1y, S_2x, S_2y, ...., S_nx, S_ny);
SenseNodes0 = zeros(1,((NumNodes-1) * ProblemD));         % allocate space for the sensing node vector, in incidence form
for i=1:(NumNodes-1)
    index = (i-1)*ProblemD + 1;
    SenseNodes0(index:(index+ProblemD-1)) = Nodes((i+1),:);
end
%% optimize the sensing node locations, given fixed order of tour through nodes
OptimizedSenseNodes = FixedPathOptimization(SenseNodes0);

% now plot the results--need data in the particular incidence form for the plotting function                                                   
xlim([-2,7]);  ylim([-4,6]);
PlotIncidence = [FixedNodeIncidence, transpose(OptimizedSenseNodes)];
% PlotIncidence = [FixedNodeIncidence, SenseNodes0];
PlotPathIncidenceSolution(PlotIncidence);

%% now check to see if any nodes can be removed
    % First convert optimized sensing node locations to a graph form:
SenseLocations = {};   SenseLocations{1} = transpose(StartNode);
for i=2:NumNodes
    SenseLocations{i} = OptimizedSenseNodes(((i-2)*ProblemD + 1):((i-1)*ProblemD));
end
SolutionGraph = HoogeveenPath;                 % get the node order from above
SolutionGraph.Nodes.Location = transpose(SenseLocations); % update the sensing node locations
PlotPathGraphSolution(SolutionGraph);

    % Now check if reductions are possible due to overlaps
ReducedGraph = RemoveSensingOverlaps(SolutionGraph);
PlotPathGraphSolution(ReducedGraph)

%% now use this result in the BONMIN optimizer for comparison
optresult = TourFind_STP(PlotIncidence);
