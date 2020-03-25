n = 1000;
k = 10000000;
H = rand(1,n); H = sort(H); H = H / sum(H);

drawn1 = discretesample(H,k);
H1 = zeros(1,n);
for i=1:n
    H1(i) = H1(i) + length(find(drawn1==i));
end
H1 = H1 /sum(H1);

drawn2 = drawSample(H,k);
H2 = zeros(1,n);
for i=1:n
    H2(i) = H2(i) + length(find(drawn2==i));
end
H2 = H2 /sum(H2);

plot(H); hold on; plot(H1,'r'); plot(H2,'g');

disp('discretesample error w.r.t true distro:')
sum((H - H1).^2)
disp('drawSample error w.r.t true distro:')
sum((H - H2).^2)