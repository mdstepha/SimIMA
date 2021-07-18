function wrapperSystem = wrapInSystem(system)
% Wrap the given (sub)system in a (sub)system, and 
% return the newly created wrapper (sub)system's name (beginning from top
% system) 
%
% PARAMETERS
% ---------- 
% system : string -- name of the (sub)system to be wrapped in a subsystem
%          eg: "mymodel/sub1/sub2/sub3"
% 
% NOTES:
% ------
% If a name to a top-level system is passed in (eg: "mymodel"),
%   1. If there is no immediate (at first depth) subsystem named
%      "Subsystem" among the blocks to be wrapped, the newly created wrapper
%      subsystem will be named "Subsystem" 
%   2. If there is an immediate subsystem named "Subsystem" among the
%      blocks to be wrapped, the newly created wrapper subsystem will be 
%      named "Subsystem1"
%   3. If there are immediate subsystems named "Subsystem" and "Subsystem1"
%      among the blocks to be wrapped, the newly created wrapper subsystem
%      will be named "Subsystem2", and so on. 

%   - the top-level system will be wrapped inside a subsystem named
%     'Subsystem'
% If a nane to a sub-system is passed in (eg: "mymodel/mysubsystem"), 
%   - the subsystem will be wrapped in another subsystem 
%   - the wrapper subsystem will take the original name of wrapped subsystem
%   - the wrapped subsystem will be renamed to 'Subsystem' 
%   - Thus, the new hierarchy will look like:
%     "mymodel/mysubsystem/Subsystem" 
% 
% PORTS
% -----
% - The number of inports and outports remains the same as before. 
% - The name of the inports and outports remains preserved (both outside
%   and inside the wrapper subsystem. For example, if the a name to a
%   top-level system (having inport, ip and outport, op is passed; then the
%   resulting model will have: 
%     1. an inport named ip 
%     2. an outport named op 
%     3. a subsystem containing all blocks of the original top-level system. 
%        These block include the following: 
%          1. an inport named ip 
%          2. an outport named op 
%          3. all other blocks of original top-level system 
%
% IMPORTANT: 
% ----------
% This function is NOT IDEMPOTENT. Executing this function 
% multiple times keeps on wrapping the (sub)system by another subsystem in 
% a nested fashion. So, use with caution.
% 
% ASSUMPTIONS:
% ------------
% - The corresponding mdl file is loaded. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  systemIsTopSystem = isTopSystem(system); 

  blocks = find_system(system, 'SearchDepth', 1);  % 1 is max_depth considered
  bh = [];
  for i = 2:length(blocks)
    bh = [bh get_param(blocks{i}, 'handle')];
  end
  Simulink.BlockDiagram.createSubsystem(bh);
  
  if systemIsTopSystem
      blocks_after = find_system(system, 'SearchDepth', 1);  % 1 is max_depth considered
      wrapperSystem = setdiff(blocks_after, blocks);  
  else 
      wrapperSystem = system; 
  end
end