% *** Purpose *** 
% Checking the average number of misses for 
% structural hide and seek algorithm with uniform update
% open a box, if not found, distribute its mass to all N boxes

clear
clc

N = 100; %number of boxes

%% H is a normal distribution
H = rand(1,N); H = H / sum(H); %hider distribution
[~,idx] = sort(H); %for plotting

%% H is a degenerate distribution
%loc = randperm(N,1);
%H = zeros(1,N); H(loc) = 1;

%% H is a semi-degenerate distribution
%n_loc = 10;
%loc = randperm(N,n_loc);
%H = zeros(1,N); H(loc) = 1; H = H / sum(H);

%% Sampling starts
MaxHideTrials = 1e3;

MISS = zeros(1,MaxHideTrials);
for hideIter = 1:MaxHideTrials
    hBox = drawSample(H,1); %hiding location

    foundFlag = false;
    S = ones(1,N)/N;
    MissCnt = 0;

    %start searching
    while(1)
        box = drawSample(S,1);
        if(box == hBox)
            foundFlag = true;
            MISS(hideIter) = MissCnt;
            fprintf('HideIter = %d\t Misses = %d\n',hideIter,MISS(hideIter));
            break;
        end
        MissCnt = MissCnt + 1;
    
        %update seeker distribution
        temp = S(box);
        S(box) = 0;
        S = S + temp/N;
        %fprintf('%f ',S(hBox));
        
        %plot
        %if(mod(MissCnt,20) == 0)
        %    clf; hold on;
        %    plot(sort(H));
        %    plot(S(idx),'r-');
        %    drawnow;
        %end
    end
end

%print the summary
fprintf('\nAverage Miss in %d hiding trials is %f\n',MaxHideTrials,mean(MISS));