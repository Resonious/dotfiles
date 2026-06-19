# Jail color scheme - orange/red tint to distinguish from host
set -g fish_color_user ff8700
set -g fish_color_host ff5f00
set -g fish_color_cwd ffaf00
set -g fish_color_command ff8700
set -g fish_color_param d7af87
set -g fish_color_error ff0000
set -g fish_color_comment 808080
set -g fish_color_autosuggestion 585858
set -g fish_color_valid_path --underline

# Explicit orange/red prompt. Defined as a function so the jail is
# unmistakably colored regardless of fish's default-prompt internals or
# color-variable scoping quirks.
function fish_prompt
    set -l last_status $status
    set_color ff5f00
    echo -n (whoami)
    set_color ff8700
    echo -n '@'(prompt_hostname)' '
    set_color ffaf00
    echo -n (prompt_pwd)
    set_color normal
    echo -n (fish_vcs_prompt)
    if test $last_status -ne 0
        set_color ff0000
        echo -n ' ['$last_status']'
    end
    set_color ff8700
    echo -n ' # '
    set_color normal
end

fish_add_path ~/.local/bin ~/.npm-global/bin ~/.cargo/bin
alias claude="claude --dangerously-skip-permissions"

if type -q mise
    mise activate fish | source
end
