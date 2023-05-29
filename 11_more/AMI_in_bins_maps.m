function r = AMI_in_bins_maps(AC, AMI, num_bins, binedges)
    r = {};
    for i = 1:num_bins
        r{i} = AMI(binedges(i) <= AC & AC < binedges(i+1));
    end

end