% Simulation of Field Distortion
%
%     With sources (Positions & Flux), a reference PSF and a group of 
% distortion parameters, the function GenDistortedImage() will generate a 
% distorted image.
% 
%     The definition of the coordinate system is quite important for 
% programming. Here, we define X axis in column direction, increasing from 
% left to right, Y axis in row direction, increasing from top to bottom.  
% In the following codes, we use common variables that i and m are in 
% column (X) direction, j and n are in row (Y) direction. 
% 
%     The sizes of an image and a PSF are required to be odd numbers.  
% The coordinate of the central pixel is (0,0).  The factor of down 
% sampling is also an odd number.
%
% History £º
% V0.1 2020-01-11£¬the first version after a careful design.
% V0.2 2020-01-13, correct the ERRORs about the reference position. plese
%                  search V0.2 for actually modification. 

function outImage = GenDistortedImage(imgSize, psfInfo, sourceInfo, ...
    distortionFPars, distortionGPars, downSamplingFactor, IsDrawImg)
% GenDistortedImage() will generate a distorted image when given a list of
%   parameters.
% Input : 
%   imgSize  :  [imgW, imgH], imgW is the width, imgH is the height.
%   psfInfo  :  [psfW, psfH, sigma]. sigma controls the broadness of the PSF.
%   sourceInfo  :   [nCol, nRow, spacing, flux], nRow and nCol should be odd numbers.
%   distortionFPars  :
%   distortionGPars  :  A list of distortion parameters, each row has the 
%                       style of [iPow, jPow, mPow, nPow, coefficient]
%   downSamplingFactor  :  A factor for down sampling the distorted image.
%   IsdrawImg :  Bool variable which controls if draw the images.
% Output £º
%   outImage  :  The output image with distortion. The sizes are 
%                width = imgW/downSamplingFactor and height = imgH/downSamplingFactor.

    tic;
    
    % Some constants
    HRFName = 'HRDistortedImage.png';
    LRFName = 'LRDistortedImage.png';
    
    % Initialize outImage.
    outImage = zeros(imgSize(2), imgSize(1));
    
    % Generate a list of sources.
    sourceList = GenSources(sourceInfo);

    [numOfSources, ~] = size(sourceList);
    for ii = 1 : numOfSources
        % Get the F coefficients.
        [fZero, fCoeffs] = GenDistortionCoeffs(distortionFPars, ...
            sourceList(ii,1:2));
        % Set the G coefficients.
        [gZero, gCoeffs] = GenDistortionCoeffs(distortionGPars, ...
            sourceList(ii,1:2));
        
        % Generate a distorted PSF and its reference position.
        [distortedPSF, refPosition] = GenDistortedPSF(fCoeffs, gCoeffs, ...
            [fZero, gZero], sourceList(ii,:), psfInfo); 
        
        % Paste the PSF on outImage
        outImage = PastePSF(outImage, distortedPSF, refPosition);
    end
    toc;
    
    % Draw the high resolution outImage, and save the image into a file.
    if (IsDrawImg) 
        imgTitle = 'High Resolution Disorted Image';
        DrawImage(outImage, HRFName, imgTitle, distortionFPars, ...
            distortionGPars);
    end
    toc;
    
    % Down sample the image.
    outImage = DownSampleImage(outImage, downSamplingFactor);
    toc;
    
    % Draw the down sampled image, and save the image into a file.
    if (IsDrawImg) 
        imgTitle = 'Low Resolution Disorted Image';
        DrawImage(outImage, LRFName, imgTitle, distortionFPars, ...
            distortionGPars); 
    end
    toc;

end


