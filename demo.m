%clc;
clear all;

addpath 'algorithm'
noisy = 0;
downsample_method = 'bicubic';
ext = 'png';
num = 1;

path = 'Depth_Enh/02_RGBZ_Dataset';
saveDir = 'RGBZ';
if ~exist(sprintf('results/%s',saveDir)) 
    mkdir(sprintf('results/%s',saveDir));         
end 

if noisy
  colorImgName = sprintf('%s/RGBZ_%02d_noisy_color.%s',path,num,ext);
else
  colorImgName = sprintf('%s/RGBZ_%02d_clean_color.%s',path,num,ext);
end
dptImgName = sprintf('%s/RGBZ_%02d_clean_depth.%s',path,num,ext);

% upsampling factor 1/2/3/4
uf = 2;

gt_depth = im2double(imread(dptImgName));
img = im2double(imread(colorImgName));
[M, N] = size(gt_depth);
[Mmb, Nmb, ch] = size(img);

dd  = [Mmb - M; Nmb - N];  
img = img(dd(1)/2+1:end-dd(1)/2, dd(2)/2+1:end-dd(2)/2,:);
dpt_res_n = imresize(gt_depth, 1/(2^uf), downsample_method);

%scale-space filtering using joint static and dynamic guidance 
nei= 0;                   % 0: 4-neighbor 1: 8-neighbor
lambda = 2;               % regularization parameter
mu = 40;                  
nu = 0.25;                
step = 5;                 % num of steps

mask = zeros(M,N);
u0 = zeros(M,N);
mask = zeros(M,N);
u0(1:2^uf:end,1:2^uf:end) = dpt_res_n;
mask(1:2^uf:end,1:2^uf:end) = 1;
imwrite(dpt_res_n,sprintf('results/%s/%s_%02d_depth_d%02d.%s',saveDir,saveDir,num,2^uf,ext));
imwrite(u0,sprintf('results/%s/%s_%02d_depth_%02d_sparse.%s',saveDir,saveDir,num,2^uf,ext));

u_ours = mesolver(img,u0,u0,mask,nei,lambda,mu,nu,step);
u_ours = medfilt2(u_ours);
if noisy
  imwrite(u_ours,sprintf('results/%s/%s_%02d_noisy_depth_u%02d_ours.%s',saveDir,saveDir,num,2^uf,ext));  
else
  imwrite(u_ours,sprintf('results/%s/%s_%02d_clean_depth_u%02d_ours.%s',saveDir,saveDir,num,2^uf,ext));  
end



