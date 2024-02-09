%% Global definitions file which should be relevant for all S-t Path calculations
global StartNode GoalNode              % start, s, and goal, t, nodes
global Nodes NumNodes                  % actual data for nodes, and number of nodes (including the StartNode)
global FixedNodeIncidence              % incidence vector of a fixed path.  Needed for optimization of sensing nodes only
global NumBinaryVars NumContinuousVars % number of binary and continuous variables
global NumVars                         % Sum of binary and continous variable numbers
global SenseRadius                     % sensing radius for circular sensing model
global ProblemD                        % dimension of the problem: 2 for planar, 3 for spatial
global Epsilon                         % needed for approxmating linear equality constraints
global stats
global testmode      
% some test cases
ProblemD = 2;                          % assuming planar problem
SenseRadius = 1.75;                    % sensing radius of circular sensing
Epsilon = 0.1;

% Nodes_STP;                           % read in the CoverNode locations, located in file Nodes_STP.m
%NodesBig_STP;
EmilyNodes;                            % read in Emily's example data
NumNodes = length(Nodes);              % number of nodes (including start node, N1)
StartNode = Nodes(1,:);                % starting location.  It need not be at the origin
GoalNode = Nodes(NumNodes,:);          % goal node location
      % set up the dimensions of the optiization variable vectors
NumBinaryVars = NumNodes * (NumNodes - 1)/2;      % num. of binary decision variables (SYMMETRIC)
                                                  % note that links to StartNode N1 are included
NumContinuousVars= ProblemD * (NumNodes-1);       % number of continous variables.  StartNode is NOT a variable
NumVars = NumBinaryVars + NumContinuousVars;      % number of all variables

global MyMplusT                         % internal variable for diagnostics