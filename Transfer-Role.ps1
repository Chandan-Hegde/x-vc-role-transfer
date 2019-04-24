##################################################################
#
# PowerCLI Script to Transfer Role from one vCenter to anothe ones
#
##################################################################

param(
	[string] $VC1, [string] $VC2, [string] $transferrole
)
 
# Set the PowerCLI Configuration to connect to multiple vCenters
#Set-PowerCLIConfiguration -DefaultVIServerMode multiple -Confirm:$false
 
# Connect to both the source and destination vCenters
connect-viserver -server $VC1

# Get roles to transfer
$SystemAdminsRole = get-virole -server $VC1 -name $transferrole
 
# Get role Privileges
[string[]]$privsforRoleAfromVC1 = Get-VIPrivilege -Role (Get-VIRole -Name $SystemAdminsRole -server $VC1) |%{$_.id}

#Disconnect from Source vCenter
Disconnect-VIServer * -Confirm:$false 

# Connect to both the source and destination vCenters
connect-viserver -server $VC2
 
# Create new role in VC2
New-VIRole -name $SystemAdminsRole -Server $VC2
 
# Add Privileges to new role.
Set-VIRole -role (get-virole -Name $SystemAdminsRole -Server $VC2) -AddPrivilege (get-viprivilege -id $privsforRoleAfromVC1 -server $VC2)
 
#Disconnect from Source vCenter
Disconnect-VIServer * -Confirm:$false 
