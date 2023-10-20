function pass_part_fail=aaa___ifversion___test(varargin)
%This is not a true test suite, but it should confirm the function runs without errors.
%
%Pass:    passes all tests
%Partial: [no partial passing condition]
%Fail:    fails any test
pass_part_fail='pass';

checkpoint('aaa___ifversion___test','ifversion')
if nargin==0,RunTestHeadless=false;else,RunTestHeadless=true;end

try ME=[]; %#ok<NASGU>
    w=warning('off','HJW:ifversion:NoOctaveTest');
    RunExamples(RunTestHeadless)
    warning(w);% Reset warning.
    [ThrowError,msg] = TestDictionary;
catch ME;if isempty(ME),ME=lasterror;end %#ok<LERR>
    warning(w);
    if nargout>0
        pass_part_fail='fail';
    else
        rethrow(ME)
    end
end

SelfTestFailMessage = '';
% No self-validators found for this function.
checkpoint('read'); % Force write-out to checkpoint file.

if ThrowError || ~isempty(SelfTestFailMessage)
    if nargout>0
        pass_part_fail='fail';
    else
        if ThrowError
            error(msg)
        else
            error('Self-validator functions returned these error(s):\n%s',SelfTestFailMessage)
        end
    end
end
disp(['tester function ' mfilename ' finished '])
if nargout==0,clear,end
end
function RunExamples(RunTestHeadless)
% This creates the strings for a few examples.
% Mapping [false true] to ' X' requires double(tf)*56+32
txt = { ...
    sprintf('Do the claims below match the actual version?\nv: %s\n',version),...
    sprintf('[%c] R2009a or later',32+56*double(ifversion('>=','R2009a'))),...
    sprintf('[%c] R2015b or older',32+56*double(ifversion('<','R2016a'))),...
    sprintf('[%c] R2018a',32+56*double(ifversion('==','R2018a'))),...
    sprintf('[%c] R2023b',32+56*double(ifversion('==',23.02))),...
    sprintf('[%c] Octave',32+56*double(ifversion('<',0,'Octave','>',0))),...
    sprintf('[%c] Octave 6 and higher',32+56*double(ifversion('<',0,'Octave','>=',6))),...
    ''};
if ~RunTestHeadless
    clc
    fprintf('%s\n',txt{:})
end
end
function [ThrowError,msg]=TestDictionary
[IsMatlab,version_dictionary] = ifversion('>',0,'Octave','<',0);
ThrowError = false;msg = '';
if IsMatlab
    % Loop through the dictionary and see if the numeric test matches the text test.
    for n=1:size(version_dictionary,1)
        % Skip the old release names (like R13) and skip #.#0 releases.
        v1 = version_dictionary{n,1};v2 = version_dictionary{n,2}/100;
        if strcmp(v1(1:2),'R1'),continue,end
        if mod(version_dictionary{n-1,2},10)==9,continue,end
        if xor(ifversion('==',v1),ifversion('==',v2))
            % If the results don't match, throw an error.
            EndsInZero = logical(mod(v2,10));
            msg = sprintf([ ...
                'Test failed for %s (v%.' num2str(1+EndsInZero) 'f):\n'...
                'Test returned %d for char and %d for numeric.\n'],...
                v1,v2,ifversion('==',v1),ifversion('==',v2));
            ThrowError = true;
            return
        end
    end
end
end
function [tf,version_dictionary]=ifversion(test,Rxxxxab,Oct_flag,Oct_test,Oct_ver)
%Determine if the current version satisfies a version restriction
%
% To keep the function fast, no input checking is done. This function returns a NaN if a release
% name is used that is not in the dictionary.
%
% Syntax:
%   tf = ifversion(test,Rxxxxab)
%   tf = ifversion(test,Rxxxxab,'Octave',test_for_Octave,v_Octave)
%
% Input/output arguments:
% tf:
%   If the current version satisfies the test this returns true. This works similar to verLessThan.
% Rxxxxab:
%   A char array containing a release description (e.g. 'R13', 'R14SP2' or 'R2019a') or the numeric
%   version (e.g. 6.5, 7, or 9.6). Note that 9.10 is interpreted as 9.1 when using numeric input.
% test:
%   A char array containing a logical test. The interpretation of this is equivalent to
%   eval([current test Rxxxxab]). For examples, see below.
%
% Examples:
% ifversion('>=','R2009a') returns true when run on R2009a or later
% ifversion('<','R2016a') returns true when run on R2015b or older
% ifversion('==','R2018a') returns true only when run on R2018a
% ifversion('==',23.02) returns true only when run on R2023b
% ifversion('<',0,'Octave','>',0) returns true only on Octave
% ifversion('<',0,'Octave','>=',6) returns true only on Octave 6 and higher
% ifversion('==',9.10) returns true only when run on R2016b (v9.1) not on R2021a (9.10).
%
% The conversion is based on a manual list and therefore needs to be updated manually, so it might
% not be complete. Although it should be possible to load the list from Wikipedia, this is not
% implemented.
%
%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%
%|                                                                         |%
%|  Version: 1.2.1.1                                                       |%
%|  Date:    2023-10-20                                                    |%
%|  Author:  H.J. Wisselink                                                |%
%|  Licence: CC by-nc-sa 4.0 ( creativecommons.org/licenses/by-nc-sa/4.0 ) |%
%|  Email = 'h_j_wisselink*alumnus_utwente_nl';                            |%
%|  Real_email = regexprep(Email,{'*','_'},{'@','.'})                      |%
%|                                                                         |%
%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%/%
%
% Tested on several versions of Matlab (ML 6.5 and onward) and Octave (4.4.1 and onward), and on
% multiple operating systems (Windows/Ubuntu/MacOS). For the full test matrix, see the HTML doc.
% Compatibility considerations:
% - This is expected to work on all releases.

