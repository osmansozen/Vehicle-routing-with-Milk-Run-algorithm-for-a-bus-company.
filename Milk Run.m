clc
clear all

q=6%Number of Cities
v=3%Number of Vehicles
cap=46;%Capacity of a Vehicle

x=ones(q,q,v);
c=zeros(q,q);

%Distances Among Cities
c(1,2)=764; c(1,3)=306; c(1,4)=307; c(1,5)=388; c(1,6)=850; c(2,3)=459;...
    c(2,4)=961; c(2,5)=892; c(2,6)=740; c(3,4)=492; c(3,5)=512;...
    c(3,6)=645; c(4,5)=104; c(4,6)=909; c(5,6)=694;

c=c+c';
sum1=0;
f=zeros(q,q,v);

%For Loop For Objective Function Matrix
for k=1:1:v
    for i=1:1:q
        for j=1:1:q
            if i==j
            x(i,j,k)=0;
            end
            newval=c(i,j)*x(i,j,k);
            sum1=sum1+x(i,j,k);
            f(i,j,k)=newval.*x(i,j,k);
        end
    end
end

%Converting Objective Function Matrix to Vector
f=f(:);
f=f.';

sum2=length(f)-sum(f==0);
sum1;

N=length(f);

intcon = 1:N;

%Demands
d1=0;
d2=45;
d3=40;
d4=10;
d5=20;
d6=10;

D=[d1 d2 d3 d4 d5 d6];

%Constriction 4
A=[];
for k=1:1:v
    m0=zeros(q,q,v);
    for i=1:1:q
        for j=2:1:q
            m0(i,j,k)=D(j)*x(i,j,k);
        end
    end
    m0=m0(:);
    m0=m0.';
   A=[A;m0];
end

b = [cap.*ones(1,v)];

%Constriction 2
eskisit1=[];
for j=2:1:q
    m1=zeros(q,q,v);
    for k=1:1:v
        for i=1:1:q
            if i~=j
                m1(i,j,k)=1;
            end
        end
    end
    m1=m1(:);
    m1=m1.';
    eskisit1=[eskisit1;m1];
end

%Constriction 3
eskisit2=[];
for i=2:1:q
    m2=zeros(q,q,v);
    for k=1:1:v
        for j=1:1:q
            if i~=j
                m2(i,j,k)=1;
            end
        end
    end
    m2=m2(:);
    m2=m2.';
    eskisit2=[eskisit2;m2];
end

%Constriction 5
eskisit3=[];
for k=1:1:v
    m3=zeros(q,q,v);
    for i=1:1:q
        for j=2:1:q
            if i~=j && i==1
                m3(i,j,k)=1;
            end
        end
    end
    m3=m3(:);
    m3=m3.';
    eskisit3=[eskisit3;m3];
end

%Constriction 6
eskisit4=[];
for k=1:1:v
    m4=zeros(q,q,v);
    for i=2:1:q
        for j=1:1:q
            if i~=j && j==1
                m4(i,j,k)=1;
            end
        end
    end
    m4=m4(:);
    m4=m4.';
    eskisit4=[eskisit4;m4];
end

%Constriction 7
m51=zeros(q,q,v);
m52=zeros(q,q,v);
for k=1:1:v
    for i=1:1:q
        for t=2:1:q
            for j=1:1:q
            if i~=t && t~=j
                m51(i,t,k)=1;
                m52(t,j,k)=1;
            end
          end
        end
    end
end
eskisit5=m51-m52;
eskisit5=eskisit5(:);
eskisit5=eskisit5.';


Aeq = [eskisit1;eskisit2;eskisit3;eskisit4;eskisit5];
beq = [ones(1,(q-1)),ones(1,(q-1)),ones(1,v),ones(1,v),0];
lb = zeros(1,length(f));
ub = ones(1,length(f));
x0=[];
[x,fval,exitflag,output] = intlinprog(f,intcon,A,b,Aeq,beq,lb,ub,x0)

find(x)