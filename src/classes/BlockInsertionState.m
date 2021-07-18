classdef BlockInsertionState 
    properties
        context 
        suggs
        percentTexts 
    end 
    
    methods 

        function obj = BlockInsertionState(context, suggs, percentTexts)
            obj.context = context; 
            obj.suggs = suggs;
            obj.percentTexts = percentTexts; 
        end 

    end 
end 