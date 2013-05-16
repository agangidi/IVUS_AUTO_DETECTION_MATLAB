function imF = GetFrameEnv(f, fid)
VC_PER_FR =  256; % vectors per frame 
DT_PER_VC = 256; % data units per vector
FRAME_SIZE = VC_PER_FR*DT_PER_VC*4;
offset = FRAME_SIZE*f;
status = fseek (fid, offset, 'bof');
if (status ~= 0)
    mes = ferror(fid);
    sprintf('error: %s', mes);
    imF = 0;
    return;
end
imF = fread(fid, [DT_PER_VC VC_PER_FR], 'int32');
imF = abs(imF);

