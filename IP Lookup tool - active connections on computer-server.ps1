# Import the necessary assembly for Windows Forms
Add-Type -AssemblyName System.Windows.Forms

# Create a form
$form = New-Object Windows.Forms.Form
$form.Text = "IP Address Lookup Tool"
$form.Size = New-Object Drawing.Size(400, 300)

# Create a listbox to display IP addresses
$listBox = New-Object Windows.Forms.ListBox
$listBox.Location = New-Object Drawing.Point(20, 20)
$listBox.Size = New-Object Drawing.Size(200, 200)

# Get active TCP connections
$connections = Get-NetTCPConnection | Where-Object { $_.State -eq 'Established' }

# Populate the listbox with remote IP addresses
$connections | ForEach-Object {
    $listBox.Items.Add($_.RemoteAddress)
}

# Create a button for IP lookup
$buttonLookup = New-Object Windows.Forms.Button
$buttonLookup.Text = "Lookup IP"
$buttonLookup.Location = New-Object Drawing.Point(240, 20)

# Event handler for button click
$buttonLookup.Add_Click({
    $selectedIP = $listBox.SelectedItem
    if ($selectedIP) {
        # Perform IP address lookup (using ip-api.com)
        $ipInfo = Invoke-RestMethod -Uri "http://ip-api.com/json/$selectedIP" -Method Get
        [Windows.Forms.MessageBox]::Show("IP Address: $selectedIP`nOwner: $($ipInfo.org)`nLocation: $($ipInfo.city), $($ipInfo.country)", "IP Lookup Result", [Windows.Forms.MessageBoxButtons]::OK, [Windows.Forms.MessageBoxIcon]::Information)
    } else {
        [Windows.Forms.MessageBox]::Show("Please select an IP address from the list.", "Error", [Windows.Forms.MessageBoxButtons]::OK, [Windows.Forms.MessageBoxIcon]::Error)
    }
})

# Add controls to the form
$form.Controls.Add($listBox)
$form.Controls.Add($buttonLookup)

# Show the form
$form.ShowDialog()
