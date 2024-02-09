%% Simple function to change the links in a directed graph to implement a Hamiltonian cut
%  Because this gets called multiple times, it made sense to put this a small function
%  INPUTS:  G is the graph that will be manipulated. "Pre" is a predecessor
%  node.  "node" is the node index (in the graph node numbering scheme)
%  that is being bypassed (pre and post are on incoming and outgoing
%  edges). "post" is the successor node on the outgoing edge.  The function
%  removes the edge from pre-to-node, and node-to-post.  It is then
%  replaced by an edge from pre-to-post.
function [NewGraph] = ByPass(G,pre,node,post)
NewGraph = rmedge(G,pre,node);
NewGraph = rmedge(NewGraph,node,post);
    % HACK: in the addedge call below, the number "1" is a placehold for
    % the weight of the newly added edge.  It would be nice to add the
    % "true" weight for the edge (e.g., a Euclidean distance).  But since
    % edge weights are not subsequently in any meaningful way for the next
    % steps of the algorithm, it is okay to fudge the issue here.  Of
    % course, this may change.
%NewGraph = addedge(NewGraph,pre,post,1); %EMILYS CHANGE FOR UNWEIGHTED
%GRAPHS AS TEST SUBJECTS
NewGraph = addedge(NewGraph,pre,post);
end
