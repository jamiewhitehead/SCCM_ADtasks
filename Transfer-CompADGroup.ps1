PARAM
    (
    [String]$SrcComputerName,
    [String]$TrgtComputerName
    )
  
# ####################################################################################
# ####     MAIN CODE                                                            ######
# ####################################################################################

# ------------------------------
# Prepare the ADSI Search object
# ------------------------------

$dom = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
$root = $dom.GetDirectoryEntry()
$search = [System.DirectoryServices.DirectorySearcher]$root

# ---------------------------------------------------------------------------------
# Get the list of groups (distinguishedName) that the Source machine is a member of
# ---------------------------------------------------------------------------------

$search.Filter = "(&(objectCategory=Computer)(SamAccountname=$($SrcComputerName)`$))"
$SrcADMachineGroupList = $search.FindOne().Properties.memberof

# ---------------------------------
# Get the target computer ADSI Path
# ---------------------------------

$search.Filter = "(cn=$TrgtComputerName)"
$TrgtADMachine = $search.FindOne().GetDirectoryEntry().Path

# --------------------------------------------------------
# Add the target computer to each of the discovered Groups
# --------------------------------------------------------

ForEach($ADGroup in $SrcADMachineGroupList)
{
    $search.Filter = "(distinguishedName=$ADGroup)"
    $ADGroupObj = [ADSI]$search.FindOne().Path
    Try
    {
        $ADGroupObj.psbase.Invoke("Add",$TrgtADMachine)
    }
    Catch
    {
        If($($_.Exception) -match "The object already exists")
        {
            #No Action to take. Computer is already a member of the group. 
        }       
        Else
        {
            $_.Exception > "C:\Get-AdGroup4Comp.log"
        }
    }
}

# ####################################################################################
# ####     END OF MAIN CODE                                                     ######
# #################################################################################### 