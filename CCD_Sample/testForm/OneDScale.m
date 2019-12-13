

function result = OneDScale(line,Q)
    new_line = complex(line);
    line_fft = fft(new_line);
    lenline = length(line);
    marksize = (lenline-1)/2;
    
    new_lineFFT = zeros(Q*(lenline-1)+1,1);
    new_lineFFT(1:marksize) = line_fft(1:marksize);
    new_lineFFT(Q*(lenline-1)-marksize+2:Q*(lenline-1)+1) = line_fft(lenline-marksize+1:lenline);
    
    new_lineQ = ifft(new_lineFFT);
    
    result = real(Q*new_lineQ);
end