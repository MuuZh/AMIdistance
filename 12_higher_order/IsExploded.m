function IE = IsExploded(series)
    ac = autocorr(series, NumLags=1);
    IE = isnan(ac(2));
end