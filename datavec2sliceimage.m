% convenient wrapper for 
% makeimagestack(datavec2mat(datavec,mask~=0),varargin{:});
%
% ih = datavec2sliceimage(datavec,mask,varargin)
function ih = datavec2sliceimage(datavec,mask,varargin)

mat = datavec2mat(datavec,mask~=0);
ih = makeimagestack(mat,varargin{:});
