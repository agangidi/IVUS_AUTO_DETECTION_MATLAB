function average_error=step_2_3_contour_init_rbf(finput)

source=load('ManualLumen.er');
source1=load('ManualEEM.er');
gate=load('Gate.txt');
fnum=gate(finput,:)
size(fnum)

     % change for specific frame of interest
fid_env = fopen('BSC-DIGITIZER-7_103-007_LAD_RF_11072007_020653.env');
f = 7*GetFrameEnv(fnum, fid_env)-GetFrameEnv(fnum-1, fid_env)-GetFrameEnv(fnum-2, fid_env)-GetFrameEnv(fnum+1, fid_env)-GetFrameEnv(fnum+2, fid_env)-GetFrameEnv(fnum-3, fid_env)-GetFrameEnv(fnum+3, fid_env);
%f=GetFrameEnv(fnum, fid_env);

coeff = rbfcreate([1:256],source(finput,:),'RBFsmooth', 50);
actual = rbfinterp([1:256], coeff);

coeff = rbfcreate([1:256],source1(finput,:),'RBFsmooth', 50);
ManEEM = rbfinterp([1:256], coeff);

% Tree  of discrete wavelete frames decomposition

[Ill,I3,I2,I1]=dwft2(abs(f),'haar');


[Ill,I6,I5,I4]=dwft2(Ill,'haar');



[Ill,I9,I8,I7]=dwft2(Ill,'haar');



[Ill,I12,I11,I10]=dwft2(Ill,'haar');

[Ill,I15,I14,I13]=dwft2(Ill,'haar');


Ibk=abs(Ill);


Itex=abs(I1)+abs(I4)+abs(I7)+abs(I10);

%Itex=abs(I7)+abs(I8)+abs(I10)+abs(I11);

ILtex=abs(Ill); 

norm=max(max(Itex(30:210,1:255)));

norm2=max(max(ILtex(30:210,1:255)));

Iint1=(Itex/norm);
Iint2=(ILtex/norm2);

Iint= 255*Iint1;

Iint3=255*Iint2;

x=zeros(1,256);
y=zeros(1,256);
xlumen=zeros(1,256);
ylumen=zeros(1,256);
xmeda=zeros(1,256);
ymeda=zeros(1,256);

ylume=[];
xlume=[];
ymed=[];
xmed=[];

T=30;

for i=1:256,
  for j=26:210
		if Iint(j,i)>T
		break;
		end
	end
	x(i)=i;
	y(i)=j;
    if (y(i)<125)&&(y(i)>26)
        ylume=[ylume,y(i)];
        xlume=[xlume,i];
    end
end

yli=y; 
%ylumen=rbfsmooth(x,y);     %using radial basis function to obtain a smooth function neglecting anamolies
%xlumen=x;

%,
y=zeros(1,256);
imshow(abs(f).^0.4/max(max(abs(f).^0.4)));
hold on

coeff = rbfcreate(xlume, ylume,'RBFsmooth',150);
ylii = rbfinterp([1:256], coeff);

%ylii=(actual+ylii)/2;

plot((ylii),'y','linewidth',.1)


for i=2:256
	[v,y(i)]=max(Iint3((ylii(i)+5):255,i));
	x(i)=i;
    y(i)=(y(i)+ylii(i));
    if ((y(i)<200)&&(y(i)>10)&&((abs(y(i)-y(i-1))>0)||(abs(y(i)-y(i-1))<180)))
        ymed=[ymed,y(i)];
        xmed=[xmed,i];
    end
end


ymi=y; 
%ymeda=rbfsmooth(x,y);    %using radial basis function to obtain a smooth function neglecting anamolies
%xmeda=x;






%plotting the detected values



%plot(yli,'r','linewidth',.5)
%plot(ylumen,'r','linewidth',.5)
%plot(ymi,'g','linewidth',.5)

%coeff = rbfcreate(xlume, ylume,'RBFsmooth',1);
%ylii = rbfinterp([1:256], coeff);

%plot(ylii,'r','linewidth',.5)

xmed=[xmed (xmed+256) (xmed+512)];
ymed=[ymed ymed ymed];




coeff = rbfcreate(xmed, ymed,'RBFsmooth', 250);
%ylii2 = rbfinterp([1:256], coeff)
ylii2 = rbfinterp([1:768], coeff);

ylii2=ylii2(257:512);

%plot(ylii2,'g','linewidth',.5)

%ylii2=((ylii2+ManEEM)/2);

plot((actual),'b','linewidth',.5)                                                                                                                            
plot(ylii2,'g','linewidth',.1)

%plot(y,'g+','linewidth',.1)

plot((ManEEM ),'r','linewidth',.5)
hold off

print size(ymed)

average_error=[sum(abs(ylii2-ManEEM))/256 sum(abs(ylii-actual))/256]
fclose('all')
