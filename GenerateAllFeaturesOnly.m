%% Generate AllFeatures Only
addAllCodePaths();
% 1. User goes into GlobalEnv and sets -- to change later 
    % globalEnv.StudyInstanceName:  ie: 'Run1'
    % globalEnv.EndFrame ie: 50000;
    % globalEnv.EstArea: ie: 560;
   
    
% 2. Computer probes directory and sets the environment
vid = 'AIB_HR_f6';

disp('Setting global environment')
env = setGlobalEnv('MSHAO1.DPU', vid);

disp('Extracting All Features')
% 3. Extract All Features
extractAllFeatures( env ); 