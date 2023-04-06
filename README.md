[![View ifversion on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/69138-ifversion)

This minitool helps you determine the version of Matlab (or Octave) that is running your code. This is helpful when imposing a minimum version requirement, or when different versions need different methods to reach the same end result. By using persistent variables this will stay fast even with repeated calls.

You shouldn't use a logical test with v=version;v=str2double(v(1:3)); as it is incomplete for several releases (like e.g. 7.14 or a future version 10.1). That also includes the potential for float rounding errors.

    % examples:
    ifversion('>=','R2009a')        % returns true when run on R2009a or later
    ifversion('<','R2016a')         % returns true when run on R2015b or older
    ifversion('==','R2018a')        % returns true only when run on R2018a
    ifversion('==',9.14)            % returns true only when run on R2023a
    ifversion('<',0,'Octave','>',0) % returns true only on Octave
    ifversion('<',0,'Octave','>=',6)% returns true only on Octave 6 and higher
    ifversion('==',9.10)            % !!! returns true only when run on R2016b (v9.1), not R2021a (v9.10) !!!

If you don't want to use a separate function, there are two built-in functions that may do what you need: [`verLessThan`](https://www.mathworks.com/help/matlab/ref/verlessthan.html) (introduced in R2007a) and [`isMATLABReleaseOlderThan`](https://www.mathworks.com/help/matlab/ref/ismatlabreleaseolderthan.html) (introduced in R2020b). The latter also allows filtering based on release type (pre-release vs normal release) and update number.

Licence: CC by-nc-sa 4.0
