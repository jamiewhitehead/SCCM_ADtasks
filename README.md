"# SCCM_ADtasks" 

One awesmoe feature of the "run command line" feature of an SCCM task sequence is that you can run the task sequence steps with an alternate set of credentials. This is very useful when running scripts that require a alternate set of credentials without having to hard code those credentisl into the script. 
Having the credentials hard coded into the script presents a significant security hazard, plus making credential cahnges can become a logistical nightmare. 

This has been used quite well when running vbscripts or batch files...... however, when it came to powershell, the scripts would just not work. Testing the scripts outside the task sequence, with alternate credentials would work. Testing the script in side the task sequence withou alternate credentials would also work. Just not the combination of the two. 

The answer was resolved to be that when an alternate credential is specified then Configuration manager disables COM object support. This pretty much breaks every useful operational command from about Powershell 2.0 onwards. 
To acheive the functionality required the script has been written using the older .NET methods that have now been replaced by Powershell functions. 

The script in this repository was used at a custeomr to make the transfer of physical computers for end users, by automating the assignment of AD groups to the new machine (for CM Applications and other security considerations);
	- finds the AD groups for a source computer
	- adds the target computer intot he list of groups found by the first step. 
	
This script can be successfully run in a Configuration manager task sequence with alternate credentials specified. 