param (
   [string]$datadir = "..\data",
   [string]$psexecpath = "..\..\SysInternalsSuite"
)

Get-ChildItem $datadir | % {
  $package_data = ConvertFrom-Json "$(gc $_.FullName)"
  # $package_data | fl *
  if ($package_data.installassystem -ne $null) {
    # For now, misuse psexec.exe
    $tempscript = "dss-jdlsjl.cmd"
    $package_data.installstring | Out-File $tempscript -Encoding ASCII
    $tempscript_path = (Get-Item $tempscript).FullName
    Invoke-Expression "$psexecpath\psexec.exe -ids /accepteula $tempscript_path"
  } else {
    # Run as invoking user (scheduled task configured user)
    Invoke-Expression $package_data.installstring
  }
}
