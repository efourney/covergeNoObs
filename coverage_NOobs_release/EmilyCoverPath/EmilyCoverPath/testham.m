%record  factors:
%total d s, total d t, max inner node d, dfsearch pass,degree pass
n = 1000; %number iterations to run
masterstats = zeros(n,6);
global stats
global testmode
testmode = true;
stats = [];

for k = 1:n
    numNodest = max([min([500, round(normrnd(250,10))]),3]);
    testnodes = zeros(numNodest,2);
    for j = 1:numNodest
        testnodes(j,:) = [10*rand, 10*rand];
    end
    Copy_of_PathHeuristic_Script
    close all
    masterstats(k,:) = [numNodest stats];
end

figure
subplot(3,2,1)
histogram(masterstats(:,1))
xlabel('Number of nodes in graph')
ylabel('Number of Instances')
subplot(3,2,2)
histogram(masterstats(:,2))
xlabel('Total Degree of Start Node')
ylabel('Number of Instances')
subplot(3,2,3)
histogram(masterstats(:,3))
xlabel('Total Degree of End Node')
ylabel('Number of Instances')
subplot(3,2,4)
histogram(masterstats(:,4))
xlabel('Max Degree of Internal Node')
ylabel('Number of Instances')
subplot(3,2,5)
bar(100*sum(masterstats(:,5))/length(masterstats(:,5)))
ylabel('% Passing Test 1')
subplot(3,2,6)
bar(100*sum(masterstats(:,6))/length(masterstats(:,6)))
ylabel('% Passing Test 2')


