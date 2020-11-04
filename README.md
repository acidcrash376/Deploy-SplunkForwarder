# Deploy-SplunkForwarder

## Introduction
A tool to host, deploy and configure Splunk Universal Forwarders and Sysinternals Sysmon to multiple endpoints. All configurable while running the script, no requirement to edit anything from inside the script itself. 

On first running, you will have to define some key variables first from within the Varibles menu. These are the Splunk indexer IP:port, Splunk Deployment Server IP:port, Splunk Index name, the name of the Splunk Universal Forwarder msi, the Sysmon executable and the Sysmon config xml file. Once defined, configure the local SMB share from the Server menu. This is just a stop or start option, no further configuration required. Next from within the Client menu; transfer the files to the endpoints, install the Universal Forwarder, followed by install Sysmon. Optional house cleaning by removing the installation files and staging directory can also be done. You can also install Splunk Universal Forwarder and Sysmon should you require to do so.

## Version History
### 2.0.0.Beta
Initial public release

### 2.0.1.Beta
Changed wording of Install *Install HIDS* to *Install Universal Forwarder* to be clearer as to what it was doing. 

## To-Do
1. Create a Diagnostics menu
2. Move List Host, Ping Host, Test WinRM on Host options to Diagnostics
3. Create a Check Service and Restart Service check in Diagnostics
4. Add a function to populate the computers.txt from active directory
