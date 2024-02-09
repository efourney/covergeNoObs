%% Function that finds "shortcuts" that turn a (DIRECTED) graph that satisfies 
%  the Euler trail property (each graph edge visited only once) into a
%  Directed Hamltonian Path (each vertex visited only once) by "shortcutting" the
%  Euler Graph (which is the input, EG)
%
%  Hamiltonian shortcutting is a heuristic. This algorithm does not yet try 
%  clever heuristics, such as greedy optimization of the choice
%  of cuts in the typical situation where there are multiple cut choices.
%  Also, there are HACKs in the current implementation (see below).
%  Search for "HACK".  The Hacks can be categorized as not handling more
%  complicated cases.
%
%  The algorithm goes likes this.  FIrst, some basic checks about the
%  incoming Euler Trail are made.  Second, an internal even degree nodes
%  are shotcut if necessary.  Then the start and goal nodes are tested for
%  a shortcut requirement, and processed if necessary.
function [HGraph] = Emily_HamiltonianShortcut(EG)
 global stats
 global testmode
 stats = ones(1,5);
 
%
HGraph = EG;                                   % copy graph.  Maybe this can be removed?
    % calculate the "degrees" of the graph nodes, which includes the
    % in-degree, out-degree, and, total-degree and net-degree.
in_d = indegree(HGraph); out_d = outdegree(HGraph);  % basic indegree and outdegree of graph nodes
total_d = in_d + out_d;                        % total degree of the directed graph nodes
stats(1) = total_d(1);
stats(2) = total_d(end);
stats(3) = max(total_d(2:end-1));
net_d = out_d - in_d;                          % net degree of graph nodes
%
%% Perform a few basic checks on the incoming graph, and return if errors are found
%
n_graph_nodes = numnodes(HGraph);               % number of nodes in the incoming graph
% n_even_degree_nodes = find(mod(total_d,2)==0);  % number of even total degree nodes
n_odd_degree_nodes = find(mod(total_d,1)==0);   % number of odd total degree nodes
start_net_degree = net_d(1);                    % net degree of start node (should be +1)
goal_net_degree = net_d(n_graph_nodes);         % net degree of goal node (should be -1)
goal_node_index = n_graph_nodes;                % index of goal node
if (n_odd_degree_nodes > 2)  & ~testmode
        fprintf('ERROR:  Hamiltonian Shortcut.  Input graph has more than 2 odd degree nodes\n');
    return;
else
    if (start_net_degree ~= 1) & ~testmode
            fprintf('ERROR:  Hamiltonian Shortcut. Start Node has wrong degree of %i\n',net_d(1));
        return;
    else
        if(goal_net_degree ~= -1) & ~testmode
            fprintf('ERROR:  Hamiltonian Shortcut.  Goal node has wrong degree of %i\n',goal_degree);
            return;
        end
    end
