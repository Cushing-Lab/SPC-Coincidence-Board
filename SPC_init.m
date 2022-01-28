function SPC_init(initFile)
%SPC_init- Initialze board
    global SPC_MODULE_NUMBER
    [ret] = calllib('spcm64', 'SPC_init', 'spcm.ini');
    if ret < 0
        ErrorCode = '??????????????????????????????????????????????????'; %enough length!
        ErrorCodePtr = libpointer('cstring', ErrorCode);
        [ret, ErrorCode] = calllib('spcm64', 'SPC_get_error_string', ret, ErrorCodePtr, 50); 
        fprintf('\nSPC Board initialization failed.:\n%s. \nAborted.\n', ErrorCode);
        if ret == -6
            fprintf('To fix, open Becker and Hickl program, click the box under In Use next to the M1. Then select Apply, and Ok.');
        end
        return;
    else
        %SPC_get_init_status- Initialization status of SPC board
        [ret] = calllib('spcm64', 'SPC_get_init_status', SPC_MODULE_NUMBER);
        if ret < 0
            fprintf('\nBoard initialization failed. See Below. Error code: %d\n', ret)
            fprintf('\nINIT_ SPC_NOT_DONE -1 init not done\nINIT_ SPC_WRONG_EEP_CHKSUM -2 wrong EEPROM checksum\nINIT_ SPC_WRONG_MOD_ID -3 wrong module identification code\nINIT_ SPC_HARD_TEST_ERR -4 hardware test failed\nINIT_ SPC_CANT_OPEN_PCI_CARD -5 cannot open PCI card\nINIT_ SPC_MOD_IN_USE -6 module in use (locked) - cannot initialise\nINIT_ SPC_WINDRVR_VER -7 incorrect WinDriver version\nINIT_ SPC_WRONG_LICENSE -8 corrupted license key\nINIT_SPC_FIRMWARE_VER -9 incorrect firmware version of DPC/SPC module\nINIT_SPC_NO_LICENSE -10 license key not read from registry\nINIT_SPC_LICENSE_NOT_VALID -11 license is not valid for SPCM DLL\n')
            return
        else
            fprintf('SPC Board initialized successfully.\n');
        end
    end
end



%
