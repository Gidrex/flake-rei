{ pkgs, ... }:
{
  programs.mpv = {
    enable = true;
    config = {
      # Video
      vo = "gpu,wlshm";
      gpu-context = "wayland";
      hwdec = "auto-safe";
      profile = "gpu-hq";

      # Quality Settings (work only if gpu VO is active)
      scale = "ewa_lanczossharp";
      cscale = "ewa_lanczossharp";
      dscale = "mitchell";
      interpolation = "yes";
      video-sync = "display-resample";
      tscale = "oversample";

      # Audio
      ao = "pipewire,alsa";
      audio-channels = "stereo";
      audio-format = "s32";
      audio-samplerate = 0;

      # High quality resampler (Explicit precision)
      af = "lavfi=[aresample=resampler=soxr:precision=28]";
      gapless-audio = "yes";

      # General
      volume = 100;
      volume-max = 130;
      replaygain = "no";
      save-position-on-quit = "yes";
      keep-open = "yes";
      force-window = "immediate";

      # UI & Subtitles
      osd-font = "SauceCodePro Nerd Font Mono";
      sub-font = "SauceCodePro Nerd Font Mono";
      sub-auto = "fuzzy";
    };

    scripts = with pkgs.mpvScripts; [
      mpris
    ];
  };

  catppuccin.mpv.enable = true;
}
