{ pkgs, ... }: {
  programs.mpv = {
    enable = true;
    config = {
      # Video & Wayland
      vo = "gpu,wlshm";
      gpu-context = "wayland";
      hwdec = "auto-safe";
      profile = "gpu-hq";
      force-window = "immediate";

      # Quality
      scale = "ewa_lanczossharp";
      cscale = "ewa_lanczossharp";
      dscale = "mitchell";
      interpolation = "yes";
      video-sync = "display-resample";
      tscale = "oversample";

      # Audio (High-End FLAC)
      ao = "pipewire,alsa";
      audio-channels = "stereo";
      audio-format = "s32";
      audio-samplerate = 0;
      af = "lavfi=[aresample=resampler=soxr:precision=28]";
      gapless-audio = "yes";

      # General
      volume = 100;
      volume-max = 130;
      replaygain = "no";
      save-position-on-quit = "yes";
      keep-open = "yes";

      # Subtitles & UI
      sub-auto = "fuzzy";
      sub-font = "SauceCodePro Nerd Font Mono";
      sub-font-size = 36;
      osd-font = "SauceCodePro Nerd Font Mono";
      osd-bar = "no";
      border = "no";
    };

    scripts = with pkgs.mpvScripts; [
      mpris
      uosc
      thumbfast
    ];

    scriptOpts = {
      uosc = {
        top_bar = "always";
        top_bar_controls = "yes";
        top_bar_title = "yes";
        click_threshold = 250;
        double_click_threshold = 300;
      };
    };
  };

  catppuccin.mpv.enable = true;
}
