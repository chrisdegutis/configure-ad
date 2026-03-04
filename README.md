<p align="center">
<img src="https://i.imgur.com/pU5A58S.png" alt="Microsoft Active Directory Logo"/>
</p>

<h1>On-premises Active Directory Deployed in the Cloud (Azure)</h1>
This project demonstrates deploying an Active Directory Domain Services (AD DS) environment inside Microsoft Azure Virtual Machines to simulate a real enterprise identity infrastructure. It walks through provisioning Azure compute resources, configuring networking, installing AD DS, and joining a client VM to a domain.
<br><br>
Both infrastructure setup and domain operations tasks are included, showcasing cloud-based system administration and directory service management that aligns with real-world IT environments.<br />

<h2>What This Project Does</h2>

This lab simulates an organization’s core identity infrastructure in the cloud by:

1. Creating Azure VMs for a Domain Controller and a client machine
2. Installing and promoting the server VM to a Domain Controller
3. Configuring static networking and DNS resolution across VMs
4. Creating AD Organizational Units, users, groups, and domain accounts
5. Joining a client VM to the domain and verifying user authentication
6. Enabling domain-based user login and Remote Desktop access for non-admins
7. Using PowerShell to create multiple users and perform administrative tasks

<h2>Video Demonstration</h2>

- ### [YouTube: How to Deploy on-premises Active Directory within Azure Compute](https://www.youtube.com)

<h2>Environments and Technologies Used</h2>

- Microsoft Azure (Virtual Machines/Compute)
- Remote Desktop
- Active Directory Domain Services
- PowerShell

<h2>Operating Systems Used </h2>

- Windows Server 2025 Datacenter
- Windows 10 (21H2)

<h2>High-Level Deployment and Configuration Steps</h2>

- Step 1
- Step 2
- Step 3
- Step 4

<h2>Deployment and Configuration Steps</h2>

<b>Step 1</b>
<p>Begin by creating a Resource Group, which will act as a logical container for all Azure resources used in this lab, including the Virtual Network, Domain Controller, and Virtual Machines.</p>
<img width="800" height="1875" alt="image" src="https://github.com/user-attachments/assets/2e23386a-6936-4577-8c7b-f011c01c52e1" />
<hr><br>

<b>Step 2</b>
<p>Create a Virtual Network (VNet) to enable network communication between the virtual machines and other resources in this environment. The VNet should be placed in the Resource Group created above. For this lab, the VNet will be deployed in the East US 2 region. Ensure that all virtual machines and related resources are deployed in the same region to allow proper connectivity.
<p><img width="800" height="1842" alt="image" src="https://github.com/user-attachments/assets/6aeb214f-0e05-49cb-89e5-eea66ee46860" /></p>
<hr><br>

<b>Step 3</b>
<p>Create the Domain Controller virtual machine (VM) using Windows Server 2025 Datacenter. Set the computer name to <b>dc-1</b> and place the virtual machine in the <b>Active-Directory-Lab</b> Resource Group. This virtual machine will host Active Directory Domain Services (AD DS) and will manage authentication, users, and resources within the domain. When configuring the virtual machine, create an Administrator account with a username and password that will be used to log into the system via Remote Desktop.</p>
<img width="800" height="1861" alt="image" src="https://github.com/user-attachments/assets/980ddf0d-477d-4d7b-b4c6-5992e875c13b" />
<p>Ensure the virtual machine is connected to the <b>Active-Directory-VNet</b> Virtual Network created earlier so it can communicate with other machines in the environment.</p>
<img width="800" height="1847" alt="image" src="https://github.com/user-attachments/assets/f2e47d83-68fb-4e5c-bf7c-0bbbbec26bd8" />
<hr><br>

<b>Step 4</b>
<p>After the Domain Controller virtual machine (dc-1) is created, select the dc-1 VM in Azure and navigate to <b>Networking → Network Settings → Network Interface → ipconfig1</b>.</p>
<img width="800" height="1258" alt="image" src="https://github.com/user-attachments/assets/84854abb-ba39-4eda-aef3-d4f8b231cc72" />
<p>From there, set the Network Interface (NIC) Private IP address settings to <b>Static</b> and save the changes. This ensures the Domain Controller always uses the same IP address, which is required for reliable Active Directory and DNS functionality.</p>
<img width="800" height="1658" alt="image" src="https://github.com/user-attachments/assets/cbe9bb44-7900-4bd6-b555-4a324ac6c467" />
<hr><br>

<b>Step 5</b>
<p>Create the client virtual machine using Windows 10. Set the computer name to <b>client-1</b>, place the virtual machine in the <b>Active-Directory-Lab</b> Resource Group, and connect it to the <b>Acrive-Directory-VNet</b> Virtual Network. When configuring the virtual machine, create an Administrator account with a username and password that will be used to log into the system via Remote Desktop. This machine will act as a domain client that will later be joined to the Active Directory domain managed by the Domain Controller.</p>
<img width="800" height="1860" alt="image" src="https://github.com/user-attachments/assets/f6cb17d2-18ea-498f-90be-7fd1f698fc5b" />
<img width="800" height="1846" alt="image" src="https://github.com/user-attachments/assets/7819b6e1-77cc-46fa-a7da-173520133c63" />
<hr><br>

<b>Step 6</b>
<p>Next, log into the Domain Controller virtual machine (dc-1) using the Administrator credentials created during the VM setup. Once logged in, disable the Windows Firewall to allow connectivity testing between the virtual machines.
<br>
Open the Run dialog, type wf.msc, and press Enter. In the Windows Defender Firewall window, select Windows Defender Firewall Properties, then set the firewall state to Off for the Domain, Private, and Public profiles. This will temporarily allow unrestricted communication between the machines for testing purposes.</p>
<img width="800" height="1562" alt="image" src="https://github.com/user-attachments/assets/ad938225-ecca-4cc0-83d3-438cc7f6d188" />
<hr><br>

<b>Step 7</b>
<p>First, locate the private IP address of the Domain Controller (dc-1). In Azure, select the dc-1 virtual machine and scroll down until you see the Private IP address, then note this address.
<br>
Next, configure the client virtual machine (client-1) to use this address as its DNS server. Select the client-1 VM in Azure and navigate to <b>Networking → Network Settings → Network Interface → DNS Servers</b>. Select <b>Custom</b>, then enter the private IP address of dc-1 as the DNS server and save the changes. This allows the client machine to use the Domain Controller for DNS resolution and Active Directory domain services.</p>


