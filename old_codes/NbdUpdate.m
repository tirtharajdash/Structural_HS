% *** Purpose ***
% Checking the average number of misses for
% structural hide and seek algorithm with nonuniform update
% open a box, if not found, reduce its mass more to it's neighbors
% and distribute a little to

%clear
%clc

rng default;

N = 100; %number of boxes

H = rand(1,N); H = H / sum(H); %hider distribution
[~,idx] = sort(H); %for plotting


MaxHideTrials = 1e2;

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
        for i=1:N
            if i ~= box-1 && i ~= box+1
                S(i) = S(i) + temp/(N-2);
            end
        end
        
        %seeker update based on neighbor 1
        if box ~= 1
            temp = S(box-1);
            S(box-1) = 0;
            for i=1:N
                if i ~= box && i ~= box+1
                    S(i) = S(i) + temp/(N-2);
                end
            end
        end
        
        %seeker update based on neighbor 1
        if box ~= N
            temp = S(box+1);
            S(box+1) = 0;
            for i=1:N
                if i ~= box-1 && i ~= box
                    S(i) = S(i) + temp/(N-2);
                end
            end
        end
        
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