classdef Suggestion 
    properties
        similarity 
        source          % corresponding clone.source2 
        mdlFilepath
        imgFilepath 
        rank            % rank of this suggestion (1:highest)
    end 
    
    methods 
        function obj = Suggestion(similarity, source, mdlFilepath, imgFilepath, rank)
            obj.similarity = similarity; 
            obj.source = source; 
            obj.mdlFilepath = mdlFilepath; 
            obj.imgFilepath = imgFilepath;
            obj.rank = rank; 
        end 
    end 
end 