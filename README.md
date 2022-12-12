# Remote Windows Threat Hunting Collection and Detection
These scripts are intended to aid in Threat Hunting within a Windows domain. The scripts assume out of band use, and therefore establish a WinRM session with the remote host via HTTPS. The original scripts came from https://github.com/mhallit13. 

## Requirements

   **AllHosts.csv:**    This is a file that is in .csv format and has the host information for machines on your network

With all the scripts, you'll need to manually change the Subnet, OS, or Hostname of the computers you would like to collect on.
  
**NOTE** 
These scripts are set up to be run in the directories they exist. This will make all the reference locations work. 
   For example, if you want to run the "compare_baseline_accounts" script, then your propmt should look similar to:
           
     PS C:\Users\<username>\Documents\03_Compare_Baseline_Scripts>
           
   If you want to change the locations, just ensure that all relative paths in your scripts are edited to show new locations!

# Baselining
To begin baselining your domain, you may either run the collect.ps1 to "collect" all of the artifacts, or you may run each script located in 02_Create_Baseline_Scripts individually.

Both methods give you the ability to output the artifacts to the folder of your convience with the -FolderOut or -FileOut parameter. Default for 02_Create_Baseline_Scripts is the Baseline folder, default for collect.ps1 is Audit Folder.

# Detecting
If you use scripts found in the 03_Compare_Baseline_Scripts, you can diffrence the current and baseline artifacts to find anomalies. With good baselines, this is a great way to identify anomalies, otherwise you may need to try something else. 

The 04_LFA_Scripts folder contains scripts that perform "Least Frequency Analysis" by grouping on a specific term and analzing some of the least common results, you may find outliers aka anomalies.
           
