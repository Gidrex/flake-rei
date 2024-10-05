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
    fadeDelta = 2;
    fadeSteps = [0.02 0.9];
    backend = "glx";
    opacityRules = [
      "96:class_g = 'kitty'"
      "93:class_g = 'TelegramDesktop'"
      "93:class_g = 'Alacritty'"
      "92:class_g = 'Logseq'"
      "92:class_g = 'steam'"
      "94:class_g = 'zen-alpha'"
      "90:class_g = 'Thunar'"
      "90:class_g = 'Spotube'"
      "90:class_g = 'vesktop'"
      "98:class_g = 'AyuGramDesktop'"
      "80:class_g = 'Nitrogen'"
    ];
  };
}
