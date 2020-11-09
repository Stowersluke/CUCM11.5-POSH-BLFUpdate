# CUCM11.5-POSH-BLFUpdate
Powershell with GUI to let a user update their BLF speed dials.

This was written and only tested with Version 11.5 CUCM.
This requires Powershell 5.1 for Invoke-WebRequest to function.
For Windows 7 you will need to run a .net update that includes PS5.1.

!! READ !!
The DLLs needed for the GUI are in the DLLs folder. The .txt files are the Base64 for each DLL.
The Base64 of the DLLs are put in to the script to bypass having to ensure the DLLs are located on the users machine.
The Here-String Variables in the script are EMPTY and you will need to copy the Base64 in to each of them.
Otherwise you will have to load the DLLs yourself.
!!      !!

It uses AD Authentication to very the credentials to pass to CUCM.

Ensure that the users running this have AXL API Access under their CUCM accounts. Or a service account that has read/write access.

It is set to only update the BLF. If they have other buttons on their modules then this will not accurately display the correct order but will still update according to the specific numerical order. I have not updated it for this yet. I have set this to be a visual representation of what my users see on their button modules.

~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-

What this does:

Each TextBox is parsed through and added to an XML that gets pushed to the phone system. This is the Display and Number boxes as well as the Index of which BLF is being updated.

The Internal and External radio buttons are to indicate for the system whether it is a directory number or a non-specific number to act as the speed dial.

The specific order that you see goes Top to Bottom, starting at the Top Left.
