%%ensure you have cvx toolbox on the path!
%%ensure emilycoverpath folder is on path!

%nodePos-target locations, slight misnomer name
nodePos = [-.2,0;...
    .4,.5;...
    1.9,1.25;...
    1.2,1;...
    1,0;...
    1.5,0;...
    3,3;...
    1.5,2.3;
    1.5,1.5;
    1,2;
    2,1;
    4,4;
    -1,-1;
    2.8,0;
    .5,4;
    3.5,1.5;
    %new for elon
    3.2,1.6;
    2.86,1;
    3,1.3; %change this to left for intersection
    3.5,1;
    2.7,.5;
    3.1,.4;
    %end new 4 elon
    3.05,-.8;
    -.2,2];

%do we want to find the base set of smallest size? if yes, isMin is true,
%else leave as false for random selection
isMin = false;
%sensing radius r
r = .5;


%%end of set up, begin code

%we want to set up a graph whos ndoes are targets and edge weights are distance
startPos = nodePos(1,:);
endNode = num2str(length(nodePos));
[s,t,w] = noObstEdge(nodePos);
weights = w;
G = graph(s,t,weights);



%overlapping graph-edge denotes overlap
%probably more efficient way, just easy for concept 
Gt = graph();
Gt = addnode(Gt,height(G.Nodes));
t1 = num2cell(1:height(G.Nodes));
t1 = string(t1);
t1 = cellstr(t1);
Gt.Nodes.Name = t1';
f = find(G.Edges.Weight<=2*r);
for i = f'
    Gt = addedge(Gt,G.Edges.EndNodes(i,1),G.Edges.EndNodes(i,2)...
        );
end

%find base set and reconstruct our edge weights
[baseIndex, Gbase] = findBaseSet(Gt,isMin);
[Gbase] = addEdgeWeights(Gbase,G); %G has no node labels!

%construct list of base node targets with location for easy access
basenodepos = [];
for i = 1:height(Gbase.Nodes.Name)
    baseindcur = str2num(Gbase.Nodes.Name{i});
    basenodepos(end+1,:) = [baseindcur nodePos(baseindcur,:)];
end




%construct the list of node positions for hoogeven/"joel's code"
%number of last node is endNode
%nodes4joel = sensing node location for hoogeveen
nodes4joel = [nodePos(1,:)]; %first and last matters, rest dont
indexOGnodes = [1];
for i = 1:height(Gbase.Nodes)
    nodeCent = nodePos(str2double(Gbase.Nodes.Name{i}),:);
    if str2double(Gbase.Nodes.Name{i}) == 1
    else
        indexOGnodes(end+1) = str2double(Gbase.Nodes.Name{i});
        indOfBase = find(str2double(Gbase.Nodes.Name{i}) == basenodepos(:,1));
        %nodes4joel(end+1,:) = basenodepos(indOfBase,2:3);
        if isempty(Gbase.Nodes.Neighbors{i})
            theti = rand(1)*360;
            nodes4joel(end+1,:) = nodePos(str2double(Gbase.Nodes.Name{i}),:);
        else
            curCell = Gbase.Nodes.Neighbors{i}{1};
            totalPoints = [];
            for j = 1:length(curCell)
                neighStr = curCell{j};
                if str2double(neighStr) ~= 1
                    neighPos = nodePos(str2double(neighStr),:);
                    parentPos = nodePos(str2double(Gbase.Nodes.Name{i}),:);
                    vecp2n = neighPos-parentPos;
                    middle = parentPos+r.*vecp2n./norm(vecp2n);
                    totalPoints = [totalPoints;middle];
                end
            end
            centroid = [mean(totalPoints(:,1)) mean(totalPoints(:,2))];
            if all(centroid == nodePos(str2double(Gbase.Nodes.Name{i}),:))
                theti = rand(1)*360;
                nodes4joel(end+1,:) = nodePos(str2double(Gbase.Nodes.Name{i}),:)+r.*[cos(theti) sin(theti)];
            else
                vec2point = centroid-nodePos(str2double(Gbase.Nodes.Name{i}),:);
                pointOnCirc = nodePos(str2double(Gbase.Nodes.Name{i}),:)+ r.*vec2point./norm(vec2point);
                nodes4joel(end+1,:) = pointOnCirc;
            end
        end
    end
    if ~isempty(Gbase.Nodes.Neighbors{i})
        curCell = Gbase.Nodes.Neighbors{i}{1};
        for j = 1:length(curCell)
            neighStr = curCell{j};
            if str2double(neighStr) ~= 1
                indexOGnodes(end+1) = str2double(neighStr);
                neighPos = nodePos(str2double(neighStr),:);
                parentPos = nodePos(str2double(Gbase.Nodes.Name{i}),:);
                vecp2n = neighPos-parentPos;
                middle = parentPos+r.*vecp2n./norm(vecp2n);
                nodes4joel(end+1,:) = middle; %for the neighbor
            end
        end
    end
