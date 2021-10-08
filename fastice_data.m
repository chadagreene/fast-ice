function [fi,x,y,t] = fastice_data(year)
% fastice_data_autumn loads Fraser et al.'s fast ice gridded data 
% corresponding to a given year. 
% 
%% Syntax 
% 
%  [fi,x,y,t] = fastice_data(year)
%
%% Description 
% 
% [fi,x,y,t] = fastice_data(year) loads gridded fast ice data for
% any year from 2000 to 2018, inclusive. 
% 
%   0 = pack ice or ocean; 
%   1 = continent; 
%   2 = islands; 
%   3 = ice shelf; 
%   4 = fast ice; 
%   5 = manual fast ice edge; 
%   6 = auto fast ice edge.
%   FillValue   = 0
% 
%% Example: Load and animate data from 2005: 
% 
% [fi,x,y,t] = fastice_data(2005);
% 
% figure 
% h = imagesc(x,y,fi(:,:,1)); 
% axis xy  
% title(datestr(t(1)))
% 
% for k = 2:length(t) 
%    h.CData = fi(:,:,k); 
%    title(datestr(t(k)))
%    pause(0.5) 
% end
% 
%% Citing this data
% If this dataset and these functions are useful for you, please cite the data and AMT. 
% 
% Fraser, A.D. and Massom, R. (2020) Circum-Antarctic landfast sea ice extent, 2000-2018, 
% Ver. 2.2, Australian Antarctic Data Centre - http://dx.doi.org/doi:10.26179/5d267d1ceb60c
% 
% Fraser, A. D., Massom, R. A., Ohshima, K. I., Willmes, S., Kappes, P. J., Cartwright, J., 
% and Porter-Smith, R.: High-resolution mapping of circum-Antarctic landfast sea ice distribution,
% 2000–2018, Earth Syst. Sci. Data, 12, 2987–2999, https://doi.org/10.5194/essd-12-2987-2020, 2020. 
% 
% Greene, C. A., Gwyther, D. E., & Blankenship, D. D. (2017). Antarctic Mapping Tools for Matlab. 
% Computers & Geosciences, 104, 151–157. https://doi.org/10.1016/j.cageo.2016.08.003
% 
%% Author Info
% This function was written by Chad A. Greene, NASA Jet Propulsion
% Laboratory, August 2021. 
% 
% See also fastice_data and fastice_data_download. 

%% Input checks: 

narginchk(1,1) 
assert(ismember(year,2000:2018),'Error: Specified year must be between 2000 and 2018.') 

%% Load data: 

% filename: 
fn = ['FastIce_70_',num2str(year),'.nc'];
assert(exist(fn,'file')==2,['Error: Cannot find the data file ',fn,'. Run fastice_data_download if necessary or make sure Matlab knows the path to the dataset.']) 

% x,y coordinates in ps71 are just the ps70 coordinates times 1.003001286780617
x = ncread(fn,'x')*1.003001286780617;
y = ncread(fn,'y')*1.003001286780617;
t = ncdateread(fn,'time'); % provided as a function below. 

% Load data:
fi = permute(ncread(fn,'Fast_Ice_Time_series'),[2 1 3]); 

end


function [dt, t, unit, refdate] = ncdateread(file, var, t)
%NCDATEREAD Reads datetimes from a netcdf time variable
%
% [tdt, tnum] = ncdateread(file, var)
% [tdt, tnum, unit, refdate] = ncdateread(file, var)
%  [...] = ncdateread(file, var, tnum)
% 
% This function reads in a time variable from a netCDF file, assuming that
% the variable conforms to CF standards with a "<time units> since
% <reference time>" units attribute.  
%
% Currently only works for standard (gregorian) calendar.
%
% Input variables:
%
%   file:       netCDF file name
%
%   var:        variable name
%
%   tnum:       numeric array.  If included, rather than read data from the
%               file, these values are converted using the unit data in the
%               file and variable indicated.
%
% Output variables:
%
%   tdt:        datetime array of times read from file
%
%   tnum:       array of numeric time values, as read directly from file
%               without time conversion  
%
%   unit:       character array, time unit
%
%   refdate:    scalar datetime, reference date

% Copyright 2016 Kelly Kearney

if verLessThan('matlab', '8.4.0')
    error('This function requires R2014b or later (relies on datetime and duration objects)');
end

% Check and parse input

if nargin > 2
    validateattributes(t, {'numeric'}, {}, 3);
else
    if iscell(file)
        t = cellfun(@(x) ncread(x, var), file, 'uni', 0);
        t = cat(1, t{:});
        file = file{1};
    else
        t = ncread(file, var);
    end
end

tunit = ncreadatt(file, var, 'units');

[dt, unit, refdate] = cftime(t, tunit);

end