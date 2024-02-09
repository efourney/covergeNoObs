%x = x(sort(xfin),:);
% xfin = [1,length(nodePos(:,1))]; %indicies of final pos to keep
% xcover = xfin;
% while length(xcover) < length(nodePos(:,1))
%     x_count = zeros(length(x),1);
%     totInds = {};
%     for i = 1:length(x)
%         dist = vecnorm(x(i,:) - nodePos,2,2);
%         myInds = find(dist<=r);
%         C = intersect(myInds,xcover);
%         x_count(i) = length(myInds) - length(C);
%         totInds{i} = myInds;
%     end
%     [~,I] = max(x_count);
%     xfin = [xfin,I];
%     xcover = unique([xcover,totInds{I}']);
% end
% 
% 
% 
% 


figure
hold on

eps = .05;
for i = 1:length(nodePos)
    plot(nodePos(i,1),nodePos(i,2), 'ro')
    viscircles([nodePos(i,1),nodePos(i,2)],r,'LineStyle','--','Color','k')
    txt1 = num2str(i);
    if length(txt1) >= 2
        txt = ['T_' txt1(1) '_' txt1(2)];
    else
        txt = ['T_' (txt1)];
    end
    text(nodePos(i,1)+eps,nodePos(i,2)+eps,txt)

    for j = 1:height(Gbase.Nodes)
        if str2num(Gbase.Nodes.Name{j})==i
            viscircles([nodePos(i,1),nodePos(i,2)],r,'Color','b')
        end
    end
end
hold on
eps = .05;
for i = 1:length(nodePos)
    plot(nodePos(i,1),nodePos(i,2), 'ro')
    viscircles([nodePos(i,1),nodePos(i,2)],r,'LineStyle','--','Color','k')
    txt1 = num2str(i);
    if length(txt1) >= 2
        txt = ['T_' txt1(1) '_' txt1(2)];
    else
        txt = ['T_' (txt1)];
    end
    text(nodePos(i,1)+eps,nodePos(i,2)+eps,txt)

    for j = 1:height(Gbase.Nodes)
        if str2num(Gbase.Nodes.Name{j})==i
            viscircles([nodePos(i,1),nodePos(i,2)],r,'Color','b')
        end
    end
end

for i = 1:NumNodes-1
    p1 = HoogeveenPath.Nodes.Location(i,:);
    ind = find(HoogeveenPath.Edges.EndNodes(:,1) == i); 
    p2 = HoogeveenPath.Nodes.Location(HoogeveenPath.Edges.EndNodes(ind,2),:);
     plot([p1(1) p2(1)],[p1(2) p2(2)],'r','LineWidth',2)
%      plot(p1(1),p1(2),'bo')
%      plot(p2(1),p2(2),'bo')
%     txt1 = num2str(i);
%     if length(txt1) >= 2
%         txt = ['S_' txt1(1) '_' txt1(2)];
%     else
%         txt = ['S_' (txt1)];
%     end
%     text(p1(1)-eps,p1(2)-eps,txt)
end
% for i = 1:NumNodes-1
%     p1 = HoogeveenPath.Nodes.Location(i,:);
%     ind = find(HoogeveenPath.Edges.EndNodes(:,1) == i); 
%     p2 = HoogeveenPath.Nodes.Location(HoogeveenPath.Edges.EndNodes(ind,2),:);
%     plot([p1(1) p2(1)],[p1(2) p2(2)],'r','LineWidth',2)
% %     plot(p1(1),p1(2),'bo')
% %     txt1 = num2str(i);
% %     if length(txt1) >= 2
% %         txt = ['S_' txt1(1) '_' txt1(2)];
% %     else
% %         txt = ['S_' (txt1)];
% %     end
% %     text(p1(1)-eps,p1(2)-eps,txt)
% end
% plot(p2(1),p2(2),'bo')
% txt1 = num2str(i+1);
%     if length(txt1) >= 2
%         txt = ['S_' txt1(1) '_' txt1(2)];
%     else
%         txt = ['S_' (txt1)];
%     end
%     text(p2(1)+eps,p2(2)+eps,txt)
% x = xold;
%x = x([1:10, 14 , 16:18],:);
%plot(basenodepos(:,2),basenodepos(:,3),'bo')
%x = x(sort(xfin),:);
% xmod = [x([1 2 3 5 7 10 12 17 19 20 21 22 24],:);[3.095,.8078]];
% xmod = [x([1 2 3 5 7 10 12],:);[3.095,.8078]; x([17 19 20 21 22 24],:)];
% plot(xmod(:,1),xmod(:,2),'bo')
plot(x(:,1),x(:,2),'bo')
eps = .05;
for i = 1:length(x)-1
    p1 = x(i,:);
    p2 = x(i+1,:);
    plot([p1(1) p2(1)],[p1(2) p2(2)],'k','LineWidth',2)
    %viscircles([p1(1),p1(2)],r,'LineStyle','--','Color','r')
    txt1 = num2str(i);
    if length(txt1) >= 2
        txt = ['S_' txt1(1) '_' txt1(2)];
    else
        txt = ['S_' (txt1)];
    end
    text(x(i,1)-eps,x(i,2)+eps,txt)
end
i = i+1;
txt1 = num2str(i);
    if length(txt1) >= 2
        txt = ['S_' txt1(1) '_' txt1(2)];
    else
        txt = ['S_' (txt1)];
    end
    text(x(i,1)-eps,x(i,2)+eps,txt)

% for i = 1:length(xmod)
%     txt1 = num2str(i);
%     if length(txt1) >= 2
%         txt = ['S_' txt1(1) '_' txt1(2)];
%     else
%         txt = ['S_' (txt1)];
%     end
%     text(xmod(i,1)-eps,xmod(i,2)+eps,txt)
% end



% for i = 1:NumNodes-1
%     p1 = HoogeveenPath.Nodes.Location(i,:);
%     ind = find(HoogeveenPath.Edges.EndNodes(:,1) == i); 
%     p2 = HoogeveenPath.Nodes.Location(HoogeveenPath.Edges.EndNodes(ind,2),:);
%      plot([p1(1) p2(1)],[p1(2) p2(2)],'r','LineWidth',2)
% %      plot(p1(1),p1(2),'bo')
% %      plot(p2(1),p2(2),'bo')
% %     txt1 = num2str(i);
% %     if length(txt1) >= 2
% %         txt = ['S_' txt1(1) '_' txt1(2)];
% %     else
% %         txt = ['S_' (txt1)];
% %     end
% %     text(p1(1)-eps,p1(2)-eps,txt)
% end
% plot(p2(1),p2(2),'bo')
% plot(p1(1),p1(2),'bo')
% txt1 = num2str(i+1);
%     if length(txt1) >= 2
%         txt = ['S_' txt1(1) '_' txt1(2)];
%     else
%         txt = ['S_' (txt1)];
%     end
%     text(p2(1)+eps,p2(2)+eps,txt)
for i = 1:length(nodePos)
    plot(nodePos(i,1),nodePos(i,2), 'ro')
%     viscircles([nodePos(i,1),nodePos(i,2)],r,'LineStyle','--','Color','k')
%     txt1 = num2str(i);
%     if length(txt1) >= 2
%         txt = ['T_' txt1(1) '_' txt1(2)];
%     else
%         txt = ['T_' (txt1)];
%     end
%     text(nodePos(i,1)+eps,nodePos(i,2)+eps,txt)
% 
%     for j = 1:height(Gbase.Nodes)
%         if str2num(Gbase.Nodes.Name{j})==i
%             viscircles([nodePos(i,1),nodePos(i,2)],r,'Color','b')
%         end
%     end
end