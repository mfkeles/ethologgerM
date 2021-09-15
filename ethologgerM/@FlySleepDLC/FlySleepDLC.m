%DLC FlySleep
%This software package is used to analyze and quality check the outputs of
%DLC tracking. 

%TODO replace t with df!!!!

classdef FlySleepDLC < handle_light
    properties
        Fly;
        File;
        Folder;
        DLC;
        DLCfiltered;
        Path;
        DateInt;
        TimeInt;
        Created;
        Modified;
        ChooseFiltered =0;
        dfPose
        dfLlh
    end
    
    properties (Transient)
        Data
        Sensor
        Frames
    end
    
    properties (Hidden)
        threshold
        adaptive_llh_threshold
        median_filter_size
        pose_cfg %TODO: SINGLE CFG STRUCT, AUTO CONFIG LOAD
        feature_cfg
    end
    
    
    properties (SetAccess = private)
        
    end
    
    methods %Constructor - creates object
        
        function  obj = FlySleepDLC(pathIN)
            
            %if no path
            if nargin == 0 || isempty(pathIN)
                try 
                   [FileName,PathName] = uigetfile('*.avi');
                   obj = getAviPath(obj, fullfile(PathName, FileName));
                catch
                end
            end
            
            %if path is specified:
            if nargin>0 && ~isempty(pathIN)
               [filename, name, ext] = fileparts(pathIN);
               if strcmp(ext,".avi")
                if isa(pathIN,'char')
                    obj = getAviPath(obj,pathIN);
                else
                    error('Path is not a string');
                end
               elseif strcmp(ext,".csv")
                   obj.DLC = pathIN;
                   getDLCData(obj);
                   obj.File = name;
                   obj.Folder = filename;
               else
                   error("File extensions need to be either .csv or .avi")
               end
               
            end
            
            getConfigFiles(obj);
            
            
%             if ~isempty(obj.File)
%                 getDateTime(obj);
%             end
            
        end
    end
    
    methods (Access=public)
        getDLCData(obj)
        getDateTime(obj)
        [dfPose, dfLlh] = getOrientedPose(obj,threshold)
        
    end
    
    methods (Static)
        [dfTemp] = median_filter(dfPose,order)
        [cfg] = read_config(pathIN)
        [dfTemp,pfilt] = adaptive_llh_filter(dfPose,dfLlh,llh_adaptive_filter);
       
    end
    
    
end



        
            
           