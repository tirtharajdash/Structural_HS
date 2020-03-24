%% Function to create the neighborhood list
% Inputs: number of boxes, N; neighborhood size: nbdsize
% Outputs: neighborhood list of each box (nbd)
function nbd = createNeighbors(N,nbdsize)
for i=1:N
    nbd{i}=[];
    for j=i-nbdsize:i+nbdsize
        if j ~= i && j >= 1 && j <= N
            nbd{i} = [nbd{i} j];
        end
    end
end