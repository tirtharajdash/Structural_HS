function BOX = drawSample(distr,n)
len_distr = length(distr);
for i=1:n
     randnum = rand();
     cum = 0;
     for j=1:len_distr
         cum = cum + distr(j);
         if(cum > randnum)
             BOX(i) = j;
             break;
         end
     end
 end