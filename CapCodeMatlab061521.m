% This code calculates the direct, indirect, and total spatial spillover effects 
% for the capital stock variables (Table 7) following LeSage and Pace (2009, pp 114-115).  


% Estimated "marginal effects" od stocks of capital for metro, non-metro
% and non-metro nonmetro adjacent counties; these are obtained from the
% last portion of the STATA code "....". 
% Betas - coefficients for the stocks of capital not interacted with W 
% Thetas - coefficients for the spatial lags of the stocks of capital 
% seBetas - standard errors associated with eack element of Betas
% Thetas - coefficients for the spatial lags of the stocks of capital 
% seThetas - standard errors associated with the elements of Thetas

Betas = [1.367	-4.869	2.189 ; 
        -0.18	-0.091	0.031 ; 
         0.036	-0.005	0.02 ; 
        -0.036	-0.092	-0.069 ; 
         0.108    0.15	0.111 ; 
         -0.109	-0.031	0.26 ; 
         -0.001	0.022	-0.024; 
         0.002	0.02	0.032; 
         0.119	0.065	0.043; 
         0.251	-0.013	0.279; 
         0.118	-0.08	-0.046; 
         -0.018	-0.018	-0.017]; 

seBetas=[0.147	2.22	0.51;
        0.137	0.064	0.107;
        0.016	0.019	0.02;
        0.056	0.041	0.026;
        0.019	0.023	0.019;
        0.078	0.038	0.107;
        0.012	0.013	0.014;
        0.017	0.018	0.018;
        0.015	0.013	0.012;
        0.088	0.031	0.056;
        0.056	0.047	0.038;
        0.016	0.013	0.012];

Thetas= [-2.451	-38.198	-2.279;
        -5.165	0.38	4.582;
        0.119	0.344	-0.01;
        0.518	-0.292	-0.597;
        0.361	0.381	0.193;
        -1.932	0.129	2.411;
        -0.622	0.157	-0.135;
        0.349	-0.222	0.174;
        -0.182	0.106	-0.169;
        3.95	-0.135	0.47;
        0.365	-0.752	-0.652;
        -0.036	-0.087	-0.198]; 

seThetas=   [2.218	31.501	5.644; 
            2.239	0.883	1.472;
            0.219	0.214	0.259;
            0.698	0.431	0.266;
            0.271	0.265	0.224;
            1.081	0.321	1.177;
            0.162	0.171	0.14;
            0.202	0.204	0.193;
            0.129	0.11	0.103;
            0.978	0.437	0.492;
            0.806	0.556	0.422;
            0.171	0.148	0.127];  

rho=0.4610; 
serho=0.0930; 

%%% calculate a row standardized proximity weighting matrix using Haverstine forumla
%%% max distance considered for proximity: 200 miles 

% Download the file "Coordinates.mat" in the same directory where the 
% .m files are locatehd

lon =Coordinates(:,1); 
lat =Coordinates(:,2);

% Obtain a matrix W containing spatial weights - maximum distance of
% influence is assumed to be 200 miles 

max_dist=sqrt((max(lon) - min(lon))^2 + (max(lat) - min(lat))^2);
n=length(lon);

% Radius of the earth in KM
Rkm=6367;
% Radius of the earth in miles
Rmil=3956;
%Distance between counties 
dist=zeros(n,n);
W=zeros(n,n);
a=pi/180;
lon=lon'.*a;
lat=lat'.*a;

for i=1:n;
    for j=1:n;
        dlon(i,j)=lon(j)-lon(i); 
        dlat(i,j)=lat(j)-lat(i);
        b(i,j)=sqrt(sin(0.5*dlat(i,j))^2+cos(lat(i))*cos(lat(j))*sin(0.5*dlon(i,j))^2);
        if b(i,j)>=1;
            b(i,j)=1;
        end
        dist(i,j)=Rmil*2*asin(b(i,j));
        if dist(i,j)==0;
            W(i,j)=0;
        end
        if dist(i,j)>=200;
            W(i,j)=0;
        end
        if dist(i,j)~=0;
        W(i,j)=1./dist(i,j);
        end
    end
end

sumcW=sum(W,1);
sumrW=sum(W,2);
minWc=min(sumcW);
minWr=min(sumrW);

for i=1:n;
    W(:,i)=W(:,i)./sumrW(i);
    W(i,i)=0;
end

dir=zeros(size(Betas,1), size(Betas,2));
indir=zeros(size(Betas,1), size(Betas,2));
total=zeros(size(Betas,1), size(Betas,2));

I=eye(n);
ivec=diag(I);


%%% the matrixes "dir" "indir" and "total" represent the Indirect, indirect and Total Spatial supllovers  

for i=1:12;
    for j=1:3;
        S=inv(I-rho*W)*(I*Betas(i,j)+W*Thetas(i,j)); 
        dir(i,j)=sum(diag(S))/n; 
        indir(i,j)=sum((sum((S-I.*S),1)/n))/n; 
        total(i,j)=(ivec'*S*ivec)/n; 
   end 
end

%%% values of the estimated Indirect spatial spillovers 
% indir_N=indir.*n; 
% indir_NN=total-dir;

%%%%%% Simulated SE

%%%% simulated standard errors are obtained treating the esimated coefficients as 
%%%% random variables, and taking 1,000 draws from their distribution   

RD=1000;   % number of random draws 

RBetas=zeros(size(Betas,1), size(Betas,2), RD);
RThetas=zeros(size(Betas,1), size(Betas,2), RD);
Rrho=zeros(1, 1, RD);

%%% Random draws 

for i=1:12;
    for j=1:3;
        for k=1:RD;
            RBetas(i,j,k) = normrnd(Betas(i,j), seBetas(i,j));
            RThetas(i,j,k) = normrnd(Thetas(i,j), seThetas(i,j));
        end
    end
end

for k=1:RD;
    Rrho(k) = normrnd(rho, rhoSE);
end


Rdir=zeros(size(Betas,1), size(Betas,2), RD);
Rindir=zeros(size(Betas,1), size(Betas,2), RD);
Rtotal=zeros(size(Betas,1), size(Betas,2), RD);

I=eye(n);
ivec=diag(I);

for i=1:12;
    for j=1:3;
        for k=1:RD;
            S=inv(I-Rrho(k)*W)*(I*RBetas(i,j,k)+W*RThetas(i,j,k)); 
            Rdir(i,j,k)=sum(diag(S))/n; 
            Rindir(i,j,k)=sum((sum((S-I.*S),1)/n)); 
            Rtotal(i,j,k)=(ivec'*S*ivec)/n; 
        end  
    end
end

%Simulated standard errors of Direct, Indirect and Total spatial spillovers 
sim_seDir=std(Rdir,0,3);
sim_seInd=std(Rindir,0,3);
sim_seTot=std(Rtotal,0,3);



