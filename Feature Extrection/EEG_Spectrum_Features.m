outputFile = 'EEG_Full_Spectrum_Features_All_Users.csv';
fid = fopen(outputFile, 'w');
fprintf(fid, 'User,Page,Product,Bought,Electrode,');

bands = struct('Delta', [1 4], 'Theta', [4 8], 'Alpha', [8 12], 'Beta', [12 30], 'Gamma', [30 45]);

for band = fieldnames(bands)'
    bandName = band{1};
    for freq = bands.(bandName)(1):bands.(bandName)(2)
        fprintf(fid, '%s_Freq_%d_FFT,%s_Freq_%d_PSD,', bandName, freq, bandName, freq);
    end
end
fprintf(fid, '\n');

for userId = 1:44
    if userId == 4 || userId == 11
        continue;
    end
    
    userLabel = sprintf('S%02d', userId); 
    userData = eval(userLabel); 

    EEGFs = userData.EEG_clean.Fs; 

    filteredEEG = struct();
    for band = fieldnames(bands)'
        bandName = band{1};
        [b, a] = butter(3, bands.(bandName) / (EEGFs/2)); 
        filteredEEG.(bandName) = filtfilt(b, a, userData.EEG_clean.Data')'; 
    end

    for iPage = 1:6 
        for iProduct = 1:24 
            pageNo = int2str(iPage);
            productNo = int2str(iProduct);
            productField = strcat('Page', pageNo, '.', 'Product', productNo);
            
            if isfield(userData.(strcat('Page', pageNo)), strcat('Product', productNo))
                myProduct = userData.(strcat('Page', pageNo)).(strcat('Product', productNo));
                boughtStatus = myProduct.ProductInfo.Bought; 
                
                for iSegment = 1:size(myProduct.EEG_segments, 1)
                    startSample = myProduct.EEG_segments(iSegment, 1);
                    endSample = myProduct.EEG_segments(iSegment, 2);
                    
                    if (endSample - startSample) < EEGFs/2
                        continue
                    end
                    
                    for electrode = 1:size(userData.EEG_clean.Data, 1)
                        fprintf(fid, '%s,%d,%d,%d,%d,', userLabel, iPage, iProduct, boughtStatus, electrode);
                        
                        for band = fieldnames(bands)'
                            bandName = band{1};
                            eegSegment = filteredEEG.(bandName)(electrode, startSample:endSample);
                            
                            fftVals = abs(fft(eegSegment));
                            [psdVals, freqs] = pwelch(eegSegment, [], [], [], EEGFs);
                            
                            for freq = bands.(bandName)(1):bands.(bandName)(2)
                                freqIndex = find(freqs >= freq, 1, 'first');
                                if isempty(freqIndex)
                                    continue;
                                end
                                fprintf(fid, '%.6f,%.6f,', fftVals(freqIndex), psdVals(freqIndex));
                            end
                        end
                        
                        fprintf(fid, '\n');
                    end
                end
            end
        end
    end
end

fclose(fid);
disp('Feature extraction completed for all users (except S04 and S11) and saved to EEG_Full_Spectrum_Features_All_Users.csv');
