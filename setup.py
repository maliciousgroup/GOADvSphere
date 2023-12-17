import json
from python_terraform import Terraform, IsFlagged


class GOADBuilder(object):
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

    @staticmethod
    def _return_json_from_dict(config_vars: dict, filename: str) -> bool:
        required_keys = []
        for outer_key, inner_dict in config_vars.items():
            required_keys.append(outer_key)
        if all(config_vars[key]['value'] for key in required_keys if key in config_vars):
            try:
                with open(filename, 'w') as json_file:
                    json.dump(config_vars, json_file, indent=2)
            except (PermissionError, IOError, OSError, TypeError):
                return False
            return True
        return False

    @staticmethod
    def attention_print(msg: str) -> None:
        print(f"\n{'-' * 50}\n{msg}\n{'-' * 50}\n")

    def clean_configuration(self) -> bool:
        required_keys = []
        for outer_key, inner_dict in self.config.items():
            required_keys.append(outer_key)
        for variable in self.config:
            if self.config[variable]["value"]:
                self.config[variable]["value"] = ""
        return self._return_json_from_dict(self.config, "config.json")

    def parse_configuration(self) -> bool:
        required_keys = []
        for outer_key, inner_dict in self.config.items():
            required_keys.append(outer_key)
        for variable in self.config:
            if not self.config[variable]["value"]:
                self.config[variable]["value"] = input(f"--=[ CONFIG ]: {self.config[variable]['description']}: ")
        if self.config["tailscale_preauth_key"]["value"] == "":
            self.config["tailscale_preauth_key"]["value"] = "none"
        return self._return_json_from_dict(self.config, "config.json")

    def build_templates_from_iso(self) -> bool:
        tf = Terraform("terraform/build_templates", terraform_bin_path="bin/terraform.exe")
        return_code, stdout, stderr = tf.init()
        if return_code != 0:
            x = input(f"[x] An error was encountered. Do you want to see output? [Y/n]: ")
            if x.startswith(('Y', 'y', '')):
                print(stderr)
            raise AssertionError(f"Build encountered an error during 'init'\n")
        attempts = 0
        while attempts <= 5:
            attempts += 1
            build_vars = {key: value["value"] for key, value in self.config.items()}
            return_code, stdout, stderr = tf.apply(
                skip_plan=True,
                capture_output=False,
                no_color=IsFlagged,
                refresh=False,
                var=build_vars)
            if return_code != 0:
                self.attention_print(f"[ Retry Number {attempts} ] - Trying again.")
                continue
            else:
                return True
        raise AssertionError(f"Build encountered an error during build_templates 'apply'")

    def build_vms_from_templates(self) -> bool:
        tf = Terraform("terraform/clone_templates", terraform_bin_path="bin/terraform.exe")
        return_code, stdout, stderr = tf.init()
        if return_code != 0:
            x = input(f"[x] An error was encountered. Do you want to see output? [Y/n]: ")
            if x.startswith(('Y', 'y', '')):
                print(stderr)
            raise AssertionError(f"Build encountered an error during 'init'\n")
        attempts = 0
        while attempts <= 3:
            attempts += 1
            build_vars = {key: value["value"] for key, value in self.config.items()}
            return_code, stdout, stderr = tf.apply(
                skip_plan=True,
                capture_output=False,
                no_color=IsFlagged,
                refresh=False,
                var=build_vars)
            if return_code != 0:
                self.attention_print(f"[ Retry Number {attempts} ] - Trying again.")
                continue
            else:
                return True
        raise AssertionError(f"Build encountered an error during clone_templates 'apply'")


if __name__ == '__main__':
    try:
        setup_goad_v2 = GOADBuilder("config.json")
        setup_goad_v2.build_templates_from_iso()
        setup_goad_v2.build_vms_from_templates()
    except AssertionError as e:
        print(f"--=[ FATAL ERROR] - {e.__str__()}")
