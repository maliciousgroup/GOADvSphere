# GOADvSphere
A vSphere deployment of GOADv2 - BETA version 0.1

---

# INSTALL FROM WINDOWS - BETA TESTING
## How to install
Download the Packer and Terraform binaries from the following links, and place them in the 'bin' folder.

- https://releases.hashicorp.com/packer/1.10.0/packer_1.10.0_windows_amd64.zip
- https://releases.hashicorp.com/terraform/1.6.6/terraform_1.6.6_windows_amd64.zip

Make sure you have python3 on your Windows machine, and install the **python-terraform** module.

```pip3 install python-terraform```

Setup the infrastructure by using the setup.py script.

```python3 setup.py```

The build will first create some templates from ISO, then it will use those templates to build the infrastructure. Lastly a ansible script will run from the Ubuntu jumpbox setting up all the configuration details for the GOADv2 lab.

This version of the build automatically downloads the installs the ISOs from our public repo at lab.malicious.group. The templates will be stored on the vSphere datastore and will be used to clone into the GOADv2 infrastructure.



**NOTE:**

This is a clone of the latest GOAD build (v2) from Orange Cyberdefense rebuilt for vSphere infrastructure. Their repo can be found here: https://github.com/Orange-Cyberdefense/GOAD

---

### Todo

- [ ] Build the ```destroy.py``` script to cleanly tear down infrastructure
- [ ] Add logic to detect an available vmnic during vSphere vSwitch setup in ```build_templates/resources.tf``` file 
- [ ] Add option for user to select 'GOAD', 'NHA', or a custom build template during setup
- [ ] Improve the current ansible scripts to improve some stability issues
- [ ] Add a exchange 2019 ansible script to extend the GOAD network to another server running Exchange 2019