function sourceList = GenSources(sourceInfo)
% GenSources will generate a list of sources with positions and fluxs.
% V0.2, with refX=0 and refY=0. No imgSize is needed.
% Input : 
%   sourceInfo   :   [nCol, nRow, spacing, flux], nRow and nCol should be odd numbers.
% Output :
%   sourceList  :  A list of sources, each line has the style of [x, y, flux].
    
    % Initialize sourceList.
    sourceList = zeros(sourceInfo(1)*sourceInfo(2), 3);
    
    % V0.2, with refX=0 and refY=0. No imgSize is needed.
    %refX = (imgSize(1)+1)/2;
    %refY = (imgSize(2)+1)/2;
    refX = 0;
    refY = 0;
    hCol = (sourceInfo(1)-1)/2; 
    hRow = (sourceInfo(2)-1)/2;
    
    for ii = -hCol : hCol
        x = refX + ii*sourceInfo(3);
        for jj = -hRow : hRow   
             y = refY + jj*sourceInfo(3);
             idx = (jj+hRow)*sourceInfo(1) + (ii+hCol+1);
             sourceList(idx, :) = [x, y, sourceInfo(4)];
        end
    end
             
end


function [zeroCoeff, distortionCoeffs] = GenDistortionCoeffs(distortionPars, ...
            position)
% GenDistortionCoeffs() will generate new coefficient of u(mPow) and
%     v(nPow), which is dependent on position [x,y]. 
%     distortionCoeffs = coefficient*x^iPow*y^jPow. 
%     The coefficient with zero mPow and nPow should be picked up for
%     estimating the global shift of the PSF.
%
% Input :
%   distortionPars  :   [iPow, jPow, mPow, nPow, coefficient].
%   position  :  [x, y].
% Output :
%   zeroCoeff  :   The coefficient with mPow==0 and nPow==0
%   distortionCoeffs :   [mPow, nPow, coefficient] 

    % Get the number of parameters.
    [N, ~] = size(distortionPars);
    
    % Initialize zeroCoeff and tmpCoeffs.
    zeroCoeff = 0.0;
    tmpCoeffs = zeros(N, 3);
    
    idx = 0;
    for ii = 1 : N
        if (distortionPars(ii,3)==0 && distortionPars(ii,4)==0)
            zeroCoeff = zeroCoeff + distortionPars(ii,5)* ...
                position(1)^distortionPars(ii,1) * ...
                position(2)^distortionPars(ii,2);
        else 
            idx = idx + 1;
            tmpCoeffs(idx,1) = distortionPars(ii,3); % Set mPow
            tmpCoeffs(idx,2) = distortionPars(ii,4); % Set nPow
            tmpCoeffs(idx,3) = distortionPars(ii,5) * ...
                postion(1)^distortionPars(ii,1) * ...
                position(2)^distortionPars(ii,2);
        end
    end
    
    % Set the distortionCoeffs.
    if (idx<1)
        distortionCoeffs = -1;
    else 
        distortionCoeffs = tmpCoeffs(1:idx,:);
    end
    
end


function [distortedPSF, refPosition] = GenDistortedPSF(fCoeffs, gCoeffs, ...
            zeroCoeffs, source, psfInfo)
