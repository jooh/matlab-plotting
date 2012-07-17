% Show a video (4D matrix with frame in 4th dim) in the current axis n
% times (default 1) at fps (default 24).
% ax = showvideo(vidmat,[n],[fps])
function ax = showvideo(vidmat,nrep,fps)

if ieNotDefined('nrep')
    nrep = 1;
end

if ieNotDefined('fps')
    fps = 24;
end

nframes = size(vidmat,4);
for n = 1:nframes
    frames(n) = im2frame(vidmat(:,:,:,n));
end

movie(frames,nrep,fps);
