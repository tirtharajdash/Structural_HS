%% function to decide performance of each box
% Inputs: Hider distribution (H)
% Outputs: Performance of each box (Hperf)
function Hperf = associatePerfs(H)
Hperf = H / max(H); %it's just a function of the prob. mass