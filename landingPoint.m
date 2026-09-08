function [xland,yland,vland]=landingPoint(x,y,xHill,yHill,v)

for i=1:length(yHill) % This goes through every yHill element
    for k=1:length(y) % This goes through every y element
        distance=sqrt((y(k)-yHill(i))^2+(x(k)-xHill(i))^2); %distance
        if distance <=0.1 %tolerance 0.1
            index=k;
           break
            
        end
    end
end

 xland=x(index); %xland final 
 yland=y(index);  %yland final 
 vland=v(index); %velocity at landing, m/s
