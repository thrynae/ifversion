# ifversion documentation
[![View ifversion on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/69138-ifversion)
[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=thrynae/ifversion)

Table of contents

- Description section:
- - [Description](#description)
- Matlab/Octave section:
- - [Syntax](#syntax)
- - [Output arguments](#output-arguments)
- - [Input arguments](#input-arguments)
- - [Examples](#examples)
- - [Compatibility, version info, and licence](#compatibility-version-info-and-licence)

## Description

This minitool helps you determine the version of Matlab (or Octave) that is running your code. This is helpful when imposing a minimum version requirement, or when different versions need different methods to reach the same end result. By using persistent variables this will stay fast even with repeated calls.

You shouldn't use a logical test with v=version;v=str2double(v(1:3)); as it is incomplete for several releases (like e.g. 7.14 or 23.2). That also includes the potential for float rounding errors.

If you don't want to use a separate function, there are two built-in functions that may do what you need: [`verLessThan`](https://www.mathworks.com/help/matlab/ref/verlessthan.html) (introduced in R2007a) and [`isMATLABReleaseOlderThan`](https://www.mathworks.com/help/matlab/ref/ismatlabreleaseolderthan.html) (introduced in R2020b). The latter also allows filtering based on release type (pre-release vs normal release) and update number.

## Matlab/Octave

### Syntax

    tf=ifversion(test,Rxxxxab)
    tf=ifversion(test,Rxxxxab,'Octave',test_for_Octave,v_Octave)

### Output arguments

|Argument|Description|
|---|---|
|tf|If the current version satisfies the test this returns `true`. <br>This works similar to `verLessThan`.|

### Input arguments

|Argument|Description|
|---|---|
|test|Char array containing a logical test. The interpretation of this is equivalent to `eval([current test Rxxxxab])`. For examples, see below.|
|Rxxxxab|Char array containing a release description (e.g. `'R13'`, `'R14SP2'` or `'R2019a'`) or the numeric version. Note that `9.10` is interpreted as `9.1` when using numeric input.|
|test_for_Octave|See the `test` parameter. If not provided, the same test will run on GNU Octave as on Matlab. This will also trigger a warning.|
|v_Octave|The numeric version of Octave. If not provided, the same test will run on GNU Octave as on Matlab. This will also trigger a warning.|

### Examples
A few examples of valid syntax options:

```matlab
    ifversion('>=','R2009a')        % returns true when run on R2009a or later
    ifversion('<','R2016a')         % returns true when run on R2015b or older
    ifversion('==','R2018a')        % returns true only when run on R2018a
    ifversion('==',24.01)           % returns true only when run on R2024a
    ifversion('<',0,'Octave','>',0) % returns true only on Octave
    ifversion('<',0,'Octave','>=',6)% returns true only on Octave 6 and higher
    ifversion('==',9.10)            % !!! returns true only when run on R2016b (v9.1), not R2021a (v9.10) !!!
```

### Compatibility, version info, and licence
Compatibility considerations:
- This is expected to work on all releases.

|Test suite result|Windows|Linux|MacOS|
|---|---|---|---|
|Matlab R2024a|<it>W11 : Pass</it>|<it></it>|<it>Monterey : Pass</it>|
|Matlab R2023b|<it></it>|<it>ubuntu_22.04 : Pass</it>|<it>Monterey : Pass</it>|
|Matlab R2023a|<it>W11 : Pass</it>|<it></it>|<it></it>|
|Matlab R2022b|<it>W11 : Pass</it>|<it>ubuntu_22.04 : Pass</it>|<it>Monterey : Pass</it>|
|Matlab R2022a|<it>W11 : Pass</it>|<it></it>|<it></it>|
|Matlab R2021b|<it>W11 : Pass</it>|<it>ubuntu_22.04 : Pass</it>|<it>Monterey : Pass</it>|
|Matlab R2021a|<it>W11 : Pass</it>|<it></it>|<it></it>|
|Matlab R2020b|<it>W11 : Pass</it>|<it>ubuntu_22.04 : Pass</it>|<it>Monterey : Pass</it>|
|Matlab R2020a|<it>W11 : Pass</it>|<it></it>|<it></it>|
|Matlab R2019b|<it>W11 : Pass</it>|<it>ubuntu_22.04 : Pass</it>|<it>Monterey : Pass</it>|
|Matlab R2019a|<it>W11 : Pass</it>|<it></it>|<it></it>|
|Matlab R2018b|<it>W11 : Pass</it>|<it>ubuntu_22.04 : Pass</it>|<it>Monterey : Pass</it>|
|Matlab R2018a|<it>W11 : Pass</it>|<it></it>|<it></it>|
|Matlab R2017b|<it>W11 : Pass</it>|<it>ubuntu_22.04 : Pass</it>|<it>Monterey : Pass</it>|
|Matlab R2016b|<it>W11 : Pass</it>|<it>ubuntu_22.04 : Pass</it>|<it>Monterey : Pass</it>|
|Matlab R2015a|<it>W11 : Pass</it>|<it></it>|<it></it>|
|Matlab R2013b|<it>W11 : Pass</it>|<it></it>|<it></it>|
|Matlab R2007b|<it>W11 : Pass</it>|<it></it>|<it></it>|
|Matlab 6.5 (R13)|<it>W11 : Pass</it>|<it></it>|<it></it>|
|Octave 8.4.0|<it>W11 : Pass</it>|<it></it>|<it></it>|
|Octave 8.2.0|<it>W11 : Pass</it>|<it></it>|<it></it>|
|Octave 7.2.0|<it>W11 : Pass</it>|<it></it>|<it></it>|
|Octave 6.2.0|<it>W11 : Pass</it>|<it>ubuntu_22.04 : Pass</it>|<it>Catalina : Pass</it>|
|Octave 5.2.0|<it>W11 : Pass</it>|<it></it>|<it></it>|
|Octave 4.4.1|<it>W11 : Pass</it>|<it></it>|<it>Catalina : Pass</it>|

    Version: 1.2.1.2
    Date:    2024-03-23
    Author:  H.J. Wisselink
    Licence: CC by-nc-sa 4.0 ( https://creativecommons.org/licenses/by-nc-sa/4.0 )
    Email = 'h_j_wisselink*alumnus_utwente_nl';
    Real_email = regexprep(Email,{'*','_'},{'@','.'})

### Test suite

The tester is included so you can test if your own modifications would introduce any bugs. These tests form the basis for the compatibility table above. Note that functions may be different between the tester version and the normal function. Make sure to apply any modifications to both.
