#https://mahapps.com/controls/
#Load required libraries
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Windows.Forms, System.Drawing, System.DirectoryServices.AccountManagement

#<# Configurations for CUCM API.
#Replace CUCMIPADDRESS
$Global:URI = "https://CUCMIPADDRESS:8443/axl/"

#Replace Version
$Global:Headers = @{SOAPAction="CUCM:DB ver=11.5";Accept="Accept: text/*"}

#Replace Partition
$Global:RoutePartition = ""
#>

if($cred -ne $null){$cred -eq $null}

##################################User Credentials For AXL API######################################
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
Function Verify-Credentials(){
    if($Cred -eq $null){return $false}
    $USNA = $Cred.username
    $PAWO = $Cred.GetNetworkCredential().password
    $DS = New-Object System.DirectoryServices.AccountManagement.PrincipalContext([System.DirectoryServices.AccountManagement.ContextType]::'domain')
    return $DS.ValidateCredentials($USNA, $PAWO)
}
$attempts = 0
Do{

    if ($cred -eq $null){
        try{
            $cred = Get-Credential -Credential $null
        }catch{
            Exit
        }
    }

    if(!(Verify-Credentials)){
       if($attempts -ge 3){
            [System.Windows.MessageBox]::Show('3 Failed Attempts, Exiting') | Out-Null
            Exit
        }

        [System.Windows.MessageBox]::Show('Authentication Failed') | Out-Null
        $cred = $null
        $attempts++
    }
}
Until(Verify-Credentials)
#############################END Credential Verification Block################################


##################################Embedded .dll files###############################################
#
#
#IMPORTANT: Convert the DLLs to base64 and input them in to the Here-Strings. This will prevent any unneeded copying of DLLs to users files and remove the need for admin access to DLL folders.
#This will bloat the file but it's still very small overall.
#
#ControlzEx.dll
$controlzex64 = @"
"@
$controlzex = [System.Convert]::FromBase64String($controlzex64)
[System.Reflection.Assembly]::Load($controlzex) | Out-Null

#MahApps.Metro.dll
$mahapps64 = @"
"@
$mahapps = [System.Convert]::FromBase64String($mahapps64)
[System.Reflection.Assembly]::Load($mahapps) | Out-Null

#System.Windows.Interactivity.dll
$sysinteract64 = @"
"@
$sysinteract = [System.Convert]::FromBase64String($sysinteract64)
[System.Reflection.Assembly]::Load($sysinteract) | Out-Null


##################################Main Form Loading#################################################


