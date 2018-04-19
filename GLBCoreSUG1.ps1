<#
-----------------------------------------------------------------------------------------------------------------------
SYNOPSIS:     This script is designed to read text file from destination specified and add the update(s) 
              to the corresponding Software Update group for WSUS reporting 
              All updates in the SUG.txt file are provided by Global  

Functions:    This script contains a number of funcitons where all parameters are mandatory  
Date Created  02/14/2018             
Author:       Albert K Council
ScriptName    GLBcoreUSA.PS1
Usage:        ./GLBCoreUSA.ps1 SUG-Update
-----------------------------------------------------------------------------------------------------------------------
#>
Set-ExecutionPolicy -Scope Process -ExecutionPolicy bypass
$Logfile = "C:\Temp\$(gc env:computername).log"
$LogCount =  Get-content -Path C:\temp\suig1.txt
$fileName = "C:\temp\suig.txt"
-ties 

function LogWrite
{
   Param ([string]$logstring)

   Add-content $Logfile -value $logstring
}


# function used to move the software updates into the target group 

function SUG-Update
{
    Param(
        [Parameter(Mandatory=$False)]
        [string]$fileName
    )
    CD USA:
    $updates = get-content 'C:\Temp\sug.txt'
        
        foreach ($update in $updates)
        {
            #$update = Get-CMSoftwareUpdate -name $update

            #Write-host $update " seen here!!!!"
            
            $update =  Get-CMSoftwareUpdate -name $update # -ea Silentlycontinue
                
               if ( !($update ) )
                {  
                
                    #Write details on updates from list not found or downloaded to the WSUS Software update repository '
                    Write-Host $update  ' Was not found in list'
                    #$update | Select-Object -ExpandProperty $update LocalizedDisplayName 

                    logwrite $update.PSChildName  
               } 
                    else 
               {  
                    
                    Write-Host $update 'Found and moving to software update group ' 
                    #Write details on updates from list found and downloaded to the WSUS Software update repository '
                    #$update | Select-Object -ExpandProperty $update LocalizedDisplayName 

    #get-cmsoftwareupdate -name  $update | Add-CMSoftwareUpdateToGroup  -softwareupdategroupid 16888984 
    $update | Add-CMSoftwareUpdateToGroup  -softwareupdategroupid 16888984 
                    
               }                              
        }
}



function LogPreviousDetails( )
{
Net USE '\\goamsapp232.kworld.kpmg.com\SUGexport'
    
    If ( Test-Path  '\\goamsapp232.kworld.kpmg.com\SUGexport' )
            {
                #Get and log share availability details
                Write-Host "Able to connect to file share and destination is available"
                
                #Get and log date information from SUG.txt file
                $FileDate = Get-ChildItem -Path \\goamsapp232.kworld.kpmg.com\SUGexport\sug.txt

                #Get and log file size details used to track changes in file  
                $fileDate.Length

                #Get And log the total number of updates from previous file and current if option
                $FileDate.count
                
                #Confirm details and call funciton to append to software update group reporting
                SUG-Update ('C:\Temp\SUIG1.txt')                                
             } 

    elseif (!( Test-Path '\\goamsapp232.kworld.kpmg.com\SUGexport\' ))
            {  
                Write-Host "Share not located and unable to read file details "
            
            }
    } 

LogPreviousDetails

