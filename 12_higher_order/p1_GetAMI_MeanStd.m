function [AMImean, AMIstd] = p1_GetAMI_MeanStd(AC1, sample_size, series_length, eta)
    % This function calculates the standard deviation of the AMI
    % for a given AC1 value.
    AR1matrix = NaN(sample_size, series_length);
    for i = 1:sample_size
        AR1matrix(i,:) = MkSg_AR(series_length, AC1, eta);
    end

    % compute the AMI for each series
    AC_using_method = "Fourier";
    AMI_using_method = "kraskov2";

    step_AC = 1;
    step_AMI = 1;
    AMI = NaN(sample_size, 1);
    for i = 1:sample_size
        AMI(i) = IN_AutoMutualInfo(AR1matrix(i,:), step_AMI, AMI_using_method);
    end

    AMImean = mean(AMI);
    AMIstd = std(AMI);
end