function TestGenDistortedImage(mode)
% Test function 'GenDistortedImage().

    if (mode==1)
        % point-to-point distortion.
        imgSize = [635, 635];
        psfInfo = [65, 65, 10];
        sourceInfo = [7, 7, 70, 100];
        factor = 5;
        %k1 = -5.0e-6;
        k1 = -1.0e-10;
        k2 = -2.0e-11;
        %k2 = -2.0e-21;
        
        fPars = [[3, 0, 0, 0, k1]; [2, 1, 0, 0, k1]; ...
            [5, 0, 0, 0, k2]; [3, 2, 0, 0, 2.0*k2]; [1, 4, 0, 0, k2]];
        gPars = [[2, 1, 0, 0, k1]; [0, 3, 0, 0, k1]; ...
            [4, 1, 0, 0, k2]; [2, 3, 0, 0, 2.0*k2]; [0, 5, 0, 0, k2]];
        
        oImg = GenDistortedImage(imgSize, psfInfo, sourceInfo, fPars, gPars, factor, true);
    end

end