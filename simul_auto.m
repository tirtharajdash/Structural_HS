%% *** Implementation of the Simulation ideas discussed in Sept 2019 (v0) ***
%% *** This version takes various experiment choices manually as input ***
%% *** Written by: Tirtharaj Dash, BITS Pilani, Goa Campus ***


clear
clc

%% Set Number of Boxes
fprintf('-------\nINPUTS\n-------')
N = input('\nEnter number of locations: ');

%% Generate Hider Distribution, H

choiceH = input('\nEnter choice of H (1: easy, 2: less easy, 3: less hard, 4: hard): ');

switch choiceH
case 1
	%choice 1 [easy]: degenerate H
	loc = randperm(N,1);
	H = zeros(1,N); H(loc) = 1;
case 2
	%choice 2 [less easy]: semi-degenerate H
	n_loc = ceil(0.25*N);
	loc = randperm(N,n_loc);
	H = zeros(1,N); H(loc) = 1; H = H / sum(H);
case 3
	%choice 3 [less hard]: normal H
	H = rand(1,N); H = H / sum(H);
case 4
	%Choice 4 [hard]: Uniform H
	H = ones(1,N)/N;
end

Hperf = H / max(H); %performance of boxes

%% Choice of Neighborhodd of a Location

%Map the box structure on to number line
nbd{1} = 2;
for i=2:N-1
    nbd{i} = [i-1 i+1];
end
nbd{N} = N-1;

%% Seeker distribution update choice
choiceUpdS = input('\nHow would you update S (1: no update, 2: uniform update, 3: structural update): ');

%% Search Procedure with Seeker Distribution, S

MaxHideTrials = 1e3; %maximum hider hiding trials
MISS = inf(1,MaxHideTrials); %vector to store the misses
HIT = zeros(1,MaxHideTrials); %whether the hider was found
theta = 0.10; %threshold temperature

%start hide-seek
fprintf('\n[Started] Hide-and-Seek simulation...\n');
for hideIter = 1:MaxHideTrials
    hBox = discretesample(H,1); %hiding location
    
    foundFlag = false; %not found yet
    S = ones(1,N)/N; %start with S being Unif(1,N)
    MissCnt = 0; %bad guesses or misses
    Opened = []; %booking of boxes opened so far
    
    %start searching
    while(MissCnt < N)
        box = discretesample(S,1);
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
        	S = S / sum(S)
	case 3 %structural update (hot and cold)
		if Hperf(box) >= theta
			nbdInOpened = intersect(Opened,nbd{box});
			nbdToUpdate = setdiff(nbd{box},nbdInOpened);
			if ~isempty(nbdToUpdate)
				S(nbdToUpdate) = S(nbdToUpdate) + S(box)/length(nbdToUpdate);
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
fprintf('\n-----------\nSTATISTICS\n-----------')
fprintf('\nNumber of times the hider was found\t: %d/%d',length(foundIdx),MaxHideTrials);
fprintf('\nAverage misses in %d successes is\t: %6.3f (%6.3f)',length(foundIdx),mean(foundMISS),std(foundMISS));
fprintf('\nFailure rate\t\t\t\t: %4.3f\n\n',1-length(foundIdx)/MaxHideTrials);
