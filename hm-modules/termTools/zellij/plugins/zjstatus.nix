{ pkgs, lib, ... }:
{
  programs.zellij.settings.load_plugins._children = [
    {
      "\"https://github.com/dj95/zjstatus/releases/latest/download/zjframes.wasm\""._children = [
        {
          hide_frame_for_single_pane = "true";
          hide_frame_except_for_search = "true";
          hide_frame_except_for_scroll = "true";
          hide_frame_except_for_fullscreen = "true";
        }
      ];
    }
  ];

  xdg.configFile = {
    "zellij/plugins/zjstatus.wasm".source = "${pkgs.zjstatus}/bin/zjstatus.wasm";
  };

  programs.zellij.layouts.custom = {
    layout._children = [
      {
        swap_tiled_layout = {
          _props.name = "vertical";
          _children = [
            {
              tab = {
                _props.max_panes = 5;
                _children = [
                  {
                    pane = {
                      split_direction = "vertical";
                      _children = [
                        { pane = { }; }
                        {
                          pane = {
                            "children" = { };
                          };
                        }
                      ];
                    };
                  }
                ];
              };
            }
            {
              tab = {
                _props.max_panes = 8;
                _children = [
                  {
                    pane = {
                      split_direction = "vertical";
                      _children = [
                        {
                          pane = {
                            "children" = { };
                          };
                        }
                        {
                          pane = {
                            _children = lib.genList (_: { pane = { }; }) 4;
                          };
                        }
                      ];
                    };
                  }
                ];
              };
            }
            {
              tab = {
                _props.max_panes = 12;
                _children = [
                  {
                    pane = {
                      split_direction = "vertical";
                      _children = [
                        {
                          pane = {
                            "children" = { };
                          };
                        }
                        {
                          pane = {
                            _children = lib.genList (_: { pane = { }; }) 4;
                          };
                        }
                        {
                          pane = {
                            _children = lib.genList (_: { pane = { }; }) 4;
                          };
                        }
                      ];
                    };
                  }
                ];
              };
            }
          ];
        };
      }
      {
        swap_tiled_layout = {
          _props.name = "horizontal";
          _children = [
            {
              tab = {
                _props.max_panes = 5;
                _children = [
                  { pane = { }; }
                  { pane = { }; }
                ];
              };
            }
            {
              tab = {
                _props.max_panes = 8;
                _children = [
                  {
                    pane = {
                      _children = [
                        {
                          pane = {
                            split_direction = "vertical";
                            "children" = { };
                          };
                        }
                        {
                          pane = {
                            split_direction = "vertical";
                            _children = lib.genList (_: { pane = { }; }) 4;
                          };
                        }
                      ];
                    };
                  }
                ];
              };
            }
            {
              tab = {
                _props.max_panes = 12;
                _children = [
                  {
                    pane = {
                      _children = [
                        {
                          pane = {
                            split_direction = "vertical";
                            "children" = { };
                          };
                        }
                        {
                          pane = {
                            split_direction = "vertical";
                            _children = lib.genList (_: { pane = { }; }) 4;
                          };
                        }
                        {
                          pane = {
                            split_direction = "vertical";
                            _children = lib.genList (_: { pane = { }; }) 4;
                          };
                        }
                      ];
                    };
                  }
                ];
              };
            }
          ];
        };
      }
      {
        swap_tiled_layout = {
          _props = {
            name = "stacked";
          };
          _children = [
            {
              tab = {
                _props.min_panes = 5;
                _children = [
                  {
                    pane = {
                      split_direction = "vertical";
                      _children = [
                        { pane = { }; }
                        {
                          pane = {
                            stacked = true;
                            "children" = { };
                          };
                        }
                      ];
                    };
                  }
                ];
              };
            }
          ];
        };
      }
      {
        swap_floating_layout = {
          _props.name = "staggered";
          _children = [ { floating_panes = { }; } ];
        };
      }
      {
        swap_floating_layout = {
          _props.name = "enlarged";
          _children = [
            {
              floating_panes = {
                _props.max_panes = 10;
                _children =
                  [ ]
                  ++ (lib.genList (i: {
                    pane = {
                      x = "5%";
                      y = i + 1;
                      width = "90%";
                      height = "90%";
                    };
                  }) 9)
                  ++ [
                    {
                      pane = {
                        focus = true;
                        x = 10;
                        y = 10;
                        width = "90%";
                        height = "90%";
                      };
                    }
                  ];
              };
            }
          ];
        };
      }
      {
        swap_floating_layout = {
          _props.name = "spread";
          _children = [
            {
              floating_panes = {
                _props.max_panes = 1;
                _children = [
                  {
                    pane = {
                      y = "50%";
                      x = "50%";
                    };
                  }
                ];
              };
            }
            {
              floating_panes = {
                _props.max_panes = 2;
                _children = [
                  {
                    pane = {
                      x = "1%";
                      y = "25%";
                      width = "45%";
                    };
                  }
                  {
                    pane = {
                      x = "50%";
                      y = "25%";
                      width = "45%";
                    };
                  }
                ];
              };
            }
            {
              floating_panes = {
                _props.max_panes = 3;
                _children = [
                  {
                    pane = {
                      focus = true;
                      y = "55%";
                      width = "45%";
                      height = "45%";
                    };
                  }
                  {
                    pane = {
                      x = "1%";
                      y = "1%";
                      width = "45%";
                    };
                  }
                  {
                    pane = {
                      x = "50%";
                      y = "1%";
                      width = "45%";
                    };
                  }
                ];
              };
            }
            {
              floating_panes = {
                _props.max_panes = 4;
                _children = [
                  {
                    pane = {
                      x = "1%";
                      y = "55%";
                      width = "45%";
                      height = "45%";
                    };
                  }
                  {
                    pane = {
                      focus = true;
                      x = "50%";
                      y = "55%";
                      width = "45%";
                      height = "45%";
                    };
                  }
                  {
                    pane = {
                      x = "1%";
                      y = "1%";
                      width = "45%";
                      height = "45%";
                    };
                  }
                  {
                    pane = {
                      x = "50%";
                      y = "1%";
                      width = "45%";
                      height = "45%";
                    };
                  }
                ];
              };
            }
          ];
        };
      }
      {
        default_tab_template = {
          _children = [
            {
              pane = {
                size = 2;
                borderless = true;
                plugin = {
                  location = "file://${pkgs.zjstatus}/bin/zjstatus.wasm";
                  format_left = "{mode}#[bg=#1E1E2E] ";
                  format_center = "{tabs}";
                  format_right = "#[bg=#1E1E2E,fg=#96CDFB]#[bg=#96CDFB,fg=#1E1E2E,bold]  #[bg=#585B70,fg=#96CDFB,bold] {session} #[bg=#1E1E2E,fg=#585B70,bold]";
                  format_space = "";
                  format_hide_on_overlength = "true";
                  format_precedence = "crl";

                  border_enabled = "false";
                  border_char = "─";
                  border_format = "#[fg=#6C7086]{char}";
                  border_position = "top";

                  mode_normal = "#[bg=#ABE9B3,fg=#1E1E2E,bold]  NORMAL#[bg=#1E1E2E,fg=#ABE9B3]█";
                  mode_locked = "#[bg=#585B70,fg=#1E1E2E,bold]  LOCKED#[bg=#1E1E2E,fg=#585B70]█";
                  mode_resize = "#[bg=#F28FAD,fg=#1E1E2E,bold] 󰩨 RESIZE#[bg=#1E1E2E,fg=#F28FAD]█";
                  mode_pane = "#[bg=#96CDFB,fg=#1E1E2E,bold]  PANE#[bg=#1E1E2E,fg=#96CDFB]█";
                  mode_tab = "#[bg=#DDB6F2,fg=#1E1E2E,bold] 󰓩 TAB#[bg=#1E1E2E,fg=#DDB6F2]█";
                  mode_scroll = "#[bg=#FAE3B0,fg=#1E1E2E,bold]  SCROLL#[bg=#1E1E2E,fg=#FAE3B0]█";
                  mode_enter_search = "#[bg=#89DCEB,fg=#1E1E2E,bold]  ENT-SEARCH#[bg=#1E1E2E,fg=#89DCEB]█";
                  mode_search = "#[bg=#89DCEB,fg=#1E1E2E,bold] 󱎸 SEARCH#[bg=#1E1E2E,fg=#89DCEB]█";
                  mode_rename_tab = "#[bg=#DDB6F2,fg=#1E1E2E,bold] 󰑕 RENAME-TAB#[bg=#1E1E2E,fg=#DDB6F2]█";
                  mode_rename_pane = "#[bg=#96CDFB,fg=#1E1E2E,bold] 󰑕 RENAME-PANE#[bg=#1E1E2E,fg=#96CDFB]█";
                  mode_session = "#[bg=#89DCEB,fg=#1E1E2E,bold] 󰓫 SESSION#[bg=#1E1E2E,fg=#89DCEB]█";
                  mode_move = "#[bg=#F5C2E7,fg=#1E1E2E,bold] 󰆾 MOVE#[bg=#1E1E2E,fg=#F5C2E7]█";
                  mode_prompt = "#[bg=#89DCEB,fg=#1E1E2E,bold] > PROMPT#[bg=#1E1E2E,fg=#89DCEB]█";
                  mode_tmux = "#[bg=#FAB387,fg=#1E1E2E,bold]  TMUX#[bg=#1E1E2E,fg=#FAB387]█";

                  tab_normal = "#[bg=#1E1E2E,fg=#96CDFB] █#[bg=#96CDFB,fg=#1E1E2E,bold]{index} #[bg=#585B70,fg=#96CDFB,bold] {name}{floating_indicator}#[bg=#1E1E2E,fg=#585B70,bold]█";
                  tab_normal_fullscreen = "#[bg=#1E1E2E,fg=#96CDFB] █#[bg=#96CDFB,fg=#1E1E2E,bold]{index} #[bg=#585B70,fg=#96CDFB,bold] {name}{fullscreen_indicator}#[bg=#1E1E2E,fg=#585B70,bold]█";
                  tab_normal_sync = "#[bg=#1E1E2E,fg=#96CDFB] █#[bg=#96CDFB,fg=#1E1E2E,bold]{index} #[bg=#585B70,fg=#96CDFB,bold] {name}{sync_indicator}#[bg=#1E1E2E,fg=#585B70,bold]󰃨";

                  tab_active = "#[bg=#1E1E2E,fg=#FAB387] █#[bg=#FAB387,fg=#1E1E2E,bold]{index} #[bg=#585B70,fg=#FAB387,bold] {name}{floating_indicator}#[bg=#1E1E2E,fg=#585B70,bold]█";
                  tab_active_fullscreen = "#[bg=#1E1E2E,fg=#FAB387] █#[bg=#FAB387,fg=#1E1E2E,bold]{index} #[bg=#585B70,fg=#FAB387,bold] {name}{fullscreen_indicator}#[bg=#1E1E2E,fg=#585B70,bold]█";
                  tab_active_sync = "#[bg=#1E1E2E,fg=#FAB387] █#[bg=#FAB387,fg=#1E1E2E,bold]{index} #[bg=#585B70,fg=#FAB387,bold] {name}{sync_indicator}#[bg=#1E1E2E,fg=#585B70,bold]█";

                  tab_separator = "#[bg=#1E1E2E] &";

                  tab_sync_indicator = "󰃨";
                  tab_fullscreen_indicator = "󰊓";
                  tab_floating_indicator = "󰹙";

                  command_git_branch_command = "git rev-parse --abbrev-ref HEAD";
                  command_git_branch_format = "#[fg=blue] {stdout} ";
                  command_git_branch_interval = "10";
                  command_git_branch_rendermode = "static";

                  datetime = "#[fg=#6C7086,bold] {format} ";
                  datetime_format = "%A, %d %b %Y %H:%M";
                  datetime_timezone = "Europe/Moscow";
                };
              };
            }
            { "children" = { }; }
          ];
        };
      }
    ];

  };
}
