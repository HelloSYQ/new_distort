

function result = sampling_sim_calc(test_length,cigma)
    z = @(x) exp(-(x-(test_length+1)/2).^2/cigma^2);
    for i = 1:test_length
        z_int(i) = integral(z,i-1/2,i+1/2);
    end
    result = z_int;
end