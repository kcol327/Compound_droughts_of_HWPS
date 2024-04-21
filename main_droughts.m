%% compound resource droughts
[index_hw,fre_hw,dura_hw,du_ym_hw,MonthMat_hw] = compound_drought(DSRI,WCI,t_DSRI,t_WCI,year);
[index_hp,fre_hp,dura_hp,du_ym_hp,MonthMat_hp] = compound_drought(DSRI,PCI,t_DSRI,t_PCI,year);
[index_wp,fre_wp,dura_wp,du_ym_wp,MonthMat_wp] = compound_drought(PCI,WCI,t_PCI,t_WCI,year);
[index_hwp,fre_hwp,dura_hwp,du_ym_hwp,MonthMat_hwp] = Triple_drought(DSRI,WCI,PCI,t_DSRI,t_WCI,t_PCI,year);
%% energy droughts
[index_TP,fre_TP,dura_TP]=single_drought(TP,t_TP);
[Oneday,Sevenday,Moreday,duMon] = TPDuraatMon(index_TP,year);
%% function
function [index,fre,dura] = single_drought(x,tx)
n=length(x);
m=0;
rec=zeros(n,1);
for i=1:n
    if x(i)<=tx(i)
        m=m+1;
        index(m)=i;
        rec(i)=1;
    end
end
%frequency and duration 
di=diff([0;rec;0]);
dura=find(di==-1)-find(di==1);
fre=length(dura);
end

function [index,fre,dura,du_ym,MonthMat] = compound_drought(x,y,tx,ty,year)
n=length(x);
m=0;
rec=zeros(n,1);
for i=1:n
    if(x(i)<=tx(i))&&(y(i)<=ty(i))
        m=m+1;
        index(m)=i;
        rec(i)=1;
    end
end
%frequency and duration 
di=diff([0;rec;0]);
dura=find(di==-1)-find(di==1);
fre=length(dura);
rec_y=reshape(rec,365,year);
for i=1:year
    di_y=diff([0;rec_y(:,i);0]);
    temp=find(di_y==-1)-find(di_y==1);
    n1=length(temp);
    du_y(i,1:n1)=temp;
end
du_ym=DuraofEvent_Year(du_y,year);
MonthMat=Month_duration(rec_y,year);
end

function [index,fre,dura,du_ym,MonthMat] = Triple_drought(x,y,z,tx,ty,tz,year)
n=length(x);
m=0;
rec=zeros(n,1);
for i=1:n
    if(x(i)<=tx(i))&&(y(i)<=ty(i))&&(z(i)<=tz(i))
        m=m+1;
        index(m)=i;
        rec(i)=1;
    end
end
%frequency and duration 
di=diff([0;rec;0]);
dura=find(di==-1)-find(di==1);
fre=length(dura);
rec_y=reshape(rec,365,year);
for i=1:year
    di_y=diff([0;rec_y(:,i);0]);
    temp=find(di_y==-1)-find(di_y==1);
    n1=length(temp);
    du_y(i,1:n1)=temp;
end
du_ym=DuraofEvent_Year(du_y,year);
MonthMat=Month_duration(rec_y,year);
end

function [du_ey] = DuraofEvent_Year(du_y,year)
du_ey=zeros(year,4);
for i=1:year
    for j=1:length(du_y(i,:))
    if du_y(i,j)==1
        du_ey(i,1)=du_ey(i,1)+1;
    elseif (du_y(i,j)>=2)&&(du_y(i,j)<=3)
        du_ey(i,2)=du_ey(i,2)+1;
    elseif (du_y(i,j)>=4)&&(du_y(i,j)<=7)
        du_ey(i,3)=du_ey(i,3)+1;
    elseif du_y(i,j)>=8
        du_ey(i,4)=du_ey(i,4)+1;
    end
    end
end
end

function Monmat = Month_duration(rec_y,year)
Monmat=zeros(12,year);
i=1;
for m=1:12
    if (m==1)||(m==3)||(m==5)||(m==7)||(m==8)||(m==10)||(m==12)
        Monmat(m,:)=reshape(sum(rec_y(i:i+30,:)),[1,year]);
        i=i+31;
    elseif m==2
        Monmat(m,:)=reshape(sum(rec_y(i:i+27,:)),[1,year]);
        i=i+28;
    else
        Monmat(m,:)=reshape(sum(rec_y(i:i+29,:)),[1,year]);
        i=i+30;
    end
end
end


function [Oneday,Sevenday,Moreday,duMon] = TPDuraatMon(index,year)
y=zeros(year*365,1);
y(index)=1;
D_month=[31,59,90,120,151,181,212,243,273,304,334,365];
di=diff([0;y;0]);
du=find(di==-1)-find(di==1);
Sta_d=find(di==1);
month=zeros(length(du),1);
for i=1:length(Sta_d)
    modi=mod(Sta_d(i),365);
    if modi~=0
       month(i)=min(find(D_month>=modi));
    else
       month(i)=12;
    end
end
duMon=[du,month];
Oneday_index=find(du==1);
Oneday=duMon(Oneday_index,:);
Sevenday_index=find((du>=1)&(du<=7));
Sevenday=duMon(Sevenday_index,:);
Moreday_index=find(du>7);
Moreday=duMon(Moreday_index,:);
end
