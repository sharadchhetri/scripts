# Author: Sharad Kumar Chhetri
#  Date: 27-May-2025
#  Version: 1.0
#  Description: This simple powershell script will create a Liberary variable set in Octopus. 
#     It will also create and update Variable Name and its value by taking input from CSV file.
 

$ErrorActionPreference = "Stop";

# Define working variables
$octopusURL = "https://Your-Octopus-URL-Address"
$octopusAPIKey = "Your-API-Key"
$header = @{ "X-Octopus-ApiKey" = $octopusAPIKey }

# Give Space Name
$spaceName = 'Default'

# Path to your CSV file
$csvPath = "C:\variable-set.csv"

# Give LiberaryVariableSet Name
$librarySetName = "TestVS"
$Description = "TestVS variable set"

$variableSet = @{
    Name = "$librarySetName" 
    Description = "$Description"
    Variables = @() # Initialize an empty variables array to be populated later
}| ConvertTo-Json

# Get space
$space = (Invoke-RestMethod -Method Get -Uri "$octopusURL/api/spaces/all" -Headers $header) | Where-Object {$_.Name -eq $spaceName}

# Get variable set
$librarySet = (Invoke-RestMethod -Method Get -Uri "$octopusURL/api/$($space.Id)/libraryvariablesets/all" -Headers $header) | Where-Object {$_.Name -eq $librarySetName}

# Check if Liberary Variable Set exist else create the variable set.
function check_liberaryVariableSet {
    try {
        # If-Else condition
        if ( $librarySet.Name -eq $librarySetName ) {
            Write-Host $librarySetName exist
        }
        else {
            Write-Host "$librarySetName do not exist. Creating VariableSet"
            $response = Invoke-RestMethod -Uri "$octopusURL/api/$($space.Id)/libraryvariablesets" -Method Post -Headers $header -ContentType "application/json" -Body $variableSet
            return $response
            write-host "---"
            write-host "$response"
        }
      }
      catch {
        # Code to execute if an error occurs
        Write-Host "An error occurred: $($_.Exception.Message)"
      }
}

# Create/Update Variable Name and Value in LiberaryVariableSet
function create_new_variables {
# Import the CSV file
$variables = Import-Csv $csvPath
$variableSetId = $librarySet.VariableSetId
$variableSet = Invoke-RestMethod -Method Get -Uri "$octopusURL/api/$($space.Id)/variables/$variableSetId" -Headers $header -ContentType "application/json"
# Loop through each variable from CSV and add to the variable set
foreach ($variable in $variables) {

    $variableToUpdate = $variableSet.Variables | Where-Object {$_.Name -eq $variable.Name}
    if ($null -eq $variableToUpdate)
    {
    # Create new object
    $variableToUpdate = New-Object -TypeName PSObject
    $variableToUpdate | Add-Member -MemberType NoteProperty -Name "Name" -Value $variable.Name
    $variableToUpdate | Add-Member -MemberType NoteProperty -Name "Value" -Value $variable.Value
    $variableToUpdate | Add-Member -MemberType NoteProperty -Name "Type" -Value $variable.Type
    $variableToUpdate | Add-Member -MemberType NoteProperty -Name "IsSensitive" -Value ($variable.IsSensitive -replace '\$')

    # Add to collection
    $variableSet.Variables += $variableToUpdate

    $variableSet.Variables
    }
    # update variable value if variable name already exist
    $variableToUpdate.Value = $variable.Value
}
$result = $variableSet | ConvertTo-Json -Depth 10

# Add or update variable in variable set
Invoke-RestMethod -Method Put -Uri "$octopusURL/api/$($space.Id)/variables/variableset-LibraryVariableSets-40" -Headers $header -Body $result -ContentType "application/json"
}

# calling functions
check_liberaryVariableSet
create_new_variables