#The entire Main XAML form, modify this to change the main window.
[xml]$Main_Xaml = @"
<Controls:MetroWindow
    
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:Controls="clr-namespace:MahApps.Metro.Controls;assembly=MahApps.Metro"
        Title="Button Module Updater"
        Height="1000"
        Width="1000"
        ResizeMode="CanMinimize"
        WindowStartupLocation = "Manual"
        Left = "400"
        Top = "10"
        >

    <Window.Resources>
        <ResourceDictionary>
            <ResourceDictionary.MergedDictionaries>
                <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Controls.AnimatedSingleRowTabControl.xaml" />
                <!-- MahApps.Metro resource dictionaries. Make sure that all file names are Case Sensitive! -->
                <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Controls.xaml" />
                <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Fonts.xaml" />
                <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Colors.xaml" />
                <!-- Accent and AppTheme setting -->
                <!--â€œRedâ€, â€œGreenâ€, â€œBlueâ€, â€œPurpleâ€, â€œOrangeâ€, â€œLimeâ€, â€œEmeraldâ€, â€œTealâ€, â€œCyanâ€, â€œCobaltâ€, â€œIndigoâ€, â€œVioletâ€, â€œPinkâ€, â€œMagentaâ€, â€œCrimsonâ€, â€œAmberâ€, â€œYellowâ€, â€œBrownâ€, â€œOliveâ€, â€œSteelâ€, â€œMauveâ€, â€œTaupeâ€, â€œSiennaâ€ -->
                <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Accents/Blue.xaml" />
                <!-- â€œBaseLightâ€, â€œBaseDarkâ€ -->
                <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Accents/BaseDark.xaml" />
            </ResourceDictionary.MergedDictionaries>
        </ResourceDictionary>
    </Window.Resources>

    <Controls:MetroWindow.RightWindowCommands>
        <Controls:WindowCommands>
            <Button Name="Setting_Button" Content="Settings" />
           <!-- <Button Name="Log_Button">
                <StackPanel Orientation="Horizontal">
                    <TextBlock Margin="4 0 0 0" VerticalAlignment="Center" Text="View Logs" />
                </StackPanel>
            </Button>
           -->
        </Controls:WindowCommands>
    </Controls:MetroWindow.RightWindowCommands>

    <Grid Name="Grid1" Background="#252525">
        <TabControl HorizontalAlignment="Left" VerticalAlignment="Top" Height="900" Width="990" Margin="5,5,5,5">
            <TabItem Header="Left Module" FontSize="9" Padding="340,0,0,0">
                <Grid Name="Grid11" Background="#555555" Margin="0,0,0,0">
                    <TabControl TabStripPlacement="Bottom" HorizontalAlignment="Left" VerticalAlignment="Bottom" Height="895" Width="980" Margin="5,5,5,5">
                        <TabItem Header="Page 1" FontSize="9" Background="#555555" Padding="397,0,0,0">
                            <Grid Name="Grid111" Background="#252525" Margin="0,0,0,0">

                                <Rectangle Name="Line1Rect" Fill="#555555" HorizontalAlignment="Left" Height="70" Margin="10,50,0,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line2Rect" Fill="#555555" HorizontalAlignment="Left" Height="70" Margin="10,140,0,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line3Rect" Fill="#555555" HorizontalAlignment="Left" Height="70" Margin="10,230,0,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line4Rect" Fill="#555555" HorizontalAlignment="Left" Height="70" Margin="10,320,0,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line5Rect" Fill="#555555" HorizontalAlignment="Left" Height="70" Margin="10,410,0,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line6Rect" Fill="#555555" HorizontalAlignment="Left" Height="70" Margin="10,500,0,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line7Rect" Fill="#555555" HorizontalAlignment="Left" Height="70" Margin="10,590,0,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line8Rect" Fill="#555555" HorizontalAlignment="Left" Height="70" Margin="10,680,0,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line9Rect" Fill="#555555" HorizontalAlignment="Left" Height="70" Margin="10,770,0,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line10Rect" Fill="#555555" HorizontalAlignment="Right" Height="70" Margin="0,50,15,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line11Rect" Fill="#555555" HorizontalAlignment="Right" Height="70" Margin="0,140,15,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line12Rect" Fill="#555555" HorizontalAlignment="Right" Height="70" Margin="0,230,15,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line13Rect" Fill="#555555" HorizontalAlignment="Right" Height="70" Margin="0,320,15,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line14Rect" Fill="#555555" HorizontalAlignment="Right" Height="70" Margin="0,410,15,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line15Rect" Fill="#555555" HorizontalAlignment="Right" Height="70" Margin="0,500,15,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line16Rect" Fill="#555555" HorizontalAlignment="Right" Height="70" Margin="0,590,15,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line17Rect" Fill="#555555" HorizontalAlignment="Right" Height="70" Margin="0,680,15,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line18Rect" Fill="#555555" HorizontalAlignment="Right" Height="70" Margin="0,770,15,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>


                                <TextBox Name="Line1DispText" MaxLength="30" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,55,0,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line1NumbText" MaxLength="11" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,85,0,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>

                                <TextBox Name="Line2DispText" MaxLength="30" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,145,0,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line2NumbText" MaxLength="11" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,175,0,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>
                                
                                <TextBox Name="Line3DispText" MaxLength="30" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,235,0,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line3NumbText" MaxLength="11" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,265,0,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>
                                
                                <TextBox Name="Line4DispText" MaxLength="30" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,325,0,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line4NumbText" MaxLength="11" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,355,0,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>
                                
                                <TextBox Name="Line5DispText" MaxLength="30" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,415,0,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line5NumbText" MaxLength="11" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,445,0,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>
                                
                                <TextBox Name="Line6DispText" MaxLength="30" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,505,0,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line6NumbText" MaxLength="11" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,535,0,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>
                                
                                <TextBox Name="Line7DispText" MaxLength="30" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,595,0,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line7NumbText" MaxLength="11" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,625,0,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>
                                
                                <TextBox Name="Line8DispText" MaxLength="30" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,685,0,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line8NumbText" MaxLength="11" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,715,0,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>
                                
                                <TextBox Name="Line9DispText" MaxLength="30" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,775,0,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line9NumbText" MaxLength="11" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,805,0,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>
                                
                                <TextBox Name="Line10DispText" MaxLength="30" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,55,163,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line10NumbText" MaxLength="11" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,85,273,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>
                                
                                <TextBox Name="Line11DispText" MaxLength="30" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,145,163,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line11NumbText" MaxLength="11" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,175,273,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>
                                
                                <TextBox Name="Line12DispText" MaxLength="30" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,235,163,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line12NumbText" MaxLength="11" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,265,273,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>
                                
                                <TextBox Name="Line13DispText" MaxLength="30" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,325,163,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line13NumbText" MaxLength="11" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,355,273,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>
                                
                                <TextBox Name="Line14DispText" MaxLength="30" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,415,163,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line14NumbText" MaxLength="11" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,445,273,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>
                                
                                <TextBox Name="Line15DispText" MaxLength="30" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,505,163,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line15NumbText" MaxLength="11" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,535,273,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>
                                
                                <TextBox Name="Line16DispText" MaxLength="30" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,595,163,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line16NumbText" MaxLength="11" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,625,273,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>
                                
                                <TextBox Name="Line17DispText" MaxLength="30" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,685,163,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line17NumbText" MaxLength="11" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,715,273,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>
                                
                                <TextBox Name="Line18DispText" MaxLength="30" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,775,163,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line18NumbText" MaxLength="11" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,805,273,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>


                                <RadioButton Name="Line1IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="1" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="400,60,0,0" />
                                <RadioButton Name="Line2IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="2" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="400,150,0,0" />
                                <RadioButton Name="Line3IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="3" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="400,240,0,0" />
                                <RadioButton Name="Line4IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="4" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="400,330,0,0" />
                                <RadioButton Name="Line5IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="5" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="400,420,0,0" />
                                <RadioButton Name="Line6IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="6" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="400,510,0,0" />
                                <RadioButton Name="Line7IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="7" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="400,600,0,0" />
                                <RadioButton Name="Line8IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="8" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="400,690,0,0" />
                                <RadioButton Name="Line9IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="9" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="400,780,0,0" />
                                <RadioButton Name="Line10IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="10" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,60,20,0" />
                                <RadioButton Name="Line11IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="11" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,150,20,0" />
                                <RadioButton Name="Line12IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="12" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,240,20,0" />
                                <RadioButton Name="Line13IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="13" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,330,20,0" />
                                <RadioButton Name="Line14IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="14" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,420,20,0" />
                                <RadioButton Name="Line15IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="15" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,510,20,0" />
                                <RadioButton Name="Line16IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="16" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,600,20,0" />
                                <RadioButton Name="Line17IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="17" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,690,20,0" />
                                <RadioButton Name="Line18IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="18" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,780,20,0" />


                                <RadioButton Name="Line1ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="1" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="398,90,0,0"/>
                                <RadioButton Name="Line2ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="2" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="398,180,0,0"/>
                                <RadioButton Name="Line3ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="3" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="398,270,0,0"/>
                                <RadioButton Name="Line4ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="4" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="398,360,0,0"/>
                                <RadioButton Name="Line5ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="5" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="398,450,0,0"/>
                                <RadioButton Name="Line6ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="6" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="398,540,0,0"/>
                                <RadioButton Name="Line7ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="7" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="398,630,0,0"/>
                                <RadioButton Name="Line8ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="8" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="398,720,0,0"/>
                                <RadioButton Name="Line9ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="9" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="398,810,0,0"/>
                                <RadioButton Name="Line10ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="10" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,90,20,0"/>
                                <RadioButton Name="Line11ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="11" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,180,20,0"/>
                                <RadioButton Name="Line12ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="12" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,270,20,0"/>
                                <RadioButton Name="Line13ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="13" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,360,20,0"/>
                                <RadioButton Name="Line14ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="14" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,450,20,0"/>
                                <RadioButton Name="Line15ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="15" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,540,20,0"/>
                                <RadioButton Name="Line16ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="16" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,630,20,0"/>
                                <RadioButton Name="Line17ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="17" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,720,20,0"/>
                                <RadioButton Name="Line18ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="18" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,810,20,0"/>


                                <Label Name="Line1DispLabel" Content="Display:" HorizontalAlignment="Left" Margin="10,52,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line2DispLabel" Content="Display:" HorizontalAlignment="Left" Margin="10,142,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line3DispLabel" Content="Display:" HorizontalAlignment="Left" Margin="10,232,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line4DispLabel" Content="Display:" HorizontalAlignment="Left" Margin="10,322,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line5DispLabel" Content="Display:" HorizontalAlignment="Left" Margin="10,412,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line6DispLabel" Content="Display:" HorizontalAlignment="Left" Margin="10,502,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line7DispLabel" Content="Display:" HorizontalAlignment="Left" Margin="10,592,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line8DispLabel" Content="Display:" HorizontalAlignment="Left" Margin="10,682,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line9DispLabel" Content="Display:" HorizontalAlignment="Left" Margin="10,772,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line10DispLabel" Content="Display:" HorizontalAlignment="Right" Margin="0,52,410,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line11DispLabel" Content="Display:" HorizontalAlignment="Right" Margin="0,142,410,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line12DispLabel" Content="Display:" HorizontalAlignment="Right" Margin="0,232,410,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line13DispLabel" Content="Display:" HorizontalAlignment="Right" Margin="0,322,410,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line14DispLabel" Content="Display:" HorizontalAlignment="Right" Margin="0,412,410,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line15DispLabel" Content="Display:" HorizontalAlignment="Right" Margin="0,502,410,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line16DispLabel" Content="Display:" HorizontalAlignment="Right" Margin="0,592,410,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line17DispLabel" Content="Display:" HorizontalAlignment="Right" Margin="0,682,410,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line18DispLabel" Content="Display:" HorizontalAlignment="Right" Margin="0,772,410,0" VerticalAlignment="Top" FontSize="16"/>


                                <Label Name="Line1NumbLabel" Content="Number:" HorizontalAlignment="Left" Margin="10,82,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line2NumbLabel" Content="Number:" HorizontalAlignment="Left" Margin="10,172,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line3NumbLabel" Content="Number:" HorizontalAlignment="Left" Margin="10,262,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line4NumbLabel" Content="Number:" HorizontalAlignment="Left" Margin="10,352,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line5NumbLabel" Content="Number:" HorizontalAlignment="Left" Margin="10,442,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line6NumbLabel" Content="Number:" HorizontalAlignment="Left" Margin="10,532,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line7NumbLabel" Content="Number:" HorizontalAlignment="Left" Margin="10,622,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line8NumbLabel" Content="Number:" HorizontalAlignment="Left" Margin="10,712,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line9NumbLabel" Content="Number:" HorizontalAlignment="Left" Margin="10,802,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line10NumbLabel" Content="Number:" HorizontalAlignment="Right" Margin="0,82,403,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line11NumbLabel" Content="Number:" HorizontalAlignment="Right" Margin="0,172,403,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line12NumbLabel" Content="Number:" HorizontalAlignment="Right" Margin="0,262,403,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line13NumbLabel" Content="Number:" HorizontalAlignment="Right" Margin="0,352,403,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line14NumbLabel" Content="Number:" HorizontalAlignment="Right" Margin="0,442,403,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line15NumbLabel" Content="Number:" HorizontalAlignment="Right" Margin="0,532,403,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line16NumbLabel" Content="Number:" HorizontalAlignment="Right" Margin="0,622,403,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line17NumbLabel" Content="Number:" HorizontalAlignment="Right" Margin="0,712,403,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line18NumbLabel" Content="Number:" HorizontalAlignment="Right" Margin="0,802,403,0" VerticalAlignment="Top" FontSize="16"/>


                            </Grid>
                        </TabItem>
                        <TabItem Header="Page 2" FontSize="9" Background="#555555" Padding="22,0,0,0">
                            <Grid Name="Grid112" Background="#252525" Margin="0,0,0,0">

                                <Rectangle Name="Line19Rect" Fill="#555555" HorizontalAlignment="Left" Height="70" Margin="10,50,0,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line20Rect" Fill="#555555" HorizontalAlignment="Left" Height="70" Margin="10,140,0,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line21Rect" Fill="#555555" HorizontalAlignment="Left" Height="70" Margin="10,230,0,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line22Rect" Fill="#555555" HorizontalAlignment="Left" Height="70" Margin="10,320,0,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line23Rect" Fill="#555555" HorizontalAlignment="Left" Height="70" Margin="10,410,0,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line24Rect" Fill="#555555" HorizontalAlignment="Left" Height="70" Margin="10,500,0,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line25Rect" Fill="#555555" HorizontalAlignment="Left" Height="70" Margin="10,590,0,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line26Rect" Fill="#555555" HorizontalAlignment="Left" Height="70" Margin="10,680,0,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line27Rect" Fill="#555555" HorizontalAlignment="Left" Height="70" Margin="10,770,0,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line28Rect" Fill="#555555" HorizontalAlignment="Right" Height="70" Margin="0,50,15,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line29Rect" Fill="#555555" HorizontalAlignment="Right" Height="70" Margin="0,140,15,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line30Rect" Fill="#555555" HorizontalAlignment="Right" Height="70" Margin="0,230,15,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line31Rect" Fill="#555555" HorizontalAlignment="Right" Height="70" Margin="0,320,15,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line32Rect" Fill="#555555" HorizontalAlignment="Right" Height="70" Margin="0,410,15,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line33Rect" Fill="#555555" HorizontalAlignment="Right" Height="70" Margin="0,500,15,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line34Rect" Fill="#555555" HorizontalAlignment="Right" Height="70" Margin="0,590,15,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line35Rect" Fill="#555555" HorizontalAlignment="Right" Height="70" Margin="0,680,15,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line36Rect" Fill="#555555" HorizontalAlignment="Right" Height="70" Margin="0,770,15,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>


                                <TextBox Name="Line19DispText" MaxLength="30" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,55,0,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line19NumbText" MaxLength="11" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,85,0,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>

                                <TextBox Name="Line20DispText" MaxLength="30" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,145,0,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line20NumbText" MaxLength="11" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,175,0,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>

                                <TextBox Name="Line21DispText" MaxLength="30" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,235,0,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line21NumbText" MaxLength="11" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,265,0,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>

                                <TextBox Name="Line22DispText" MaxLength="30" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,325,0,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line22NumbText" MaxLength="11" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,355,0,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>

                                <TextBox Name="Line23DispText" MaxLength="30" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,415,0,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line23NumbText" MaxLength="11" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,445,0,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>

                                <TextBox Name="Line24DispText" MaxLength="30" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,505,0,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line24NumbText" MaxLength="11" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,535,0,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>

                                <TextBox Name="Line25DispText" MaxLength="30" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,595,0,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line25NumbText" MaxLength="11" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,625,0,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>

                                <TextBox Name="Line26DispText" MaxLength="30" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,685,0,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line26NumbText" MaxLength="11" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,715,0,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>

                                <TextBox Name="Line27DispText" MaxLength="30" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,775,0,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line27NumbText" MaxLength="11" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,805,0,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>

                                <TextBox Name="Line28DispText" MaxLength="30" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,55,163,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line28NumbText" MaxLength="11" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,85,273,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>

                                <TextBox Name="Line29DispText" MaxLength="30" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,145,163,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line29NumbText" MaxLength="11" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,175,273,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>

                                <TextBox Name="Line30DispText" MaxLength="30" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,235,163,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line30NumbText" MaxLength="11" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,265,273,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>

                                <TextBox Name="Line31DispText" MaxLength="30" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,325,163,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line31NumbText" MaxLength="11" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,355,273,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>

                                <TextBox Name="Line32DispText" MaxLength="30" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,415,163,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line32NumbText" MaxLength="11" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,445,273,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>

                                <TextBox Name="Line33DispText" MaxLength="30" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,505,163,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line33NumbText" MaxLength="11" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,535,273,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>

                                <TextBox Name="Line34DispText" MaxLength="30" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,595,163,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line34NumbText" MaxLength="11" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,625,273,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>

                                <TextBox Name="Line35DispText" MaxLength="30" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,685,163,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line35NumbText" MaxLength="11" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,715,273,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>

                                <TextBox Name="Line36DispText" MaxLength="30" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,775,163,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line36NumbText" MaxLength="11" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,805,273,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>


                                <RadioButton Name="Line19IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="19" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="400,60,0,0" />
                                <RadioButton Name="Line20IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="20" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="400,150,0,0" />
                                <RadioButton Name="Line21IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="21" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="400,240,0,0" />
                                <RadioButton Name="Line22IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="22" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="400,330,0,0" />
                                <RadioButton Name="Line23IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="23" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="400,420,0,0" />
                                <RadioButton Name="Line24IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="24" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="400,510,0,0" />
                                <RadioButton Name="Line25IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="25" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="400,600,0,0" />
                                <RadioButton Name="Line26IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="26" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="400,690,0,0" />
                                <RadioButton Name="Line27IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="27" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="400,780,0,0" />
                                <RadioButton Name="Line28IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="28" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,60,20,0" />
                                <RadioButton Name="Line29IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="29" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,150,20,0" />
                                <RadioButton Name="Line30IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="30" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,240,20,0" />
                                <RadioButton Name="Line31IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="31" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,330,20,0" />
                                <RadioButton Name="Line32IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="32" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,420,20,0" />
                                <RadioButton Name="Line33IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="33" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,510,20,0" />
                                <RadioButton Name="Line34IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="34" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,600,20,0" />
                                <RadioButton Name="Line35IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="35" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,690,20,0" />
                                <RadioButton Name="Line36IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="36" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,780,20,0" />


                                <RadioButton Name="Line19ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="19" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="398,90,0,0"/>
                                <RadioButton Name="Line20ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="20" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="398,180,0,0"/>
                                <RadioButton Name="Line21ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="21" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="398,270,0,0"/>
                                <RadioButton Name="Line22ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="22" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="398,360,0,0"/>
                                <RadioButton Name="Line23ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="23" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="398,450,0,0"/>
                                <RadioButton Name="Line24ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="24" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="398,540,0,0"/>
                                <RadioButton Name="Line25ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="25" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="398,630,0,0"/>
                                <RadioButton Name="Line26ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="26" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="398,720,0,0"/>
                                <RadioButton Name="Line27ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="27" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="398,810,0,0"/>
                                <RadioButton Name="Line28ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="28" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,90,20,0"/>
                                <RadioButton Name="Line29ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="29" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,180,20,0"/>
                                <RadioButton Name="Line30ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="30" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,270,20,0"/>
                                <RadioButton Name="Line31ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="31" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,360,20,0"/>
                                <RadioButton Name="Line32ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="32" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,450,20,0"/>
                                <RadioButton Name="Line33ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="33" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,540,20,0"/>
                                <RadioButton Name="Line34ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="34" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,630,20,0"/>
                                <RadioButton Name="Line35ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="35" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,720,20,0"/>
                                <RadioButton Name="Line36ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="36" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,810,20,0"/>


                                <Label Name="Line19DispLabel" Content="Display:" HorizontalAlignment="Left" Margin="10,52,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line20DispLabel" Content="Display:" HorizontalAlignment="Left" Margin="10,142,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line21DispLabel" Content="Display:" HorizontalAlignment="Left" Margin="10,232,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line22DispLabel" Content="Display:" HorizontalAlignment="Left" Margin="10,322,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line23DispLabel" Content="Display:" HorizontalAlignment="Left" Margin="10,412,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line24DispLabel" Content="Display:" HorizontalAlignment="Left" Margin="10,502,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line25DispLabel" Content="Display:" HorizontalAlignment="Left" Margin="10,592,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line26DispLabel" Content="Display:" HorizontalAlignment="Left" Margin="10,682,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line27DispLabel" Content="Display:" HorizontalAlignment="Left" Margin="10,772,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line28DispLabel" Content="Display:" HorizontalAlignment="Right" Margin="0,52,410,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line29DispLabel" Content="Display:" HorizontalAlignment="Right" Margin="0,142,410,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line30DispLabel" Content="Display:" HorizontalAlignment="Right" Margin="0,232,410,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line31DispLabel" Content="Display:" HorizontalAlignment="Right" Margin="0,322,410,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line32DispLabel" Content="Display:" HorizontalAlignment="Right" Margin="0,412,410,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line33DispLabel" Content="Display:" HorizontalAlignment="Right" Margin="0,502,410,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line34DispLabel" Content="Display:" HorizontalAlignment="Right" Margin="0,592,410,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line35DispLabel" Content="Display:" HorizontalAlignment="Right" Margin="0,682,410,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line36DispLabel" Content="Display:" HorizontalAlignment="Right" Margin="0,772,410,0" VerticalAlignment="Top" FontSize="16"/>


                                <Label Name="Line19NumbLabel" Content="Number:" HorizontalAlignment="Left" Margin="10,82,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line20NumbLabel" Content="Number:" HorizontalAlignment="Left" Margin="10,172,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line21NumbLabel" Content="Number:" HorizontalAlignment="Left" Margin="10,262,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line22NumbLabel" Content="Number:" HorizontalAlignment="Left" Margin="10,352,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line23NumbLabel" Content="Number:" HorizontalAlignment="Left" Margin="10,442,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line24NumbLabel" Content="Number:" HorizontalAlignment="Left" Margin="10,532,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line25NumbLabel" Content="Number:" HorizontalAlignment="Left" Margin="10,622,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line26NumbLabel" Content="Number:" HorizontalAlignment="Left" Margin="10,712,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line27NumbLabel" Content="Number:" HorizontalAlignment="Left" Margin="10,802,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line28NumbLabel" Content="Number:" HorizontalAlignment="Right" Margin="0,82,403,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line29NumbLabel" Content="Number:" HorizontalAlignment="Right" Margin="0,172,403,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line30NumbLabel" Content="Number:" HorizontalAlignment="Right" Margin="0,262,403,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line31NumbLabel" Content="Number:" HorizontalAlignment="Right" Margin="0,352,403,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line32NumbLabel" Content="Number:" HorizontalAlignment="Right" Margin="0,442,403,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line33NumbLabel" Content="Number:" HorizontalAlignment="Right" Margin="0,532,403,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line34NumbLabel" Content="Number:" HorizontalAlignment="Right" Margin="0,622,403,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line35NumbLabel" Content="Number:" HorizontalAlignment="Right" Margin="0,712,403,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line36NumbLabel" Content="Number:" HorizontalAlignment="Right" Margin="0,802,403,0" VerticalAlignment="Top" FontSize="16"/>


                            </Grid>

                        </TabItem>
                    </TabControl>
                </Grid>
            </TabItem>
            <TabItem Header="Right Module" FontSize="9" Padding="26,0,0,0">
                <Grid Name="Grid12" Background="#555555" Margin="0,0,0,0">
                    <TabControl TabStripPlacement="Bottom" HorizontalAlignment="Left" VerticalAlignment="Bottom" Height="895" Width="980" Margin="5,5,5,5">
                        <TabItem Header="Page 1" FontSize="9" Background="#555555" Padding="397,0,0,0">
                            <Grid Name="Grid121" Background="#252525" Margin="0,0,0,0">

                                <Rectangle Name="Line37Rect" Fill="#555555" HorizontalAlignment="Left" Height="70" Margin="10,50,0,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line38Rect" Fill="#555555" HorizontalAlignment="Left" Height="70" Margin="10,140,0,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line39Rect" Fill="#555555" HorizontalAlignment="Left" Height="70" Margin="10,230,0,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line40Rect" Fill="#555555" HorizontalAlignment="Left" Height="70" Margin="10,320,0,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line41Rect" Fill="#555555" HorizontalAlignment="Left" Height="70" Margin="10,410,0,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line42Rect" Fill="#555555" HorizontalAlignment="Left" Height="70" Margin="10,500,0,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line43Rect" Fill="#555555" HorizontalAlignment="Left" Height="70" Margin="10,590,0,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line44Rect" Fill="#555555" HorizontalAlignment="Left" Height="70" Margin="10,680,0,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line45Rect" Fill="#555555" HorizontalAlignment="Left" Height="70" Margin="10,770,0,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line46Rect" Fill="#555555" HorizontalAlignment="Right" Height="70" Margin="0,50,15,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line47Rect" Fill="#555555" HorizontalAlignment="Right" Height="70" Margin="0,140,15,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line48Rect" Fill="#555555" HorizontalAlignment="Right" Height="70" Margin="0,230,15,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line49Rect" Fill="#555555" HorizontalAlignment="Right" Height="70" Margin="0,320,15,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line50Rect" Fill="#555555" HorizontalAlignment="Right" Height="70" Margin="0,410,15,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line51Rect" Fill="#555555" HorizontalAlignment="Right" Height="70" Margin="0,500,15,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line52Rect" Fill="#555555" HorizontalAlignment="Right" Height="70" Margin="0,590,15,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line53Rect" Fill="#555555" HorizontalAlignment="Right" Height="70" Margin="0,680,15,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line54Rect" Fill="#555555" HorizontalAlignment="Right" Height="70" Margin="0,770,15,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>


                                <TextBox Name="Line37DispText" MaxLength="30" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,55,0,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line37NumbText" MaxLength="11" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,85,0,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>

                                <TextBox Name="Line38DispText" MaxLength="30" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,145,0,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line38NumbText" MaxLength="11" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,175,0,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>

                                <TextBox Name="Line39DispText" MaxLength="30" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,235,0,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line39NumbText" MaxLength="11" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,265,0,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>

                                <TextBox Name="Line40DispText" MaxLength="30" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,325,0,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line40NumbText" MaxLength="11" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,355,0,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>

                                <TextBox Name="Line41DispText" MaxLength="30" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,415,0,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line41NumbText" MaxLength="11" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,445,0,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>

                                <TextBox Name="Line42DispText" MaxLength="30" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,505,0,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line42NumbText" MaxLength="11" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,535,0,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>
                                
                                <TextBox Name="Line43DispText" MaxLength="30" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,595,0,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line43NumbText" MaxLength="11" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,625,0,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>
                                
                                <TextBox Name="Line44DispText" MaxLength="30" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,685,0,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line44NumbText" MaxLength="11" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,715,0,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>
                                
                                <TextBox Name="Line45DispText" MaxLength="30" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,775,0,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line45NumbText" MaxLength="11" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,805,0,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>
                                
                                <TextBox Name="Line46DispText" MaxLength="30" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,55,163,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line46NumbText" MaxLength="11" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,85,273,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>
                                
                                <TextBox Name="Line47DispText" MaxLength="30" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,145,163,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line47NumbText" MaxLength="11" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,175,273,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>
                                
                                <TextBox Name="Line48DispText" MaxLength="30" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,235,163,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line48NumbText" MaxLength="11" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,265,273,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>
                                
                                <TextBox Name="Line49DispText" MaxLength="30" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,325,163,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line49NumbText" MaxLength="11" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,355,273,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>
                                
                                <TextBox Name="Line50DispText" MaxLength="30" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,415,163,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line50NumbText" MaxLength="11" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,445,273,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>
                                
                                <TextBox Name="Line51DispText" MaxLength="30" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,505,163,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line51NumbText" MaxLength="11" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,535,273,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>
                                
                                <TextBox Name="Line52DispText" MaxLength="30" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,595,163,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line52NumbText" MaxLength="11" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,625,273,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>
                                
                                <TextBox Name="Line53DispText" MaxLength="30" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,685,163,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line53NumbText" MaxLength="11" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,715,273,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>
                                
                                <TextBox Name="Line54DispText" MaxLength="30" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,775,163,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line54NumbText" MaxLength="11" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,805,273,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>


                                <RadioButton Name="Line37IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="37" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="400,60,0,0" />
                                <RadioButton Name="Line38IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="38" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="400,150,0,0" />
                                <RadioButton Name="Line39IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="39" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="400,240,0,0" />
                                <RadioButton Name="Line40IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="40" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="400,330,0,0" />
                                <RadioButton Name="Line41IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="41" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="400,420,0,0" />
                                <RadioButton Name="Line42IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="42" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="400,510,0,0" />
                                <RadioButton Name="Line43IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="43" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="400,600,0,0" />
                                <RadioButton Name="Line44IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="44" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="400,690,0,0" />
                                <RadioButton Name="Line45IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="45" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="400,780,0,0" />
                                <RadioButton Name="Line46IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="46" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,60,20,0" />
                                <RadioButton Name="Line47IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="47" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,150,20,0" />
                                <RadioButton Name="Line48IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="48" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,240,20,0" />
                                <RadioButton Name="Line49IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="49" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,330,20,0" />
                                <RadioButton Name="Line50IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="50" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,420,20,0" />
                                <RadioButton Name="Line51IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="51" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,510,20,0" />
                                <RadioButton Name="Line52IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="52" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,600,20,0" />
                                <RadioButton Name="Line53IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="53" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,690,20,0" />
                                <RadioButton Name="Line54IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="54" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,780,20,0" />


                                <RadioButton Name="Line37ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="37" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="398,90,0,0"/>
                                <RadioButton Name="Line38ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="38" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="398,180,0,0"/>
                                <RadioButton Name="Line39ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="39" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="398,270,0,0"/>
                                <RadioButton Name="Line40ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="40" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="398,360,0,0"/>
                                <RadioButton Name="Line41ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="41" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="398,450,0,0"/>
                                <RadioButton Name="Line42ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="42" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="398,540,0,0"/>
                                <RadioButton Name="Line43ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="43" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="398,630,0,0"/>
                                <RadioButton Name="Line44ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="44" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="398,720,0,0"/>
                                <RadioButton Name="Line45ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="45" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="398,810,0,0"/>
                                <RadioButton Name="Line46ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="46" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,90,20,0"/>
                                <RadioButton Name="Line47ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="47" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,180,20,0"/>
                                <RadioButton Name="Line48ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="48" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,270,20,0"/>
                                <RadioButton Name="Line49ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="49" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,360,20,0"/>
                                <RadioButton Name="Line50ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="50" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,450,20,0"/>
                                <RadioButton Name="Line51ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="51" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,540,20,0"/>
                                <RadioButton Name="Line52ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="52" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,630,20,0"/>
                                <RadioButton Name="Line53ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="53" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,720,20,0"/>
                                <RadioButton Name="Line54ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="54" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,810,20,0"/>


                                <Label Name="Line37DispLabel" Content="Display:" HorizontalAlignment="Left" Margin="10,52,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line38DispLabel" Content="Display:" HorizontalAlignment="Left" Margin="10,142,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line39DispLabel" Content="Display:" HorizontalAlignment="Left" Margin="10,232,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line40DispLabel" Content="Display:" HorizontalAlignment="Left" Margin="10,322,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line41DispLabel" Content="Display:" HorizontalAlignment="Left" Margin="10,412,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line42DispLabel" Content="Display:" HorizontalAlignment="Left" Margin="10,502,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line43DispLabel" Content="Display:" HorizontalAlignment="Left" Margin="10,592,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line44DispLabel" Content="Display:" HorizontalAlignment="Left" Margin="10,682,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line45DispLabel" Content="Display:" HorizontalAlignment="Left" Margin="10,772,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line46DispLabel" Content="Display:" HorizontalAlignment="Right" Margin="0,52,410,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line47DispLabel" Content="Display:" HorizontalAlignment="Right" Margin="0,142,410,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line48DispLabel" Content="Display:" HorizontalAlignment="Right" Margin="0,232,410,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line49DispLabel" Content="Display:" HorizontalAlignment="Right" Margin="0,322,410,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line50DispLabel" Content="Display:" HorizontalAlignment="Right" Margin="0,412,410,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line51DispLabel" Content="Display:" HorizontalAlignment="Right" Margin="0,502,410,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line52DispLabel" Content="Display:" HorizontalAlignment="Right" Margin="0,592,410,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line53DispLabel" Content="Display:" HorizontalAlignment="Right" Margin="0,682,410,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line54DispLabel" Content="Display:" HorizontalAlignment="Right" Margin="0,772,410,0" VerticalAlignment="Top" FontSize="16"/>


                                <Label Name="Line37NumbLabel" Content="Number:" HorizontalAlignment="Left" Margin="10,82,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line38NumbLabel" Content="Number:" HorizontalAlignment="Left" Margin="10,172,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line39NumbLabel" Content="Number:" HorizontalAlignment="Left" Margin="10,262,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line40NumbLabel" Content="Number:" HorizontalAlignment="Left" Margin="10,352,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line41NumbLabel" Content="Number:" HorizontalAlignment="Left" Margin="10,442,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line42NumbLabel" Content="Number:" HorizontalAlignment="Left" Margin="10,532,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line43NumbLabel" Content="Number:" HorizontalAlignment="Left" Margin="10,622,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line44NumbLabel" Content="Number:" HorizontalAlignment="Left" Margin="10,712,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line45NumbLabel" Content="Number:" HorizontalAlignment="Left" Margin="10,802,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line46NumbLabel" Content="Number:" HorizontalAlignment="Right" Margin="0,82,403,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line47NumbLabel" Content="Number:" HorizontalAlignment="Right" Margin="0,172,403,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line48NumbLabel" Content="Number:" HorizontalAlignment="Right" Margin="0,262,403,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line49NumbLabel" Content="Number:" HorizontalAlignment="Right" Margin="0,352,403,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line50NumbLabel" Content="Number:" HorizontalAlignment="Right" Margin="0,442,403,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line51NumbLabel" Content="Number:" HorizontalAlignment="Right" Margin="0,532,403,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line52NumbLabel" Content="Number:" HorizontalAlignment="Right" Margin="0,622,403,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line53NumbLabel" Content="Number:" HorizontalAlignment="Right" Margin="0,712,403,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line54NumbLabel" Content="Number:" HorizontalAlignment="Right" Margin="0,802,403,0" VerticalAlignment="Top" FontSize="16"/>


                            </Grid>
                        </TabItem>
                        <TabItem Header="Page 2" FontSize="9" Background="#555555" Padding="22,0,0,0">
                            <Grid Name="Grid122" Background="#252525" Margin="0,0,0,0">

                                <Rectangle Name="Line55Rect" Fill="#555555" HorizontalAlignment="Left" Height="70" Margin="10,50,0,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line56Rect" Fill="#555555" HorizontalAlignment="Left" Height="70" Margin="10,140,0,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line57Rect" Fill="#555555" HorizontalAlignment="Left" Height="70" Margin="10,230,0,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line58Rect" Fill="#555555" HorizontalAlignment="Left" Height="70" Margin="10,320,0,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line59Rect" Fill="#555555" HorizontalAlignment="Left" Height="70" Margin="10,410,0,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line60Rect" Fill="#555555" HorizontalAlignment="Left" Height="70" Margin="10,500,0,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line61Rect" Fill="#555555" HorizontalAlignment="Left" Height="70" Margin="10,590,0,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line62Rect" Fill="#555555" HorizontalAlignment="Left" Height="70" Margin="10,680,0,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line63Rect" Fill="#555555" HorizontalAlignment="Left" Height="70" Margin="10,770,0,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line64Rect" Fill="#555555" HorizontalAlignment="Right" Height="70" Margin="0,50,15,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line65Rect" Fill="#555555" HorizontalAlignment="Right" Height="70" Margin="0,140,15,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line66Rect" Fill="#555555" HorizontalAlignment="Right" Height="70" Margin="0,230,15,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line67Rect" Fill="#555555" HorizontalAlignment="Right" Height="70" Margin="0,320,15,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line68Rect" Fill="#555555" HorizontalAlignment="Right" Height="70" Margin="0,410,15,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line69Rect" Fill="#555555" HorizontalAlignment="Right" Height="70" Margin="0,500,15,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line70Rect" Fill="#555555" HorizontalAlignment="Right" Height="70" Margin="0,590,15,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line71Rect" Fill="#555555" HorizontalAlignment="Right" Height="70" Margin="0,680,15,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>
                                <Rectangle Name="Line72Rect" Fill="#555555" HorizontalAlignment="Right" Height="70" Margin="0,770,15,0" Stroke="#FFCCCCCC" VerticalAlignment="Top" Width="460" StrokeThickness="2"/>


                                <TextBox Name="Line55DispText" MaxLength="30" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,55,0,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line55NumbText" MaxLength="11" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,85,0,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>

                                <TextBox Name="Line56DispText" MaxLength="30" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,145,0,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line56NumbText" MaxLength="11" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,175,0,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>

                                <TextBox Name="Line57DispText" MaxLength="30" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,235,0,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line57NumbText" MaxLength="11" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,265,0,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>

                                <TextBox Name="Line58DispText" MaxLength="30" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,325,0,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line58NumbText" MaxLength="11" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,355,0,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>

                                <TextBox Name="Line59DispText" MaxLength="30" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,415,0,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line59NumbText" MaxLength="11" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,445,0,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>

                                <TextBox Name="Line60DispText" MaxLength="30" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,505,0,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line60NumbText" MaxLength="11" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,535,0,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>

                                <TextBox Name="Line61DispText" MaxLength="30" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,595,0,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line61NumbText" MaxLength="11" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,625,0,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>

                                <TextBox Name="Line62DispText" MaxLength="30" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,685,0,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line62NumbText" MaxLength="11" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,715,0,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>

                                <TextBox Name="Line63DispText" MaxLength="30" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,775,0,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line63NumbText" MaxLength="11" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="90,805,0,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>

                                <TextBox Name="Line64DispText" MaxLength="30" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,55,163,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line64NumbText" MaxLength="11" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,85,273,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>

                                <TextBox Name="Line65DispText" MaxLength="30" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,145,163,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line65NumbText" MaxLength="11" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,175,273,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>

                                <TextBox Name="Line66DispText" MaxLength="30" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,235,163,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line66NumbText" MaxLength="11" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,265,273,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>

                                <TextBox Name="Line67DispText" MaxLength="30" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,325,163,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line67NumbText" MaxLength="11" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,355,273,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>

                                <TextBox Name="Line68DispText" MaxLength="30" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,415,163,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line68NumbText" MaxLength="11" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,445,273,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>

                                <TextBox Name="Line69DispText" MaxLength="30" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,505,163,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line69NumbText" MaxLength="11" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,535,273,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>

                                <TextBox Name="Line70DispText" MaxLength="30" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,595,163,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line70NumbText" MaxLength="11" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,625,273,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>

                                <TextBox Name="Line71DispText" MaxLength="30" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,685,163,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line71NumbText" MaxLength="11" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,715,273,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>

                                <TextBox Name="Line72DispText" MaxLength="30" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,775,163,0" TextWrapping="NoWrap"  Height="25" Width="230" FontSize="14"/>
                                <TextBox Name="Line72NumbText" MaxLength="11" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,805,273,0" TextWrapping="NoWrap"  Height="25" Width="120" FontSize="14"/>


                                <RadioButton Name="Line55IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="55" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="400,60,0,0" />
                                <RadioButton Name="Line56IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="56" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="400,150,0,0" />
                                <RadioButton Name="Line57IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="57" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="400,240,0,0" />
                                <RadioButton Name="Line58IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="58" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="400,330,0,0" />
                                <RadioButton Name="Line59IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="59" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="400,420,0,0" />
                                <RadioButton Name="Line60IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="60" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="400,510,0,0" />
                                <RadioButton Name="Line61IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="61" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="400,600,0,0" />
                                <RadioButton Name="Line62IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="62" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="400,690,0,0" />
                                <RadioButton Name="Line63IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="63" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="400,780,0,0" />
                                <RadioButton Name="Line64IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="64" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,60,20,0" />
                                <RadioButton Name="Line65IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="65" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,150,20,0" />
                                <RadioButton Name="Line66IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="66" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,240,20,0" />
                                <RadioButton Name="Line67IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="67" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,330,20,0" />
                                <RadioButton Name="Line68IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="68" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,420,20,0" />
                                <RadioButton Name="Line69IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="69" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,510,20,0" />
                                <RadioButton Name="Line70IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="70" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,600,20,0" />
                                <RadioButton Name="Line71IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="71" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,690,20,0" />
                                <RadioButton Name="Line72IntRadio" Content="Internal" FlowDirection="RightToLeft" GroupName="72" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,780,20,0" />


                                <RadioButton Name="Line55ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="55" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="398,90,0,0"/>
                                <RadioButton Name="Line56ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="56" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="398,180,0,0"/>
                                <RadioButton Name="Line57ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="57" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="398,270,0,0"/>
                                <RadioButton Name="Line58ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="58" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="398,360,0,0"/>
                                <RadioButton Name="Line59ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="59" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="398,450,0,0"/>
                                <RadioButton Name="Line60ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="60" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="398,540,0,0"/>
                                <RadioButton Name="Line61ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="61" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="398,630,0,0"/>
                                <RadioButton Name="Line62ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="62" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="398,720,0,0"/>
                                <RadioButton Name="Line63ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="63" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="398,810,0,0"/>
                                <RadioButton Name="Line64ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="64" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,90,20,0"/>
                                <RadioButton Name="Line65ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="65" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,180,20,0"/>
                                <RadioButton Name="Line66ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="66" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,270,20,0"/>
                                <RadioButton Name="Line67ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="67" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,360,20,0"/>
                                <RadioButton Name="Line68ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="68" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,450,20,0"/>
                                <RadioButton Name="Line69ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="69" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,540,20,0"/>
                                <RadioButton Name="Line70ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="70" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,630,20,0"/>
                                <RadioButton Name="Line71ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="71" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,720,20,0"/>
                                <RadioButton Name="Line72ExtRadio" Content="External" FlowDirection="RightToLeft" GroupName="72" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,810,20,0"/>


                                <Label Name="Line55DispLabel" Content="Display:" HorizontalAlignment="Left" Margin="10,52,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line56DispLabel" Content="Display:" HorizontalAlignment="Left" Margin="10,142,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line57DispLabel" Content="Display:" HorizontalAlignment="Left" Margin="10,232,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line58DispLabel" Content="Display:" HorizontalAlignment="Left" Margin="10,322,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line59DispLabel" Content="Display:" HorizontalAlignment="Left" Margin="10,412,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line60DispLabel" Content="Display:" HorizontalAlignment="Left" Margin="10,502,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line61DispLabel" Content="Display:" HorizontalAlignment="Left" Margin="10,592,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line62DispLabel" Content="Display:" HorizontalAlignment="Left" Margin="10,682,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line63DispLabel" Content="Display:" HorizontalAlignment="Left" Margin="10,772,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line64DispLabel" Content="Display:" HorizontalAlignment="Right" Margin="0,52,410,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line65DispLabel" Content="Display:" HorizontalAlignment="Right" Margin="0,142,410,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line66DispLabel" Content="Display:" HorizontalAlignment="Right" Margin="0,232,410,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line67DispLabel" Content="Display:" HorizontalAlignment="Right" Margin="0,322,410,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line68DispLabel" Content="Display:" HorizontalAlignment="Right" Margin="0,412,410,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line69DispLabel" Content="Display:" HorizontalAlignment="Right" Margin="0,502,410,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line70DispLabel" Content="Display:" HorizontalAlignment="Right" Margin="0,592,410,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line71DispLabel" Content="Display:" HorizontalAlignment="Right" Margin="0,682,410,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line72DispLabel" Content="Display:" HorizontalAlignment="Right" Margin="0,772,410,0" VerticalAlignment="Top" FontSize="16"/>


                                <Label Name="Line55NumbLabel" Content="Number:" HorizontalAlignment="Left" Margin="10,82,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line56NumbLabel" Content="Number:" HorizontalAlignment="Left" Margin="10,172,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line57NumbLabel" Content="Number:" HorizontalAlignment="Left" Margin="10,262,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line58NumbLabel" Content="Number:" HorizontalAlignment="Left" Margin="10,352,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line59NumbLabel" Content="Number:" HorizontalAlignment="Left" Margin="10,442,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line60NumbLabel" Content="Number:" HorizontalAlignment="Left" Margin="10,532,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line61NumbLabel" Content="Number:" HorizontalAlignment="Left" Margin="10,622,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line62NumbLabel" Content="Number:" HorizontalAlignment="Left" Margin="10,712,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line63NumbLabel" Content="Number:" HorizontalAlignment="Left" Margin="10,802,0,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line64NumbLabel" Content="Number:" HorizontalAlignment="Right" Margin="0,82,403,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line65NumbLabel" Content="Number:" HorizontalAlignment="Right" Margin="0,172,403,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line66NumbLabel" Content="Number:" HorizontalAlignment="Right" Margin="0,262,403,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line67NumbLabel" Content="Number:" HorizontalAlignment="Right" Margin="0,352,403,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line68NumbLabel" Content="Number:" HorizontalAlignment="Right" Margin="0,442,403,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line69NumbLabel" Content="Number:" HorizontalAlignment="Right" Margin="0,532,403,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line70NumbLabel" Content="Number:" HorizontalAlignment="Right" Margin="0,622,403,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line71NumbLabel" Content="Number:" HorizontalAlignment="Right" Margin="0,712,403,0" VerticalAlignment="Top" FontSize="16"/>
                                <Label Name="Line72NumbLabel" Content="Number:" HorizontalAlignment="Right" Margin="0,802,403,0" VerticalAlignment="Top" FontSize="16"/>


                            </Grid>

                        </TabItem>
                    </TabControl>
                </Grid>
            </TabItem>
        </TabControl>
        <StatusBar Name="StatusBar" BorderBrush="#1585b5" BorderThickness="1" Height="31" HorizontalAlignment="Stretch" VerticalAlignment="Bottom" Background="#FF252525" Foreground="White" Margin="-1,0,-1,-1">
            <TextBlock Name="StatusBar_Text" Text="" FontSize="14"/>
        </StatusBar>
    </Grid>

