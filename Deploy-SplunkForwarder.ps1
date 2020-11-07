<#
.SYNOPSIS
  A script to manage Splunk Universal Forwarders
.DESCRIPTION
  This script is 
.PARAMETER <Parameter_Name>
  None
.INPUTS
  None
.OUTPUTS
  None
.NOTES
  Version:        2.0.2.beta
  Author:         Acidcrash376
  Creation Date:  10/06/2020
  Last Update:	  07/11/2020
  Purpose/Change: Initial script development
  Web:            https://github.com/acidcrash376/Deploy-SplunkForwarder
.EXAMPLE
  ./Deploy-SplunkForwarder.ps1
#>
<########################################################################################################### 
These are Core Menu functions of the script
###########################################################################################################>
$script:SplunkIndex = $null
$script:SplunkDeploymentServer = $null
#$script:DownloadServer = $null
$script:Computers = $null
$script:index = $null 
$script:SufFILEName = $null
$script:SysmonFILEName = $null
$script:sysmonconfFILEName = $null
$script:path = $null 
$creds = Get-Credential -Credential "$env:USERDOMAIN\$env:username"


Function FnStart-Script {
Param ()
Begin {
		Clear-Host
		Write-Host
		Write-Host "`t[ " -ForegroundColor Yellow -BackgroundColor Black -NoNewline; Write-Host "Splunk Universal Forwarder Deployment Tool" -ForegroundColor White -BackgroundColor Black -NoNewline; Write-Host " ]" -ForegroundColor Yellow -BackgroundColor Black
		Write-Host
		Write-Host "You MUST provide a list of IP or hostnames per line in computers.txt"
		Write-Host
    }
Process {
    Try {
        $check1 = Test-Path .\SplunkIndexip.txt
		$check2 = Test-Path .\SplunkDeploymentServerip.txt
        $check3 = Test-Path .\Index.txt 
        $check4 = Test-Path .\SufFILEName.txt
        $check5 = Test-Path .\SysmonFILEName.txt
        $check7 = Test-Path .\sysmonconfFILEName.txt
		$check6 = Test-Path .\computers.txt
		#$check3 = Test-Path .\DownloadServerip.txt 
		FnSplunkIndexFILE
		FnSplunkDeploymentServerFILE
		#FnDownloadServerFILE
		FnHostFILE
		FnIndexFILE
		FnSufFILE
        FnSysmonFILE
        FnSysmonConfFile
		Sleep 2
		FnMain-Options
        }
        Catch {
		Write-Host -BackgroundColor Red "Error: $($_.Exception)"
		Break
    }
  }
  End {
    If ($?) {
      Write-Host 'Start Script.'
      Write-Host ' '
    }
  }
}

Function FnMain-Options {
Param (
)
Begin {
}
Process {
		Try {
			#$script:SplunkIndex = Get-Content -Path ".\SplunkIndexip.txt"
			#$script:SplunkDeploymentServer = Get-Content -Path ".\SplunkDeploymentServerip.txt"
			#$script:DownloadServer = Get-Content -Path ".\DownloadServerip.txt"
			#$script:Computers = Get-Content -Path ".\computers.txt"
			#$script:index = Get-Content -Path ".\Index.txt"
			#$script:SufFILEName = Get-Content -Path ".\SufFILEName.txt"
            #$script:SysmonFILEName = Get-Content -Path ".\SysmonFILEName.txt"
			
			Clear-Host
			Write-Host
			Write-Host "`t[ " -ForegroundColor Yellow -BackgroundColor Black -NoNewline; Write-Host "Splunk Universal Forwarder Deployment Tool" -ForegroundColor White -BackgroundColor Black -NoNewline; Write-Host " ]" -ForegroundColor Yellow -BackgroundColor Black
			Write-Host
			Write-Host
			Write-Host "`tMain Menu" -ForegroundColor Yellow
			Write-Host "`t---------" -ForegroundColor Yellow
			Write-Host "`t1 Variables" -ForegroundColor Green # -NoNewline; Write-Host "`t`t`t[100% Complete]" -ForegroundColor Green -BackgroundColor Black
			Write-Host "`t2 Server Side Config" -ForegroundColor Green # -NoNewline; Write-Host "`t`t[100% Complete]" -ForegroundColor Green -BackgroundColor Black
			Write-Host "`t3 Client Config" -ForegroundColor Green # -NoNewline; Write-Host "`t`t`t[90% Complete]" -ForegroundColor Yellow -BackgroundColor Black
			Write-Host "`t4 Diagnostics"-ForegroundColor Green #-NoNewline; Write-Host "`t[60% Complete]" -ForegroundColor Yellow -BackgroundColor Black
			Write-Host
			Write-Host
			Write-Host "`tQ Exit Script" -ForegroundColor Green
			Write-Host
            Write-Host "`tH Help" -ForegroundColor Green
			Write-Host "`tC Credits" -ForegroundColor Green
            Write-Host "`tV Version" -ForegroundColor Green
			Write-Host 
			FnMain-Menu
            }
            Catch {
            Write-Host -BackgroundColor Red "Error: $($_.Exception)"
            FnPause-ForInput
            Break
            }
        }
        End {
            If ($?) {
                      Write-Host 'FnVariables-Options'
                      Write-Host ' '
                    }
        }
}

Function FnMain-Menu {
Param (
        [String]$userinput = $(Write-Host 'Select an Option: ' -foregroundcolor Yellow -NoNewLine; Read-Host)
)
Begin {
}
Process {
        Try {
            Switch ( $userinput )
                {
				Q { FnExitScript }
				1 { FnVariables-Options }
				2 { FnServerSide-Options }
				3 { FnClientConfig-Options }
				4 { FnDiagnostics-Options }
                H { FnHelp }
				C { FnCredits }
                V { FnVersion }
				
				}
				FnVariables-Menu
			}
			Catch {
            Write-Host -BackgroundColor Red "Error: $($_.Exception)"
            Break
            }
        }
		End {
            If ($?) {
                      Write-Host 'FnVariables-Menu'
                      Write-Host ' '
                    }
        }
}

Function FnVariables-Options {
Param (
)
Begin {
}
Process {
		Try {
			$SplunkIndex = Get-Content -Path ".\SplunkIndexip.txt"
			$SplunkDeploymentServer = Get-Content -Path ".\SplunkDeploymentServerip.txt"
			$Computers = Get-Content -Path ".\computers.txt"
			$index = Get-Content -Path ".\Index.txt"
			$FnSufFILEName = Get-Content -Path ".\SufFILEName.txt"
            $FnSysmonFILEName = Get-Content -Path ".\SysmonFILEName.txt"
            $FnSysmonConfFileName = Get-Content -Path ".\sysmonconfFILEName.txt"
			
			Clear-Host
			Write-Host
			Write-Host "`t[ " -ForegroundColor Yellow -BackgroundColor Black -NoNewline; Write-Host "Splunk Universal Forwarder Deployment Tool" -ForegroundColor White -BackgroundColor Black -NoNewline; Write-Host " ]" -ForegroundColor Yellow -BackgroundColor Black
			Write-Host
			Write-Host
			Write-Host "`tVariables" -ForegroundColor Yellow
			Write-Host "`t---------" -ForegroundColor Yellow
			Write-Host "`t1 Splunk Indexer:                               "$SplunkIndex -ForegroundColor Green
			Write-Host "`t2 Deployment Server:                            "$SplunkDeploymentServer -ForegroundColor Green
			Write-Host "`t3 Index Name:	                                "$Index -ForegroundColor Green
			Write-Host "`t4 The Splunk Universal Forwarder MSI file name: "$FnSufFILEName -ForegroundColor Green
			Write-Host "`t5 The Sysmon file name:                         "$FnSysmonFILEName -ForegroundColor Green
            Write-Host "`t6 The Sysmon Config file name:                  "$FnSysmonConfFileName -ForegroundColor Green
			Write-Host "`t7 List Hosts in computers.txt                   "  -ForegroundColor Green
			Write-Host
			Write-Host "`tM Back to Main menu"  -ForegroundColor Green
			Write-Host "`tQ Exit Script											" -ForegroundColor Green
			Write-Host
			#Write-Host "              The link is: http://${DownloadServer}/${FnSufFILEName}" -ForegroundColor yellow
			Write-Host 
			FnVariables-Menu
            }
            Catch {
            Write-Host -BackgroundColor Red "Error: $($_.Exception)"
            FnPause-ForInput
            Break
            }
        }
        End {
            If ($?) {
                      Write-Host 'FnVariables-Options'
                      Write-Host ' '
                    }
        }
}

