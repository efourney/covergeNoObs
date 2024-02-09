function [sensNodeLoc] = sensNodReduxOptSIMPL(r,targCent,x)
%find reduced set of sensing nodes
totCellofL = cell(length(targCent(:,1)),2);
curleng = 0;
for i = 2:length(x(:,1))
    lineSeg = x(i-1:i,:);
    for j = 1:length(targCent(:,1))
        [points] = pointsIntLineSegCirc(lineSeg(1,:),lineSeg(2,:),targCent(j,:),r);
        if isempty(points) %numerical issues fix :/
            [points] = pointsIntLineSegCirc(lineSeg(1,:),lineSeg(2,:),targCent(j,:),r+r/100);
        end
        
        if ~isempty(points)
            if length(points(:,1)) == 1
            points = [points;points];
            end
            start = points(1,:);
            fin = points(2,:);
            Ls = norm(start-lineSeg(1,:))+curleng;
            Lf = norm(fin-lineSeg(1,:))+curleng;
            totCellofL{j,1}(end+1,1:2) = [Ls,Lf];
            totCellofL{j,2}(end+1,1:4) = [start,fin];
        end
    end
    curleng = curleng+norm(lineSeg(1,:)-lineSeg(2,:));
end

%we know at least one point is viewing each region, so we fill in in case
%of numerical issues
totLeng = 0;
for i = 2:length(totCellofL(:,1))
    totLeng = totLeng + norm(x(i,:)-x(i-1,:));
    if isempty(totCellofL{i,1})
        totCellofL{i,1} = [totLeng totLeng];
        totCellofL{i,2} = [x(i,:),x(i,:)];
    end
end
%now we have a bunch of l's for each target, should have at least one per
%target.
LbyTarg = zeros(length(targCent(:,1)),3);
PbyTarg = zeros(length(targCent(:,1)),4);
for i = 1:length(totCellofL(:,1))
    %curList is already sorted
    curList = totCellofL{i,1};
    curPoin = totCellofL{i,2};
    j = 2;
    while j<=length(curList(:,1))
        if abs(curList(j-1,2)-curList(j,1))<=.001
            curList(j-1,:) = [curList(j-1,1),curList(j,2)];
            curPoin(j-1,:)=[curPoin(j-1,1:2),curPoin(j,3:4)];
            curList(j,:) = [];
            curPoin(j,:) = [];
            j = j-1;
        end
        j = j+1;
    end
    %consolidated now
    LbyTarg(i,:) = [i,curList(1,:)];
    PbyTarg(i,:) = curPoin(1,:);
end
%now we just need to sort and pull and we are done!
[~,ind] = sort(LbyTarg(:,2));
LbyTarg = LbyTarg(ind,:);
if any(LbyTarg(:,2)>LbyTarg(:,3))
    ind2swap = LbyTarg(:,2)>LbyTarg(:,3);
    LbyTargCopy = LbyTarg;
    LbyTarg(ind2swap,2) = LbyTargCopy(ind2swap,3);
    LbyTarg(ind2swap,3) = LbyTargCopy(ind2swap,2);
    PbyTargCopy = PbyTarg;
    PbyTarg(ind2swap,1:2) = PbyTargCopy(ind2swap,3:4);
    PbyTarg(ind2swap,3:4) = PbyTargCopy(ind2swap,1:2);
end
PbyTarg = PbyTarg(ind,:);

%we want to work from end to begininng;
sensNodeLoc = [];
targCov = {};
while ~isempty(LbyTarg)
sensNodeLoc(end+1,:) = PbyTarg(end,1:2);
curLinSens = LbyTarg(end,2);
inds2rem = curLinSens<=LbyTarg(:,3)+.0001 & curLinSens>=LbyTarg(:,2)-.0001;
targCov{end+1} = LbyTarg(inds2rem,1);
LbyTarg(inds2rem,:) = [];
PbyTarg(inds2rem,:) = [];
end
end