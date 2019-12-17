

function result = OneDScale(line,Q)
    new_line = complex(line);
    line_fft = fft(new_line);
    lenline = length(line);
    marksize = (lenline+1)/2;
    Qlength = Q*lenline;
    
    
    new_lineFFT = zeros(Qlength,1);
    new_lineFFT(1:marksize) = line_fft(1:marksize);
    new_lineFFT(Qlength-marksize+2:Qlength) = line_fft(marksize+1:lenline);   
    new_lineQ = ifft(new_lineFFT);
    
    result = real(Q*new_lineQ);
end