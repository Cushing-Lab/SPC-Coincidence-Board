function SPC_get_mode()
%SPC_get_mode- Get board mode (hardware vs simulation)
    [ret] = calllib('spcm64', 'SPC_get_mode');
    if ret < 0
        fprintf('SPC in Simulation Mode. Use SPC_set_mode to change to Hardware Mode to continue.\n');
        return
    else 
        fprintf('SPC in Hardware Mode.\n');
    end
end

