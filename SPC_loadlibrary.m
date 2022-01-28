function SPC_loadlibrary()
%Load library
    if ~libisloaded('spcm64')
        lib = loadlibrary('spcm64', 'Spcm_def.h');
    else
        fprintf('Note: SPCM64 was already loaded.\n');
    end

    %Check if library is loaded
    if (libisloaded('spcm64'))
        fprintf('SPCM64 library opened successfully.\n');
    else
        fprintf('Could not open SPCM64 library.\n');
        return;
    end
end

