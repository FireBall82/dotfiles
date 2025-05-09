function fish_greeting                                            
    echo "aww shit here we go again"
end
function fish_prompt
    echo ' -'$PWD '->'
end
if status is-interactive
    # Commands to run in interactive sessions can go here
end
set -gx EDITOR "nvim"
set -gx VISUAL "nvim"

fastfetch
alias config='cd / && cd etc/nixos && sudo nvim configuration.nix'
alias rebuild='sudo nixos-rebuild switch'