Function FnVariables-Menu {
Param (
        [String]$userinput = $(Write-Host 'Select an Option: ' -foregroundcolor Yellow -NoNewLine; Read-Host)
)
Begin {
}
Process {
        Try {
            Switch ( $userinput )
                {
				1 { FnSplunkIndex }
				2 { FnDeploymentServer }
				3 { FnIndexName }
				#4 { FnDownloadServer }
				4 { FnSufFILEname }
                5 { FnSysmonFILEName }
                6 { FnSysmonConfFileName }
                7 { FnListComputers }
				Q { FnExitScript }
				M { FnMain-Options }
				}
				FnVariables-Menu
			}
			Catch {
            Write-Host -BackgroundColor Red "Error: $($_.Exception)"
            Break
            }
        }
		End {
            If ($?) {
                      Write-Host 'FnVariables-Menu'
                      Write-Host ' '
                    }
        }
}

Function FnServerSide-Options {
Param (
)
Begin {
}
Process {
		Try {
			$SplunkIndex = Get-Content -Path ".\SplunkIndexip.txt"
			$SplunkDeploymentServer = Get-Content -Path ".\SplunkDeploymentServerip.txt"
			#$DownloadServer = Get-Content -Path ".\DownloadServerip.txt"
			$Computers = Get-Content -Path ".\computers.txt"
			$index = Get-Content -Path ".\Index.txt"
			$FnSufFILEName = Get-Content -Path ".\SufFILEName.txt"
			
			Clear-Host
			Write-Host
			Write-Host "`t[ " -ForegroundColor Yellow -BackgroundColor Black -NoNewline; Write-Host "Splunk Universal Forwarder Deployment Tool" -ForegroundColor White -BackgroundColor Black -NoNewline; Write-Host " ]" -ForegroundColor Yellow -BackgroundColor Black
			Write-Host
			Write-Host
			Write-Host "`tServer Side Config" -ForegroundColor Yellow
			Write-Host "`t------------------" -ForegroundColor Yellow
			Write-Host "`t1 Start SMB      							" -ForegroundColor Green
			Write-Host "`t2 Stop SMB Share                          " -ForegroundColor Green
			Write-Host "`t3 Check Splunk Universal Forwarder path   " -ForegroundColor Green
			#Write-Host "`t4 Universal Forwarder Config:	            " -ForegroundColor Green -NoNewline; Write-Host "`t[Not Implemented Yet]" -ForegroundColor Red -BackgroundColor Black
			Write-Host
			Write-Host "`tM Back to Main menu"  -ForegroundColor Green
			Write-Host "`tQ Exit Script											" -ForegroundColor Green
			Write-Host 
			FnServerSide-Menu
            }
            Catch {
            Write-Host -BackgroundColor Red "Error: $($_.Exception)"
            FnPause-ForInput
            Break
            }
        }
        End {
            If ($?) {
                      Write-Host 'FnVariables-Options'
                      Write-Host ' '
                    }
        }
}

Function FnServerSide-Menu {
Param (
        [String]$userinput = $(Write-Host 'Select an Option: ' -foregroundcolor Yellow -NoNewLine; Read-Host)
)
Begin {
}
Process {
        Try {
            Switch ( $userinput )
                {
				1 { FnStartSMBShare }
				2 { FnStopSMBShare }
				3 { FnCheckSUFPath }
				#4 { FnSUFConfig-Options }
				Q { FnExitScript }
				M { FnMain-Options }
				}
				FnServerSide-Menu
			}
			Catch {
            Write-Host -BackgroundColor Red "Error: $($_.Exception)"
            Break
            }
        }
		End {
            If ($?) {
                      Write-Host 'FnVariables-Menu'
                      Write-Host ' '
                    }
        }
}

Function FnClientConfig-Options {
Param (
)
Begin {
}
Process {
		Try {
			$SplunkIndex = Get-Content -Path ".\SplunkIndexip.txt"
			$SplunkDeploymentServer = Get-Content -Path ".\SplunkDeploymentServerip.txt"
			#$DownloadServer = Get-Content -Path ".\DownloadServerip.txt"
			$Computers = Get-Content -Path ".\computers.txt"
			$index = Get-Content -Path ".\Index.txt"
			$FnSufFILEName = Get-Content -Path ".\SufFILEName.txt"
            $FnSysmonFILEName = Get-Content -Path ".\SysmonFILEName.txt"   

			Clear-Host
			Write-Host
			Write-Host "`t[ " -ForegroundColor Yellow -BackgroundColor Black -NoNewline; Write-Host "Splunk Universal Forwarder Deployment Tool" -ForegroundColor White -BackgroundColor Black -NoNewline; Write-Host " ]" -ForegroundColor Yellow -BackgroundColor Black
			Write-Host
			Write-Host
			Write-Host "`tClient Config" -ForegroundColor Yellow
			Write-Host "`t-------------" -ForegroundColor Yellow
			Write-Host "`t1 Download installation Files via SMB  " -ForegroundColor Green
			Write-Host "`t2 Install Universal Forwarder          " -ForegroundColor Green 
			Write-Host "`t3 Uninstall Universal Forwarder        " -ForegroundColor Green
            Write-Host "`t4 Install Sysmon                       " -ForegroundColor Green
            Write-Host "`t5 Enable Sysmon in Slunk Forwarder     " -ForegroundColor Green
            Write-Host "`t6 Remove Sysmon                        " -ForegroundColor Green
			Write-Host "`t7 Restart Endpoints	                 " -ForegroundColor Green
			Write-Host "`t8 Remove installation Files            " -ForegroundColor Green
			#Write-Host "`t8 List Hosts	                         " -ForegroundColor Green		
			#Write-Host "`t9 Ping Hosts                           " -ForegroundColor Green
			#Write-Host "`t0 Test WinRM connection to hosts	     " -ForegroundColor Green
			Write-Host
			Write-Host "`tM Back to Main menu"  -ForegroundColor Green
			Write-Host "`tQ Exit Script											" -ForegroundColor Green
			Write-Host 
			FnClientConfig-Menu
            }
            Catch {
            Write-Host -BackgroundColor Red "Error: $($_.Exception)"
            FnPause-ForInput
            Break
            }
        }
        End {
            If ($?) {
                      Write-Host 'FnVariables-Options'
                      Write-Host ' '
                    }
        }
}

Function FnClientConfig-Menu {
Param (
        [String]$userinput = $(Write-Host 'Select an Option: ' -foregroundcolor Yellow -NoNewLine; Read-Host)
)
Begin {
}
Process {
        Try {
            Switch ( $userinput )
                {
				1 { FnDownloadFilesSMB }
                2 { FnInstallHIDS }
				3 { FnUninstallHIDS }
				4 { FnInstallSysmon }
                5 { FnEnableSysmon }
				6 { FnUninstallSysmon }
				7 { FnRestartEndpoints }
				8 { FnRemoveFiles }
                
				#8 { FnListHosts }
				#9 { FnTestComputers }
				#0 { FnTestWinRMComputers }
				Q { FnExitScript }
				M { FnMain-Options }
				}
				FnVariables-Menu
			}
			Catch {
            Write-Host -BackgroundColor Red "Error: $($_.Exception)"
            Break
            }
        }
		End {
            If ($?) {
                      Write-Host 'FnVariables-Menu'
                      Write-Host ' '
                    }
        }
}

Function FnDiagnostics-Options {
Param (
)
Begin {
}
Process {
		Try {
			$SplunkIndex = Get-Content -Path ".\SplunkIndexip.txt"
			$SplunkDeploymentServer = Get-Content -Path ".\SplunkDeploymentServerip.txt"
			#$DownloadServer = Get-Content -Path ".\DownloadServerip.txt"
			$Computers = Get-Content -Path ".\computers.txt"
			$index = Get-Content -Path ".\Index.txt"
			$FnSufFILEName = Get-Content -Path ".\SufFILEName.txt"
			
			Clear-Host
			Write-Host
			Write-Host "`t[ " -ForegroundColor Yellow -BackgroundColor Black -NoNewline; Write-Host "Splunk Universal Forwarder Deployment Tool" -ForegroundColor White -BackgroundColor Black -NoNewline; Write-Host " ]" -ForegroundColor Yellow -BackgroundColor Black
			Write-Host
			Write-Host
			Write-Host "`tDiagnostics Menu" -ForegroundColor Yellow
			Write-Host "`t----------------" -ForegroundColor Yellow
			Write-Host "`t1 List Hosts     							" -ForegroundColor Green
			Write-Host "`t2 Ping Hosts                              " -ForegroundColor Green
			Write-Host "`t3 Test WinRM connection                   " -ForegroundColor Green
			Write-Host "`t4 Check Services            	            " -ForegroundColor Green #-NoNewline; Write-Host "`t[Not Implemented Yet]" -ForegroundColor Red -BackgroundColor Black
			Write-Host "`t5 Restart Services                        " -ForegroundColor Green #-NoNewline; Write-Host "`t[Not Implemented Yet]" -ForegroundColor Red -BackgroundColor Black
            Write-Host "`t6 Start Services                          " -ForegroundColor Green #-NoNewline; Write-Host "`t[Not Implemented Yet" -ForegroundColor Red -BackgroundColor Black
            Write-Host
			Write-Host "`tM Back to Main menu"  -ForegroundColor Green
			Write-Host "`tQ Exit Script											" -ForegroundColor Green
			Write-Host 
			FnDiagnostics-Menu
            }
            Catch {
            Write-Host -BackgroundColor Red "Error: $($_.Exception)"
            FnPause-ForInput
            Break
            }
        }
        End {
            If ($?) {
                      Write-Host 'FnVariables-Options'
                      Write-Host ' '
                    }
        }
}

