<p align="center">
<img src="https://i.imgur.com/pU5A58S.png" alt="Microsoft Active Directory Logo"/>
</p>

<h1>On-premises Active Directory Deployed in the Cloud (Azure)</h1>
This project demonstrates deploying and managing an Active Directory Domain Services (AD DS) environment in Microsoft Azure using Windows Server and Windows client virtual machines. The lab includes provisioning cloud infrastructure, configuring networking and DNS, installing and promoting a Domain Controller, and joining a client machine to the domain.
<br><br>
It also covers core Active Directory administration tasks, including user and organizational unit management, Group Policy configuration, account lockout policies, and password resets.<br />

<h2>Video Demonstration</h2>

- ### [YouTube: How to Deploy on-premises Active Directory within Azure Compute](https://www.youtube.com)

<h2>Environments and Technologies Used</h2>

- Microsoft Azure (Virtual Machines/Compute)
- Remote Desktop Protocol (RDP)
- Active Directory Domain Services (AD DS)
- PowerShell
- Networking/DNS

<h2>Operating Systems Used </h2>

- Windows Server 2025 Datacenter
- Windows 10 (21H2)

<h2>High-Level Deployment and Configuration Steps</h2>
<p>This lab simulates an organization’s core identity infrastructure in the cloud by:
- Provisioning Azure infrastructure including a Resource Group, Virtual Network, and Virtual Machines
- Deploying a Windows Server VM and promoting it to a Domain Controller using Active Directory Domain Services (AD DS)
- Configuring static networking and DNS so client machines use the Domain Controller for name resolution
- Creating Active Directory Organizational Units (OUs), users, groups, and administrative accounts
- Joining a Windows client machine to the domain and verifying domain authentication
- Enabling Remote Desktop access for domain users on the client machine
- Using PowerShell to automate the creation of multiple Active Directory user accounts
- Configuring account lockout policies and performing account management tasks such as unlocking accounts, resetting passwords, and enabling or disabling users</p>

<h2>Deployment and Configuration Steps</h2>

<b>Step 1</b>
<p>Begin by creating a <b>Resource Group</b>, which will act as a logical container for all Azure resources used in this lab, including the Virtual Network, Domain Controller, and Virtual Machines. 
<br><br>
Ensure the region is the same for resource group, virtual network, and virtual machines. In this lab, we will be using <b>East US 2</b>.</p>
<img width="800" height="1875" alt="image" src="https://github.com/user-attachments/assets/2e23386a-6936-4577-8c7b-f011c01c52e1" />
<hr><br>

<b>Step 2</b>
<p>Create a Virtual Network (VNet) to enable network communication between the virtual machines and other resources in this environment. The VNet should be placed in the Resource Group created above. For this lab, the VNet will be deployed in the East US 2 region. Ensure that all virtual machines and related resources are deployed in the same region to allow proper connectivity.</p>
<img width="800" height="1842" alt="image" src="https://github.com/user-attachments/assets/6aeb214f-0e05-49cb-89e5-eea66ee46860" />
<hr><br>

<b>Step 3</b>
<p>Next, create the Domain Controller virtual machine (VM) using Windows Server 2025 Datacenter. Set the computer name to <b>dc-1</b>, region to <b>East US 2</b> and place the virtual machine in the <b>Active-Directory-Lab</b> Resource Group. This virtual machine will host Active Directory Domain Services (AD DS) and will manage authentication, users, and resources within the domain. 
<br><br>
When configuring the virtual machine, create an Administrator account with a username and password that will be used to log into the system via Remote Desktop. Click Next to Networking and ensure the virtual machine is connected to the <b>Active-Directory-VNet</b> Virtual Network created earlier so it can communicate with other machines in the environment. Then click Review & Create.</p>
<img width="800" height="1861" alt="image" src="https://github.com/user-attachments/assets/980ddf0d-477d-4d7b-b4c6-5992e875c13b" />
<img width="800" height="1847" alt="image" src="https://github.com/user-attachments/assets/f2e47d83-68fb-4e5c-bf7c-0bbbbec26bd8" />
<hr><br>

