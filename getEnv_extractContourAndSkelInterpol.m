function [ env ] = getEnv_extractContourAndSkelInterpol( globalEnv )
%SETENV Sets the environment for executing the feature extraction system
%   Sets code paths, specifies working directories, and manages warning messages

%% Specify directories and file structure
% Specify the directory that contains the code
%env.CodeDirectory = 'C:\Users\vsimonis\Documents\MATLAB\LocalNematodes\';
env.CodeDirectory = globalEnv.CodeDirectory;
% Specify where the results will be saved
env.WorkingDir = globalEnv.WorkingDir;%'C:\Users\vsimonis\Documents\MATLAB\Data\N2_nf1--manual\';
env.StudyInstanceName = globalEnv.StudyInstanceName; %'Test';

% Sepcify whether to add to existing saved data
env.InputMatFileName = 'ContourAndSkel';

%Specify frequency to save the data
env.SaveRate =  1000;
% Specify the directories and files for the output
env.OutputCsvFileName = 'ContourAndSkelInterpol';
env.OutputMatFileName = 'ContourAndSkelInterpol';

%% Starting and ending frame 

%If ending frame is greater than number frames, the system adjsuts by
%setting ending frame to the number of frames in the video.

env.StartFrame =1; %9680;
env.EndFrame = globalEnv.EndFrame;% 10%43762;% 16681; 

%% Display

%Every nth seq number to display to the screen
env.DisplayRate = 10;

%Specify the cropping done during tracking
env.Cropping = 0;   % 0 = no cropping, 1 = cropping
env.CropSize = 0;

%Specify parameters related to camera shot changes during tracking
env.ShotChanges = 1;  % 0 = no, 1 = yes
env.CameraStartRow = 1;
env.CameraStartCol = 1;

%% Segmentation Parameters

env.StructElementSize = 2;
env.EstArea = globalEnv.EstArea;
%env.EstPosition = [506, 559];
%env.WindowSize = [200,200];

%% Endpoints from Curvature Parameters
env.KernelRadius = 10;
env.Sigma = 1;
env.Threshold = 0.6;
env.SigmaAdjusted = 1;

%% Width Profile Analysis

    %set the pixels from each end to use in the width profile analysis
    env.WidthProfileRange = [5,30];
end

