Import-Module ActiveDirectory

# Set default password and OU path
$password = ConvertTo-SecureString "Password1" -AsPlainText -Force
$ouPath = "OU=_EMPLOYEES,DC=mydomain,DC=com"

# Expanded first name list
$firstNames = @(
    "James","John","Robert","Michael","William","David","Richard","Joseph","Thomas","Charles",
    "Christopher","Daniel","Matthew","Anthony","Mark","Donald","Steven","Paul","Andrew","Joshua",
    "Kenneth","Kevin","Brian","George","Edward","Ronald","Timothy","Jason","Jeffrey","Ryan",
    "Jacob","Gary","Nicholas","Eric","Stephen","Jonathan","Larry","Justin","Scott","Brandon",
    "Benjamin","Samuel","Frank","Gregory","Raymond","Alexander","Patrick","Jack","Dennis","Jerry",
    "Tyler","Aaron","Jose","Adam","Nathan","Henry","Douglas","Zachary","Peter","Kyle",
    "Walter","Ethan","Jeremy","Harold","Keith","Christian","Roger","Noah","Gerald","Carl",
    "Terry","Sean","Austin","Arthur","Lawrence","Jesse","Dylan","Bryan","Joe","Jordan",
    "Billy","Bruce","Albert","Willie","Gabriel","Logan","Alan","Juan","Wayne","Roy",
    "Ralph","Randy","Eugene","Vincent","Russell","Elijah","Louis","Bobby","Philip","Johnny",

    "Emma","Olivia","Ava","Sophia","Isabella","Mia","Charlotte","Amelia","Harper","Evelyn",
    "Abigail","Emily","Ella","Elizabeth","Camila","Luna","Sofia","Avery","Mila","Aria",
    "Scarlett","Penelope","Layla","Chloe","Victoria","Madison","Eleanor","Grace","Nora","Riley",
    "Zoey","Hannah","Hazel","Lily","Ellie","Violet","Lillian","Zoe","Stella","Aurora",
    "Natalie","Emilia","Everly","Leah","Aubrey","Willow","Addison","Lucy","Audrey","Bella",
    "Nova","Brooklyn","Paisley","Savannah","Claire","Skylar","Isla","Genesis","Naomi","Elena",
    "Caroline","Eliana","Anna","Maya","Valentina","Ruby","Kennedy","Ivy","Ariana","Aaliyah",
    "Cora","Madelyn","Alice","Kinsley","Hailey","Gabriella","Allison","Gianna","Serenity","Samantha",
    "Sarah","Autumn","Quinn","Eva","Piper","Sophie","Sadie","Delilah","Josephine","Nevaeh"
)

# Expanded last name list
$lastNames = @(
    "Smith","Johnson","Williams","Brown","Jones","Garcia","Miller","Davis","Rodriguez","Martinez",
    "Hernandez","Lopez","Gonzalez","Wilson","Anderson","Thomas","Taylor","Moore","Jackson","Martin",
    "Lee","Perez","Thompson","White","Harris","Sanchez","Clark","Ramirez","Lewis","Robinson",
    "Walker","Young","Allen","King","Wright","Scott","Torres","Nguyen","Hill","Flores",
    "Green","Adams","Nelson","Baker","Hall","Rivera","Campbell","Mitchell","Carter","Roberts",
    "Gomez","Phillips","Evans","Turner","Diaz","Parker","Cruz","Edwards","Collins","Reyes",
    "Stewart","Morris","Morales","Murphy","Cook","Rogers","Gutierrez","Ortiz","Morgan","Cooper",
    "Peterson","Bailey","Reed","Kelly","Howard","Ramos","Kim","Cox","Ward","Richardson",
    "Watson","Brooks","Chavez","Wood","James","Bennett","Gray","Mendoza","Ruiz","Hughes",
    "Price","Alvarez","Castillo","Sanders","Patel","Myers","Long","Ross","Foster","Jimenez"
)

# Hashtable to track usernames created in this script run
$createdUsers = @{}

for ($i = 1; $i -le 1000; $i++) {
    $firstName = Get-Random -InputObject $firstNames
    $lastName = Get-Random -InputObject $lastNames
    $displayName = "$firstName $lastName"

    # Create username: first initial + last name
    $username = ($firstName.Substring(0,1) + $lastName).ToLower()

    # Remove any spaces or special characters
    $username = $username -replace "[^a-z0-9]", ""

    $baseUsername = $username
    $counter = 1

    # Ensure username is unique in this run and in AD
    while ($createdUsers.ContainsKey($username) -or (Get-ADUser -Filter "SamAccountName -eq '$username'" -ErrorAction SilentlyContinue)) {
        $username = "$baseUsername$counter"
        $counter++
    }

    $createdUsers[$username] = $true

    try {
        New-ADUser `
            -Name $displayName `
            -GivenName $firstName `
            -Surname $lastName `
            -DisplayName $displayName `
            -SamAccountName $username `
            -UserPrincipalName "$username@mydomain.com" `
            -AccountPassword $password `
            -Path $ouPath `
            -Enabled $true `
            -ChangePasswordAtLogon $false

        Write-Host "Created user: $displayName ($username)" -ForegroundColor Green
    }
    catch {
        Write-Host "Failed to create user: $displayName" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Yellow
    }
}
