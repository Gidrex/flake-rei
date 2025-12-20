function __fish_gd_complete_gdrive
    set -l tokens (commandline -opc)
    set -l cmd $tokens[2]
    set -l token (commandline -ct)
    # Remove gdrive: prefix if present for listing
    set -l clean_token (string replace -r '^gdrive:' "" -- $token)
    set -l dir (string replace -r '[^/]*$' "" -- $clean_token)

    set -l rclone_args lsf "gdrive:$dir" --fast-list --max-depth 1

    if contains -- $cmd lsd rmd
        set -a rclone_args --dirs-only
    end

    set -l prefix ""
    # For multi-arg commands, force gdrive: prefix
    if contains -- $cmd cp mv sync bisync
        set prefix "gdrive:"
    end

    for item in (rclone $rclone_args 2>/dev/null)
        echo "$prefix$dir$item"
    end
end

set -l cmds init ls lst ls mv sync bisync rmd cp ln size cat rm help
complete -c gd -f -n "not __fish_seen_subcommand_from $cmds" -a "$cmds"
complete -c gd -f -n "__fish_seen_subcommand_from $cmds" -a "(__fish_gd_complete_gdrive)"