</Controls:MetroWindow>
"@


#Loading the form to allow control
$Main_Reader = (New-Object System.Xml.XmlNodeReader $Main_Xaml) 
$Main_Form = [Windows.Markup.XamlReader]::Load($Main_Reader) 


#AutoFind all controls
$Main_Xaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]") | ForEach-Object { 
    New-Variable  -Name $_.Name -Value $Main_Form.FindName($_.Name) -Force
}

##################################XML Format Viewing Tool###########################################

#If you're receiving errors when updating, use this function to view the xml in proper format to check for errors.
#Instead of pushing to the server output this to the screen to verify the xml has everything correct.

function WriteXmlToScreen ([xml]$xml)
{
    $StringWriter = New-Object System.IO.StringWriter;
    $XmlWriter = New-Object System.Xml.XmlTextWriter $StringWriter;
    $XmlWriter.Formatting = "indented";
    $xml.WriteTo($XmlWriter);
    $XmlWriter.Flush();
    $StringWriter.Flush();
    Write-Host $StringWriter.ToString();
}


##################################Settings Menu Start###############################################


[string]$global:blfDest = $null
[string]$global:blfLabel = $null
[string]$global:blfIndex = $null


#Pull user info from callmanager
#To test for specific users just replace the name with their account. Change it back to ensure generic usage.
Function Get-User{

    $getuserAxl = @"
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.cisco.com/AXL/API/11.5">
   <soapenv:Header/>
   <soapenv:Body>
      <ns:getUser sequence="?">
         <userid>$env:USERNAME</userid>
         <returnedTags uuid="?">
            <associatedDevices>
               <device>?</device>
            </associatedDevices>
         </returnedTags>
      </ns:getUser>
   </soapenv:Body>
</soapenv:Envelope>
"@

    $axluser = Invoke-WebRequest -UseBasicParsing -ContentType "text/xml;charset=UTF-8" -Headers $headers -Body $getuserAxl -Uri $uri -Method Post -Credential $cred
    [string]$GLOBAL:axluserPhone = ([xml]$axluser.Content).Envelope.Body.getUserResponse.return.user.associatedDevices.device | where {$_ -like 'SEP*'}
       
}

