# This file is sourced on login shells only (responsible for setting up the
# initial environment)

set -gx PATH /bin
append-to-path /sbin
append-to-path /usr/bin
append-to-path /usr/sbin
append-to-path ~/bin
prepend-to-path /usr/local/sbin
prepend-to-path /usr/local/bin

# Set locale
set -gx LC_ALL en_US.UTF-8
set -gx LANG en_US.UTF-8
