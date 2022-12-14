#Get public and private function definition files.
$Public = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )

#Set Cert validation callback
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}

#Dot source the files
Foreach ($import in @($Public + $Private))
{
    Try
    {
        . $import.fullname
        Write-Output $import.fullname
    }
    Catch
    {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

#Read in or create an initial config file and variable

#Export Public functions ($Public.BaseName) for WIP modules
Export-ModuleMember -Function $Public.Basename