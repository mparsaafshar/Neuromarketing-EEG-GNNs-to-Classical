outputFile = 'EEG_Features_All_Users.csv';
fid = fopen(outputFile, 'w');

fprintf(fid, 'User,Page,Product,Bought,Electrode,');

bands = struct('Delta', [1 4], 'Theta', [4 8], 'Alpha', [8 12], 'Beta', [12 30], 'Gamma', [30 45]);

for band = fieldnames(bands)'
    bandName = band{1};
    fprintf(fid, '%s_FFT_Mean,%s_FFT_Std,%s_FFT_Skew,%s_FFT_Kurt,%s_PSD_Mean,%s_PSD_Std,%s_PSD_Skew,%s_PSD_Kurt,', ...
        bandName, bandName, bandName, bandName, bandName, bandName, bandName, bandName);
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
                            fft_mean = mean(fftVals);
                            fft_std = std(fftVals);
                            fft_skew = skewness(fftVals, 1);
                            fft_kurt = kurtosis(fftVals, 1);

                            [psdVals, freqs] = pwelch(eegSegment, [], [], [], EEGFs);
                            psd_mean = mean(psdVals);
                            psd_std = std(psdVals);
                            psd_skew = skewness(psdVals, 1);
                            psd_kurt = kurtosis(psdVals, 1);

                            fprintf(fid, '%.6f,%.6f,%.6f,%.6f,%.6f,%.6f,%.6f,%.6f,', ...
                                fft_mean, fft_std, fft_skew, fft_kurt, ...
                                psd_mean, psd_std, psd_skew, psd_kurt);
                        end

                        fprintf(fid, '\n');
                    end
                end
            end
        end
    end
end

fclose(fid);
disp('Feature extraction for all users completed and saved.');


