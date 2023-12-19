rem Custom networking rules
rem reg ADD HKLM\SYSTEM\CurrentControlSet\Control\Network\NewNetworkWindowOff /f
rem netsh advfirewall firewall set rule group="Network Discovery" new enable=Yes
rem netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=Yes
rem netsh advfirewall set privateprofile state on