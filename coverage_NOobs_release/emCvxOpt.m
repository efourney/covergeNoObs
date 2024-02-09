function [x] = emCvxOpt(v,r)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
r = num2str(r);
%fileID = fopen('emCvxOptScript.m','w');
fileID = fopen('/Users/emilyfourney/Desktop/coverageDOUBLEnumbers/coverageNowWithSense/emCvxOptScript.m','w');
fprintf(fileID,'cvx_begin');
fprintf(fileID,'\n');
hig = num2str(length(v));
fprintf(fileID,['    variable x(' hig ',2)']);
fprintf(fileID,'\n');
fprintf(fileID,['    minimize(']);
for i = 1:length(v)-1
    fprintf(fileID,['norm(x(' num2str(i+1) ',:)-x(' num2str(i) ',:))']);
    if i~=length(v)-1
        fprintf(fileID,'+');
    end
end
fprintf(fileID,[')\n']);
fprintf(fileID,['    subject to']);
fprintf(fileID,'\n');
fprintf(fileID,['        x(1,1) == v(1,1)']);
fprintf(fileID,'\n');
fprintf(fileID,['        x(1,2) == v(1,2)']);
fprintf(fileID,'\n');
for i = 2:length(v)
    fprintf(fileID,['        norm(x(' num2str(i) ',:)-v(' num2str(i) ',:)) <= ' r '\n']);
end
fprintf(fileID,'cvx_end');
fclose(fileID);

% tic
emCvxOptScript
% time2opt = toc
% 
% d = 8;
end