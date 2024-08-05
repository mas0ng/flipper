# Get Chrome's "Login Data" SQLite file path
$chromePath = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Login Data"

# Copy the database file to avoid lock issues
$copyPath = "$env:TEMP\ChromeLoginData.db"
Copy-Item -Path $chromePath -Destination $copyPath

# Load SQLite assembly (requires SQLite DLLs or System.Data.SQLite NuGet package)
Add-Type -Path "C:\path\to\System.Data.SQLite.dll"

# Open the SQLite connection
$connection = New-Object System.Data.SQLite.SQLiteConnection
$connection.ConnectionString = "Data Source=$copyPath;Version=3;"
$connection.Open()

# Execute the query to get logins
$command = $connection.CreateCommand()
$command.CommandText = "SELECT origin_url, username_value, password_value FROM logins"
$reader = $command.ExecuteReader()

# Function to decrypt the password
function DecryptPassword([byte[]]$password) {
    $entropy = [byte[]]@()
    $plaintext = [System.Security.Cryptography.ProtectedData]::Unprotect($password, $entropy, [System.Security.Cryptography.DataProtectionScope]::CurrentUser)
    return [System.Text.Encoding]::UTF8.GetString($plaintext)
}

# Prepare CSV output
$output = "URL,Username,Password`n"

# Read and decrypt each password
while ($reader.Read()) {
    $url = $reader["origin_url"]
    $username = $reader["username_value"]
    $password = $reader["password_value"]
    
    $passwordDecrypted = DecryptPassword($password)
    $output += "$url,$username,$passwordDecrypted`n"
}

# Close connection
$reader.Close()
$connection.Close()

# Save to a CSV file
$outputPath = "$env:USERPROFILE\Desktop\ChromePasswords.csv"
$output | Out-File -FilePath $outputPath

# Clean up
Remove-Item -Path $copyPath

Write-Host "Passwords exported to $outputPath"