Function FnDiagnostics-Menu {
Param (
        [String]$userinput = $(Write-Host 'Select an Option: ' -foregroundcolor Yellow -NoNewLine; Read-Host)
)
Begin {
}
Process {
        Try {
            Switch ( $userinput )
                {
				1 { FnListHosts }
				2 { FnTestComputers }
				3 { FnTestWinRMComputers }
				4 { FnCheckServices }
                5 { FnRestartServices }
                6 { FnStartServices }
				Q { FnExitScript }
				M { FnMain-Options }
				}
				FnServerSide-Menu
			}
			Catch {
            Write-Host -BackgroundColor Red "Error: $($_.Exception)"
            Break
            }
        }
		End {
            If ($?) {
                      Write-Host 'FnVariables-Menu'
                      Write-Host ' '
                    }
        }
}

Function FnSUFConfig-Options {
Param (
)
Begin {
}
Process {
		Try {
			$SplunkIndex = Get-Content -Path ".\SplunkIndexip.txt"
			$SplunkDeploymentServer = Get-Content -Path ".\SplunkDeploymentServerip.txt"
			#$DownloadServer = Get-Content -Path ".\DownloadServerip.txt"
			$Computers = Get-Content -Path ".\computers.txt"
			$index = Get-Content -Path ".\Index.txt"
			$FnSufFILEName = Get-Content -Path ".\SufFILEName.txt"
			
			Clear-Host
			Write-Host
			Write-Host "`t[ " -ForegroundColor Yellow -BackgroundColor Black -NoNewline; Write-Host "Splunk Universal Forwarder Deployment Tool" -ForegroundColor White -BackgroundColor Black -NoNewline; Write-Host " ]" -ForegroundColor Yellow -BackgroundColor Black
			Write-Host
			Write-Host
			Write-Host "`tUniversal Forwarder Config" -ForegroundColor Yellow
			Write-Host "`t--------------------------" -ForegroundColor Yellow
			Write-Host "`t1 Variables:                               " -ForegroundColor Green
			Write-Host "`t2 Client Config:                            " -ForegroundColor Green
			Write-Host "`t3 Universal Forwarder Config:	                                "-ForegroundColor Green
			Write-Host
			Write-Host "`tM Back to Main menu"  -ForegroundColor Green
			Write-Host "`tQ Exit Script											" -ForegroundColor Green
			Write-Host 
			FnClientConfig-Menu
            }
            Catch {
            Write-Host -BackgroundColor Red "Error: $($_.Exception)"
            Break
            }
        }
        End {
            If ($?) {
                      Write-Host 'FnVariables-Options'
                      Write-Host ' '
                    }
        }
}

Function FnSUFConfig-Menu {
Param (
        [String]$userinput = $(Write-Host 'Select an Option: ' -foregroundcolor Yellow -NoNewLine; Read-Host)
)
Begin {
}
Process {
        Try {
            Switch ( $userinput )
                {
				1 { FnVariables-Options }
				2 { FnClientConfig-Options }
				3 { FnSUFConfig-Options }
				Q { FnExitScript }
				M { FnMain-Options }
				}
				FnVariables-Menu
			}
			Catch {
            Write-Host -BackgroundColor Red "Error: $($_.Exception)"
            Break
            }
        }
		End {
            If ($?) {
                      Write-Host 'FnVariables-Menu'
                      Write-Host ' '
                    }
        }
}

Function FnPause-ForInput {
Param (
        
)
Begin {
}
Process {
        Try {
            [String]$pauseforinput = $(Write-Host 'Press '-NoNewLine; Write-Host '[ENTER]' -ForegroundColor Yellow -NoNewline; Write-Host ' to continue...'; Read-Host)
            }
            Catch {
            Write-Host -BackgroundColor Red "Error: $($_.Exception)"
            FnPause-ForInput
            }
        }
        End {
            If ($?) {
                      #Write-Host 'Password sucessfully changed for user'$user -ForegroundColor Green
                      Write-Host ' '
                    }
        }
}

Function FnExitScript {
Param (

)
Begin {
}
Process {
        Try {
            exit
            }
            Catch {
            Write-Host -BackgroundColor Red "Error: $($_.Exception)"
            Break
            }
        }
        End {
            If ($?) {
                      Write-Host 'Exit Script'
                      Write-Host ' '
                    }
        }
}

<########################################################################################################### 
These are initial check functions of the script
###########################################################################################################>

Function FnSplunkIndexFILE {

    If ($check1 -eq $true) {
        Write-Host "`tThe SplunkIndexip.txt file found!!" -ForegroundColor Green
        sleep 0
        }  Else {
        Write-Host "`tNo SplunkIndexip.txt file here...creating one." -ForegroundColor Yellow
        New-Item -Path . -Name SplunkIndexip.txt -Type "file"  | Out-Null
        sleep 1
        } 
}

Function FnSplunkDeploymentServerFILE {

    If ($check2 -eq $true) {
        Write-Host "`tThe SplunkDeploymentServerip.txt file found!!" -ForegroundColor Green
        sleep 0
        }  Else {
        Write-Host "`tNo SplunkDeplymentServerip.txt file here...creating one." -ForegroundColor Yellow
        New-Item -Path . -Name SplunkDeploymentServerip.txt -Type "file" | Out-Null
        sleep 0
        } 
}

<#
Function FnDownloadServerFILE {

    If ($check3 -eq $true) {
        Write-Host "`tThe DownloadServerip.txt file found!!" -ForegroundColor Green
        sleep 0
        }  Else {
        Write-Host "`tNo DownloadServerip.txt file here...creating one." -ForegroundColor Yellow
        New-Item -Path . -Name DownloadServerip.txt -Type "file"  | Out-Null
        sleep 0
        } 
}
#>

Function FnIndexFILE {

    If ($check3 -eq $true) {
        Write-Host "`tThe Index.txt found!!" -ForegroundColor Green
        
        
        sleep 0
        }  Else {
        Write-Host "`tNo index.txt file here...creating one." -ForegroundColor Yellow
        New-Item -Path . -Name Index.txt -Type "file" | Out-Null
        
        sleep 2
        } 
}

Function FnSufFILE {

    If ($check4 -eq $true) {
        Write-Host "`tThe SufFILEName.txt found!!" -ForegroundColor Green
        
        
        sleep 0
        }  Else {
        Write-Host "`tNo SufFILEName.txt file here...creating one." -ForegroundColor Yellow
        New-Item -Path . -Name SufFILEName.txt -Type "file" | Out-Null
        
        sleep 2
        } 
}

Function FnSysmonFILE {

    If ($check5 -eq $true) {
        Write-Host "`tThe SysmonFILEName.txt found!!" -ForegroundColor Green
        
        
        sleep 0
        }  Else {
        Write-Host "`tNo SysmonFILEName.txt file here...creating one." -ForegroundColor Yellow
        New-Item -Path . -Name SysmonFILEName.txt -Type "file" | Out-Null
        
        sleep 2
        } 
}

Function FnSysmonConfFile {

    If ($check7 -eq $true) {
        Write-Host "`tThe SysmonConfFileName.txt found!!" -ForegroundColor Green
        
        
        sleep 0
        }  Else {
        Write-Host "`tNo SysmonConfFILEName.txt file here...creating one." -ForegroundColor Yellow
        New-Item -Path . -Name SysmonConfFILEName.txt -Type "file" | Out-Null
        
        sleep 2
        } 
}

Function FnHostFILE {

    If ($check6 -eq $true) {
        Write-Host "`tThe computers.txt file found!!" -ForegroundColor Green
       
        sleep 0
        }  Else {
        Write-Host "`tYou need a computers.txt file in this directory, you need to make one!!" -ForegroundColor Red
        } 
}

Function FnGetComputers {
    $Global:Computers = Get-Content ".\computers.txt"
}
<########################################################################################################### 
These functions are for the framework of the script
###########################################################################################################>

