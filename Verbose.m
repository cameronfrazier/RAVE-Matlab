function Verbose( ap, strText, varargin )
%VERBOSE Conditional printing of text
%   simplifying fcn for conditional printing

    if ap.verbose
        fprintf(1,strText, cell2mat(varargin));
    end

end

