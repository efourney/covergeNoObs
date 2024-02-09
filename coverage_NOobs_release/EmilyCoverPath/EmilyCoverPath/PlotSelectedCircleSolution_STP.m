%% Function to visualize a "solution." It plots the target nodes and sensing radius
%  around each target node.  This version of the plotting routine uses the 
%  "incidence vector" form of the solution, which takes the form [\xi,s],
%  where \xi is the binary incidence vector, and s is a "flat"
%  representation of the sensing node (x,y) locations.
%  
function [] = PlotSelectedCircleSolution_STP(x,NodeCirc,SenseCirc)
global Nodes StartNode NumNodes
global NumBinaryVars NumContinuousVars NumVars
global SenseRadius
%
hold on;                                        % make sure all of the following graphics goes on the same plot
%% extract relevant data from solution vector x
xi = x(1:NumBinaryVars);                   % get the binary variables
s = x((1+NumBinaryVars):NumVars);          % get the continuous solution variables
sx=s(1:2:(NumContinuousVars-1));  sy=s(2:2:NumContinuousVars);   % get the x, y coordinates of the sensing nodes
%% Now plot lines that represent the decision variables connecting the sensing nodes
%  We first take care of the startnode, sinceit is the same as the first sensng node
for j=1:(NumNodes-1)                     % note, when j=1, then we are index \xi_{1,2}
    if xi(j) == 1
        line([StartNode(1),sx(j)],[StartNode(2),sy(j)],'Color','green','LineWidth',4);
        hold on;
    end
end
    % now we loop through all of the sensing nodes, starting at S2
for ixi=1:NumNodes-2
    for jxi=(ixi+1):(NumNodes-1)
        xi_index = ixi*NumNodes - ixi*(ixi+1)/2 + (jxi-ixi);
        % if the decision vector term \xi_{ixi,ixj} is one,
        if xi(xi_index) == 1
            line([sx(ixi),sx(jxi)],[sy(ixi),sy(jxi)],'Color','green','LineWidth',4);
            hold on;
        end
    end
end
%% plot the sensor node location
hold on;
pt=plot(sx,sy,'.','color','blue','MarkerSize',30);   % put cross-hairs at sensing locations
hold on;
%% plot selected sensing node (not target node) circles
if ismember(1,SenseCirc)
    fprintf('Plotting first SenseCircle at StartNode\n');
    viscircles(StartNode,SenseRadius,'LineStyle','--');
end

for i=2:NumNodes
    CurSenseNode =[sx(i-1),sy(i-1)];
    if ismember(i,SenseCirc)
        fprintf('Plotting Circle %i\n',i);
        viscircles(CurSenseNode,SenseRadius,'LineStyle','--');
        hold on;
    end
end
%% plot the problem input data: target nodes & sensing radii
    % sensing circles
for iplot=1:NumNodes
    CurNode=[Nodes(iplot,1), Nodes(iplot,2)];
        % plot target nodes as "dots"
    plot(CurNode(1),CurNode(2),'.','color','red','MarkerSize',20);
    hold on;
        % plot sensing range as circles for SELECTED Nodes
    if ismember(iplot,NodeCirc)
        fprintf('Plotting Node Circle %i\n',iplot);
        viscircles(CurNode,SenseRadius,'LineStyle','--');
        hold on;
    end
end      
hold off;
end