#Pull phone info based off previous user
#If the user has more than 1 phone associated with their account, this may show the wrong info
Function Get-Phone{

    $getphoneAxl= @"
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.cisco.com/AXL/API/11.5">
   <soapenv:Header/>
   <soapenv:Body>
      <ns:getPhone sequence="?">
         <name>$axluserPhone</name>
         <returnedTags ctiid="?" uuid="?">
            <busyLampFields>
               <busyLampField>
                  <blfDest>?</blfDest>
                  <blfDirn>?</blfDirn>
                  <routePartition>?</routePartition>
                  <label>?</label>
                  <associatedBlfSdFeatures>
                     <feature>?</feature>
                  </associatedBlfSdFeatures>
                  <index>?</index>
               </busyLampField>
            </busyLampFields>
         </returnedTags>
      </ns:getPhone>
   </soapenv:Body>
</soapenv:Envelope>
"@
    $axlphone = Invoke-WebRequest -UseBasicParsing -ContentType "text/xml;charset=UTF-8" -Headers $headers -Body $getphoneAxl -Uri $uri -Method Post -Credential $cred
    $GLOBAL:phoneBLF = ([xml]$axlphone.Content).Envelope.Body.getPhoneResponse.return.phone.busyLampFields
    $GLOBAL:phoneUuid = ([xml]$axlphone.Content).Envelope.Body.getPhoneResponse.return.phone.uuid
    $GLOBAL:uuid = $phoneUuid.ToString()
}

