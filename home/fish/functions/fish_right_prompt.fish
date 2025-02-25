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
