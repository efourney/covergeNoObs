    fprintf('Hamiltonian Shortcut:  staqrt node needs shortcutting\n');
    before = predecessors(HGraph,1); % get predecessor nodes for goal's incoming edges 
    %display(before);
    after = successors(HGraph,1);    % get successor nodes for goal's outgoing edges
    %display(after);
    numpaths = length(before);                     % number of edges entering goal node 
    CutFound = false; 
%emilys code
    %will be only 1 path from s to t (maybe missing nodes but ok)
    myTemp = HGraph;
    %remove all edges entering start node
    slicedOutREAL = rmedge(myTemp,before,ones(length(before),1)*1);
    %indexes of nodes starting chains leading to node
    chainStarts = [goal_node_index,before'];
    %we could check lenght of all combos, instead, we connect in numerical
    %order
    %for optimal solution check any order
        %not even worth it as we would need full combinatorics over up to 
        %n predecessors, aith -> infinite? internal matches
    slicedOut = flipedge(slicedOutREAL); %sliced out REAL is real graph
    %slicedOut is only for tracking dfsearches
    for i = 2:length(chainStarts)-1
        %pick two NON CONNECTED TO THE END chains to merge
        chain1 = dfsearch(slicedOut,chainStarts(i));
        chain2 = dfsearch(slicedOut,chainStarts(i+1));
        %disconnect first edge from goal
        slicedOutREAL = rmedge(slicedOutREAL,1,chain1(end-1));
        slicedOutREAL = addedge(slicedOutREAL,chain2(1),chain1(end-1));
    end
    %now slicedOutREAL is one or 0 closed loop 1-1, one 1-n chain
    %slicedOut = flipedge(slicedOutREAL);
    after2 = successors(slicedOutREAL,1); 
    %should only be 2 or 1
    if length(after2) == 2
        test1 = dfsearch(slicedOutREAL,after2(1));
        test2 = dfsearch(slicedOutREAL,after2(2));
        if find(test1 == goal_node_index)
            %after2(1) is the start of the chain connected to the goal
            slicedOutREAL = rmedge(slicedOutREAL,1,after2(1));
            slicedOutREAL = addedge(slicedOutREAL,test2(end),after2(1));
        else
            %after2(2) is the start of the chain connected to the goal
            slicedOutREAL = rmedge(slicedOutREAL,1,after2(2));
            slicedOutREAL = addedge(slicedOutREAL,test1(end),after2(2));
        end

    end
%     lastChain = dfsearch(slicedOut,chainStarts(1));
%     ind = find(lastChain==1);
%     if ind ~= length(lastChain)
%         slicedOutREAL = rmedge(slicedOutREAL,lastChain(ind+1),1);
%         slicedOutREAL = rmedge(slicedOutREAL,1,lastChain(ind-1));
%         slicedOutREAL = addedge(slicedOutREAL,lastChain(ind+1),lastChain(ind-1));
%         %connect the potential sole 1-1 loop to the 1-t chain
%     end
    testRun = dfsearch(slicedOutREAL,1)
    if length(testRun)==goal_node_index
        CutFound = true;
        HGraph = slicedOutREAL;
    else
        fprintf('Hamiltonian Shortcut:  start node FAILED\n');
    end