#####################################Load Current Layout############################################

Function Check-Radio{
    if($child.blfDirn){
        return "Internal"
    }
    if($child.blfDest){
        return "External"
    }
}


Function Load-CurrentLayout {
    (Get-Variable *e$indexnumber"disptex*" -ValueOnly).Text = $child.label
    Switch(Check-Radio){
        "Internal"{
            (Get-Variable *e$indexnumber"numbtex*" -ValueOnly).Text = $child.blfDirn.Substring($_.Length + 1 )
            (Get-Variable *e$indexnumber"intradi*" -ValueOnly).IsChecked="True"
        }
        "External"{
            (Get-Variable *e$indexnumber"numbtex*" -ValueOnly).Text = $child.blfDest
            (Get-Variable *e$indexnumber"extradi*" -ValueOnly).IsChecked="True"
        }
    }
}

#####################################Update New Layout##############################################

Function Check-RadioUpdate{
    if((Get-Variable *e$indexnumber"intrad*" -ValueOnly)){
        if((Get-Variable *e$indexnumber"intrad*" -ValueOnly).isChecked -eq "True"){
            if(((Get-Variable *e$indexnumber"disptex*" -ValueOnly).text -eq '') -or ((Get-Variable *e$indexnumber"numbtex*" -ValueOnly).text -eq '')){
                return "Skip"
            }
            else{
                return "Internal"
            }
        }
    }
    if((Get-Variable *e$indexnumber"extrad*" -ValueOnly)){
        if((Get-Variable *e$indexnumber"extrad*" -ValueOnly).isChecked -eq "True"){
            if(((Get-Variable *e$indexnumber"disptex*" -ValueOnly).text -eq '') -or ((Get-Variable *e$indexnumber"numbtex*" -ValueOnly).text -eq '')){
                return "Skip"
            }
            else{
                return "External"
            }
        }
    }
}

