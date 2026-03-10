<p align="center">
<img src="https://i.imgur.com/pU5A58S.png" alt="Microsoft Active Directory Logo"/>
</p>

<h1>Active Directory Domain Deployment in Azure</h1>
<p>
This project demonstrates deploying an <b>Active Directory Domain Services (AD DS)</b> environment in <b>Microsoft Azure</b> using Windows Server and Windows client virtual machines. The lab includes provisioning Azure infrastructure, configuring networking and DNS, installing and promoting a <b>Domain Controller</b>, and joining a client machine to the domain.
</p>
<p>
It also covers foundational <b>Active Directory</b> administration tasks such as creating organizational units, managing domain users, configuring <b>Group Policy</b>, and verifying domain authentication from a client machine.
</p>


<!--- <h2>Video Demonstration</h2>

- ### [YouTube: How to Deploy on-premises Active Directory within Azure Compute](https://www.youtube.com) -->
<hr>

<h2>Environments and Technologies Used</h2>

- Microsoft Azure (Virtual Machines/Compute)
- Remote Desktop Protocol (RDP)
- Active Directory Domain Services (AD DS)
- PowerShell
- Networking/DNS

<h2>Operating Systems Used </h2>

- Windows Server 2025 Datacenter
- Windows 10 Enterprise (21H2)

<h2>High-Level Deployment and Configuration Steps</h2>
<p><b>This lab simulates an organization’s core identity infrastructure in the cloud by:</b>

- Provisioning Azure infrastructure including a Resource Group, Virtual Network, and Virtual Machines
- Deploying a Windows Server VM and promoting it to a Domain Controller using Active Directory Domain Services (AD DS)
- Configuring static networking and DNS so client machines use the Domain Controller for name resolution
- Creating Active Directory Organizational Units (OUs), users, groups, and administrative accounts
- Joining a Windows client machine to the domain and verifying domain authentication
- Enabling Remote Desktop access for domain users on the client machine
- Using PowerShell to automate the creation of multiple Active Directory user accounts
- Configuring account lockout policies and performing account management tasks such as unlocking accounts, resetting passwords, and enabling or disabling users</p>

<h2>Deployment and Configuration Steps</h2>

<h3>Step 1: Create a Resource Group</h3>
<p>Begin by creating a <b>Resource Group</b>, which will act as a logical container for all Azure resources used in this lab, including the Virtual Network, Domain Controller, and Virtual Machines. 
<br><br>
Ensure the region is the same for resource group, virtual network, and virtual machines. In this lab, we will name the resource group <b>Active-Directory-Lab</b> and the region <b>East US 2</b>.</p>
<img width="800" height="1875" alt="image" src="https://github.com/user-attachments/assets/2e23386a-6936-4577-8c7b-f011c01c52e1" />
<hr>

<h3>Step 2: Create a Virtual Network</h3>
<p>Create a <b>Virtual Network (VNet)</b> to enable network communication between the virtual machines and other resources in this environment. The VNet should be placed in the <b>Resource Group created above (Active-Directory-Lab)</b>. For this lab, the VNet will be deployed in the <b>East US 2</b> region. Ensure that all virtual machines and related resources are deployed in the same region <b>East US 2</b> to allow proper connectivity.</p>
<img width="800" height="1842" alt="image" src="https://github.com/user-attachments/assets/6aeb214f-0e05-49cb-89e5-eea66ee46860" />
<hr>

<h3>Step 3: Create the Domain Controller VM</h3>
<p>Next, create the Domain Controller virtual machine (VM) using Windows Server 2025 Datacenter. Set the computer name to <b>dc-1</b>, region to <b>East US 2</b> and place the virtual machine in the <b>Active-Directory-Lab</b> Resource Group. This virtual machine will host Active Directory Domain Services (AD DS) and will manage authentication, users, and resources within the domain. 
<br><br>
When configuring the virtual machine, create an Administrator account with a username and password that will be used to log into the system via Remote Desktop. Click Next to Networking and ensure the virtual machine is connected to the <b>Active-Directory-VNet</b> Virtual Network created earlier so it can communicate with other machines in the environment. Then click Review & Create.</p>
<img width="800" height="1861" alt="image" src="https://github.com/user-attachments/assets/980ddf0d-477d-4d7b-b4c6-5992e875c13b" />
<img width="800" height="1847" alt="image" src="https://github.com/user-attachments/assets/f2e47d83-68fb-4e5c-bf7c-0bbbbec26bd8" />
<hr>

