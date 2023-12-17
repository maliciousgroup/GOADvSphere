# GOADvSphere
A vSphere deployment of GOADv2 - ALPHA TESTING FOR STABILITY

---

# INSTALL FROM WINDOWS - ALPHA TESTING OPEN
## How to install
Download the Packer and Terraform binaries from the following links, and place them in the 'bin' folder.

- https://releases.hashicorp.com/packer/1.10.0/packer_1.10.0_windows_amd64.zip
- https://releases.hashicorp.com/terraform/1.6.6/terraform_1.6.6_windows_amd64.zip

Make sure you have python3 on your Windows machine, and install the **python-terraform** module.

```pip3 install python-terraform```

Download the following 4 ISOs and then upload them to your vSphere datastore (for now - working on automating this step)

- Ubuntu : https://drive.proton.me/urls/DT2ZJT2DFG#Hrttx9VrjaC9
- pfSense : https://drive.proton.me/urls/FA08F8WGTW#cv6IgxiWosxT
- Windows 2016 : https://drive.proton.me/urls/7172RTE1X0#56N0qOH4RVT2
- Windows 2019 : https://drive.proton.me/urls/CFCGGTEKFM#jZ2P1qafnI1R

Once ISOs are uploaded to your datastore, install the infra by using the setup.py script.

```python3 setup.py```

*IF* you are NOT using the IP range 192.168.1.0/24 for your vSphere 'VM Network' interface, then you will need to change two lines within the pfsense.pkr.hcl file. Lines 82 and 84 will need to be changed to whatever subnet you are using on the 'VM Network' interface. Currently I am using a static IP on the pfSense machine, but this isn't required and I will update this in a future release.

```
82:   "<wait>192.168.1.234<enter>",  (change to a static IP on your range)
83:   "<wait>24<enter>",
84:   "<wait>192.168.1.1<enter>",    (change to the gateway for that range)
```

---


# INSTALL FROM LINUX - DEBUGGING NOW - RELEASE SOON
I am currently working on this, and it should only take a few days to have it automated under one setup.py script.
