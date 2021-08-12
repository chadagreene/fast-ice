
% This script downloads the anual gridded fast ice data from Fraser et al. 
% The annual grids are about 500 MB each, so the downloading takes a while.
% If the download fails, get the data manually here:
% https://data.aad.gov.au/s3/bucket/datasets/science/AAS_4116_Fraser_fastice_circumantarctic/fastice_v2_2/.
% 
% This script was written by Chad A. Greene, JPL, August 2021. 

yr = 2000:2018; 
w = waitbar(0,'Downloading '); 

try 
    for k = 1:length(yr)

       url = ['https://public.services.aad.gov.au/datasets/science/AAS_4116_Fraser_fastice_circumantarctic/fastice_v2_2/FastIce_70_',num2str(yr(k)),'.nc'];
       fn = ['FastIce_70_',num2str(yr(k)),'.nc'];

       waitbar((k-1)/length(yr),w,{['Downloading data from ',num2str(yr(k)),'.']})
       websave(fn,url)

    end
catch
    close(w) 
    error('There was an error downloading the fast ice data. Try downloading all the files manually here: https://data.aad.gov.au/s3/bucket/datasets/science/AAS_4116_Fraser_fastice_circumantarctic/fastice_v2_2/')
end


waitbar(1,w,'Done') 
pause(0.1) 
close(w) 