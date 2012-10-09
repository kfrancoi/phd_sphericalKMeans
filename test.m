a = +0.2;
b = -0.1;

uan = 0.7;
ubn = 0.3;

alpha = 5;

for i=1:10
    ua = (alpha * uan*a)^3;
    ub = (alpha * ubn*b)^3;
    
    uan = ua/(ua+ub)
    ubn = ub/(ua+ub)
end;