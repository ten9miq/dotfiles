. ~/.config/fish/aliases.fish

# Globals
set -gx EDITOR vim

# Interactive/login shells
if status --is-login
    . ~/.config/fish/env.fish
end
