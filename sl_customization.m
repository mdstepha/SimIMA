function sl_customization(cm)
  % adds items to the end of Simulink Editor Tools menu
  cm.addCustomMenuFcn('Simulink:ToolsMenu', @getMyMenuItems);

  % adds right-click menu items at the beginning
  cm.addCustomMenuFcn('Simulink:PreContextMenu', @getMyMenuItems);

  % adds right-click menu items at the end 
  %   cm.addCustomMenuFcn('Simulink:ContextMenu', @getMyMenuItems);       %

end

% Define the custom menu function.
function schemaFcns = getMyMenuItems(callbackInfo) 
    schemaFcns = {@getItem1, @getItem2, @getItem3}; 
end

% Define the schema function for first menu item.
function schema = getItem1(callbackInfo)
    schema = sl_action_schema;
    schema.label = 'SimIMA: Suggest Blocks';
    schema.userdata = 'simvma';
    schema.accelerator = 'Ctrl+J';  % todo: fixit -- not working 
    schema.callback = @myCallback1;
end


% Define the schema function for second menu item.
function schema = getItem2(callbackInfo)
    schema = sl_action_schema;
    schema.label = 'SimIMA: Suggest Complete Systems';
    schema.userdata = 'simvma';
    schema.callback = @myCallback2;
end

% Define the schema function for third menu item.
function schema = getItem3(callbackInfo)
    schema = sl_action_schema;
    schema.label = 'SimIMA: Configure Block Suggestions';
    schema.userdata = 'simvma';
    schema.callback = @myCallback3;
end


function myCallback1(callbackInfo) 
    initialize(); 
    suggestBlocks(); 
end

function myCallback2(callbackInfo) 
    initialize(); 
    appSimxample();
end

function myCallback3(callbackInfo)  
    initialize(); 
    appSimgestion(); 
end