% GenDistortedPSF() generate a distorted PSF when the distortion
%     coefficients, the information of the source and the PSF are known.
%
% Input :
%   fCoeffs   :    The coefficients in U direction.
%   gCoeffs   :    The coefficients in V direction.
%   zeroCoeffs  :  [fZero, gZero].
%   source   :    [x0, y0, flux], the position and flux of an source.
%   psfInfo  :  [psfW, psfH, sigma]
% Output :
%   distortedPSF  :  The distorted PSF.   
%   refPosition   :  The reference position of the PSF.

    % Relevant equations :
    % Pr(u-x0+f, v-y0+g)*O(x0,y0)
    % fZero = sum(a_ij00*x0^i*y0^j)
    % fOther = sum(a_ijmn*x0^i*y0^j*u^m*v^n)
    % So, for x0, y0,  u-x0+f = u+fOther - (x0-fZero).

    x0 = source(1);  
    y0 = source(2);
    
    % Calculate refPosition
    % V0.2, correct the ERRORs in shifts.
    dx = x0 - zeroCoeffs(1);
    dy = y0 - zeroCoeffs(2);
    refX = double(int32(dx));
    refY = double(int32(dy));
    refPosition = [refX, refY];
    
    % Calculate the distorted PSF. *****
    psfHW = (psfInfo(1)-1)/2; 
    psfHH = (psfInfo(2)-1)/2;
    m = refX-psfHW : refX+psfHW;  
    n = refY-psfHH : refY+psfHH;
    % V0.2, correct the ERRORs in shifts.
    ddx = dx - refX;
    ddy = dy - refY;
    m = m + ddx;
    n = n + ddy;
    u = m - refX;  % V0.2
    v = n - refY;  % V0.2
    
    % Calculate the distorted u.
    if (fCoeffs~=-1)
        [NF,~] = size(fCoeffs);
        for ii = 1 : NF
            u = u + fCoeffs(ii,3) .* m.^fCoeffs(ii,1) .* n.^fCoeffs(ii,2);
        end
    end
    
    % Calculate the distorted v.
    if (gCoeffs~=-1)
        [NG,~] = size(gCoeffs);
        for ii = 1 : NG
            v = v + gCoeffs(ii,3) .* m.^gCoeffs(ii,1) .* n.^gCoeffs(ii,2);
        end
    end
    
    % Calculate the distorted PSF.
    [U, V] = meshgrid(u,v);
    distortedPSF = exp( -(U.^2 + V.^2)./(2*psfInfo(3)^2) );
    
    % Normalize the PSF.
    distortedPSF = distortedPSF./sum(distortedPSF(:));
    distortedPSF = source(3) .* distortedPSF;

end


function [outImage, errCode] = PastePSF(inImage, distortedPSF, refPosition)
% PastePSF() will paste a distorted PSF on the outImage.
%
% Input :
%   inImage   :  The input image.
%   distortedPSF  :  The distorted PSF to be pasted.
%   refPosition   :   The reference position of the PSF. 
% Output : 
%   outImage  :  The output image.
%   errCode    :  Error code, 1: Success; -1 :  Cut; -2 : OutOfRange & failed.
%

    [psfH, psfW] = size(distortedPSF);
    psfHW = (psfW-1)/2;
    psfHH = (psfH-1)/2;
    [imgH, imgW] = size(inImage);

    % V0.2, calculate the absolute reference postion.
    refX = refPosition(1) + (imgW+1)/2;
    refY = refPosition(2) + (imgH+1)/2;

    outImage = inImage;
    if ( (refX<=imgW - psfHW) && (refX > psfHW) && ...
            (refY>psfHH) && (refY<=imgH-psfHH) )
        % In this situation, the whole PSF is inside outImage. 
        XB = refX-psfHW;
        XE = refX+psfHW;
        YB = refY-psfHH;
        YE = refY+psfHH;
        outImage(XB:XE, YB:YE) = outImage(XB:XE, YB:YE) + distortedPSF;
        errCode = 1;
    elseif ( (refX<=-psfHW) || (refX>imgW+psfHW) || ...
            (refY<=-psfHH) || (refY>imgH+psfHH) )
        % In this situation, the whole PSF is outside outImage.
        disp(' Out of range! Pasting PSF failed!');
        errCode = -2;
    else
        % In this situation, the PSF partially inside outImage.
        disp(' Cut needed during Pasting PSF!');
 
        oMinX = max(refX-psfHW, 1);
        if (oMinX==1)  
            sMinX = psfHW-refX+2;
        else
            sMinX = 1;
        end
    
        oMaxX = min(refX+psfHW, imgW);
        if (oMaxX==imgW)  
            sMaxX = imgW - (refX+psfHW) + psfW;
        else
            sMaxX = psfW;
        end
    
        oMinY = max(refY-psfHH, 1);
        if (oMinY==1)  
            sMinY = psfHH-refY +2;
        else
            sMinY = 1;
        end
        
        oMaxY = min(refY+psfHH, imgH);
        if (oMaxY==imgH)  
            sMaxY = imgH - (refY+psfHW) + psfH;
        else
            sMaxY = psfH;
        end
        
        outImage(oMinX:oMaxX, oMinY:oMaxY) = outImage(oMinX:oMaxX, oMinY:oMaxY) + ...
            distortedPSF(sMinX:sMaxX, sMinY:sMaxY);
        errCode = -1;
    end
