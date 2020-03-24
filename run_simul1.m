% This is the program that calls function_simul1.m using various arguments
% Arguments: N (No. of boxes), 
%            choiceH (choice of Hider distribution), 
%            choiceUpdS (choice of seeker update criteria),
%            MaxHideTrials (Maximum hiding trials),
%            thetaH (hot threshold),
%            thetaC (cold threshold)
% Written by: Tirtharaj Dash, BITS Pilani, Goa Campus

clc;

MaxHideTrials = 1e3; %maximum hider hiding trials
thetaH = 0.80; %threshold temperature -- High
thetaC = 0.40; %threshold temperature -- Low

file = fopen('stat_0.80_0.40_multimodal_nbd1.txt','w');
fprintf(file,'\\hline \\hline \n');
fprintf(file,'choiceH & choiceUpdS & SuccessRate & mean(misses) & sd(misses) \\\\\n');
fprintf(file,'\\hline \\hline \n');
for N = [1e3,2e3,3e3]
    fprintf(file,'\\multicolumn{5}{c}{$n = %d$} \\\\ \n\\hline \n',N);
    for choiceH = 1%[1,2,3,4]
        for choiceUpdS = [1,2,3]
            %call the function
            [foundIdx,foundMISS] = function_simul1(N,choiceH,choiceUpdS,MaxHideTrials,thetaH,thetaC);
            %write to file
            fprintf(file,'%d & %d & %6.3f & %6.3f & %6.3f \\\\\n',choiceH,choiceUpdS,length(foundIdx)/MaxHideTrials,mean(foundMISS),std(foundMISS));
        end
        fprintf(file,'\\hline \n');
    end
    fprintf(file,'\\hline \n');
end
