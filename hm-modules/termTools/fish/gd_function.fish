# gd function
function gd
    set cmd $argv[1]
    set -e argv[1]

    # Helper to prefix args with gdrive: if needed (skips flags)
    function __gd_run_remote
        set -l rclone_cmd $argv[1]
        set -e argv[1]
        set -l args
        for arg in $argv
            set -l processed_arg "$arg" # Default to original arg
            if not string match -q -- "-*" "$arg" # If not a flag
                if not string match -q -- "gdrive:*" "$arg" # And not already gdrive:
                    set processed_arg "gdrive:$arg" # Then add gdrive:
                end
            end
            set -a args "$processed_arg"
        end
        rclone $rclone_cmd $args
    end

    switch $cmd
        case init
            rclone mount gdrive: ~/gdrive \
                --vfs-cache-mode full \
                --vfs-cache-max-size 10G \
                --vfs-cache-max-age 24h \
                --dir-cache-time 1h \
                --poll-interval 15s \
                --vfs-read-chunk-size 32M \
                --vfs-read-chunk-size-limit 2G \
                --daemon
        case ls
            __gd_run_remote lsf $argv
        case lst
            __gd_run_remote ls $argv
        case mv
            rclone move $argv --progress
        case sync
            rclone sync $argv --progress
        case bisync
            rclone bisync $argv --progress
        case rmd
            __gd_run_remote rmdir $argv
        case cp
            rclone copy $argv --progress
        case ln
            __gd_run_remote link $argv
        case size
            __gd_run_remote size $argv
        case cat
            __gd_run_remote cat $argv
        case rm
            __gd_run_remote delete $argv --progress
        case help '*'
            echo "gdrive commands:"
            echo "  init             - Mounts the gdrive remote to ~/gdrive."
            echo "  lsd <path>       - Lists directories."
            echo "  ls <path>        - Lists files."
            echo "  cat <path>       - Concatenates file."
            echo "  rm <path>        - Deletes file."
            echo "  cp <src> <dst>   - Copies files (use gdrive: prefix for remote)."
            echo "  mv <src> <dst>   - Moves files (use gdrive: prefix for remote)."
            echo "  sync <src> <dst> - Synchronizes source to dest."
    end
end
