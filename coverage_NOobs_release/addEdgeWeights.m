function [Gbase] = addEdgeWeights(Gbase,G); %G has no node labels!
%ADDEDGEWEIGHTS Summary of this function goes here
%   Detailed explanation goes here
n = height(Gbase.Nodes);

for i = 1:n-1
    for j = n-i+1:-1:2
        s = i;
        t= j+i-1;
        node1Num4G = str2num(Gbase.Nodes.Name{s});
        node2Num4G = str2num(Gbase.Nodes.Name{t});
        for k = 1:height(G.Edges)
            if G.Edges.EndNodes(k,1) == node1Num4G || G.Edges.EndNodes(k,2) == node1Num4G
                if G.Edges.EndNodes(k,1) == node2Num4G || G.Edges.EndNodes(k,2) == node2Num4G
                    w = G.Edges.Weight(k);
                end
            end
        end
        Gbase = addedge(Gbase,Gbase.Nodes.Name{s},Gbase.Nodes.Name{t},w);
    end
end


end

