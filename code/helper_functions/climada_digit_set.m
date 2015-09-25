function [digit, digit_str] = climada_digit_set(data,data2)
% set digit and digit string for a given data set
% NAME:
%   climada_digit_set
% PURPOSE:
%   Set digit (10 to the power of digit) and digit string for a given data 
%   set, e.g. for an input of 1'000'000, digit = 6 and digit_str = 'millions' 
% CALLING SEQUENCE:
%   [digit, digit_str] = climada_digit_set(data,data2)
% EXAMPLE:
%   [digit, digit_str] = climada_digit_set(1000000,20)
% INPUTS:
%   data: an array or matrix of data
%   data2: an array or matrix of data
% OPTIONAL INPUT PARAMETERS:
%   data2: a second array or matrix of data
% OUTPUTS:
%   digit: an array defining 10 to the power of digit, e.g. 6 for millions,
%   9 for billions
%   digit_str: a char, e.g 'millions', 'billions'
% RESTRICTIONS:
% MODIFICATION HISTORY:
% Lea Mueller, 20150924, init
%-

global climada_global
if ~climada_init_vars, return; end

% poor man's version to check arguments
if ~exist('data','var'), data = ''; end
if ~exist('data2','var'), data2 = ''; end

% init
digit = '';
digit_str = '';

% get maximum of both data sets
max_1 = max(data(:));
max_2 = max(data2(:));

max_data = max([max_1 max_2])+1;
if isempty(max_data)
    return
end

digit = 0;
max_data = max_data *10^-digit;
while max(max_data) > 1000
    digit = digit+3;
    max_data = max_data/1000;
end
switch digit
    case 3
        digit_str = 'thousands';
    case 6
        digit_str = 'millions';
    case 9
        digit_str = 'billions';
    case 12
        digit_str = 'trillions';
    otherwise
        digit_str = '';
end

