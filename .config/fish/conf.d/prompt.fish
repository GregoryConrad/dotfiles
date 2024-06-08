function fish_prompt
    set cells
    set bg_colors
    set fg_colors
    set default_fg_color 444

    # Time
    set -a cells (date +'%H:%M')
    set -a fg_colors $default_fg_color
    set -a bg_colors dfdfff

    # Working directory
    if set git_root (git rev-parse --show-toplevel 2> /dev/null)
        set repo_name (string replace "$(dirname $git_root)/" '' $PWD)
        set -a cells " $repo_name"
        set -a fg_colors $default_fg_color
        set -a bg_colors 5fd7ff
    else
        set -a cells (prompt_pwd --full-length-dirs 2)
        set -a fg_colors $default_fg_color
        set -a bg_colors 87afff
    end

    # Git branch
    set branch (git symbolic-ref HEAD 2> /dev/null | awk 'BEGIN{FS="/"} {print $NF}')
    if test -n "$branch"
        set -a cells " $(set_color -o $default_fg_color)$branch"
        set -a fg_colors $default_fg_color
        set -a bg_colors d787ff
    end

    # Build the prompt
    set -a bg_colors normal # reset after last cell
    while test (count $cells) -ne 0
        set cell $cells[1]
        set -e cells[1]
        set fg_color $fg_colors[1]
        set -e fg_colors[1]
        set bg_color $bg_colors[1]
        set -e bg_colors[1]
        set next_bg_color $bg_colors[1]
        printf "%s $cell %s" \
            "$(set_color -b $bg_color)$(set_color $fg_color)" \
            "$(set_color -b $next_bg_color)$(set_color $bg_color)"
    end
    printf "$(set_color normal) "
end

function fish_right_prompt
    if test "$fish_key_bindings" = fish_vi_key_bindings
        or test "$fish_key_bindings" = fish_helix_key_bindings
        or test "$fish_key_bindings" = fish_hybrid_key_bindings
        switch $fish_bind_mode
            case default
                set_color --bold red
                echo '[N]'
            case insert
                set_color --bold green
                echo '[I]'
            case replace_one
                set_color --bold green
                echo '[R]'
            case replace
                set_color --bold cyan
                echo '[R]'
            case visual
                set_color --bold magenta
                echo '[V]'
        end
        set_color normal
    end
end
