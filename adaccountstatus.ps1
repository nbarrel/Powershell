##Nicholas Barillas AD Account status script Sept 2023
# Prompt the user to enter a list of usernames separated by commas
$usernames = Read-Host "Enter one or more usernames (comma-separated):"

# Split the input into an array of usernames
$usernamesArray = $usernames -split ","

# Iterate through the list of usernames
foreach ($username in $usernamesArray) {
    # Trim and clean up each username
    $username = $username.Trim()

    # Get the user object
    $user = Get-ADUser -Identity $username -Properties "DisplayName", "msDS-UserPasswordExpiryTimeComputed", "AccountExpirationDate"

    # Check if the user exists
    if ($user -eq $null) {
        Write-Host "User $username not found in Active Directory."
    } else {
        # Check if the user's password has expired
        if ($user."msDS-UserPasswordExpiryTimeComputed" -ne $null) {
            $passwordExpiryDate = [datetime]::FromFileTime($user."msDS-UserPasswordExpiryTimeComputed")
            $currentDate = Get-Date

            if ($currentDate -gt $passwordExpiryDate) {
                Write-Host "Password for $($user.DisplayName) has expired."
            } else {
                Write-Host "Password for $($user.DisplayName) is valid until $passwordExpiryDate."
            }
        } else {
            Write-Host "Password expiration information not available for $($user.DisplayName)."
        }

        # Check if the user's account has an expiry date set
        if ($user.AccountExpirationDate -ne $null) {
            $accountExpiryDate = $user.AccountExpirationDate
            $currentDate = Get-Date

            if ($currentDate -gt $accountExpiryDate) {
                Write-Host "Account for $($user.DisplayName) has expired."
            } else {
                Write-Host "Account for $($user.DisplayName) is valid until $accountExpiryDate."
            }
        } else {
            Write-Host "Account expiration information not available for $($user.DisplayName)."
        }
    }
}
