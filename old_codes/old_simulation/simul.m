%% *** Implementation of the Simulation ideas discussed in Sept 2020 (v0) ***
%% *** This version takes various experiment choices manually
%% *** Written by: Tirtharaj Dash, BITS Pilani, Goa Campus ***


clear
clc

%% Set Number of Boxes
fprintf('-------\nINPUTS\n-------')
N = input('\nEnter number of locations: ');

%% Generate Hider Distribution, H

%choice 1 [easy]: degenerate H
loc = randperm(N,1);
H = zeros(1,N); H(loc) = 1;

%choice 2 [less easy]: semi-degenerate H
%n_loc = 10;
%loc = randperm(N,n_loc);
%H = zeros(1,N); H(loc) = 1; H = H / sum(H);

%choice 3 [less hard]: normal H
%H = rand(1,N); H = H / sum(H);
%[~,idx] = sort(H); %for plotting

%Choice 4 [hard]: Uniform H
%H = ones(1,N)/N;

%% Choice of Neighborhodd of a Location

%Map the box structure on to number line
nbd{1} = 2;
for i=2:N-1
    nbd{i} = [i-1 i+1];
end
nbd{N} = N-1;

%% Search Procedure with Seeker Distribution, S

MaxHideTrials = 1e3; %maximum hider hiding trials
MISS = inf(1,MaxHideTrials); %vector to store the misses
HIT = zeros(1,MaxHideTrials); %whether the hider was found
theta = 0.2; %threshold temperature

%start hide-seek
fprintf('\n[Started] Hide-and-Seek simulation...\n');
for hideIter = 1:MaxHideTrials
    hBox = drawSample(H,1); %hiding location
    
    foundFlag = false; %not found yet
    S = ones(1,N)/N; %start with S being Unif(1,N)
    MissCnt = 0; %bad guesses or misses
    Opened = []; %booking of boxes opened so far
    
    %start searching
    while(MissCnt <= N)
        box = drawSample(S,1);
        if(box == hBox)
            foundFlag = true;
            HIT(hideIter) = 1; %hider was found by seeker
            MISS(hideIter) = MissCnt; %how many misses before finding hider
            %fprintf('HideIter = %d\t Misses = %d\n',hideIter,MISS(hideIter));
            break;
        end
        MissCnt = MissCnt + 1;
        Opened(MissCnt) = box;
                
        %Update S
%         for i=1:N
%             %don't update for 'box'
%             if i ~= box
%                 %Case 1: if 'box' is hot  and i is a neighbor of 'box'
%                 if H(box) >= theta && ~isempty(find(nbd{box}==i))
%                     nbdInOpened = intersect(Opened,nbd{box});
%                     nbdToUpdate = setdiff(nbd{box},nbdInOpened);
%                     S(i) = S(i) + S(box)/length(nbdToUpdate);
%                 end
%                 
%                 %Case 2: if 'box' is hot and i is not a neighbor of 'box'
%                 if H(box) >= theta && isempty(find(nbd{box}==i))
%                     S(i) = S(i);
%                 end
%             end
%         end
%         
%         %Case 3: if 'box' is cold
%         if H(box) < theta
%             S(Opened) = 0;
%         end

        %S(Opened) = 0;
              
        %normalise to make the new S a distribution
        %S = S / sum(S);
                
        %plot
        %if(mod(MissCnt,20) == 0)
        %    clf; hold on;
        %    plot(sort(H));
        %    plot(S(idx),'r-');
        %    drawnow;
        %end
    end
end
fprintf('\n[Finished] simulation...\n');

%% Print the Statistics of the Simulation
foundIdx = find(HIT==1);
foundMISS = MISS(foundIdx);
fprintf('\n-----------\nSTATISTICS\n-----------')
fprintf('\nNumber of times the hider was found\t: %d/%d',length(foundIdx),MaxHideTrials);
fprintf('\nAverage misses in %d successes is\t: %6.3f (%6.3f)',length(foundIdx),mean(foundMISS),std(foundMISS));
fprintf('\nFailure rate\t\t\t\t: %4.3f %%\n\n',1-length(foundIdx)/MaxHideTrials);