#Primary xml being updated to push to callmanager, comment added to busyLampFields because powershell sees empty nodes as strings.
[xml]$global:updatephoneAxl = @"
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.cisco.com/AXL/API/11.5">
    <soapenv:Header/>
    <soapenv:Body>
        <ns:updatePhone sequence="?">
            <uuid></uuid>
            <busyLampFields>
                <!--INSERTBELOW-->
            </busyLampFields>
        </ns:updatePhone>
    </soapenv:Body>
</soapenv:Envelope>
"@

#Formatted xml to append to primary xml, for internal calls (blfDirn). Have to add \+1000000 to the start otherwise the phone system doesn't know, it goes off DNs.
#Customize $blfDirn to however you have your DNs formatted. This takes the standard 4-digit extension with \+1000000 in front of it.
Function New-Internal{

    [string]$global:blfDirn = ("\+1000000" + (Get-Variable *e$indexnumber"numbtext" -ValueOnly).text)
    [string]$global:blfLabel = (Get-Variable *e$indexnumber"disptext" -ValueOnly).text
    [string]$global:blfIndex = $indexnumber

    [xml]$global:newblfDirn = @"
    <busyLampField>
        <blfDirn>$global:blfDirn</blfDirn>
        <routePartition>$global:routePartition</routePartition>
        <label>$global:blfLabel</label>
        <associatedBlfSdFeatures />
        <index>$global:blfIndex</index>
    </busyLampField>
"@
    $updatephoneAxl.Envelope.Body.updatePhone.busyLampFields.AppendChild($updatephoneAxl.ImportNode($newblfDirn.FirstChild,$true))
}

