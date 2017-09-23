% Try 'SetGlobal Environment' file%
function [ globalEnv ] = setGlobalEnv(user, video)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

globalEnv.video = video;
globalEnv.user = user;

%% This bit here will change depending on the computadora
globalEnv.CodeDirectory = sprintf('%s%s%s', 'C:\Users\', user, '\My Documents\MATLAB\');
globalEnv.WorkingDir = sprintf('%s%s%s%s', 'C:\Users\', user, '\My Documents\MATLAB\Data\', video);
globalEnv.VideoInputDir = sprintf('%s%s%s%s', 'C:\Users\', user, '\My Documents\MATLAB\Data\', video);

%% This bit finds the Log and Video file
for file = dir(globalEnv.WorkingDir)'     % List folder content
    if ~isempty(strfind(file.name, '.avi'))
        globalEnv.VideoInputName = file.name;
    elseif ~isempty(strfind(file.name, 'log'))
        globalEnv.LogFileName = file.name;
    end
end
%% Naming conventions for Extract All Features mat and csv
globalEnv.OutputCsvFileName = 'AllFeatures';                       %What this mean?!
globalEnv.OutputMatFileName = 'AllFeatures';
%% Has log file?
globalEnv.ShotChanges = 1;          %what this mean?

switch video
    case 'RIM_HR_nf11_a'
        globalEnv.StudyInstanceName= 'RIM_HR_nf11_a';
        globalEnv.EndFrame = 5000;
        globalEnv.EstArea = 1500;          % Estimated worm body area in an image
    
    % add more if necessary
end

%%% This bit finds mat files generated during skel, contour and all
%%% features
globalEnv.StudyInstanceDir = sprintf('%s\\%s', globalEnv.WorkingDir, globalEnv.StudyInstanceName);
filesInDir  = dir(globalEnv.StudyInstanceDir);

for file = filesInDir'
    if ~isempty(strfind(file.name, '.mat'))
        if ~isempty(strfind(file.name, 'ContourAndSkel'))
            globalEnv.ContourSkelMat = file.name;
        elseif ~isempty(strfind(file.name, 'AllFeatures'))
            globalEnv.FeaturesMat = file.name;
            
        end
    end
end


end