end


function outImage = DownSampleImage(inImage, factor)
% DownSampleImage() down sample a high resolution image to a low resolution
%     image.
%
% Input : 
%   inImage  :  The input image.
%   factor   :   Down sampling factor.
% Output :
%   outImage
    
    [NR, NC] = size(inImage);
    LNR = NR/factor;
    LNC = NC/factor;
    
    outImage = zeros(LNR, LNC);
    for jj = 1:LNR
        for ii = 1:LNC
            tmpImg = inImage((jj-1)*factor+1 : jj*factor, ...
                (ii-1)*factor+1 : ii*factor);
            outImage(jj,ii) = sum(tmpImg(:));
        end
    end
    
end


function DrawImage(inImage, imgFName, imgTitle, FPars, GPars)
% DrawImage() draw an image and display relevant information.
% Input
%   inImage  : The input image.
%   imgFName   :  File name of the printed image.
%   imgTitle   :  The title of the figure.
%   FPars  :  The f distortion parameters to be shown.
%   GPars  :  The g distortion parameters to be shown.
% Output
%   image file for publication.

    % Generate a cell which contains the strings about the FPars. 
    [NF,~] = size(FPars);
    FParsStr = cell(1,NF+1);
    FParsStr(1) = {'f parameters'};
    for ii = 1:NF
        str = Pars2Str(FPars(ii,:));
        nstr = ['a_{', str];
        FParsStr(ii+1) = {nstr};
    end
    
    % Generate a cell which contains the strings about the FPars. 
    [NG,~] = size(GPars);
    GParsStr = cell(1,NG+1);
    GParsStr(1) = {'g parameters'};
    for ii = 1:NG
        str = Pars2Str(GPars(ii,:));
        nstr = [ 'b_{', str];
        GParsStr(ii+1) = {nstr};
    end

    % Calculate the text position.
    [imgY, imgX] = size(inImage);
    vs = 0.1;
    TFX = imgX*0.05;
    TFY = imgY*vs;
    TGX = imgX*0.80;
    TGY = imgY*vs;
    
    figure;
    set(gcf,'units','normalized','position',[0.1 0.1 0.55 0.8]);
    set(gca,'position',[0.05 0.13 0.9 0.8]);
    %contourf(inImage, 20, 'LineStyle', 'none');
    imshow(inImage, []);
    colormap(autumn);
    colorbar;
    set(gca,'XGrid','on');
    set(gca,'YGrid','on');
    axis on;
    set(gca,'FontSize',24);
    title(imgTitle);
    set(gca,'FontSize',16);
    xlabel('X Position (pixel)');
    ylabel('Y Position (pixel)');
    
    % Draw f and g parameters.
    text(TFX, TFY, FParsStr, 'FontSize', 16);
    text(TGX, TGY, GParsStr, 'FontSize', 16);
    
    print(gcf,'-dpng', imgFName, '-r300');

end


function str = Pars2Str(Pars)
% Pars2Str() convert Pars into a string with predefined style.
%
% Input
%   Pars   :   Parameters in style of [iPow, jPow, mPow, nPow, Coefficient]
% Output
%   str   :   Ouput string nnnn = nnnE1.2

    ip = num2str(Pars(1));
    jp = num2str(Pars(2));
    mp = num2str(Pars(3));
    np = num2str(Pars(4));
    cp = num2str(Pars(5),'%8.2e\n');
    str = [ip, jp, mp, np, '} = ', cp];
    
end