end
[~,order] = sort(indexOGnodes);
indexOGnodes = indexOGnodes(order);

%want to just ensure that sensing node for nth target is nth node
nodes4joel = nodes4joel(order,:);


%copy of pathheuristic script runs hoogeveen
tic
Copy_of_PathHeuristic_Script
nosensreduxhoogtime = toc;

%helpful figure for visualization but unneccesary
% figure
% hold on
% for i = 1:NumNodes-1
%     p1 = HoogeveenPath.Nodes.Location(i,:);
%     ind = find(HoogeveenPath.Edges.EndNodes(:,1) == i); 
%     p2 = HoogeveenPath.Nodes.Location(HoogeveenPath.Edges.EndNodes(ind,2),:);
%     plot([p1(1) p2(1)],[p1(2) p2(2)],'r','LineWidth',2)
% end
% 
% hold on
% eps = .05;
% for i = 1:length(nodePos)
%     plot(nodePos(i,1),nodePos(i,2), 'o')
%     viscircles([nodePos(i,1),nodePos(i,2)],r,'LineStyle','--','Color','k')
%     for j = 1:height(Gbase.Nodes)
%         if str2num(Gbase.Nodes.Name{j})==i
%             viscircles([nodePos(i,1),nodePos(i,2)],r,'Color','b')
%         end
%     end
%     txt = num2str(i);
%     text(nodePos(i,1)+eps,nodePos(i,2)+eps,txt)
% end

%1 is the 0th start node!
emilyFullNode1stFix = [nodePos];
%get order of node visits
nodeOrderHoog = 1;
while length(nodeOrderHoog) < height(HoogeveenPath.Nodes)
    fir = nodeOrderHoog(end);
    for i = 1:height(HoogeveenPath.Edges)
        if fir == HoogeveenPath.Edges.EndNodes(i,1)
            nodeOrderHoog(end+1) = HoogeveenPath.Edges.EndNodes(i,2);
        end
    end
end

poses = HoogeveenPath.Nodes.Location;
poses = poses(nodeOrderHoog,:);
lengthHoogS = sum(vecnorm(diff(poses),2,2));

circCentsOrderHoog = emilyFullNode1stFix(nodeOrderHoog,:);

tic;
x = emCvxOpt(circCentsOrderHoog,r);
time4opt = toc;

[sensNodeLoc] = sensNodReduxOptSIMPL(r,nodePos,x);



%plot figures to see paths and nodes
figure
hold on
for i = 1:NumNodes-1
    p1 = HoogeveenPath.Nodes.Location(i,:);
    ind = find(HoogeveenPath.Edges.EndNodes(:,1) == i); 
    p2 = HoogeveenPath.Nodes.Location(HoogeveenPath.Edges.EndNodes(ind,2),:);
    plot([p1(1) p2(1)],[p1(2) p2(2)],'r','LineWidth',2)
end

for i = 2:length(nodes4joel)
        txt1 = num2str(i);
    if length(txt1) >= 2
        txt = ['S_' txt1(1) '_' txt1(2)];
    else
        txt = ['S_' (txt1)];
    end
    plot(nodes4joel(i,1),nodes4joel(i,2),'r*')
    text(nodes4joel(i,1)+eps,nodes4joel(i,2)+eps,txt)

end

hold on
eps = .05;
for i = 1:length(nodePos)
    plot(nodePos(i,1),nodePos(i,2), 'o')
    viscircles([nodePos(i,1),nodePos(i,2)],r,'LineStyle','--','Color','k');
    for j = 1:height(Gbase.Nodes)
        if str2num(Gbase.Nodes.Name{j})==i
            viscircles([nodePos(i,1),nodePos(i,2)],r,'Color','b');
        end
    end
    txt1 = num2str(i);
    if length(txt1) >= 2
        txt = ['T_' txt1(1) '_' txt1(2)];
    else
        txt = ['T_' (txt1)];
    end
    text(nodePos(i,1)+eps,nodePos(i,2)+eps,txt)
end

hold on
for i = 1:length(x)-1
    p1 = x(i,:);
    p2 = x(i+1,:);
    plot([p1(1) p2(1)],[p1(2) p2(2)],'k','LineWidth',2)
end

plot(x(:,1),x(:,2),'*k')
plot(sensNodeLoc(:,1),sensNodeLoc(:,2),'.b')
