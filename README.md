# GOADvSphere
A vSphere deployment of GOADv2 - ALPHA TESTING FOR STABILITY

(Malicious Group Research)
---

# INSTALL FROM WINDOWS - ALPHA TESTING OPEN
## How to install
Download the Packer and Terraform binaries from the following links, and place them in the 'bin' folder.

- https://releases.hashicorp.com/packer/1.10.0/packer_1.10.0_windows_amd64.zip
- https://releases.hashicorp.com/terraform/1.6.6/terraform_1.6.6_windows_amd64.zip

Make sure you have python3 on your Windows machine, and install the **python-terraform** module.

```pip3 install python-terraform```

Download the following 4 ISOs and then upload them to your vSphere datastore (for now - working on automating this step)

- Ubuntu 22.04 : https://drive.proton.me/urls/DT2ZJT2DFG#Hrttx9VrjaC9
- pfSense 2.7.1 : https://drive.proton.me/urls/FA08F8WGTW#cv6IgxiWosxT
- Windows 2016 : https://drive.proton.me/urls/7172RTE1X0#56N0qOH4RVT2
- Windows 2019 : https://drive.proton.me/urls/CFCGGTEKFM#jZ2P1qafnI1R

Once ISOs are uploaded to your datastore, install the infra by using the setup.py script.

```python3 setup.py```

The build will first create some templates from the ISOs above, then it will use those templates to build the infrastructure. Lastly a ansible script will run from the Ubuntu jumpbox setting up all the configuration details for the GOADv2 lab.

***NOTE:***
*IF* you are NOT using the IP range 192.168.1.0/24 for your vSphere 'VM Network' interface, then you will need to change two lines within the pfsense.pkr.hcl file. Lines 82 and 84 will need to be changed to whatever subnet you are using on the 'VM Network' interface. Currently I am using a static IP on the pfSense machine, but this isn't required and I will update this in a future release.

```
82:   "<wait>192.168.1.234<enter>",  (change to a static IP on your range)
83:   "<wait>24<enter>",
84:   "<wait>192.168.1.1<enter>",    (change to the gateway for that range)
```

and also update the config.xml file within the ```/packer/pfsense/files/config.xml``` to reflect the new IP address. Just replace the 192.168.1.234 and 192.168.1.1 with whatever your network is.

The GOADv2 deployment will be created on the OPT1 interface on network 10.20.30.0/24. There is also an optional variable if you want to set a Tailscale Preauth Key for automatic Tailscale intergreation of the GOAD network automatically. The only thing you do is supply your tailscale preauth key during setup.py, and once setup is complete, make sure to allow the subnet routes (10.20.30.0/24) in your Tailscale administration panel. This will allow anyone you provide a key to, to have access to your lab as well.

TODO (in progress): 
- set complex passwords for ansible user (generate with Terraform)
- verify sysprep runs on final reboot to update SID's if not already done in cloning process
- set some rules to pfsense can use user-supplied IP network info if different from 192.168.1.0/24
- debug the OS detection rule to have it build cross-platform from Windows AND Linux
- add an ELK instance running on Ubuntu 22.04 instead of 18.04
- remove OPT1 to WAN access in pfSense, killing internet access after provisioning is 100% complete
- remove Ubuntu jumpbox after provisioning is 100% complete, since it was used purely for ansible compatibility
- add option to change from GOAD to NHA network infrastructure, the work has been done already just needs some tweaking 

---
---


# INSTALL FROM LINUX - DEBUGGING NOW - RELEASE SOON
I am currently working on this, and it should only take a few days to have it automated under one setup.py script.