### Variables Menu ###
Function FnSplunkIndex {
Param ()
Begin{}
Process {
		Try {
			$Path = "SplunkIndexip.txt"
			$Check = Test-Path $Path
			
			If ($Check -eq $true) {
			#Write-Host "SplunkIndexip.txt exists"
			$R = Read-Host "What is the IP address of the Splunk Indexer? (W.X.Y.Z:9997)"
			Echo $R | Out-File $Path -Encoding ASCII
			$Content = Get-Content $Path
			Write-Host
			Write-Host "The Splunk Indexer is not set to"$Content
			FnVariables-Options}
			
			Else {
			Write-Host "SplunkIndexip.txt missing, creating...."
			New-Item -Path . -Name $Path -Type "File" 
			$R = Read-Host "What is the IP address of the Splunk Indexer? (W.X.Y.Z:9997)"
			Echo $R | Out-File $Path -Encoding ASCII
			$Content = Get-Content $Path
			Write-Host
			Write-Host "The Splunk Indexer is now set to"$Content
			FnVariables-Options

			}
		}
		Catch   {
		Write-Host -BackgroundColor Red "Error: $($_.Exception)"
		}
		End {
		If ($?) {
                      Write-Host 'Function not yet implemented'
                      Write-Host ' '
                      Pause-ForInput
                      Start-Options
                    }
		}
	}
}	

Function FnDeploymentServer {
Param ()
Begin{}
Process {
		Try {
			$Path = "SplunkDeploymentServerip.txt"
			$Check = Test-Path $Path
			
			If ($Check -eq $true) {
			$R = Read-Host "What is the IP address of the Splunk Deployment Server? (W.X.Y.Z:8089)"
			Echo $R | Out-File $Path -Encoding ASCII
			$Content = Get-Content $Path
			Write-Host
			Write-Host "The Splunk Deployment Server is now set to"$Content
			FnVariables-Options}
			
			Else {
			Write-Host "SplunkDeploymentServerip.txt missing, creating...."
			New-Item -Path . -Name $Path -Type "File" 
			$R = Read-Host "What is the IP address of the Splunk Deployment Server? (W.X.Y.Z:8089)"
			Echo $R | Out-File $Path -Encoding ASCII
			$Content = Get-Content $Path
			Write-Host
			Write-Host "The Splunk Deployment Server is now set to"$Content
			FnVariables-Options

			}
		}
		Catch   {
		Write-Host -BackgroundColor Red "Error: $($_.Exception)"
		}
		End {
		If ($?) {
                      Write-Host 'Function not yet implemented'
                      Write-Host ' '
                      Pause-ForInput
                      Start-Options
                    }
		}
	}
}

Function FnIndexName {
Param ()
Begin{}
Process {
		Try {
			$Path = "Index.txt"
			$Check = Test-Path $Path
			
			If ($Check -eq $true) {
			$R = Read-Host "What is the Index name? (This must already have been created on the server first)"
			Echo $R | Out-File $Path -Encoding ASCII
			$Content = Get-Content $Path
			Write-Host
			Write-Host "The Index is now set to"$Content
			FnVariables-Options}
			
			Else {
			Write-Host "Index.txt missing, creating...."
			New-Item -Path . -Name $Path -Type "File" 
			$R = Read-Host "What is the Index name? (This must already have been created on the server first)"
			Echo $R | Out-File $Path -Encoding ASCII
			$Content = Get-Content $Path
			Write-Host
			Write-Host "The Index is now set to"$Content
			FnVariables-Options

			}
		}
		Catch   {
		Write-Host -BackgroundColor Red "Error: $($_.Exception)"
		}
		End {
		If ($?) {
                      Write-Host 'Function not yet implemented'
                      Write-Host ' '
                      Pause-ForInput
                      Start-Options
                    }
		}
	}
}

<# Function FnDownloadServer {
Param ()
Begin{}
Process {
		Try {
			$Path = "DownloadServerip.txt"
			$Check = Test-Path $Path
			
			If ($Check -eq $true) {
			$R = Read-Host "What is the IP/Hostname/Domain Name of the server hosting the Universal Forwarder? (W.X.Y.Z:1234)"
			Echo $R | Out-File $Path -Encoding ASCII
			$Content = Get-Content $Path
			Write-Host
			Write-Host "The Download Server is now set to..."$Content
			FnVariables-Options}
			
			Else {
			Write-Host "DownloadServerip.txt missing, creating...."
			New-Item -Path . -Name $Path -Type "File" 
			$R = Read-Host "What is the IP/Hostname/Domain Name of the server hosting the Universal Forwarder? (W.X.Y.Z:1234)"
			Echo $R | Out-File $Path -Encoding ASCII
			$Content = Get-Content $Path
			Write-Host
			Write-Host "The Download Server is now set to..."$Content
			FnVariables-Options

			}
		}
		Catch   {
		Write-Host -BackgroundColor Red "Error: $($_.Exception)"
		}
		End {
		If ($?) {
                      Write-Host 'Function not yet implemented'
                      Write-Host ' '
                      Pause-ForInput
                      Start-Options
                    }
		}
	}
} #>

Function FnSufFILEName {
Param ()
Begin{}
Process {
		Try {
			$Path = "SufFILEName.txt"
			$Check = Test-Path $Path
			
			If ($Check -eq $true) {
			$R = Read-Host "What is the filename of your Universal Forwarder installation MSI?"
			Echo $R | Out-File $Path -Encoding ASCII
			$Content = Get-Content $Path
			Write-Host
			Write-Host "The Installation file is now set to..."$Content
			FnVariables-Options}
			
			Else {
			Write-Host "SufFILEName.txt missing, creating...."
			New-Item -Path . -Name $Path -Type "File" 
			$R = Read-Host "What is the filename of your Universal Forwarder installation MSI?)"
			Echo $R | Out-File $Path -Encoding ASCII
			$Content = Get-Content $Path
			Write-Host
			Write-Host "The Installation file is now set to..."$Content
			FnVariables-Options

			}
		}
		Catch   {
		Write-Host -BackgroundColor Red "Error: $($_.Exception)"
		}
		End {
		If ($?) {
                      Write-Host 'Function not yet implemented'
                      Write-Host ' '
                      Pause-ForInput
                      Start-Options
                    }
		}
	}
}

Function FnSysmonFILEName {
Param ()
Begin{}
Process {
		Try {
			$Path = "SysmonFILEName.txt"
			$Check = Test-Path $Path
			
			If ($Check -eq $true) {
			$R = Read-Host "What is the filename of your Sysmon executable?"
			Echo $R | Out-File $Path -Encoding ASCII
			$Content = Get-Content $Path
			Write-Host
			Write-Host "The Installation file is now set to..."$Content
			FnVariables-Options}
			
			Else {
			Write-Host "SysmonFILEName.txt missing, creating...."
			New-Item -Path . -Name $Path -Type "File" 
			$R = Read-Host "What is the filename of your Sysmon executable?)"
			Echo $R | Out-File $Path -Encoding ASCII
			$Content = Get-Content $Path
			Write-Host
			Write-Host "The Installation file is now set to..."$Content
			FnVariables-Options

			}
		}
		Catch   {
		Write-Host -BackgroundColor Red "Error: $($_.Exception)"
		}
		End {
		If ($?) {
                      Write-Host 'Function not yet implemented'
                      Write-Host ' '
                      Pause-ForInput
                      Start-Options
                    }
		}
	}
}

Function FnSysmonConfFILEName {
Param ()
Begin{}
Process {
		Try {
			$Path = "SysmonConfFILEName.txt"
			$Check = Test-Path $Path
			
			If ($Check -eq $true) {
			$R = Read-Host "What is the filename of your Sysmon Configuration XML?"
			Echo $R | Out-File $Path -Encoding ASCII
			$Content = Get-Content $Path
			Write-Host
			Write-Host "The Configuration file is now set to..."$Content
			FnVariables-Options}
			
			Else {
			Write-Host "SysmonconfFILEName.txt missing, creating...."
			New-Item -Path . -Name $Path -Type "File" 
			$R = Read-Host "What is the filename of your SysmonConfiguration XML?)"
			Echo $R | Out-File $Path -Encoding ASCII
			$Content = Get-Content $Path
			Write-Host
			Write-Host "The Configuration file is now set to..."$Content
			FnVariables-Options

			}
		}
		Catch   {
		Write-Host -BackgroundColor Red "Error: $($_.Exception)"
		}
		End {
		If ($?) {
                      Write-Host 'Function not yet implemented'
                      Write-Host ' '
                      Pause-ForInput
                      Start-Options
                    }
		}
	}
}

Function FnListComputers {
Param ()
Begin{}
Process {
		Try {
			$Path = "computers.txt"
			$Check = Test-Path $Path
			
			If ($Check -eq $true) {
			Get-Content $Path
			FnPause-ForInput
			FnVariables-Options}
			
			Else {
			Write-Host "computers.txt missing, creating...."
			New-Item -Path . -Name $Path -Type "File" 
			Get-Content $Path
			FnPause-ForInput
			FnVariables-Options

			}
		}
		Catch   {
		Write-Host -BackgroundColor Red "Error: $($_.Exception)"
		}
		End {
		If ($?) {
                      Write-Host 'Function not yet implemented'
                      Write-Host ' '
                      FnPause-ForInput
                      Start-Options
                    }
		}
	}
}

