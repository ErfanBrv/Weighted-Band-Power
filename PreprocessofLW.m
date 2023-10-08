function [out,out1,out2,out3,out4] = PreprocessofLW(Erf,Vz_t,Vz_flag,hann_Vz_flag,Sep_flag_Vz,C1,C2,C3,C4,Erf_flag_Vz,Vref_t,Vref_flag,hann_Vref_flag,Med_flag,Win2D_flag,fft_flag,frf_flag,x1,y1,f1,f2)
%% Changing the dimention
if Vz_flag == 1
    Vz_t = permute(Vz_t,[3,1,2]);
end
if Vref_flag == 1
    Vref_t = permute(Vref_t,[3,1,2]);
end

%% Hann window 1D
if hann_Vz_flag ==1
    Vz_t = HannLAMB(Vz_t);
    figure,plot(Vz_t(:,x1,y1));title('Vz')
end
if hann_Vref_flag == 1
    Vref_t = HannLAMB(Vref_t);
    figure,plot(Vref_t(:,x1,y1));title('Vref')
end

%% Seperation of the plate and filling the missing part
if Sep_flag_Vz == 1
    Vz_t = Vz_t(:,C1:C2,C3:C4);
end 

if Erf_flag_Vz == 1
    Erf  = Erf (C1:C2,C3:C4);
    for frame = 1:size(Vz_t,1)
        for spatial_y = 1:size(Vz_t,2)
            for spatial_x = 1:size(Vz_t,3)
                if isnan(Erf(spatial_y,spatial_x))
                    Vz_t(frame,spatial_y,spatial_x) = Vz_t(frame,103,53) ;
                end
            end
        end
    end
end  
figure,plot(Vz_t(:,x1,y1));title('Vz')
Vref_t = Vref_t(:,x1,y1);Vref_t = repmat(Vref_t,1,size(Vz_t,2),size(Vz_t,3)) ;
figure,plot(Vref_t(:,x1,y1));title('Vref')

%% Median
if Med_flag ==1
     for frame = 1:size(Vz_t,1)
        Vz_t(frame,:,:) = mymedian3x3(squeeze(Vz_t(frame,:,:))); % 3x3 median filtering
     end 
     figure,imshow(squeeze(Vz_t(500,:,:)),[]),colormap('jet');title('Vz-med')
end    

%% 2D Windowing
if Win2D_flag == 1              
    for frame = 1:size(Vz_t,1)
        Vz_t(frame,:,:) = squeeze(Vz_t(frame,:,:)).* Hann2D(size(Vz_t,3),size(Vz_t,2),0.2);
    end
    figure,imshow(squeeze(Vz_t(500,:,:)),[]),colormap('jet');title('Vz-win')
end

%% Taking fft
if fft_flag == 1
    Vz_f = fft(Vz_t);Vref_f = fft(Vref_t);
    Vz_f = Vz_f(f1:f2,:,:);Vref_f = Vref_f(f1:f2,:,:);
    figure,plot(abs(Vz_f(:,x1,y1)));title('Vz-f')       
    figure,plot(abs(Vref_f(:,x1,y1)));title('Vref-f')
end

%% Computing FRF
if frf_flag ==1
    FRF = Vz_f./Vref_f;
    figure,plot(abs(FRF(:,x1,y1))),title('FRF-sginal')
    figure,imshow(FBD1(abs(FRF),1,size(FRF,1),0),[]),colormap('jet');title('FRF-FBD')
end

%%
out = Vz_f; out1 = Vref_f ; out2 = FRF; out3 = Vz_t ; out4 = Vref_t;

end
