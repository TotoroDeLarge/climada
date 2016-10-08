function hazard=climada_hazard_load(hazard)
% climada
% NAME:
%   climada_hazard_load
% PURPOSE:
%   load a hazard event set (just to avoid typing long paths and
%   filenames in the command window)
%
%    the code checkes wehther hazard.filename is current (if loaded from a
%    file) and updates, if necessary
%
%    if loading a hazard, the code checks whether a field hazard.fraction
%    exists. If not, it is added to the hazard and the .mat file is updated
%    (speeds up EDS calc)
%   
%   next call: climada_EDS_calc, climada_hazard_plot
% CALLING SEQUENCE:
%   hazard=climada_hazard_load(hazard)
% EXAMPLE:
%   hazard=climada_hazard_load(hazard)
% INPUTS:
%   hazard: the filename (and path, optional) of a previously saved hazard
%       event set. If no path provided, default path ../data/hazards is used
%       (and name can be without extension .mat)
%       > promted for if empty
%       OR: a hazard structure, in which cas it is just returned (to allow
%       calling climada_hazard_load anytime, see e.g. climada_EDS_calc)
% OPTIONAL INPUT PARAMETERS:
% OUTPUTS:
%   hazard: a struct, see e.g. climada_tc_hazard_set
% MODIFICATION HISTORY:
% David N. Bresch, david.bresch@gmail.com, 20140302
% David N. Bresch, david.bresch@gmail.com, 20150804, allow for name without path on input
% David N. Bresch, david.bresch@gmail.com, 20150820, check for correct filename
% Lea Mueller, muellele@gmail.com, 20151127, enhance to work with complete hazard as input
% Lea Mueller, muellele@gmail.com, 20151127, set hazard_file to empty if a struct without .lon
% David N. Bresch, david.bresch@gmail.com, 20160202, speedup if hazard structure passed
% David N. Bresch, david.bresch@gmail.com, 20160527, climada_hazard2octave added
% David N. Bresch, david.bresch@gmail.com, 20160916, hazards_dir used
% David N. Bresch, david.bresch@gmail.com, 20161008, check for ishazard
% David N. Bresch, david.bresch@gmail.com, 20161008, hazard.fraction added
%-

global climada_global
if ~climada_init_vars,return;end % init/import global variables

% poor man's version to check arguments
if ~exist('hazard','var'),hazard=[];end

% if already a complete hazard, return
if isstruct(hazard)
    if ~ishazard(hazard),fprintf('ERROR: not a hazard\n');hazard=[];end
    return % already a hazard
else
    hazard_file=hazard;hazard=[];
    % from now on, hazard_file is the input and hazard will be output
end

% prompt for hazard_file if not given
if isempty(hazard_file) % local GUI
    hazard_file=[climada_global.hazards_dir filesep '*.mat'];
    [filename, pathname] = uigetfile(hazard_file, 'Load hazard event set:');
    if isequal(filename,0) || isequal(pathname,0)
        return; % cancel
    else
        hazard_file=fullfile(pathname,filename);
    end
end

% complete path, if missing
[fP,fN,fE]=fileparts(hazard_file);
if isempty(fP),fP=climada_global.hazards_dir;end
if isempty(fE),fE='.mat';end
hazard_file=[fP filesep fN fE];

if ~exist(hazard_file,'file')
    fprintf('ERROR: hazard does not exist %s\n',hazard_file);
    return
else
    load(hazard_file); % contains hazard, the only line that really matters ;-)
end

if ishazard(hazard)
    % check for valid/correct hazard.filename
    if ~strcmp(hazard_file,hazard.filename)
        hazard.filename=hazard_file;
        save(hazard_file,'hazard')
    end
    
    % add hazard.fraction (for FL, other perils no slowdown)
    if ~isfield(hazard,'fraction')
        fprintf('adding hazard.fraction ...');
        hazard.fraction=spones(hazard.intensity); % fraction 100%
        save(hazard_file,'hazard')
        fprintf(' done\n');
    end
    
    hazard=climada_hazard2octave(hazard); % Octave compatibility for -v7.3 mat-files
else
    hazard=[];
end % isentity(entity)

end % climada_hazard_load