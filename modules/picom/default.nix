{
  services.picom = {
    enable = true;
    inactiveOpacity = 1;
    activeOpacity = 1;
    settings = {
      corner-radius = 15;
      blur = { 
        method = "gaussian";
        size = 10;
        deviation = 7.0;
      };
    };
    fade = true;
    vSync = true;
    shadow = true;
    fadeDelta = 4;
    fadeSteps = [0.02 0.5];
    backend = "glx";
    opacityRules = [
      "90:class_g = 'Thunar'"
      "90:class_g = 'Spotube'"
      "92:class_g = 'Alacritty'"
      "96:class_g = 'kitty'"
      "92:class_g = 'zen-alpha'"
      "90:class_g = 'vesktop'"
      "80:class_g = 'Nitrogen'"
      "95:class_g = 'TelegramDesktop'"
    ];
  };
}
