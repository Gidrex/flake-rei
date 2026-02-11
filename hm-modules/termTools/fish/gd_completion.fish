function __fish_gd_complete_gdrive
    set -l tokens (commandline -opc)
    set -l cmd $tokens[2]
    set -l token (commandline -ct)
    set -l clean_token (string replace -r '^gdrive:' "" -- $token)
    set -l dir (string replace -r '[^/]*$' "" -- $clean_token)

    set -l rclone_args lsf "gdrive:$dir" --fast-list --max-depth 1

    if contains -- $cmd lsd rmd
        set -a rclone_args --dirs-only
    end

    set -l prefix ""
    if contains -- $cmd cp mv sync bisync
        set prefix "gdrive:"
    end

    for item in (rclone $rclone_args 2>/dev/null)
        if string match -r '/$' -- $item
            echo -e "$prefix$dir$item\t(Remote directory)"
        else
            echo -e "$prefix$dir$item\t(Remote file)"
        end
    end
end

set -l gd_commands \
    "init:(Mount gdrive to ~/gdrive)" \
    "ls:(List files lsf)" \
    "lst:(List files full info)" \
    "mv:(Move files)" \
    "sync:(Sync source to dest)" \
    "bisync:(Bidirectional sync)" \
    "rmd:(Remove empty directory)" \
    "cp:(Copy files)" \
    "ln:(Generate shared link)" \
    "size:(Show directory size)" \
    "cat:(Show file content)" \
    "rm:(Delete files)" \
    "help:(Show help)"

for val in $gd_commands
    set -l parts (string split ":" $val)
    complete -c gd -f -n "not __fish_seen_subcommand_from init ls lst mv sync bisync rmd cp ln size cat rm help" -a "$parts[1]" -d "$parts[2]"
end

complete -c gd -f -n "__fish_seen_subcommand_from init ls lst mv sync bisync rmd cp ln size cat rm help" -a "(__fish_gd_complete_gdrive)"