Function FnSMBServer { 
Write-Host "Not yet implemented"
Sleep 1
FnClientConfig-Options
}

Function FnCredits {
Clear-Host
Write-Host
			Write-Host "`t[ " -ForegroundColor Yellow -BackgroundColor Black -NoNewline; Write-Host "Splunk Universal Forwarder Deployment Tool" -ForegroundColor White -BackgroundColor Black -NoNewline; Write-Host " ]" -ForegroundColor Yellow -BackgroundColor Black
			Write-Host
			Write-Host
Write-Host "`t" -NoNewLine; Write-Host "`t`t`t[ " -ForegroundColor Yellow -BackgroundColor Black -NoNewline; Write-Host "Credits" -ForegroundColor White -BackgroundColor Black -NoNewline; Write-Host " ]" -ForegroundColor Yellow -BackgroundColor Black
Write-Host "
                                                                                `
                                                                                
                @%@                                                             
                 &/.,@                                                          
                   @...&@                                                       
                    @.....@@                 ,@.                                
                     &%......@. @&#####&@( @    @,                              
                       @....../&#########@#      @///%@@                        
                        @%....@########%@        @////////@                     
                          @.@#########@        (@//////////(@                   
                     @#############&@       @@  @////////////&                  
                       @@%####%@@*                @//////////@.@%               
                      @&                           #&////////@...@              
                    @/                              @////////@....@             
                  @                 @&@             @///////@.....,#            
                @@          @  @@@   (              @//////@.......@            
             @#,,,@.                              .@/////@.........&@           
           *@,,,,,,*@                         (@@////@@...........@,,@          
           @,,,,,,,,.@                               @...........@,,,@          
           @,,(@,,,,,@                       @      @..........@@,,,,@          
            @,,,,,,,,,@                      @..@@%..........@,,,,,,,@          
              @%,,,,,%@@@#   *@@@@& @          @@/..../@@@*,,,,,,,,(@           
                                    @            @,,,,,,,,,,,,,,@@//#/          
                                   .@          *@,,,,/@@@@@#////////@           
                                   @           (&,,,@//////////////@            
                                   @             @,,,@@//@/      @              
                                  #*                 @@@//@@     @              
                                  @                     @@@@@@  @               
                                  @                          @@                 
                                 *%                      .@.                    
                                 ,&                  .@#                        
                                  @.             @@                             
                                    .@@&/(&@@@                                  
                                                                                
              `                                                                  
              - Pete de Main for the initial concept.                           
              - Calum McEwan for suggesting a more efficient way of             
                installing the forwarder.                                       
              - Google, GitHub, 4sysops and Microsoft Documentation for         
                helping me figure out cool stuff.                               
                                                                                " -BackgroundColor Black -ForegroundColor White
Write-Host
FnPause-ForInput
FnMain-Options
}

Function FnHelp {
Clear-Host
			Write-Host
			Write-Host "`t[ " -ForegroundColor Yellow -BackgroundColor Black -NoNewline; Write-Host "Splunk Universal Forwarder Deployment Tool" -ForegroundColor White -BackgroundColor Black -NoNewline; Write-Host " ]" -ForegroundColor Yellow -BackgroundColor Black
			Write-Host
			Write-Host
			Write-Host "`tHelp" -ForegroundColor Yellow
			Write-Host "`t----" -ForegroundColor Yellow
            Write-Host "
        To use the script, it has a menu system. 
        M Takes you back to the previous menu.
        Q Quits the script.
        Options 1-9 are options.

        First you must define the Variables for server IP's, Index names and filenames.
        Second you must create the SMB share from the Server Side menu.
        Third in the Client Config menu, 
            [1] Pre-stage the files. 
            [2] Install the Splunk Forwarder
            [4] Install Sysmon
            [7] Clear any staging artifacts

        There are various diagnostic options within each section. There is also
        the option to Uninstall the Splunk Forwarder and Sysmon should you 
        require it.
    "


FnPause-ForInput
FnMain-Options
}

Function FnVersion {
Clear-Host
			Write-Host
			Write-Host "`t[ " -ForegroundColor Yellow -BackgroundColor Black -NoNewline; Write-Host "Splunk Universal Forwarder Deployment Tool" -ForegroundColor White -BackgroundColor Black -NoNewline; Write-Host " ]" -ForegroundColor Yellow -BackgroundColor Black
			Write-Host
			Write-Host
			Write-Host "`tVersion" -ForegroundColor Yellow
			Write-Host "`t-------" -ForegroundColor Yellow
            Write-Host 
            Write-Host "`tVersion:        2.0.2.Beta"
            Write-Host "`tLast Update:    07/11/2020"
            Write-Host "`tAuthor:         Kevin Brooks"
            Write-Host "`tURL:            https://github.com/acidcrash376/Deploy-SplunkForwarder"
            Write-Host
            FnPause-ForInput
            FnMain-Options
}

### Server Menu ###
Function FnStartSMBShare {
Param ()
Begin{
	$SMBShareTest = Test-Path \\localhost\Splunk
	$domainName = $env:USERDOMAIN
	$user = $env:USERNAME
	$fulluser = $domainName + "\" + $user
	[String]$DomAdmin = "Domain Admins"
	$SMBPath = Get-Location
	Write-Host
}
Process {
	Try {
		If ($SMBShareTest) {
			Write-Host "SMB Share called 'Splunk' already exists"
		}
		Else {
			Write-Host "No SMB Share called 'Splunk' exists...creating"
			New-SMBShare -Name 'Splunk' -Path $SMBPath -FullAccess $DomAdmin | out-null
			#Test-Path \\localhost\Splunk
		}
	}
	Catch {
		Write-Host -BackgroundColor Red "Error: $($_.Exception)"
		}
	Write-Host
	FnPause-ForInput
	FnServerSide-Options
	}	
}

Function FnStopSMBShare {  
Param ()
Begin{
	$SMBShareTest = Test-Path \\localhost\Splunk
	$domainName = $env:USERDOMAIN
	$user = $env:USERNAME
	$fulluser = $domainName + "\" + $user
	$DomAdmin = "Domain Admins"
	Write-Host
}
Process {
	Try {
		If ($SMBShareTest) {
			Remove-SMBShare -Name 'Splunk' -Force:$true
			Write-Host "SMB Share called 'Splunk' has been removed"
		}
		Else {
			Write-Host "No SMB Share called 'Splunk' exists"
		}
	}
	Catch {
		Write-Host -BackgroundColor Red "Error: $($_.Exception)"
		}
	Write-Host
	FnPause-ForInput
	FnServerSide-Options
	}	
}

Function FnCheckSUFPath {
Param ()
Begin{
	$Path = "SufFILEName.txt"
	$SufMSI = Get-Content -Path $Path
	$UNCPath = "\\$env:computername\Splunk\$sufmsi"
	$Check = Test-Path $uncpath
}
Process {
	Try {
		If ($check) {
			Write-Host "The UNC path is: $UNCPath"
			Write-Host "Path works!" -ForegroundColor Green
		}
		Else {
			Write-Host "Please check the Share and installer MSI exist in the specified location" -ForegroundColor Yellow
		}
	}
	Catch {
		Write-Host -BackgroundColor Red "`a Error: $($_.Exception)"
		}
	Write-Host
	FnPause-ForInput
	FnServerSide-Options
	}	
}

