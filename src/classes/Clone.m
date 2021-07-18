classdef Clone 
    properties
        nlines
        similarity 
        source1         % from mdl file under development 
        source2         % from clone 
    end 
    
    methods 
        function obj = Clone(nlines, similarity, source1, source2)
            obj.nlines = nlines;
            obj.similarity = similarity; 
            obj.source1 = source1;
            obj.source2 = source2; 
        end 
    end 
end 