if nargin<2 || nargout>2,error('incorrect number of input/output arguments'),end

% The decimal of the version numbers are padded with a 0 to make sure v7.10 is larger than v7.9.
% This does mean that any numeric version input needs to be adapted. multiply by 100 and round to
% remove the potential for float rounding errors.
% Store in persistent for fast recall (don't use getpref, as that is slower than generating the
% variables and makes updating this function harder).
persistent  v_num v_dict octave
if isempty(v_num)
    % Test if Octave is used instead of Matlab.
    octave = exist('OCTAVE_VERSION', 'builtin');
    
    % Get current version number. This code was suggested by Jan on this thread:
    % https://mathworks.com/matlabcentral/answers/1671199#comment_2040389
    v_num = [100, 1] * sscanf(version, '%d.%d', 2);
    
    % Get dictionary to use for ismember.
    v_dict = {...
        'R13' 605;'R13SP1' 605;'R13SP2' 605;'R14' 700;'R14SP1' 700;'R14SP2' 700;
        'R14SP3' 701;'R2006a' 702;'R2006b' 703;'R2007a' 704;'R2007b' 705;
        'R2008a' 706;'R2008b' 707;'R2009a' 708;'R2009b' 709;'R2010a' 710;
        'R2010b' 711;'R2011a' 712;'R2011b' 713;'R2012a' 714;'R2012b' 800;
        'R2013a' 801;'R2013b' 802;'R2014a' 803;'R2014b' 804;'R2015a' 805;
        'R2015b' 806;'R2016a' 900;'R2016b' 901;'R2017a' 902;'R2017b' 903;
        'R2018a' 904;'R2018b' 905;'R2019a' 906;'R2019b' 907;'R2020a' 908;
        'R2020b' 909;'R2021a' 910;'R2021b' 911;'R2022a' 912;'R2022b' 913;
        'R2023a' 914;'R2023b' 2302};
end
version_dictionary = v_dict;

if octave
    if nargin==2
        warning('HJW:ifversion:NoOctaveTest',...
            ['No version test for Octave was provided.',char(10),...
            'This function might return an unexpected outcome.']) %#ok<CHARTEN>
        if isnumeric(Rxxxxab)
            checkpoint('ifversion_______________________________line095_cover_test','CoverTest')
            v = 0.1*Rxxxxab+0.9*fixeps(Rxxxxab);v = round(100*v);
        else
            L = ismember(v_dict(:,1),Rxxxxab);
            if sum(L)~=1
                checkpoint('ifversion_______________________________line100_cover_test','CoverTest')
                warning('HJW:ifversion:NotInDict',...
                    'The requested version is not in the hard-coded list.')
                tf = NaN;return
            else
                checkpoint('ifversion_______________________________line105_cover_test','CoverTest')
                v = v_dict{L,2};
            end
        end
    elseif nargin==4
        checkpoint('ifversion_______________________________line110_cover_test','CoverTest')
        % Undocumented shorthand syntax: skip the 'Octave' argument.
        [test,v] = deal(Oct_flag,Oct_test);
        % Convert 4.1 to 401.
        v = 0.1*v+0.9*fixeps(v);v = round(100*v);
    else
        checkpoint('ifversion_______________________________line116_cover_test','CoverTest')
        [test,v] = deal(Oct_test,Oct_ver);
        % Convert 4.1 to 401.
        v = 0.1*v+0.9*fixeps(v);v = round(100*v);
    end
else
    % Convert R notation to numeric and convert 9.1 to 901.
    if isnumeric(Rxxxxab)
        checkpoint('ifversion_______________________________line124_cover_test','CoverTest')
        % Note that this can't distinguish between 9.1 and 9.10, and will the choose the former.
        v = fixeps(Rxxxxab*100);if mod(v,10)==0,v = fixeps(Rxxxxab)*100+mod(Rxxxxab,1)*10;end
    else
        L = ismember(v_dict(:,1),Rxxxxab);
        if sum(L)~=1
            checkpoint('ifversion_______________________________line130_cover_test','CoverTest')
            warning('HJW:ifversion:NotInDict',...
                'The requested version is not in the hard-coded list.')
            tf = NaN;return
        else
            checkpoint('ifversion_______________________________line135_cover_test','CoverTest')
            v = v_dict{L,2};
        end
    end
end
switch test
    case '==', tf = v_num == v;
    case '<' , tf = v_num <  v;
    case '<=', tf = v_num <= v;
    case '>' , tf = v_num >  v;
    case '>=', tf = v_num >= v;
end
end
function val=fixeps(val)
% Round slightly up to prevent rounding errors using fix().
val = fix(val+eps*1e3);
end

function out=checkpoint(caller,varargin)
% This function has limited functionality compared to the debugging version.
% (one of the differences being that this doesn't read/write to a file)
% Syntax:
%   checkpoint(caller,dependency)
%   checkpoint(caller,dependency_1,...,dependency_n)
%   checkpoint(caller,checkpoint_flag)
%   checkpoint('reset')
%   checkpoint('read')
%   checkpoint('write_only_to_file_on_read')
%   checkpoint('write_to_file_every_call')

persistent data
if isempty(data)||strcmp(caller,'reset')
    data = struct('total',0,'time',0,'callers',{{}});
end
if strcmp(caller,"read")
    out = data.time;return
end
if nargin==1,return,end
then = now;
for n=1:numel(varargin)
    data.total = data.total+1;
    data.callers = sort(unique([data.callers {caller}]));
    if ~isfield(data,varargin{n}),data.(varargin{n})=0;end
    data.(varargin{n}) = data.(varargin{n})+1;
end
data.time = data.time+ (now-then)*( 24*60*60*1e3 );
data.time = round(data.time);
end