### Client Menu ###
Function FnInstallHIDS {
    Param ()
    Begin{
        $computers = Get-Content ".\computers.txt"
        $Path = "SufFILEName.txt"
	    $SufMSI = Get-Content -Path $Path
        $sufmsipath = "C:\Staging\$sufmsi"
        $SplunkIndexer = Get-Content ".\splunkindexip.txt"
        $deploymentserver = Get-Content ".\splunkdeploymentserverip.txt"
        
    }
    Process {
        #Write-Host "Variables Test"
        Foreach ($h in $computers) {
                
                # Starts remote session to the 
                $s = New-PSSession -ComputerName $h
                # Defines a variable for the host in FQDN format and then another variable in just hostname format
                $hfull = $h
                $h = $h.Substring(0, $h.IndexOf('.'))
                # Defines the names of the Jobs
                $Job1 = "$h-Install-Splunk"
                $job2 = "$h-Check-Service"
                
                Write-Host "Host: $hfull" -ForegroundColor Green

                # Installing the Splunk Forwarder as a job
                Write-Host "Installing... (This can take a while depending on the host)" -ForegroundColor Yellow
                Invoke-Command -Session $s -ScriptBlock {
                    Start-Process -FilePath $using:sufmsipath -Wait -Verbose -ArgumentList "AGREETOLICENSE=yes RECEIVING_INDEXER=$using:SplunkIndexer DEPLOYMENT_SERVER=$using:deploymentserver WINEVENTLOG_APP_ENABLE=1 WINEVENTLOG_SEC_ENABLE=1 WINEVENTLOG_SYS_ENABLE=1 WINEVENTLOG_FWD_ENABLE=1 WINEVENTLOG_SET_ENABLE=1 ENABLEADMON=1 /quiet"
                } -AsJob -JobName "$job1" | Out-Null
                Wait-Job -Name $job1 | Out-Null
                
                # Checking the service is running
                Write-Host "Checking SplunkForwarder service..." -ForegroundColor Yellow
                Invoke-Command -Session $s -ScriptBlock {
                    (Get-Service SplunkForwarder).Status
                } -AsJob -JobName "$Job2" | Out-Null
                Wait-Job -Name $job2 | Out-Null
                
                $j = Get-Job
                $rj = Receive-Job -Name $job2 
                
                #Write-Host "$rj"# This line will return the actual value for testing
                #Write-Host "Before"
                
                If($rj -eq "0"){
                    Write-Host "$job2 reports Splunk Forwarder service is not running!" -ForegroundColor Red
                } Elseif ($rj -eq "1") 
                {
                    Write-Host "$job2 reports Splunk Forwarder service is stopped" -ForegroundColor Yellow
                    Invoke-Command -ComputerName wkstn1 -ScriptBlock {
                        Start-Service "SplunkForwarder"
                        $t = (Get-Service -Name "SplunkForwarder").Status
                        Write-Host ""
                        if($t -eq "Running") {
                            Write-Host "Splunk Forwarder is now running" -ForegroundColor Green
                        } else 
                        {
                            Write-Host "Splunk Forwarder is still not running, further investigation required on $h" -ForegroundColor Red
                        }
                    }
                } Else 
                {
                    Write-Host "Splunk Forwarder service is installed and running ok on $hfull" -ForegroundColor Green
                }

                #Write-Host "After"                
                Write-Host ""
                Remove-Job *
                Remove-PSSession -Session $s
                
            }
            FnPause-ForInput
            FnClientConfig-Options
        Try {
        
	    }
	    Catch {
	        Write-Host -BackgroundColor Red "Error: $($_.Exception)"
	    }
    }
}
			
Function FnUnInstallHIDS {
    Param ()
    Begin{
        $computers = Get-Content ".\computers.txt"
        $Path = "SufFILEName.txt"
	    $SufMSI = Get-Content -Path $Path
        $sufmsipath = "C:\Staging\$sufmsi"
        $SplunkIndexer = Get-Content ".\splunkindexip.txt"
        $deploymentserver = Get-Content ".\splunkdeploymentserverip.txt"
        #$creds = Get-Credential -Credential "$env:USERDOMAIN\$env:username"

        

    }
    Process {
        #Write-Host "Variables Test"
        Foreach ($h in $computers) {
                # Starts remote session to the host
                $s = New-PSSession -ComputerName $h
                # Defines a variable for the host in FQDN format and then another variable in just hostname format
                $hfull = $h
                $h = $h.Substring(0, $h.IndexOf('.'))

                Write-Host "Host: $hfull" -ForegroundColor Green

                Function RemoveMSI ($h,$hfull) {
                    $sufmsi = "UniversalForwarder"
                    $t1 = Get-WMIObject Win32_Product -ErrorAction SilentlyContinue | Where-Object {$_.Name -match "$sufmsi"}
    
                    If($t1 -ne $null) {
                        #Write-Host "MSI exists"
                        Write-Host "Uninstalling Splunk Forwarder..." -ForegroundColor Yellow
                        $sufmsi2 = Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall, HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Where-Object {$_.DisplayName -match $($sufmsi)}
                        $sufmsiUninstall = $sufmsi2.Pspath.Split("\")[-1]
                        Start-Process -Wait -FilePath MsiExec.exe -Argumentlist "/X $sufmsiUninstall /quiet /norestart"
                        Write-Host "Splunk Forwarder has been removed from $using:hfull" -ForegroundColor Green
                        #CallRemoveMSI
                    }
                    Else
                    {
                        Write-Host "$sufMSI not present on $using:hfull" -ForegroundColor Yellow
                    }
                }
                
                Function CallRemoveMSI {
                    RemoveMSI
                }


                Invoke-Command -Session $s -ScriptBlock $function:RemoveMSI -ArgumentList $h
                        
                Write-Host ""
                Remove-Job *
                Remove-PSSession -Session $s
                FnPause-ForInput
                FnClientConfig-Options
            }
        Try {
        
	    }
	    Catch {
	        Write-Host -BackgroundColor Red "Error: $($_.Exception)"
	    }
    }
}		

Function FnRestartEndpoints { 
Param ()
Begin {
    Write-Host "Restarting Endpoints..."
}
Process {
        $computers = Get-Content ".\computers.txt"
		Try {

            foreach ($h in $computers) {
                Invoke-Command -ComputerName $h -ScriptBlock {Restart-Computer -Force:$true}
            }
            FnPause-ForInput
            FnClientConfig-Options
		}
		Catch {
		Write-Host -BackgroundColor Red "Error: $($_.Exception)"
		}
    }
}			

Function FnDownloadFilesHTTP { 
Write-Host "Not yet implemented"
Sleep 1
FnClientConfig-Options
}

Function FnDownloadFilesSMB { 
Param ()
Begin{
    $Path = "SufFILEName.txt"
	$SufMSI = Get-Content -Path $Path
    $path2 = ".\SysmonFILEName.txt"
    $sysmonexe = Get-Content -Path $path2
    $path3 = "sysmonconfFILEName.txt"
    $sysmonconf = Get-Content -Path $path3
    $FQDN = "$env:COMPUTERNAME.$env:USERDNSDOMAIN"
	$UNCPath = "\\$FQDN\Splunk\$sufmsi"
    $UNCPath2 = "\\$FQDN\Splunk\$sysmonexe"
    $UNCPath3 = "\\$FQDN\Splunk\$sysmonconf"
	$Check = Test-Path $uncpath
    $computers = Get-Content ".\computers.txt"
}
Process {
		
		#Write-Host $script:DownloadServer
		#Write-Host $script:SufFILEName
		
		Try {
            foreach ($h in $computers) {
                $hpath = "\\$h\c$"
                Write-Host "Host: $h" -ForegroundColor Green 
                Write-Host "Transferring $sufMSI, $sysmonexe and $sysmonconf..." -ForegroundColor Yellow

                <#### Diagnostics, remove when script is complete
                Write-Host "DIAGNOSTIC: $hpath" -ForegroundColor Yellow
                Write-Host "DIAGNOSTIC: $UNCPath" -ForegroundColor Yellow
                Write-Host "DIAGNOSTIC: $UNCPath2" -ForegroundColor Yellow
                Write-Host "DIAGNOSTIC: $UNCPath3" -ForegroundColor Yellow
                ### End of diagnostics #>

                $testlocal = Test-Path $UNCPath
                $testremote = Test-Path $hpath

                If($testlocal) {
                    #Write-Host "Local path reachable"
                    If($testremote) {
                        #Write-Host "Remote path reachable"
                        }
                        else
                        {
                        Write-Host "Remote path unreachable" -ForegroundColor Red
                        }
                    }
                    else
                    {
                    Write-Host "Neither Remote or Local path appears to work" -ForegroundColor Red
                }
                <#If($testremote) {
                    Write-Host "Remote path reachable"
                    }
                    else
                    {
                    Write-Host "Remote path unreachable"
                }#>
                New-Item -Path "$hpath\Staging\" -ItemType Directory -Force:$true | Out-Null
                #Test-Path "$hpath\Staging"
                Copy-Item -Path $UNCPath -Destination "$hpath\Staging" -Force:$true
                Copy-Item -Path $UNCPath2 -Destination "$hpath\Staging" -Force:$true
                Copy-Item -Path $UNCPath3 -Destination "$hpath\Staging" -Force:$true
                Write-Host "Files successfully copied" -ForegroundColor Green
                #Test-Path "$hpath\Staging"
            }
            #Copy-Item -Path $UNCPath -Destination $

			#$dls = $script:DownloadServer
			#$file = $script:SufFILEName
			#$computers = Get-Content ".\computers.txt"
			#Invoke-Command -ComputerName $computers -Scriptblock{Param($dls,$file);$SUF_url = "Download path: http://" + $using:dls + "/" + $using:file; Write-Host $SUF_url; $SUF_path = $home + "\Downloads" + $using:file; Write-Host $SUF_path; (New-Object Net.WebClient).DownloadFile($SUF_url, $SUF_path)}
            FnPause-ForInput
            FnClientConfig-Options
		}
		Catch {
		Write-Host -BackgroundColor Red "Error: $($_.Exception)"
		}
	}
}

