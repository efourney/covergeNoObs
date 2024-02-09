function[s,t,w] = noObstEdge(nodePos)
%NOOBSTEDGE Summary of this function goes here
%   Detailed explanation goes here
n = length(nodePos);
s = [];
t = [];
w = [];
for i = 1:n-1
    for j = n-i+1:-1:2
        s(end+1) = i;
        t(end+1) = j+i-1;
        w(end+1) = norm(nodePos(s(end),:)-nodePos(t(end),:));
    end
end

end

