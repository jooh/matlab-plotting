% convenient wrapper for 
% makeimagestack(datavec2mat(datavec,mask),varargin{:});
%
% ih = datavec2sliceimage(datavec,mask,varargin)
function ih = datavec2sliceimage(datavec,mask,varargin)

mat = datavec2mat(datavec,mask);
ih = makeimagestack(mat,varargin{:});
