function r = AMI_in_bins(AC, AMI, num_bins)
    num_AC = length(AC);
    [N, binedges] = histcounts(AC, num_bins);
    r = {};
    for i = 1:num_bins
        r{i} = AMI(binedges(i) <= AC & AC < binedges(i+1));
    end

end