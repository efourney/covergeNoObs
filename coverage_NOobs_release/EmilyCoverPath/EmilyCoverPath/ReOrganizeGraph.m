%% function to "reorganize" a DIRECTED graph so that its node index are in
%  sequential order, but with the correct node locations
function [NewG] = ReOrganizeGraph(G)
done = false;
%
NodeLocations = {};
NewG = digraph;
NewG = addnode(NewG,1);          % add startnode
NodeLocations{1} = G.Nodes.Location{1};
newnodecounter = 2;
NewNodeList = [1];
CurIndex = 1;
%
while ~done
    nextnode = successors(G,CurIndex);            % get next node index in graph
    if isempty(nextnode)
        fprintf('        nextnode is empty\n');
        done = true;
    else
        fprintf('  newnodecounter = %i, nextnode = %i\n',newnodecounter,nextnode(1));
        NewG = addnode(NewG,1);          % add a corresponding node
        fprintf('    added new node %i\n',newnodecounter);
        NewG = addedge(NewG,(newnodecounter-1),newnodecounter);
        fprintf('    added edge(%i,%i)\n',(newnodecounter-1),newnodecounter);
        NodeLocations{newnodecounter} = G.Nodes.Location{nextnode(1)};
        newnodecounter = newnodecounter + 1;
        CurIndex = nextnode(1);
    end
end
NewG.Nodes.Location = transpose(NodeLocations);
end
