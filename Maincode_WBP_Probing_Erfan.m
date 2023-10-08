%% Loading datasets
clear
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exp 
% This is responsible for loding the dataset- CFRP1 in the article
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('CFRP_330x330_QuasiIso_FBHInCircle_Chirp_5to300kHz_TimeData')  
load('ERF_Big.mat'); % Specifing the Nan values
Vref = DataMatrix(4); Vref = Vref.SignalGrid;
Vz   = DataMatrix(3); Vz   = Vz.SignalGrid;

%% necessary preprocessins
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exp 

% This function is responsible for doing some preprocessing. Please just
% consider Vz_f and Vref_f as the main outputs 

% In PreprocessofLW, there are some functions that should be placed in the
% current folder, including HannLAMB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Vz_f,Vref_f,FRF,Vz_t,Vref_t] = PreprocessofLW(Erf,Vz,1,0,1,4,118,5,117,1,Vref,1,0,0,0,1,1,10,10,1,1200);

%% WBP 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Exp

% Responsible for WBP function in the article entitled probing ... 


Erf = Erf(4:118,5:117);
[~,mm,nn] = size(Vz_f);
Vz = abs(Vz_f); Vz = permute(Vz,[2,3,1]);
Yq = Yq(4:118,5:117);
Xq = Xq(4:118,5:117);
center = [56,58];

radius = zeros(mm,nn);
for i = 1:mm
    for j = 1:nn
    %    if isnan(Erf1(i,j))
    %        radius(i,j)=0;
    %    else
        radius(i,j)= sqrt(      (  ((Yq(center(1),center(2))-Yq(i,j))*1) ^2  ) + (     ((Xq(center(1),center(2))-Xq(i,j))*1)^2    )    ); % 61,60 for CFRP12
    %    end
    end
end
figure,imshow(radius,[]),colormap('jet')


%radius(center(1),center(2)) = 0 ; 
x = nonzeros(reshape(radius,[115*113,1])) ;



WD1 = zeros(mm,nn,1200-1+1);
for i = 1:size(WD1,3)
    Vz_2 = Vz(:,:,i).^2 ;
    Vz_2(isnan(Vz_2))= 0; Vz_2(56,58)=0;  % this 56 and 58 could be changed 
    y    = nonzeros(reshape(Vz_2,[115*113,1])); 
  %  y    = (y - min(y)) / ( max(y) - min(y) ) ; 
    F2   = fit(x,y,'exp2');
    cfc  = coeffvalues(F2);
    for j = 1:mm
        for z = 1:nn
            if isnan(Erf(j,z))
                WD1(j,z,i)=0;
            else
                WD1(j,z,i)  = cfc(1)*exp(cfc(2)*radius(j,z)) + cfc(3)*exp(cfc(4)*radius(j,z)) ;
            end
        end
    end
end



out = WD1;
WBP1 = zeros(mm,nn,1200-1+1);
for k = 1:size(WBP1,3)
    for i =1:mm
        for j = 1:nn
            if isnan(Erf(i,j))  
                WBP1(i,j,k)=nan;
            else
                WBP1(i,j,k) = (abs( FRF(k,i,j))^2)/WD1(i,j,k);
            end
        end
    end
end



out1 = WBP1;
out2 = permute(out1,[3,1,2]);
ff   = log(FBD1(out2,1,1200,1));



% For filling that hole placed between FBH1 and FBH11
for i = 1:115
    for j = 1:113
        if isnan(ff(i,j))
            ff(i,j) = -0.97;
        end        
    end 
end


figure,imshow(LI(ff),[]),colormap('jet')
