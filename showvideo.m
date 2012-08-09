% Show a video (4D matrix with frame in 4th dim) in a new figure n times
% (default 1) at fps (default 24).
% ax = showvideo(vidmat,[n],[fps])
function showvideo(vidmat,nrep,fps)

if ieNotDefined('nrep')
    nrep = 1;
end

if ieNotDefined('fps')
    fps = 24;
end

nframes = size(vidmat,4);
% nb gray has no effect on rgb videos
cm = gray(256);
for n = 1:nframes
    frames(n) = im2frame(vidmat(:,:,:,n),cm);
end

vidsize = size(vidmat);

F = figurebetter;
set(F,'units','pixels','position',[0 0 vidsize(1:2)*1.3]);
axis tight
axis off
set(gca,'position',[0 0 1 1]);
movie(frames,nrep,fps)
