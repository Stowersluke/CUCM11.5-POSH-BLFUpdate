# CUCM11.5-POSH-BLFUpdate
Powershell with GUI to let a user update their BLF speed dials.

This was written and only tested with Version 11.5 CUCM.

This requires Powershell 5.1 for Invoke-WebRequest to function.

For Windows 7 you will need to run a .net update that includes PS5.1.

!! READ SETUP!!

The DLLs needed for the GUI are in the DLLs folder. The .txt files are the Base64 for each DLL.

The Base64 of the DLLs are put in to the script to bypass having to ensure the DLLs are located on the users machine.

The Here-String Variables in the script are EMPTY and you will need to copy the Base64 in to each of them.

Otherwise you will have to load the DLLs yourself.

The URI will need to be set to whichever CUCM you want to use.

The Partition needs to be set to the correct partition that your internal Directory Numbers are located for the BLFs.

If you want to try this on a different version then the Header will need to be updated to your version.

!!      !!

It uses AD Authentication to very the credentials to pass to CUCM.

Ensure that the users running this have AXL API Access under their CUCM accounts. Or a service account that has read/write access.

It is set to only update the BLF. If they have other buttons on their modules then this will not accurately display the correct order but will still update according to the specific numerical order. I have not updated it for this yet. I have set this to be a visual representation of what my users see on their button modules.

~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-

What this does:

Each TextBox is parsed through and added to an XML that gets pushed to the phone system. This is the Display and Number boxes as well as the Index of which BLF is being updated.

The Internal and External radio buttons are to indicate for the system whether it is a directory number or a non-specific number to act as the speed dial.

The specific order that you see goes Top to Bottom, starting at the Top Left.

~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-

How To Use:

Run the script and it will immediately prompt for user credentials.

Once a user is logged in it will open the GUI. Click on Settings in the top right corner and you will have the 2 main options, Load and Update.

Load Current Layout will pull the users associated phone and update the BLF order to what theirs is.

Update New Layout will save the layout in to an XML file and push it to the phone system.


~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-

Side Notes:

The GUI can be updated to whatever you want, I am not a GUI expert. To modify the GUI make sure to go in to the functions and update the "Get-Variable" with whatever you renamed the textboxes and radiobuttons.
