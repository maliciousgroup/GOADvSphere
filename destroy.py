import os
import json
import subprocess


class GOADDestroyer(object):
    def __init__(self, config: str):
        self.config: dict = self._return_dict_from_json(config)
        if not self.config:
            raise AssertionError("No configuration file found")

    @staticmethod
    def _return_dict_from_json(json_file: str) -> dict:
        try:
            with open(json_file, 'r') as file:
                return json.load(file)
        except (json.JSONDecodeError, FileNotFoundError, IOError, UnicodeDecodeError):
            return {}

    def parse_configuration(self) -> None:
        required_keys = []
        for outer_key, inner_dict in self.config.items():
            required_keys.append(outer_key)
        for variable in self.config:
            if not self.config[variable]["value"]:
                self.config[variable]["value"] = input(f"--=[ CONFIG ]: {self.config[variable]['description']}: ")
        if self.config["tailscale_preauth_key"]["value"] == "":
            self.config["tailscale_preauth_key"]["value"] = "none"

    def destroy_vms_from_vsphere(self) -> bool:
        a = self.config
        os.chdir(os.path.dirname(os.path.abspath(__file__)))
        terraform_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "bin", "terraform.exe")
        destroy_vms = f"{terraform_path} -chdir=terraform/clone_templates destroy " \
                      f"-var vsphere_server={a['vsphere_server']['value']} " \
                      f"-var vsphere_username={a['vsphere_username']['value']} " \
                      f"-var vsphere_password={a['vsphere_password']['value']} " \
                      f"-var vsphere_esxi_host={a['vsphere_esxi_host']['value']} " \
                      f"-var vsphere_datacenter={a['vsphere_datacenter']['value']} " \
                      f"-var vsphere_datastore={a['vsphere_datastore']['value']} " \
                      f"-var http_file_host={a['http_file_host']['value']} "\
                      f"-var tailscale_preauth_key={a['tailscale_preauth_key']['value']} " \
                      f"--auto-approve"
        result = subprocess.run(destroy_vms, shell=True, check=True, stdout=subprocess.PIPE, text=True)
        if result.returncode != 0:
            print(f"[x] Failed to destroy\n{result.stderr}")
            return False
        print(result.stdout)
        return True

    def destroy_infrastructure(self) -> bool:
        a = self.config
        os.chdir(os.path.dirname(os.path.abspath(__file__)))
        terraform_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "bin", "terraform.exe")
        destroy_vms = f"{terraform_path} -chdir=terraform/build_templates destroy " \
                      f"-var vsphere_server={a['vsphere_server']['value']} " \
                      f"-var vsphere_username={a['vsphere_username']['value']} " \
                      f"-var vsphere_password={a['vsphere_password']['value']} " \
                      f"-var vsphere_esxi_host={a['vsphere_esxi_host']['value']} " \
                      f"-var vsphere_datacenter={a['vsphere_datacenter']['value']} " \
                      f"-var vsphere_datastore={a['vsphere_datastore']['value']} " \
                      f"-var http_file_host={a['http_file_host']['value']} "\
                      f"-var tailscale_preauth_key={a['tailscale_preauth_key']['value']} " \
                      f"--auto-approve"
        result = subprocess.run(destroy_vms, shell=True, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        if result.returncode != 0:
            print(f"[x] Failed to destroy\n{result.stderr}")
            return False
        print(result.stdout)
        return True


if __name__ == '__main__':
    try:
        print(f"[!] You are about to destroy any existing GOADv2 (vSphere) VMs and Infrastructure...")
        x = input(f"Are you sure? [N/y]: ")
        if x.startswith(('y', 'Y')):
            destroy_goad_v2 = GOADDestroyer("config.json")
            destroy_goad_v2.parse_configuration()
            destroy_goad_v2.destroy_vms_from_vsphere()
            destroy_goad_v2.destroy_infrastructure()
    except AssertionError as e:
        print(f"--=[ FATAL ERROR] - {e.__str__()}")
