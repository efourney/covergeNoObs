%% simple function to plot just the problem data, not the solution
%  Plots dots at the Target Nodes, and SenseRadius circles around the targets
function [] = PlotNodes_STP()
% Plot the nodes and their sensing regions
global Nodes StartNode NumNodes
global NumBinaryVars NumContinuousVars NumVars
global SenseRadius

n=NumNodes;
xlim([-1,9]);  ylim([-1,9]);
hold on;
    % plot the problem input data
plot(StartNode(1),StartNode(2),'.','color','blue','MarkerSize',20);
    hold on;
    viscircles(StartNode,SenseRadius);
for iplot=2:NumNodes
    CurNode=[Nodes(iplot,1), Nodes(iplot,2)];
    plot(CurNode(1),CurNode(2),'.','color','red','MarkerSize',20);
    hold on;
    viscircles(CurNode,SenseRadius);
end  
hold off;
end     % of function

