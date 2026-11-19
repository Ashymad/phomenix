{ config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    lm_sensors
    fan2go
  ];

  systemd.services = {
    lm_sensors = {
      enable = true;
      wantedBy = [ "multi-user.target" ];
      description = "Initialize hardware monitoring sensors";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.lm_sensors}/bin/sensors -s";
      };
    };

    fan2go = {
      enable = true;
      wantedBy = [ "multi-user.target" ];
      after = [ "lm_sensors.service" ];
      description = "fan2go hardware fan control daemon";
      path = [ pkgs.getent ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.fan2go}/bin/fan2go";
        RestartPreventExitStatus = "78";
        AmbientCapabilities = "CAP_SYS_RAWIO";
      };
    };
  };

  environment.etc."fan2go/fan2go.yaml".text = lib.generators.toYAML { } {
    sensors = [
      {
        id = "cpu_package";
        hwmon = {
          platform = "coretemp";
          channel = 1;
        };
      }
      {
        id = "gpu_junction";
        hwmon = {
          platform = "amdgpu";
          channel = 2;
        };
      }
      {
        id = "gpu_edge";
        hwmon = {
          platform = "amdgpu";
          channel = 1;
        };
      }
    ];
    fans = [
      {
        id = "gpu";
        hwmon = {
          platform = "amdgpu";
          rpmChannel = 1;
        };
        neverStop = true;
        curve = "gpu_curve";
      }
      {
        id = "cpu";
        hwmon = {
          platform = "nct6796";
          rpmChannel = 1;
        };
        neverStop = true;
        curve = "cpu_curve";
      }
      {
        id = "case";
        hwmon = {
          platform = "nct6796";
          rpmChannel = 2;
        };
        neverStop = false;
        curve = "case_curve";
      }
    ];
    curves = [
      {
        id = "cpu_curve";
        linear = {
          sensor = "cpu_package";
          steps = [
            { "40" = "0%"; }
            { "41" = "1%"; }
            { "50" = "20%"; }
            { "80" = "100%"; }
          ];
        };
      }
      {
        id = "gpu_curve";
        linear = {
          sensor = "gpu_junction";
          steps = [
            { "60" = "5%"; }
            { "75" = "50%"; }
            { "90" = "100%"; }
          ];
        };
      }
      {
        id = "case_curve";
        linear = {
          sensor = "gpu_edge";
          steps = [
            { "60" = "15%"; }
            { "75" = "30%"; }
            { "90" = "100%"; }
          ];
        };
      }
    ];
  };
}