<b>Step 4</b>
<p>After the Domain Controller virtual machine (dc-1) is created, select the dc-1 VM in Azure and navigate to <b>Networking → Network Settings → Network Interface → ipconfig1</b>.</p>
<img width="800" height="1258" alt="image" src="https://github.com/user-attachments/assets/84854abb-ba39-4eda-aef3-d4f8b231cc72" />
<p>From there, set the Network Interface (NIC) Private IP address settings to <b>Static</b> and save the changes. This ensures the Domain Controller always uses the same IP address, which is required for reliable Active Directory and DNS functionality.</p>
<img width="800" height="1658" alt="image" src="https://github.com/user-attachments/assets/cbe9bb44-7900-4bd6-b555-4a324ac6c467" />
<hr><br>

<b>Step 5</b>
<p>Next, log into the Domain Controller virtual machine (dc-1) using the Administrator credentials created during the VM setup. Once logged in, disable the Windows Firewall to allow connectivity testing between the virtual machines.
<br><br>
Open the Run dialog, type wf.msc, and press Enter. In the Windows Defender Firewall window, select Windows Defender Firewall Properties, then set the firewall state to Off for the Domain, Private, and Public profiles. This will temporarily allow unrestricted communication between the machines for testing purposes.</p>
<img width="800" height="1562" alt="image" src="https://github.com/user-attachments/assets/ad938225-ecca-4cc0-83d3-438cc7f6d188" />
<hr><br>

<b>Step 6</b>
<p>Create the client virtual machine using Windows 10. Set the computer name to <b>client-1</b>, place the virtual machine in the <b>Active-Directory-Lab</b> Resource Group, and connect it to the <b>Active-Directory-VNet</b> Virtual Network. When configuring the virtual machine, create an Administrator account with a username and password that will be used to log into the system via Remote Desktop. This machine will act as a domain client that will later be joined to the Active Directory domain managed by the Domain Controller.</p>
<img width="800" height="1860" alt="image" src="https://github.com/user-attachments/assets/f6cb17d2-18ea-498f-90be-7fd1f698fc5b" />
<hr><br>

<b>Step 7</b>
<p>After the client VM (<b>client-1</b>) is created, configure its DNS settings to use the private IP address of the Domain Controller (<b>dc-1</b>).
First, locate the private IP address of <b>dc-1</b>. In Azure, select the <b>dc-1</b> virtual machine and scroll down until you see the <b>Private IP address</b> or navigate to Networking > Network Settings, then note this address.</p>
<img width="800" height="845" alt="image" src="https://github.com/user-attachments/assets/73b748a3-c000-41e7-b378-fc12566728e8" />
<br><br>
<p>Next, configure the client VM (<b>client-1</b>) to use this address as its DNS server. Select the <b>client-1</b> VM in Azure and navigate to <b>Networking → Network Settings → Network Interface → DNS servers</b>. Select <b>Custom</b>, then enter the private IP address of <b>dc-1</b> as the DNS server and save the changes. This allows the client machine to use the Domain Controller for <b>DNS resolution</b> and <b>Active Directory domain services</b>.</p>
<img width="800" height="713" alt="image" src="https://github.com/user-attachments/assets/f45c16b4-6a56-40e3-8fa4-159ad705f6a9" />
<hr><br>

<b>Step 8</b>
<p>
After updating the DNS settings, restart the <b>client-1</b> virtual machine to ensure the new DNS configuration takes effect.
<br><br>
In Azure, select the <b>client-1</b> VM and click <b>Restart</b> from the virtual machine overview panel. Once the machine restarts, it will begin using the <b>private IP address of dc-1</b> as its DNS server, allowing it to properly communicate with the Domain Controller for <b>Active Directory</b> and <b>DNS services</b>.
</p>
<img width="800" height="742" alt="image" src="https://github.com/user-attachments/assets/cc7a2fef-cfb9-4468-9839-47b9b09da35d" />
<hr><br>

<b>Step 9</b>
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
<hr><br>

<b>Step 10</b>
<p>
From <b>client-1</b>, open <b>PowerShell</b> and run the following command:
<br><br>
<b>ipconfig /all</b>
<br><br>
Review the output and locate the <b>DNS Servers</b> field. It should display the <b>private IP address of dc-1 (10.0.0.4)</b>, confirming that <b>client-1</b> is using the Domain Controller for DNS resolution.
</p>
<img width="800" height="854" alt="image" src="https://github.com/user-attachments/assets/14a74eb1-6b23-4b17-ae79-8b413d7a4f13" />





