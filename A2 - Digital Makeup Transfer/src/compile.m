mex -O resize.cc
mex -O reduce.cc
mex -O shiftdt.cc
mex -O features.cc
mex -O fconv.cc
load face_p146_small.mat

disp('Model visualization');
visualizemodel(model,1:13);