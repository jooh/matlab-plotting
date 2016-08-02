% display an animation of the data in SPM.xY.VY in a figure window. you will get
% an infinite loop so use ctrl-c to crash out when you've had enough.
%
% if SPM is undefined we attempt to pull it from the caller's workspace.
%
% spm2movie([framerate=10],[SPM])
function spm2movie(framerate,SPM)

if ieNotDefined('SPM')
    SPM = evalin('caller','SPM');
end

if ischar(SPM)
    SPM = loadbetter(SPM);
end

if ieNotDefined('framerate')
    framerate = 10;
end

volind = [];
sessind = [];
nsess = numel(SPM.Sess);
for sess = 1:numel(SPM.Sess)
    volind = [volind SPM.Sess(sess).row];
    sessind = [sessind ones(1,SPM.nscan(sess))*sess];
end


xyz = spm_read_vols(SPM.xY.VY(volind));
mi = min(xyz(:));
ma = max(xyz(:));
nvol = size(xyz,4);

n = 0;
fh = figure;
set(fh,'colormap',gray(256),'defaultaxesdataaspectratio',[1 1 1]);
frametime = 1/framerate;
thistime = 0;
tic;
while true
    n = rem(n,nvol)+1;
    thistime = thistime + frametime;
    imagesc(makeimagestack(xyz(:,:,:,n)),[mi ma]);
    axis off
    title(sprintf('run=%02d/%02d\tvol=%04d/%04d',sessind(n),nsess,volind(n),...
        SPM.nscan(sessind(n))));
    drawnow;
    while toc < thistime
        pause(frametime/10)
    end
end