<h3>Step 4: Configure Static IP for DC-1</h3>
<p>After the Domain Controller virtual machine (dc-1) is created, select the dc-1 VM in Azure and navigate to <b>Networking → Network Settings → Network Interface → ipconfig1</b>.</p>
<img width="800" height="1258" alt="image" src="https://github.com/user-attachments/assets/84854abb-ba39-4eda-aef3-d4f8b231cc72" /><br><br>
<p>From there, set the Network Interface (NIC) Private IP address settings to <b>Static</b> and save the changes. This ensures the Domain Controller always uses the same IP address, which is required for reliable Active Directory and DNS functionality.</p>
<img width="800" height="895" alt="image" src="https://github.com/user-attachments/assets/bd333164-38ab-4895-8ffb-5f3ac5bb2bec" />
<hr>

<h3>Step 5: Disable Windows Firewall</h3>
<p>Next, log into the Domain Controller virtual machine (dc-1) using the Administrator credentials created during the VM setup. Once logged in, disable the Windows Firewall to allow connectivity testing between the virtual machines.
<br><br>
Open the Run dialog, type wf.msc, and press Enter. In the Windows Defender Firewall window, select Windows Defender Firewall Properties, then set the firewall state to Off for the Domain, Private, and Public profiles. This will temporarily allow unrestricted communication between the machines for testing purposes.</p>
<img width="800" height="1562" alt="image" src="https://github.com/user-attachments/assets/ad938225-ecca-4cc0-83d3-438cc7f6d188" />
<hr>

<h3>Step 6: Create the Client VM</h3>
<p>Create the client virtual machine using Windows 10. Set the computer name to <b>client-1</b>, place the virtual machine in the <b>Active-Directory-Lab</b> Resource Group, and connect it to the <b>Active-Directory-VNet</b> Virtual Network. When configuring the virtual machine, create an Administrator account with a username and password that will be used to log into the system via Remote Desktop. This machine will act as a domain client that will later be joined to the Active Directory domain managed by the Domain Controller.</p>
<img width="800" height="1860" alt="image" src="https://github.com/user-attachments/assets/f6cb17d2-18ea-498f-90be-7fd1f698fc5b" />
<hr><br>

<h3>Step 7: Configure DNS for Client-1</h3>
<p>After the client VM (<b>client-1</b>) is created, configure its DNS settings to use the private IP address of the Domain Controller (<b>dc-1</b>).
First, locate the private IP address of <b>dc-1</b>. In Azure, select the <b>dc-1</b> virtual machine and scroll down until you see the <b>Private IP address</b> or navigate to Networking > Network Settings, then note this address.</p>
<img width="1648" height="896" alt="image" src="https://github.com/user-attachments/assets/968ec94d-1f63-4d97-8ba1-8355eb840627" />
<br><br>
<p>Next, configure the client VM (<b>client-1</b>) to use this address as its DNS server. Select the <b>client-1</b> VM in Azure and navigate to <b>Networking → Network Settings → Network Interface → DNS servers</b>. Select <b>Custom</b>, then enter the private IP address of <b>dc-1</b> as the DNS server and save the changes. This allows the client machine to use the Domain Controller for <b>DNS resolution</b> and <b>Active Directory domain services</b>.</p>
<img width="800" height="713" alt="image" src="https://github.com/user-attachments/assets/f45c16b4-6a56-40e3-8fa4-159ad705f6a9" />
<hr>

<h3>Step 8: Restart Client-1</h3>
<p>
After updating the DNS settings, restart the <b>client-1</b> virtual machine to ensure the new DNS configuration takes effect.
<br><br>
In Azure, select the <b>client-1</b> VM and click <b>Restart</b> from the virtual machine overview panel. Once the machine restarts, it will begin using the <b>private IP address of dc-1</b> as its DNS server, allowing it to properly communicate with the Domain Controller for <b>Active Directory</b> and <b>DNS services</b>.
</p>
<img width="800" height="742" alt="image" src="https://github.com/user-attachments/assets/cc7a2fef-cfb9-4468-9839-47b9b09da35d" />
<hr>

