%% *** Implementation of the Simulation ideas discussed in Sept 2019 (v0) ***
%% *** This version takes various experiment choices as function argument ***
%% *** Written by: Tirtharaj Dash, BITS Pilani, Goa Campus ***

function [foundIdx,foundMISS] = function_simul1(N,choiceH,choiceUpdS,MaxHideTrials,thetaH,thetaC)

%% Set Number of Boxes
fprintf('-------\nINPUTS\n-------')
fprintf('\nEnter number of locations: %d',N);

%% Generate Hider Distribution, H

fprintf('\nChoice of H (1: easy, 2: less easy, 3: less hard, 4: hard): %d',choiceH);

% switch choiceH
%     case 1
%         %choice 1 [easy]: degenerate H
%         loc = randperm(N,1);
%         H = zeros(1,N); H(loc) = 1;
%     case 2
%         %choice 2 [less easy]: semi-degenerate H
%         n_loc = ceil(0.25*N);
%         loc = randperm(N,n_loc);
%         H = zeros(1,N); H(loc) = 1; H = H / sum(H);
%     case 3
%         %choice 3 [less hard]: normal H
%         H = rand(1,N); H = H / sum(H);
%     case 4
%         %Choice 4 [hard]: Uniform H
%         H = ones(1,N)/N;
% end

%added latest: multimodal Hider for neighborhood test
k = 0.10; %proportion of spikes in the distro
H = multimodalDistro(N,k);

Hperf = H / max(H); %performance of boxes


%% Seeker distribution update choice
fprintf('\nUpdate S type (1: no update, 2: uniform update, 3: structural update): %d',choiceUpdS);

%create the neighborhood for boxes
if(choiceUpdS == 3)
    nbd = createNeighbors(N,1); %arg2 is neighborhood size
end

%% Search Procedure with Seeker Distribution, S

MISS = inf(1,MaxHideTrials); %vector to store the misses
HIT = zeros(1,MaxHideTrials); %whether the hider was found

%start hide-seek
fprintf('\n[Started] Hide-and-Seek simulation...\n');
for hideIter = 1:MaxHideTrials
    hBox = discretesample(H,1); %hiding location
    
    foundFlag = false; %not found yet
    S = ones(1,N)/N; %start with S being Unif(1,N)
    MissCnt = 0; %bad guesses or misses
    Opened = []; %book-keeping of boxes opened so far
    
    %start searching
    while(MissCnt < N)
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
        
        switch choiceUpdS
            case 1 %with replacement; no update
                S = S;
            case 2 %share the mass of the opened box to rest all unopend boxes
                S(Opened) = 0;
                S = S / sum(S);
            case 3 %structural update (hot and cold)
                if Hperf(box) >= thetaH
                    nbdInOpened = intersect(Opened,nbd{box});
                    nbdToUpdate = setdiff(nbd{box},nbdInOpened);
                    if ~isempty(nbdToUpdate)
                        S(nbdToUpdate) = S(nbdToUpdate) + S(box)/length(nbdToUpdate);
                    end
                end
                if Hperf(box) <= thetaC
                    unOpened = setdiff(1:N,Opened);
                    toUpdate = setdiff(unOpened,nbd{box});
                    if ~isempty(toUpdate)
                        S(toUpdate) = S(toUpdate) + S(box)/length(toUpdate);
                    end
                end
                S(Opened) = 0;
                S = S / sum(S);
        end
        
        %plotting (optional; don't uncomment it, unless you are sure!)
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
%fprintf('\n-----------\nSTATISTICS\n-----------')
%fprintf('\nNumber of times the hider was found\t: %d/%d',length(foundIdx),MaxHideTrials);
%fprintf('\nAverage misses in %d successes is\t: %6.3f (%6.3f)',length(foundIdx),mean(foundMISS),std(foundMISS));
%fprintf('\nFailure rate\t\t\t\t: %4.3f\n\n',1-length(foundIdx)/MaxHideTrials);