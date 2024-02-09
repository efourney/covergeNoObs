function [ baseIndx, Gbase ] = findBaseSet( G ,minBS)
%G is graph with all nodes, if sensing circles overlap, edge exists 
%   Detailed explanation goes here
%allnODES-cANIDATE nodes to check

Galt = G;
allNodes = 1:height(G.Nodes);
baseNodes = [];
n = length(allNodes);
baseNodes = [1 n];

%for i = 2:n-1
for i = 1:n   
    check = false;
    for k = 1:height(G.Edges)
        if str2num(G.Edges.EndNodes{k,1}) == i || str2num(G.Edges.EndNodes{k,2}) == i
            check = true;
        end
    end
    if check
    else
        baseNodes(end+1)=i;
        allNodes(i) = 0; 
    end
end
%starting position is fixed, graph is passed in with T2-Tn
%     i = 1;
%     while i <= height(Galt.Edges)
%         if str2num(Galt.Edges.EndNodes{i,1})==1 || str2num(Galt.Edges.EndNodes{i,1})==n
% %             if  str2num(Galt.Edges.EndNodes{i,2})~=n && str2num(Galt.Edges.EndNodes{i,2})~=1 
%             Galt = rmnode(Galt,Galt.Edges.EndNodes{i,2});
%             i = 1;
% %             else
% %                 i = i+1;
% %             end
%             
%         elseif str2num(Galt.Edges.EndNodes{i,2})==1 || str2num(Galt.Edges.EndNodes{i,2})==n
% %            if  str2num(Galt.Edges.EndNodes{i,1})~=n && str2num(Galt.Edges.EndNodes{i,1})~=1 
%             Galt = rmnode(Galt,Galt.Edges.EndNodes{i,1});
%             i = 1;
%  %           else
%  %               i = i+1;
%   %          end
%         else
%             i = i+1;
%         end
%         %remove all nodes touching 1, n 
%     end

allNodes = allNodes(allNodes~=0);
%initialize the neighbor table
neighbors = cell(height(Galt.Nodes),1);
Galt.Nodes.Neighbors = neighbors;
[baseIndx, allNodes,Gbase] = recursiveBigNode(baseNodes, allNodes,Galt,minBS);
end

function [base, allNodes,Galt] = recursiveBigNode(base, allNodes, Galt,minBS)
    if height(Galt.Edges) == 0
    else
    n = length(allNodes);
    count = zeros(1,n);
    for i = 1:n
%         sum1 = sum(str2num(cell2mat(Galt.Edges.EndNodes(:,1)))==allNodes(i));
%         sum2 = sum(str2num(cell2mat(Galt.Edges.EndNodes(:,2)))==allNodes(i));
        %count(i) = sum(sum(Galt.Edges.EndNodes==allNodes(i)));
        sumx = 0;
        for j = 1:height(Galt.Edges)
            if str2num(Galt.Edges.EndNodes{j,1}) == allNodes(i) || str2num(Galt.Edges.EndNodes{j,2}) == allNodes(i)
                sumx = sumx+1;
            end
        end
        count(i) = sumx;
    end
    if minBS
        [~,ind] = min(count);
    else
        [~,ind] = max(count);
    end
    %ind = randsample(n,1);
    
    ind = ind(1);
    base(end+1) = allNodes(ind);
    i = 1;
    curNeb = cell(1,1);
    while i <= height(Galt.Edges)
        if str2num(Galt.Edges.EndNodes{i,1})==(allNodes(ind))
            curNeb{1,1}(end+1) = {Galt.Edges.EndNodes{i,2}};
            Galt = rmnode(Galt,Galt.Edges.EndNodes{i,2});
            i = 1;
        elseif str2num(Galt.Edges.EndNodes{i,2})==(allNodes(ind))
            curNeb{1,1}(end+1) = {Galt.Edges.EndNodes{i,1}};
            Galt = rmnode(Galt,Galt.Edges.EndNodes{i,1});
            i = 1;
        else
            i = i+1;
        end
        %after this ,nodes in base set have no edges,
        %Galt is left only with the nodes in the base set
        %curNeb has all the neighbors
        nodeName = num2str(allNodes(ind));
        for l = 1:height(Galt.Nodes)
            if str2num(Galt.Nodes.Name{l}) == allNodes(ind)
                Galt.Nodes.Neighbors{l} = curNeb;
            end
        end

    end
    allNodes(ind) = [];
    [base, allNodes,Galt] = recursiveBigNode(base, allNodes, Galt,minBS);
    end
end