<h3>Step 9: Test Connectivity</h3>
<p>
Next, test connectivity between the two machines by logging into <b>client-1</b> and pinging the Domain Controller (<b>dc-1</b>).
<br><br>
Using <b>Remote Desktop</b>, RDP into <b>client-1</b> using its <b>public IP address</b> and the <b>Administrator credentials</b> created during setup. Once logged in, open <b>Command Prompt</b> and run the following command to ping the Domain Controller’s private IP address:
<br><br>
<b>ping 10.0.0.4</b>
<br><br>
If the ping replies successfully, network connectivity between <b>client-1</b> and <b>dc-1</b> is working as expected.
</p>
<img width="800" height="788" alt="image" src="https://github.com/user-attachments/assets/9927c0a2-46a8-482a-b5dd-a791ae54b0e6" />
<hr>

<h3>Step 10: Verify DNS Configuration</h3>
<p>
From <b>client-1</b>, open <b>PowerShell</b> and run the following command:
<br><br>
<b>ipconfig /all</b>
<br><br>
Review the output and locate the <b>DNS Servers</b> field. It should display the <b>private IP address of dc-1 (10.0.0.4)</b>, confirming that <b>client-1</b> is using the Domain Controller for DNS resolution.
</p>
<img width="800" height="854" alt="image" src="https://github.com/user-attachments/assets/14a74eb1-6b23-4b17-ae79-8b413d7a4f13" />
<hr>

<h3>Step 11: Install Active Directory Domain Services</h3>
<p>
Log into <b>DC-1</b> and install <b>Active Directory Domain Services (AD DS)</b>. Open <b>Server Manager</b>, select <b>Add Roles and Features</b>, and install the <b>Active Directory Domain Services</b> role. This will prepare the server to be promoted to a <b>Domain Controller</b>.
</p>
<img width="800" height="1044" alt="image" src="https://github.com/user-attachments/assets/601574d7-4e25-4cd1-8057-28bf5c50eca9" />
<hr>

<h3>Step 12: Promote DC-1 to a Domain Controller</h3>
<p>
After installing <b>Active Directory Domain Services (AD DS)</b>, return to <b>Server Manager</b>. You will see a notification flag indicating that additional configuration is required. Click the notification and select <b>Promote this server to a domain controller</b>.
</p>
<img width="800" height="2092" alt="image" src="https://github.com/user-attachments/assets/2c74efc6-cdb8-46e0-b48f-f65551ef0141" />
<p>
In the <b>Active Directory Domain Services Configuration Wizard</b>, choose <b>Add a new forest</b>. Enter the <b>Root domain name</b> as: <b>mydomain.com</b>. Click <b>Next</b> to continue.
</p>
<img width="800" height="2074" alt="image" src="https://github.com/user-attachments/assets/f8f5bdcb-2dbf-4655-b372-b1a3446b4155" />
<p>
On the <b>Domain Controller Options</b> page:
</p>
<ul>
<li>Leave the <b>Forest functional level</b> and <b>Domain functional level</b> as the default</li>
<li>Ensure <b>DNS Server</b> and <b>Global Catalog</b> are checked</li>
<li>Create a <b>Directory Services Restore Mode (DSRM) password</b>. For this lab, I will be using <b>Password1</b></li>
</ul>
<p>
Click <b>Next</b> through the remaining configuration pages until you reach <b>Install</b>.
</p>
<img width="800" height="2074" alt="image" src="https://github.com/user-attachments/assets/6aa544d7-9079-4c5b-99e1-9cf0cafec375" />
<p>
After the installation completes, the server will automatically restart. Once the system restarts, log back into <b>DC-1</b> using the domain account: <b>mydomain.com\labuser</b> with the same password used during setup.
</p>
<hr>