Function FnInstallSysmon {
    Param ()
    Begin{
        
    }
    Process {
	    Try {
            $computers = Get-Content ".\computers.txt"
            $sysmonexe = Get-Content ".\SysmonFILEName.txt"
            $sysmonconf = Get-Content ".\SysmonConfFILEName.txt"
            #Write-Host "Sysmon exe named $sysmonexe"
			#Write-Host "Sysmon Conf named $sysmonconf"

            Foreach ($h in $computers) {
                
                $s = New-PSSession -ComputerName $h -Credential $creds
                Write-Host "Host: $h" -ForegroundColor Green

                Invoke-Command -Session $s -ScriptBlock {
                    $h = $using:h

                    $sysmonexe = $using:sysmonexe
                    $sysmonconf = $using:sysmonconf

                    $staging = "$env:SystemDrive\Staging"
                    $sysmonexepath = "$env:SystemDrive\Staging\$sysmonexe"
                    $sysmonconfpath = "$env:SystemDrive\Staging\$sysmonconf"

                    $t1 = Test-Path "$staging"
                    $t2 = Test-Path "$sysmonexepath"
                    $t3 = Test-Path "$sysmonconfpath"

                    $t4 = Test-Path "$env:ProgramFiles\Sysmon\"

                    $startpath = "$env:SystemDrive\Staging"
                    $endpath = "$env:ProgramFiles\Sysmon"
                    $sysmonexepath1 = "$env:ProgramFiles\Sysmon\$sysmonexe"
                    $sysmonconfpath1 = "$env:ProgramFiles\Sysmon\$sysmonconf"
                    

                    If($t4) {
                    #Write-Host "Sysmon directory exists"
                    }
                    else
                    { 
                        New-Item -Path "$endpath" -ItemType Directory | Out-Null
                        $t4 = Test-Path "$endpath"
                        If ($t4){
                        #Write-Host "Sysmon directory exists"
                        }
                        Else
                        {
                        Write-Host "The Sysmon directory does not invesitgate and cannot be created" -ForegroundColor Red
                        }
                    }

                    # Checks to ensure the staging directory exists, the sysmon exe exists and the sysmon config file exists
                    If($t1) {
                        #Write-Host "$staging exists $t1" -ForegroundColor Magenta
                        # Checks to see if sysmon exe and sysmon conf are present in the staging directory
                        If($t2 -and $t3) {
                           # Write-Host "$sysmonexepath and $sysmonconfpath exists $t2" -ForegroundColor Magenta
                            Write-Host "Checks complete on $h" -ForegroundColor Green

                            # Moves the files to the sysmon directory
                            Move-Item -Path "$startpath\$sysmonexe" -Destination "$endpath\$sysmonexe" -Force:$true
                            Move-Item -Path "$startpath\$sysmonconf" -Destination "$endpath\$sysmonconf" -Force:$true

                            $t5 = "$endpath\$sysmonexe"
                            $t6 = "$endpath\$sysmonconf"

                            If($t5 -and $t6) {
                                Write-Host "Successfully moved $sysmonexe and $sysmonconf" -ForegroundColor Yellow
                            }
                            Else
                            {
                                Write-Host "$sysmonexe and $sysmonconf has not transferred correctly" -ForegroundColor Red
                            }

                            #Write-Host "$sysmonexepath1 -accepteula -i $sysmonconfpath1"   
                            & "$sysmonexepath1" -accepteula -i "$sysmonconfpath1" 2> $null | Out-Null

                            # Test service is running ok
                            $t7 = (Get-Service Sysmon*).Status
                            If($t7 -eq "4"){
                                Write-Host "Sysmon service is running" -ForegroundColor Green
                            }
                            else
                            {
                            Write-Host "Sysmon service is not running on $h"
                        }
                        }
                        Else
                        {
                            Write-Host "$sysmonexe and/or $sysmonconf does not exist on $h" -ForegroundColor Red
                            
                        }
                    }

                    Else
                    {
                        Write-Host "Staging directory does not exist on $h" -ForegroundColor Red
                    }
                }
            Write-Host "Closing session" -ForegroundColor Yellow
            Remove-PSSession -Session $s
	        }
        
            FnPause-ForInput
            FnClientConfig-Options
        }
	    Catch   {
		    Write-Host -BackgroundColor Red "Error: $($_.Exception)"
		}
	}
}

Function FnUnInstallSysmon {
    Param ()
    Begin{
        
    }
    Process {
	    Try {
            $computers = Get-Content ".\computers.txt"
            $sysmonexe = Get-Content ".\SysmonFILEName.txt"
            $sysmonconf = Get-Content ".\SysmonConfFILEName.txt"

            Foreach ($h in $computers) {
                
                $s = New-PSSession -ComputerName $h -Credential $creds
                Write-Host "Host: $h" -ForegroundColor Green

                Invoke-Command -Session $s -ScriptBlock {
                    $h = $using:h
                    $sysmonexe = $using:sysmonexe
                    $sysmonexepath = "$env:ProgramFiles\Sysmon\$sysmonexe"
                    $sysmonconf = $using:sysmonconf
                    $sysmonconfpath = "$env:ProgramFiles\Sysmon\$sysmonconf"

                    $t1 = (Get-Service Sysmon*).Status

                    If($t1 -eq 4) {
                        #Write-Host "Sysmon is running on $h" -ForegroundColor Yellow
                        Stop-Service Sysmon*

                        $t2 = (Get-Service Sysmon*).Status
                        If($t2 -eq 4) {
                            #Write-Host "Sysmon is still running on $h"
                            Stop-Service Sysmon*
                        }
                        Else
                        {
                            Write-Host "Sysmon is stopped on $h" -ForegroundColor Yellow
                            & "$sysmonexepath" -u "force" 2> $null | Out-Null
                        }
                    }
                    Else
                    {
                        Write-Host "Sysmon is not running on $h" -ForegroundColor Yellow
                        & "$sysmonexepath" -u "force" 2> $null | Out-Null
                    }
                    #$sysmonexepath
                    

                    $t3 = (Get-Service Sysmon*).Status

                    If($t3 -eq 4) {
                        Write-Host "Sysmon is still installed on $h" -ForegroundColor Yellow
                    }
                    Else
                    {
                        Remove-Item -Path $sysmonexepath -Force:$true
                        Remove-Item -Path $sysmonconfpath -Force:$true
                        Remove-Item -Path "$env:ProgramFiles\Sysmon" -Force:$true
                        Write-Host "Sysmon has been uninstalled" -ForegroundColor Green
                    }
                }

            }
            Write-Host "Closing session" -ForegroundColor Yellow
            Remove-PSSession -Session $s
            FnPause-ForInput
            FnClientConfig-Options
	    }
	    Catch   {
		    Write-Host -BackgroundColor Red "Error: $($_.Exception)"
		}
	}
}

Function FnEnableSysmon {
    Param()
    Begin{
    }
    Process {
        Try {
            $global:computers = Get-Content ".\computers.txt"
            Foreach ($h in $computers) {
                $s = New-PSSession -ComputerName $h #-Credential $creds
                Write-Host "Host: $h" -ForegroundColor Green
                #Invoke-Command -ComputerName $h -ScriptBlock {
                Invoke-Command -Session $s -ScriptBlock {
                    $splunkdir = "$env:ProgramFiles\SplunkUniversalForwarder"
                    $splunkpath = "$splunkdir\etc\apps\TA-microsoft-sysmon\local"
                    $inputs = "$splunkpath\inputs.conf"
                    #$splunkdir
                    #$splunkpath
                    #$inputs

                    $t1 = Test-Path $splunkdir


                    If($t1) {
                        #Write-Host "Test 1"
                        $t2 = Test-Path $splunkpath


                        If($t2) {
                            #Write-Host "Test 2"
                            $sysmonstring = Select-String -Path "$inputs" -Pattern 'disabled = true'
                            
                            
                            If ($sysmonstring) {
                                #Write-Host "String found!" -ForegroundColor Yellow
                                $content = Get-Content "$inputs"
                                $replace = $content -replace 'disabled = true','disabled = false'
                                $replace | Set-Content -Path $inputs
                                Write-Host "Sysmon input enabled" -ForegroundColor Green
                                Stop-Service SplunkForwarder | Out-Null
                                Start-Service SplunkForwarder | Out-Null
                            }
                            Else {
                                Write-Host "The string 'disabled = true' was not found in the inputs.conf file" -ForegroundColor Yellow
                                #Get-Content -Path $inputs
                            }


                        }
                        Else { 
                            Write-Host "The TA Sysmon Splunk App was not found, please ensure the deployment server is configured correctly" -ForegroundColor Red
                        }


                    }
                    Else {
                    Write-Host "The Splunk Universal Forwarder was not found" -ForegroundColor Red
                    }

                
                    #$inputs = "$env:ProgramFiles\$splunkpath\inputs.conf"
                    #$content = Get-Content $inputs
                    #$newcontent = $content -replace "disabled = true","disabled = false"
                    #$newcontent | Set-Content -Path $inputs
                }
                Write-Host "Closing session" -ForegroundColor Yellow
                Remove-PSSession -Session $s
            }

        }
        Catch {
        }
    }
}