end   % of if/else
    % The IntProcessNodes are the even degree nodes in the "interior" of the Euler Trail
    % (i.e., the nodes that are not the start or goal node) with degree >= 4


    IntProcessNodes = find((mod(total_d,2)==0) & (total_d>3));
    nProcess = length(IntProcessNodes);               % number of nodes to process
    %  If nProcess>0, then there are nodes to process. Else, return the input as is

    %checkduplicate edge
    mat = HGraph.Edges.EndNodes;
    [~,inds] = sort(mat(:,1));
    mat = mat(inds,:);
    mastercheck = any(mat(1:end-1,1) == mat(2:end,1) & mat(1:end-1,2) == mat(2:end,2) );
    i = 1;
    if mastercheck
        while i<=length(HGraph.Edges.EndNodes(:,1))
            logicalInd1 = HGraph.Edges.EndNodes(i,1) == HGraph.Edges.EndNodes([1:i-1,i+1:length(HGraph.Edges.EndNodes(:,1))],1);
            logicalInd2 = HGraph.Edges.EndNodes(i,2) == HGraph.Edges.EndNodes([1:i-1,i+1:length(HGraph.Edges.EndNodes(:,2))],2);
            if any(logicalInd1 & logicalInd2)
                inds = find(logicalInd1 & logicalInd2);
                edge = HGraph.Edges.EndNodes(inds(1),:);
                %the ith edge and the inds(1) edges are a pair of
                %duplicated edges
                HGraph = rmedge(HGraph,edge(1),edge(2));
                %assumes internal node, if so we need at least 2 afters
                afters = successors(HGraph,edge(2));
                HGraph = addedge(HGraph,edge(1),edge(2));
                HGraph = addedge(HGraph,edge(1),afters(1));
                HGraph = rmedge(HGraph,edge(2),afters(1));
                i = 1; %GO BACK AND CHECK ALL edges
            else
                i = i+1;
            end
        end
        %nProcess = 0;
    end


    if (nProcess > 0)
        fprintf('Hamiltonian ShortCut: there are nodes to process\n');
        for i=1:nProcess                                 % cycle through nodes with high even degree, note nothing will create more?
            CurNodeIndex = IntProcessNodes(i);           % get the next candidate node
            reallydone = false;
            while ~reallydone
                before = predecessors(HGraph,CurNodeIndex);  % get predecessor node array
                after = successors(HGraph,CurNodeIndex);     % get successor node array
                numpaths = max(length(before),length(after));                   % number of paths passing through
                % process the multiple paths passing through the current node
                CutDone = false;                             % boolean to control while loop
                CutFound = false;                            % boolean to indicate if acceptable cut is found
                jcut = 1;                                    % counter over possible paths
                if length(before) ~= 1 %if we just have one before a shortcut fixed it
                    for indicator = 1:length(before)
                        after = circshift(after,indicator-1);
                        while ~CutDone
                            % Try the first cut
                            TempGraph = ByPass(HGraph,before(jcut),IntProcessNodes(i),after(jcut));
                            % check if the graph has been disconnected.  If so, then
                            % try alternative cut.
                            % HACK: the current code only tries one alternative.  This
                            % should be rewritten to try all alternatives.
                            %in_d_tmp = indegree(TempGraph)+ outdegree(TempGraph);
                            if disconnected(TempGraph) 
                                if ~testmode
                                fprintf('           Anamolous disconnection of graph\n');
                                end
                                % shift pairings if predecessor/successor nodes to find
                                % another cut option
                                after = circshift(after,1);    % change the before/after pairing
                                TempGraph = ByPass(HGraph,before(jcut),IntProcessNodes(i),after(jcut));
                                if ~testmode
                                fprintf('      Trying ShortCut: path %i with sequence [%i,%i,%i]\n',jcut,before(jcut),IntProcessNodes(i),after(jcut));
                                end
                                % if the alternative is disconnected, then we're done
                                % the first set of paths.  Update jcut, and try another set.
                                %in_d_tmp = indegree(TempGraph)+ outdegree(TempGraph);
                                if disconnected(TempGraph)
                                    if ~testmode
                                    fprintf('       Alternative graph is disconnected\n');
                                    end
                                    jcut = jcut +1;
                                else
                                    if ~testmode
                                    fprintf('       Alternative graph successful\n');
                                    end
                                    CutDone = true;
                                    CutFound = true;
                                    HGraph = TempGraph;
                                end
                            else       % if the first cut was not disconnected, pass back the solution
                                HGraph = TempGraph;
                                CutDone = true;
                                CutFound = true;
                            end
                            if (jcut>=numpaths)   % did we exhaust all paths?
                                CutDone = true;
                                reallydone = true;
                            end
                            % If we couldn't find an non-disconnected cut, ABORT
                            if ~CutFound
                                if ~testmode
                                fprintf('ERROR:   Hamiltonian ShortCut--A ShortCut Anamoly!\n');
                                end
                                return;
                            end
                        end % of while
                    end %emily's for loop
                else
                    CutFound = true;
                    CutDone = true;
                end
                %handle weird self intersecting loops
                    k = 1;
                    while k <= height(HGraph.Edges)
                        if HGraph.Edges.EndNodes(k,1) == HGraph.Edges.EndNodes(k,2)
                            HGraph = rmedge(HGraph,HGraph.Edges.EndNodes(k,1),HGraph.Edges.EndNodes(k,2));
                        else
                            k = k+1;
                        end
                    end
                in_d2 = indegree(HGraph);
                if in_d2(IntProcessNodes(i)) == 1
                    reallydone = true;
                end  
            end
        end % of for loop
    else % if (nProcess>0)
        if ~testmode
            fprintf('  Hamiltonian Shortcut: No internal nodes need processing\n');
        end
    end  % of if(nProcess>0)


%% 2nd check if the start node needs shortcutting
%  given that the graph passed earlier tests, we can assume that the start
%  node has 1 net node degree.  First check if there is more than one
%  input path to the node-if so, then shortcutting is needed. If not, then
%  go to next step.  
%
%  If shortcutting is needed, there must be an odd number of edges LEAVING
%  to the node.  There could be 3, 5, 7, etc. 
%
%get rid of self intersecting paths
i = 1;
while i <= height(HGraph.Edges)
    if HGraph.Edges.EndNodes(i,1) == HGraph.Edges.EndNodes(i,2)
        HGraph = rmedge(HGraph,HGraph.Edges.EndNodes(i,1),HGraph.Edges.EndNodes(i,2));
    else
        i = i+1;
    end