<h3>Step 13: Create a Domain Administrator Account</h3>
<p>
Log into <b>DC-1</b> as <b>mydomain.com\labuser</b> and open <b>Active Directory Users and Computers (ADUC)</b> from the <b>Tools</b> menu in <b>Server Manager</b> or from the <b>Start Menu</b>.
</p>
<img width="800" height="1772" alt="image" src="https://github.com/user-attachments/assets/c76aa01b-001d-4f5b-a6a5-5f6de485c2d2" />
<p>Create two Organizational Units (OUs):</p>
<ul>
<li><b>_EMPLOYEES</b></li>
<li><b>_ADMINS</b></li>
</ul>
<img width="800" height="1428" alt="image" src="https://github.com/user-attachments/assets/8e39ec52-4920-465f-8ee3-b7d204e37423" />
<p>
Next, create a new domain user inside the <b>_ADMINS</b> OU with the following information:
</p>
<ul>
<li><b>Name:</b> Jane Doe</li>
<li><b>Username:</b> jane_admin</li>
<li><b>Password:</b> Cyberlab123!</li>
</ul>
<img width="800" height="1378" alt="image" src="https://github.com/user-attachments/assets/31b706a8-a603-4446-9627-d56330637620" />
<img width="800" height="1414" alt="image" src="https://github.com/user-attachments/assets/3fffa9e6-d3e6-49b6-b7ce-9995a3df4bc6" />
<p>
Add <b>jane_admin</b> to the <b>Domain Admins</b> security group to grant administrative privileges. Right-click <b>Jane Doe > Properties</b>, select tab <b>Member of</b>, type in <b>Domain Admins</b> and click <b>Check Names</b> then <b>OK</b>. Then <b>Apply</b> and <b>OK</b>.
</p>
<img width="800" height="1418" alt="image" src="https://github.com/user-attachments/assets/24407216-136b-451f-8f4a-c0a1a85ca2b7" />
<img width="800" height="1406" alt="image" src="https://github.com/user-attachments/assets/79d7541c-eb34-4852-8a74-1165ac433e74" />
<p>
Log out of <b>DC-1</b> and log back in using the domain account:
</p>
<p><b>mydomain.com\jane_admin</b></p>
<p>
Use <b>jane_admin</b> as your administrator account for the remainder of the lab.
</p>
<hr>


<h3>Step 14: Join Client-1 to the Domain</h3>
<p>
Log into <b>Client-1</b> using the original local administrator account <b>labuser</b>. Go to <b>Start Menu > Settings > About</b> then click <b>Rename this PC (advanced)</b>. Within the tab <b>Computer Name</b> click <b>Change</b> next to <b>To rename this computer or change its domain or workgroup, click Change</b>. Under <b>Member of > Domain</b>, type in <b>mydomain.com</b> and click <b>OK</b>. You will then be required to login using domain administrator credentials to save the changes. Use <b>mydomain.com\jane_admin</b> and the password you set in the last step (this lab will use <b>Cyberlab123!</b>).
</p>
<p>
After entering the domain administrator credentials, you will see a message stating the computer has been added to the domain and the computer will automatically restart to apply the changes.
</p>
<img width="800" height="2016" alt="image" src="https://github.com/user-attachments/assets/598b81c5-fa0f-4119-a810-6c3fe5368cd3" />
<p>
Next, log back into the <b>Domain Controller (DC-1)</b> and open <b>Active Directory Users and Computers (ADUC)</b>. Verify that <b>Client-1</b> appears in the domain computers list.
</p>
<img width="800" height="1596" alt="image" src="https://github.com/user-attachments/assets/04717e82-9b32-4990-a8d4-f76d4735b8ca" />
<hr>


<h3>Step 15: Organize Client Computers in Active Directory</h3>
<p>
Log into the <b>Domain Controller (DC-1)</b> and open <b>Active Directory Users and Computers (ADUC)</b>.
</p>
<p>
Create a new <b>Organizational Unit (OU)</b> named <b>_CLIENTS</b>.
</p>
<hr>
<img width="800" height="1276" alt="image" src="https://github.com/user-attachments/assets/ec841bd7-94dc-4f31-8374-bde3be4e4c47" />
<p>Once created, locate <b>Client-1</b> in the Computers folder and drag it into the <b>_CLIENTS</b> OU to keep client machines organized within the directory.</p>
<img width="800" height="1064" alt="image" src="https://github.com/user-attachments/assets/4fdf7d24-3e87-47ae-b14e-edb1f328aea1" />
<hr>