#Formatted xml to append to primary xml, for external calls (blfDest)
Function New-External{

    [string]$global:blfDest = (Get-Variable *e$indexnumber"numbtext" -ValueOnly).text
    [string]$global:blfLabel = (Get-Variable *e$indexnumber"disptext" -ValueOnly).text
    [string]$global:blfIndex = $indexnumber

    [xml]$global:newblfDest = @"       
    <busyLampField>
        <blfDest>$global:blfDest</blfDest>
        <routePartition />
        <label>$global:blfLabel</label>
        <associatedBlfSdFeatures />
        <index>$global:blfIndex</index>
    </busyLampField>
"@
    $updatephoneAxl.Envelope.Body.updatePhone.busyLampFields.AppendChild($updatephoneAxl.ImportNode($newblfDest.FirstChild,$true))
}



######Load the Settng Menu######
$Setting_Button.Add_Click({
    
    #XAML for the settings menu that pops up with the 2 buttons
    [xml]$Setting_Xaml = @"
<Controls:MetroWindow
    
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:Controls="clr-namespace:MahApps.Metro.Controls;assembly=MahApps.Metro"
        Title="Settings"
        Height="155" 
        Width="300"
        WindowStyle="ToolWindow"
        ResizeMode="NoResize"
        WindowStartupLocation = "Manual"
        Left = "1150"
        Top = "40"
        >

    <Window.Resources>
        <ResourceDictionary>
            <ResourceDictionary.MergedDictionaries>
                <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Controls.AnimatedSingleRowTabControl.xaml" />
                <!-- MahApps.Metro resource dictionaries. Make sure that all file names are Case Sensitive! -->
                <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Controls.xaml" />
                <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Fonts.xaml" />
                <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Colors.xaml" />
                <!-- Accent and AppTheme setting -->
                <!--â€œRedâ€, â€œGreenâ€, â€œBlueâ€, â€œPurpleâ€, â€œOrangeâ€, â€œLimeâ€, â€œEmeraldâ€, â€œTealâ€, â€œCyanâ€, â€œCobaltâ€, â€œIndigoâ€, â€œVioletâ€, â€œPinkâ€, â€œMagentaâ€, â€œCrimsonâ€, â€œAmberâ€, â€œYellowâ€, â€œBrownâ€, â€œOliveâ€, â€œSteelâ€, â€œMauveâ€, â€œTaupeâ€, â€œSiennaâ€ -->
                <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Accents/Blue.xaml" />
                <!-- â€œBaseLightâ€, â€œBaseDarkâ€ -->
                <ResourceDictionary Source="pack://application:,,,/MahApps.Metro;component/Styles/Accents/BaseDark.xaml" />
            </ResourceDictionary.MergedDictionaries>
        </ResourceDictionary>
    </Window.Resources>
    <!-- 271 Height-->
    <Grid HorizontalAlignment="Left" Height="497" VerticalAlignment="Top" Width="294" Background="#252525">
        <Button Name="Settings_LoadCurrent_Button" Content="Load Current Layout" HorizontalAlignment="Left" Margin="10,15,0,0" VerticalAlignment="Top" Width="279" FontSize="14"/>
        <Button Name="Settings_Update_Button" Content="Update New Layout" HorizontalAlignment="Left" Margin="10,65,0,0" VerticalAlignment="Top" Width="279" FontSize="14"/>
    </Grid>


</Controls:MetroWindow>    
    
"@

    #Read the form
    $Settings_Reader = (New-Object System.Xml.XmlNodeReader $Setting_Xaml) 
    $Settings_Form = [Windows.Markup.XamlReader]::Load($Settings_Reader) 
    
    #AutoFind all controls
    $Setting_Xaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]") | ForEach-Object { 
        New-Variable  -Name $_.Name -Value $Settings_Form.FindName($_.Name) -Force 
    }

        ##################################Settings Menu Buttons##################################################
        $Settings_LoadCurrent_Button.Add_Click({
            
            try {
                Get-User
                Get-Phone
                Foreach($child in $phoneBLF.ChildNodes){
                    $IndexNumber = $child.index
                    Load-CurrentLayout
                }
                Update_StatusBar -Message "Loaded Buttons For: $env:username"
                $Settings_Form.Close()

            }
            catch [System.Exception] {
                $ErrorActionPreference = "Continue"
                Update_StatusBar -Message "Unable To Find Phone Information: $env:Username"
            }

        })
        $Settings_Update_Button.Add_Click({
            
            try {
                foreach($indexnumber in 1..72) {
                    Switch(Check-RadioUpdate) {
                        "Skip"{
                            Update_StatusBar -Message "No Info Found For: $indexnumber. Skipping."
                        }
                        "Internal"{
                            New-Internal
                        }
                        "External"{
                            New-External
                        }

                    }
                }
                

                $updatephoneAxl.Envelope.Body.updatePhone.uuid = $uuid
                $axlupd = Invoke-WebRequest -UseBasicParsing -ContentType "text/xml;charset=UTF-8" -Headers $headers -Body $updatephoneAxl -Uri $uri -Method Post -Credential $cred
                Update_StatusBar -Message "Successfully Updated Buttons For Phone: $axluserPhone"
                #Uncomment the WriteXmlToScreen to show output of xml.
                #WriteXmlToScreen $updatephoneAxl
                $Settings_Form.Close()
                [xml]$global:updatephoneAxl = @"
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.cisco.com/AXL/API/11.5">
    <soapenv:Header/>
    <soapenv:Body>
        <ns:updatePhone sequence="?">
            <uuid></uuid>
            <busyLampFields>
                <!--INSERTBELOW-->
            </busyLampFields>
        </ns:updatePhone>
    </soapenv:Body>
</soapenv:Envelope>
"@

            }
            catch [System.Exception] {
                $ErrorActionPreference = "Continue"
                Write-Output "$($PSItem.ToString())"
                Update_StatusBar -Message "Error Updating Button Layout: $global:uuid, $env:username, $axluserPhone"
            }

        })

        ##################################Settings Menu Buttons End####################################################

    [void]$Settings_Form.ShowDialog()

})#end button

##################################Settings Menu End#################################################

#The bar at the bottom with info
Function Update_StatusBar {
    [CmdletBinding()]
    Param ([string]$Message)
    $Date_Time = Get-Date -Format G
    $StatusBar_Text.Text = "$Date_Time" + ": " + "$Message"
}

[void]$Main_Form.ShowDialog()
