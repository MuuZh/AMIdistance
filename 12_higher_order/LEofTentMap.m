function LE = LEofTentMap( rStart, rEnd, rStep )
    rValues = rStart:rStep:rEnd;
    nPoints = length( rValues );
    LE      = log(2*rValues);
end