end

in_d = indegree(HGraph); out_d = outdegree(HGraph);  % basic indegree and outdegree of graph nodes
total_d = in_d + out_d;                        % total degree of the directed graph nodes

if mastercheck
    %total_d(1) = 0;
end

if (total_d(1)>1)                    % do we need to short cut?
    %%first attempt
%     fprintf('Hamiltonian Shortcut:  staqrt node needs shortcutting\n');
%     before = predecessors(HGraph,1); % get predecessor nodes for goal's incoming edges 
%     %display(before);
%     after = successors(HGraph,1);    % get successor nodes for goal's outgoing edges
%     %display(after);
%     numpaths = length(before);                     % number of edges entering goal node 
%     CutFound = false; 
% %emilys code
%     myTemp = HGraph;
%     myTemp = rmedge(myTemp,before,ones(length(before),1));
%     %check which chains are connected to t-at least one or else failed
%     %prior!
%     s2tchainstart = [];
%     s2tchainend = [];
%     for i = 1:length(after)
%         descendants=dfsearch(myTemp,after(i));
%         if any(descendants == goal_node_index)
%             s2tchainstart(end+1) = after(i); %this node is 2nd in a chain from s to t
%             ind = find(descendants == goal_node_index);
%                 if ind == 1
%                     s2tchainstart(end) = 1;
%                     s2tchainend(end + 1) = descendants(ind);
%                 else
%                     s2tchainend(end + 1) = descendants(ind-1);
%                 end
%         end
%     end
% 
%     graph_reversed = flipedge(myTemp);
%     t2schainend = [];
%     t2schainstart = [];
%     for i = 1:length(before)
%         descendants=dfsearch(graph_reversed,before(i));
%         if any(descendants == goal_node_index)
%             t2schainend(end+1) = before(i); %this node is 2nd 2 last in a chain from t to s
%             ind = find(descendants == goal_node_index);
%             t2schainstart(end + 1) = descendants(ind-1);
%         end
%     end
%     
%     %should always be 1 more s2t than t2s, if s2t length = 1->done!
%     %else, now we connect i'th pairs, i less than the end, of s to t and t
%     %to s paths into an s to s path!
%     for i = 1:length(s2tchainstart)-1
%         HGraph = rmedge(HGraph,s2tchainend(i),goal_node_index);
%         HGraph = rmedge(HGraph,t2schainstart(i),goal_node_index);
%         HGraph = addedge(HGraph,s2tchainend(i),t2schainstart(i));
%     end
% 
%     %now, only 1 s to t path in HGraph
%     before = predecessors(HGraph,1); % get predecessor nodes for starts's incoming edges 
%     %display(before);
%     after = successors(HGraph,1);    % get successor nodes for starts's outgoing edges
%     %display(after);
%     numpaths = length(before);                     % number of edges entering goal node 
%     CutFound = false; 
% %emilys code
%     myTemp = HGraph;
% 
%     %remove all edges entering start node
%     slicedOutREAL = rmedge(myTemp,before,ones(length(before),1)*1);
%     %indexes of nodes starting chains leading to node
%     chainStarts = [goal_node_index,before'];
%     %we could check lenght of all combos, instead, we connect in numerical
%     %order
%     %for optimal solution check any order
%         %not even worth it as we would need full combinatorics over up to 
%         %n predecessors, aith -> infinite? internal matches
%     slicedOut = flipedge(slicedOutREAL); %sliced out REAL is real graph
%     %slicedOut is only for tracking dfsearches
%     for i = 2:length(chainStarts)-1
%         %pick two NON CONNECTED TO THE END chains to merge
%         chain1 = dfsearch(slicedOut,chainStarts(i));
%         chain2 = dfsearch(slicedOut,chainStarts(i+1));
%         %disconnect first edge from goal
%         slicedOutREAL = rmedge(slicedOutREAL,chain1(end-1),1);
%         slicedOutREAL = addedge(slicedOutREAL,chain1(end-1),chain2(1));
%     end
%     slicedOut = flipedge(slicedOutREAL);
%     lastChain = dfsearch(slicedOut,chainStarts(1));
%     ind = find(lastChain==1);
%     if ind ~= length(lastChain)
%         slicedOutREAL = rmedge(slicedOutREAL,lastChain(ind+1),1);
%         slicedOutREAL = rmedge(slicedOutREAL,1,lastChain(ind-1));
%         slicedOutREAL = addedge(slicedOutREAL,lastChain(ind+1),lastChain(ind-1));
%         %connect the potential sole 1-1 loop to the 1-t chain
%     end
%     testRun = dfsearch(slicedOutREAL,1);
%     if length(testRun)==goal_node_index & testRun(end) == goal_node_index
%         CutFound = true;
%         HGraph = slicedOutREAL;
%     else
%         fprintf('Hamiltonian Shortcut:  start node FAILED\n');
%     end
    %%second try
%%
    before = predecessors(HGraph,1); % get predecessor nodes for goal's incoming edges 
    after = successors(HGraph,1);  

    s2tafters = []; %after elements that are in a chain from s to t
    s2tafters_elementbeforet = [];
    s2safters = []; %after elements that are in a loop back to the start
    loop_befores = []; %indexed alonside s2s afters, corresponding element is the before
    t2s_befores = before; %if not in loop, part of t to s
    t2s_before_elementaftert = []; %elelemnt right after t on chain to s
    manip_graph = rmedge(HGraph, before, ones(length(before),1));
    for i = 1:length(after)
        chain = dfsearch(manip_graph,after(i));
        if any(chain == goal_node_index)
            s2tafters(end+1) = after(i);
            ind_n = find(chain == goal_node_index);
            if ind_n == 1
                s2tafters_elementbeforet(end+1) = 1;
            else
                s2tafters_elementbeforet(end+1) = chain(ind_n-1);
            end

        else
            s2safters(end+1) = after(i);
            loop_befores(end+1) = chain(end);
            t2s_befores = t2s_befores(t2s_befores ~= chain(end));
        end
    end
    manip_graph = flipedge(HGraph);
    for i = 1:length(t2s_befores)
        chain = dfsearch(manip_graph,t2s_befores(i));
        ind_n = find(chain == goal_node_index);
        %
%         if isempty(ind_n)
%             t2s_befores(i) = [];
%         else
        if ind_n == 1
           t2s_before_elementaftert(end+1) = 1; %unique case, directly connected t to s
        else
             t2s_before_elementaftert(end+1) = chain(ind_n-1);
        end
    end
    %we expect there to always be one more s to t chain than t to s, we
    %take the first length-1 elements and make them loops, so we are left
    %with one s to t chain, and however many loops remain
    for i = 1:length(s2tafters)-1
        HGraph = rmedge(HGraph,s2tafters_elementbeforet(i),goal_node_index);
        HGraph = rmedge(HGraph,goal_node_index,t2s_before_elementaftert(i));
        if ~(s2tafters_elementbeforet(i) == t2s_before_elementaftert(i))
            HGraph = addedge(HGraph,s2tafters_elementbeforet(i),t2s_before_elementaftert(i));
        end
    end

    %now HGraph has multiple loops and 1 s to t path!
    %we re-evaluate our vectors
    before = predecessors(HGraph,1); % get predecessor nodes for goal's incoming edges 
    after = successors(HGraph,1);  

    s2tafters = []; %after elements that are in a chain from s to t
    s2tafters_elementbeforet = [];
    s2safters = []; %after elements that are in a loop back to the start
    loop_befores = []; %indexed alonside s2s afters, corresponding element is the before
    t2s_befores = before; %if not in loop, part of t to s
    t2s_before_elementaftert = []; %elelemnt right after t on chain to s
    manip_graph = rmedge(HGraph, before, ones(length(before),1));
    for i = 1:length(after)
        chain = dfsearch(manip_graph,after(i));
        if any(chain == goal_node_index)
            s2tafters(end+1) = after(i);
            ind_n = find(chain == goal_node_index);
            ind_n = ind_n(1);
            if ind_n == 1
                s2tafters_elementbeforet(end+1) = 1;
            else
                s2tafters_elementbeforet(end+1) = chain(ind_n-1);
            end

        else
            s2safters(end+1) = after(i);
            loop_befores(end+1) = chain(end);
            t2s_befores = t2s_befores(t2s_befores ~= chain(end));
        end
    end
    manip_graph = flipedge(HGraph);
    for i = 1:length(t2s_befores)
        chain = dfsearch(manip_graph,t2s_befores(i));
        ind_n = find(chain == goal_node_index);
        if ind_n == 1
           t2s_before_elementaftert(end+1) = 1; %unique case, directly connected t to s
        else
           t2s_before_elementaftert(end+1) = chain(ind_n(1)-1);
        end
    end

    if length(s2safters) ~= 0 %if 0 we have nothing to do! else, need to combine loops
        HGraph = rmedge(HGraph, ones(length(s2safters(2:end)),1), s2safters(2:end));
        HGraph = rmedge(HGraph,loop_befores(1:end-1),ones(length(loop_befores(1:end-1)),1));
        HGraph = addedge(HGraph,loop_befores(1:end-1),s2safters(2:end));
        %now there is one loop and one s to t path
        %disconnect the s to t path from s and remove the last loop
        %entering, then connect
        HGraph = rmedge(HGraph,loop_befores(end),1);
        HGraph = rmedge(HGraph,1,s2tafters(1)); %s2tafter should be 1 element
        HGraph = addedge(HGraph,loop_befores(end),s2tafters(1));
    end
end





%% Now check if the goal node needs shortcutting
%  given that the graph passed earlier tests, we can assume that the goal
%  node has -1 net node degree.  First check if there is more than one
%  input path to the node-if so, then shortcutting is needed. If not, then
%  go to next step.  
%
%  If shortcutting is needed, there must be an odd number of edges incoming
%  to the node.  There could be 3, 5, 7, etc.  HACK: the code below only
%  deals with the case of 3 edges. 
%
in_d = indegree(HGraph); out_d = outdegree(HGraph);  % basic indegree and outdegree of graph nodes
total_d = in_d + out_d;                        % total degree of the directed graph nodes


if mastercheck
    %total_d(goal_node_index) = 0;
end

if (total_d(goal_node_index)>1)                    % do we need to short cut?
    if ~testmode
    fprintf('Hamiltonian Shortcut:  goal node needs shortcutting\n');
    end
    before = predecessors(HGraph,goal_node_index); % get predecessor nodes for goal's incoming edges 
    %display(before);
    after = successors(HGraph,goal_node_index);    % get successor nodes for goal's outgoing edges
    %display(after);
    numpaths = length(before);                     % number of edges entering goal node 
    CutFound = false; 
%emilys code
    myTemp = HGraph;
    %remove all edges LEAVING goal node
    slicedOut = rmedge(myTemp,ones(length(after),1)*goal_node_index,after);
    %indexes of nodes starting chains leading to node
    chainStarts = [1,after'];
    %we could check lenght of all combos, instead, we connect in numerical
    %order
    for i = 1:length(chainStarts)-1
        %pick two chains to merge
        chain1 = dfsearch(slicedOut,chainStarts(i));
        chain2 = dfsearch(slicedOut,chainStarts(i+1));
        %disconnect first edge from goal
        slicedOut = rmedge(slicedOut,chain1(end-1),goal_node_index);
        slicedOut = addedge(slicedOut,chain1(end-1),chain2(1));
    end
    testRun = dfsearch(slicedOut,1);
    if length(testRun)==goal_node_index & testRun(end) == goal_node_index
        CutFound = true;
        HGraph = slicedOut;
    end
end %emily added 1/2/23 need to test full loop/match ends

%joel's code handles 3 
%     % now loop through possible combinations if incoming and outgoing edge
%     % cuts.  If a bypass cut is found that does not disconnect the graph,
%     % then accept the cut, stop searching for cuts, and move to the next step.  HACK: it
%     % might be better if this step found all feasible cuts, and then chose
%     % the "best one."
%     for i=1:length(after)
%         fprintf('HSC: goal node loop %i\n',i);
%         for j=1:length(before)
%             fprintf('HSC: goal node loop iteration %i\n',j);
%             TempGraph = ByPass(HGraph,before(j),goal_node_index,after(i));
%              % check if the graph has been disconnected.  
%             if disconnected(TempGraph)
%                fprintf('  Hamiltonian ShortCut: bypass of goal node leaves disconnected graph\n')
%             else
%                fprintf('  Hamiltonian ShortCut: found acceptable goal bypass cut\n');
%                HGraph = TempGraph;
%                CutFound = true;
%                break;
%             end
%         end
%     end
%emily's code 
% 
%     if ~CutFound
%         fprintf('error no goal node shortcut found')
%     else
%         fprintf('Hamiltonian Shortcut:  goal node does not need shortcutting\n');
%     end
finaltest = dfsearch(HGraph,1);
stats(4) = length(finaltest)== goal_node_index & finaltest(end) == goal_node_index;
in_d = indegree(HGraph); out_d = outdegree(HGraph);  % basic indegree and outdegree of graph nodes
total_d = in_d + out_d; 
stats(5) = total_d(1) == 1 & total_d(end) == 1 & all(total_d(2:end-1)==2);

if mastercheck
    %stats(4) = true;
    %stats(5) = true;
end

end   % function


