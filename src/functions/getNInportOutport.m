function [nInport, nOutport] = getNInportOutport(systemPath)
% Return the number of inports and outports of the (sub)system
% If the system is a top-level system, both nInport and nOutport will be 0
%
% ASSUMPTIONS:
% -----------
% 1. system is loaded
% 
% PARAMETERS:
% -----------
% systemPath   : (sub)system's path 
%                This should be in format as returned by 'gcs' eg:
%                "mymodel/a/b/mysubsystem"


if isTopSystem(systemPath)
    nInport = 0; 
    nOutport = 0; 
else
    % IMPORTANT: the subSystem must be a character vector(rather than a string)
    % Otherwise it SOMETIMES (dont' know in detail why that happens) fails.
    
    % systemPath must not be top-level system 
    params = get_param(char(systemPath), 'PortHandles');

    nInport = length(params.Inport); 
    nOutport = length(params.Outport); 
end