Function FnRemoveFiles {
    Param ()
    Begin{
        
    }
    Process {
	    Try {
            $computers = Get-Content ".\computers.txt"
            $sysmonexe = Get-Content ".\SysmonFILEName.txt"
            $sysmonconf = Get-Content ".\SysmonConfFILEName.txt"
            $sufMSI = Get-Content ".\SufFILEName.txt"

            Foreach ($h in $computers) {
                
                $s = New-PSSession -ComputerName $h -Credential $creds
                Write-Host "Host: $h" -ForegroundColor Yellow

                Invoke-Command -Session $s -ScriptBlock {
                    $h = $using:h
                    $sysmonexe = $using:sysmonexe
                    $sysmonexepath = "$env:SystemDrive\Staging\$sysmonexe"
                    $sysmonconf = $using:sysmonconf
                    $sysmonconfpath = "$env:SystemDrive\Staging\$sysmonconf"
                    $sufMSI = $using:sufMSI
                    $sufMSIpath = "$env:SystemDrive\Staging\$sufMSI"
                    $staging = "$env:SystemDrive\Staging"

                    $t1 = Test-Path $sysmonconfpath
                    $t2 = Test-Path $sysmonexepath
                    $t3 = Test-Path $sufMSIpath
                    $t4 = Test-Path $staging

                    If($t1) {
                        Remove-Item -Path $sysmonconfpath -Force:$true
                    }

                    If($t2) {
                        Remove-Item -Path $sysmonexepath -Force:$true
                    }

                    If($t3) {
                        Remove-Item -Path $sufMSIpath -Force:$true
                    }

                    If($t4) {
                        Remove-Item -Path $staging -Force:$true
                        Write-Host "$Staging and all contents have been removed" -ForegroundColor Green
                    }
                    
                    $t5 = Test-Path $staging

                    If($t5) {
                        Write-Host "Unable to delete $staging"
                    }

                }

            }
            Write-Host "Closing session"
            Remove-PSSession -Session $s
            FnPause-ForInput
            FnClientConfig-Options
	    }
	    Catch   {
		    Write-Host -BackgroundColor Red "Error: $($_.Exception)"
		}
	}
}	

Function FnListHosts { 
Param ()
Begin{
	Write-Host
}
Process {
		Try {
			$Path = "computers.txt"
			$Check = Test-Path $Path
			
			If ($Check -eq $true) {
			Get-Content $Path
			}
			
			Else {
			Write-Host "computers.txt missing, creating...."
			New-Item -Path . -Name $Path -Type "File" 
			Get-Content $Path
			}
		}
		Catch   {
		Write-Host
		Write-Host -BackgroundColor Red "Error: $($_.Exception)"
		}
		Write-Host
		FnPause-ForInput
		FnDiagnostics-Options
	}
}
	
Function FnTestComputers {
Param ()
Begin{
	Write-Host
}
Process {
		Try {
			$hosts = Get-Content -Path .\computers.txt
			Foreach ($hostname in $hosts) {
				$test = Test-NetConnection -ComputerName $hostname
				If (($test).pingsucceeded) {
					Write-Host "$hostname is reachable" -ForegroundColor Green 
				} 
				Else {
					Write-Host "$hostname is not reachable" -ForegroundColor Red
				}
			}
		}
		Catch   {
		Write-Host -BackgroundColor Red "Error: $($_.Exception)"
		}
		Write-Host
		FnPause-ForInput
		FnDiagnostics-Options
	}
}
	
Function FnTestWinRMComputers {
Param ()
Begin{
	Write-Host
}
Process {
		Try {
			$hosts = Get-Content -Path .\computers.txt
			Foreach ($hostname in $hosts) {
				$test = Test-NetConnection -ComputerName $hostname -CommonTCPPort Winrm
				If (($test).tcptestsucceeded) {
					Write-Host "$hostname is reachable by WinRM" -ForegroundColor Green 
				} 
				Else {
					Write-Host "$hostname is not reachable by WinRM" -ForegroundColor Red
					
				}
			}	
		}
		Catch   {
		Write-Host -BackgroundColor Red "Error: $($_.Exception)"
		}
		Write-Host
		FnPause-ForInput
		FnDiagnostics-Options
	}
}

Function FnCheckServices {
    Param()
    Begin{
        FnGetComputers
    }
    Process {
        Try {
            
            Foreach ($h in $computers) {
                $s = New-PSSession -ComputerName $h
                Invoke-Command -Session $s -ScriptBlock {
                    Write-Host "Host: $using:h" -ForegroundColor Green
                    $svc = (Get-Service SplunkForwarder).Status

                    If($svc -eq "Running") {
                        Write-Host "Splunk Universal Forwarder is running" -ForegroundColor Green
                    }
                    Else {
                        Write-Host "Splunk Universal Forwarder is not running, attempting to start the service now..." -ForegroundColor Yellow
                        Start-Service -Name SplunkForwarder -WarningAction SilentlyContinue | Out-Null 
                        $svc2 = (Get-Service SplunkForwarder).Status
                        If ($svc2 -ne "Running") {
                            Write-Host "Splunk Forwarder service is failing to start"
                        }
                        Else {
                            Write-Host "Splunk Forwarder service has successfully started" -ForegroundColor Green
                        }
                    }
                }
                Remove-PSSession *
            }
            FnPause-ForInput
		    FnDiagnostics-Options
        }
        Catch {
        }
    }
}

Function FnRestartServices {
    Param()
    Begin{
        FnGetComputers
    }
    Process {
        Try {
            
            Foreach ($h in $computers) {
                $s = New-PSSession -ComputerName $h
                Invoke-Command -Session $s -ScriptBlock {
                    Write-Host "Host: $using:h" -ForegroundColor Green
                    $svc = (Get-Service SplunkForwarder).Status

                    If($svc -eq "Running") {
                        Write-Host "Splunk Universal Forwarder is running, attempting to restart now... " -ForegroundColor Yellow
                        Restart-Service -Name SplunkForwarder -WarningAction SilentlyContinue
                        $svc2 = (Get-Service SplunkForwarder).Status
                        If ($svc2 -eq "Running") {
                            Write-Host "Splunk Forwarder has restarted successfully" -ForegroundColor Green
                        }
                        Else {
                        Write-Host "Splunk Forwarder has failed to restart correctly" -ForegroundColor Red
                        }
                    }
                    Else {
                        Write-Host "Splunk Universal Forwarder is not running, attempting to start the service now..." -ForegroundColor Yellow
                        Start-Service -Name SplunkForwarder -WarningAction SilentlyContinue | Out-Null 
                        $svc2 = (Get-Service SplunkForwarder).Status
                        If ($svc2 -ne "Running") {
                            Write-Host "Splunk Forwarder service is failing to start"
                        }
                        Else {
                            Write-Host "Splunk Forwarder service has successfully started" -ForegroundColor Green
                        }
                    }
                }
                Remove-PSSession *
            
            }
            FnPause-ForInput
		    FnDiagnostics-Options
        }
        Catch {
        }
    }
}

Function FnstartServices {
    Param()
    Begin{
        FnGetComputers
    }
    Process {
        Try {
            
            Foreach ($h in $computers) {
                $s = New-PSSession -ComputerName $h
                Invoke-Command -Session $s -ScriptBlock {
                    Write-Host "Host: $using:h" -ForegroundColor Green
                    $svc = (Get-Service SplunkForwarder).Status

                    If($svc -eq "Running") {
                        Write-Host "Splunk Universal Forwarder is already running." -ForegroundColor Yellow
                    }
                    Else {
                        Write-Host "Splunk Universal Forwarder is not running, attempting to start the service now..." -ForegroundColor Yellow
                        Start-Service -Name SplunkForwarder -WarningAction SilentlyContinue | Out-Null 
                        $svc2 = (Get-Service SplunkForwarder).Status
                        If ($svc2 -ne "Running") {
                            Write-Host "Splunk Forwarder service is failing to start"
                        }
                        Else {
                            Write-Host "Splunk Forwarder service has successfully started" -ForegroundColor Green
                        }
                    }
                }
                Remove-PSSession *
            }
            FnPause-ForInput
		    FnDiagnostics-Options
        }
        Catch {
        }
    }
}
### SUF Menu ###



FnStart-Script
