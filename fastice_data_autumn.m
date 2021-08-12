function [fi,x,y,years] = fastice_data_autumn(years)
% fastice_data_autumn loads Fraser et al.'s fast ice gridded data 
% corresponding to each autumn (March). 
% 
%% Syntax 
% 
%  [fi,x,y,years] = fastice_data_autumn
%  [fi,x,y] = fastice_data_autumn(years)
%
%% Description 
% 
% [fi,x,y,years] = fastice_data_autumn loads gridded fast ice data from the
% first half of each March for the years 2000 to 2017. The fast ice dataset
% includes part of 2018, but coastlines are manually updated in March of each 
% year and version 1 of the data does not contain March 2018. 
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
% [fi,x,y] = fastice_data_autumn(years) only loads data from early March of
% the specified years, which can be 2000 to 2017, inclusive. 
% 
%% Example 1: Load and plot data from 2005
% 
% [fi,x,y] = fastice_data_autumn(2005); 
% 
% figure
% imagesc(x,y,fi) 
% axis xy image 
% 
%% Example 2: Load all data and animate changes through time: 
% 
% [fi,x,y,yr] = fastice_data_autumn; 
% 
% figure 
% h = imagesc(x,y,fi(:,:,1)); 
% axis xy  
% title(num2str(yr(1)))
% 
% for k = 2:length(years) 
%    h.CData = fi(:,:,k); 
%    title(num2str(yr(k)))
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

if nargin==0 
   years = (2000:2017)'; 
else 
   assert(all(ismember(years,2000:2017)),'Error: Specified years must be between 2000 and 2017.') 
end

%% Load data: 

% x,y coordinates in ps71 are just the ps70 coordinates times 1.003001286780617
x = ncread('FastIce_70_2000.nc','x')*1.003001286780617;
y = ncread('FastIce_70_2000.nc','y')*1.003001286780617;

% Preallocate: 
fi = nan(length(y),length(x),length(years)); 

for k = 1:length(years) 
   
   % filename: 
   fn = ['FastIce_70_',num2str(years(k)),'.nc'];
   assert(exist(fn,'file')==2,['Error: Cannot find the data file ',fn,'. Run fastice_data_download if necessary or make sure Matlab knows the path to the dataset.']) 

   if years(k)==2000
      start = [1 1 1]; 
   else 
      start = [1 1 5]; % early march of every year after 2000 
   end
   
   fi(:,:,k) = permute(ncread(fn,'Fast_Ice_Time_series',start,[Inf Inf 1]),[2 1 3]); 
   
end

end