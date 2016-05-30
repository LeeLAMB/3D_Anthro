%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Matlab Tutorial for 3D Anthropometry
%
% Wonsup Lee (mcury83@gmail.com)
% 30 May 2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; % delete all variables
close all; % close all figures

%% settings
save_outputs = 0;
    % 0: unsave outputs
    % 1: save outputs
    
%% data loading
dir = 'source 3D images';
filename = 'face_W.ply';
filename_3D_scan = fullfile(dir, filename);
[ListVertex, ListFace, ListFace_backup, HEADER] = function_loading_ply_file(filename_3D_scan);

filename = 'face_W_landmark.asc';
filename_landmark = fullfile(dir, filename);
landmark = textread(filename_landmark, '');


%% landmark identification
% NOTE. Before run this code, the face should be roughly rotated to align
% with X Y Z axis (Y-up). The face should faced to +Z direction
visualization = 0; % 1 = Yes || 0 = No
landmark = function_landmark_identification(ListFace, ListVertex, landmark, visualization);

%% alignment
% The face will be aligned using two virtual axis.
% (1) A virtual axis generated by sellion(2) and supramentale(18) will be aligned to Y-axis.
% (2) A virtual axis generated by left and right zygion(12, 13) will be aligned to X-axis.

% pick 4 landmarks for alignment
% point 1 & 2 will be aligned Y-axis
% point 3 & 4 will be used to align the face with X-axis
reference.point1 = landmark{'sellion', :};
reference.point2 = landmark{'promentale', :};
reference.point3 = landmark{'zygion L', :};
reference.point4 = landmark{'zygion R', :};
origin = landmark('sellion', :);
visualization = 0;
    % 0 = No
    % 1 = Yes
[ListVertex, landmark] = function_alignment(reference, origin, ListFace, ListVertex, landmark, visualization);

% save modified 3D image (PLY file) and landmark table (.mat file)
if save_outputs == 1
    save('face_W_landmark.mat', 'landmark');
    filename_save = 'face_W_modified.ply';
    function_saving_ply_file(ListVertex, ListFace_backup, HEADER, filename_save);
end

%% facial measurement

% length dimensions (Euclidean distance)
subject_name = 'S1';
visualization = 1;
    % 0 = No
    % 1 = Yes
measurements = function_measurement(ListFace, ListVertex, landmark, subject_name, visualization);
%%% [ADD] add more dimensions to measure in function_measurement %%%


% arc, circumference dimensions