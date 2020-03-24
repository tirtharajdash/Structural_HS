%% P = multimodalDistro(N,k)
% Inputs: N: Locations, k: Proportion of spikes
% Output: P: A multimodal distribution
function P = multimodalDistro(N,k)
rng('default');

P = ones(1,N)/N; %rand(1,N); P = P / sum(P);

loc = randi(N,1,ceil(k*N)); %random locations with spikes
sigma = 5; %spread
beta = 10; %smoothing parameter

P(loc) = P(loc) + 1; %bump the locations

for i=loc
    nbd=[];
    for j=i-sigma:i+sigma %get the neighbors of each i
        if j ~= i && j >= 1 && j <= N
            nbd = [nbd j];
        end
    end
    %bump neighbors proportional to distance from i
    P(nbd) = P(i)*exp(-beta*(i - nbd).^2/(2*sigma^2));
end
%Normalise to make P a distribution
P = P / sum(P);