<h3>Step 16: Configure Remote Desktop Access Using Group Policy</h3>
<p>
Log into <b>DC-1</b> using the domain administrator account <b>mydomain.com\jane_admin</b>. Open <b>Group Policy Management</b> from the <b>Tools</b> menu in <b>Server Manager</b>.
</p>
<p>
Right-click the <b>_CLIENTS</b> Organizational Unit and select <b>Create a GPO in this domain, and Link it here</b>.
</p>
<p>
Name the policy <b>Allow Remote Desktop</b>.
</p>
<img width="800" height="1226" alt="image" src="https://github.com/user-attachments/assets/19137cc2-aa09-41b7-8aa2-ada680d7e465" />
<p>
Edit the newly created policy by <b>right-clicking → Edit</b> and navigate to:
</p>
<p>
<b>Computer Configuration → Policies → Windows Settings → Security Settings → Local Policies → User Rights Assignment</b>
</p>
<p>
Open <b>Allow log on through Remote Desktop Services</b> and add the group <b>Domain Users</b> by typing in <b>Domain Users</b> and click <b>Check Names</b> then click <b>OK > OK > Apply > OK</b>. This allows non-administrative domain users to log into client machines using Remote Desktop.
</p>
<img width="800" height="2006" alt="image" src="https://github.com/user-attachments/assets/9d7ecdf5-f06b-4388-beff-097a9f0444d2" />
<p>
After creating the policy, log into <b>Client-1</b> as <b>mydomain.com\jane_admin</b> and update the policy by running the following command in PowerShell:
</p>
<pre><code>gpupdate /force</code></pre>
<p>
Once the policy updates, domain users will be able to connect to <b>Client-1</b> using <b>Remote Desktop</b>.
</p>
<img width="800" height="1240" alt="image" src="https://github.com/user-attachments/assets/80fb1eb4-58f3-4980-9bc6-38a0b23e7839" />
<hr>


<h3>Step 17: Create Multiple Domain Users with PowerShell</h3>
<p>
Log into <b>DC-1</b> using the domain administrator account <b>mydomain.com\jane_admin</b>.
</p>
<p>
Open <b>PowerShell ISE</b> as an administrator. Create a new script file and save it as <b>create-employees</b>.
</p>
<img width="800" height="1944" alt="image" src="https://github.com/user-attachments/assets/6f5f62b8-381c-4eae-ba0b-875e262b6cfb" />
<p>Paste the contents of the user creation script (<a href="https://github.com/chrisdegutis/ad-user-creation-script/blob/main/create-active-directory-employees.ps1">found here</a>) into the editor. Note: all user accounts will be created with the password <b>Password1</b>.
</p>
<p>
Click <b>Run</b> to run the script to automatically create 1000 user accounts in the <b>_EMPLOYEES</b> organizational unit (OU) in <b>Active Directory</b> .
</p>
<img width="800" height="1946" alt="image" src="https://github.com/user-attachments/assets/87f05d6c-e5fb-40ac-85c3-6cb3855cf710" />
<hr>


<h3>Step 18: Verify User Accounts in Active Directory</h3>
<p>
Open <b>Active Directory Users and Computers (ADUC)</b> on <b>DC-1</b>.
</p>
<p>
Navigate to the <b>_EMPLOYEES</b> Organizational Unit and confirm that the new user accounts created by the PowerShell script appear in the directory.
</p>
<p>Click on any user, <b>right-click > Properties</b> and go to the <b>Account</b> tab. Note the <b>User logon name</b>. (I will be using <b>mydomain.com\ascott</b> and password <b>Password1</b> for the lab.)</p>
<img width="800" height="2000" alt="image" src="https://github.com/user-attachments/assets/e6995f89-6b1a-4c91-9bee-9df703a2095f" />
<hr>

<h3>Step 19: Test Domain User Login</h3>
<p>
From your local machine, open <b>Remote Desktop Connection</b> and connect to <b>Client-1</b> using its public IP address.
</p>
<p>
When prompted to sign in, enter the following domain credentials:
</p>
<p>
<b>Username:</b> mydomain.com\ascott<br>
<b>Password:</b> password1
</p>
<img width="800" height="1354" alt="image" src="https://github.com/user-attachments/assets/296e0b3c-96a7-488d-b28a-81c9d675c4e9" />
<p>
If the login is successful, this confirms that the user account was created correctly in <b>Active Directory</b> and that <b>Client-1</b> is properly authenticating domain users.
</p>
<img width="800" height="2100" alt="image" src="https://github.com/user-attachments/assets/385ee7f4-8e72-43fd-89bb-ac674d83ba4f" />
<p>
If we open the properties for <b>Adam Scott (ascott)</b> in <b>Active Directory Users and Computers</b> and navigate to the <b>Member Of</b> tab, we can see that the account is a member of the <b>Domain Users</b> group.
</p>
<img width="800" height="1594" alt="image" src="https://github.com/user-attachments/assets/a20cc9da-21d0-4cd4-ae89-58c6ee3ae5ca" />
<p>
In <b>Step 16</b>, we created a <b>Group Policy Object (GPO)</b> that allows members of the <b>Domain Users</b> group to access <b>Client-1</b> using <b>Remote Desktop</b>. Because <b>Adam Scott (ascott)</b> is part of this group, the user is able to successfully log in to the machine.
</p>
<hr>
