zoxide init fish | source

abbr -a yr 'cal -y'
abbr -a c cargo
abbr -a vi nvim
abbr -a e nvim
abbr -a m make
abbr -a o open
abbr -a g git
abbr -a gc 'git checkout'
abbr -a ga 'git add -p'
abbr -a vimdiff 'nvim -d'
abbr -a ct 'cargo t'
abbr -a gah 'git stash; and git pull --rebase; and git stash pop'
abbr -a ks 'keybase chat send'
abbr -a kr 'keybase chat read'
abbr -a kl 'keybase chat list'
abbr -a pr 'gh pr create -t (git show -s --format=%s HEAD) -b (git show -s --format=%B HEAD | tail -n+3)'

if status --is-interactive
    if test -d ~/dev/others/base16/templates/fish-shell
        set fish_function_path $fish_function_path ~/dev/others/base16/templates/fish-shell/functions
        builtin source ~/dev/others/base16/templates/fish-shell/conf.d/base16.fish
    end
    # if ! set -q TMUX
    #     exec tmux
    # end
end

if command -v brew >/dev/null
    abbr -a b brew
    abbr -a bi 'brew install'
    abbr -a bu 'brew update'
    abbr -a bup 'brew upgrade'
    abbr -a bdoc 'brew doctor'
end

if command -v eza >/dev/null
    abbr -a l eza
    abbr -a ls eza
    abbr -a ll 'eza -l'
    abbr -a lll 'eza -la'
else
    abbr -a l ls
    abbr -a ll 'ls -l'
    abbr -a lll 'ls -la'
end

if test -f /opt/homebrew/share/autojump/autojump.fish
    source /opt/homebrew/share/autojump/autojump.fish
end

function pwl
    set -Ux OP_SESSION_my (pw signin my --raw)
end

function ssh
    switch $argv[1]
        case "ubuntu@"
            env TERM=xterm /usr/bin/ssh $argv
        case "*"
            /usr/bin/ssh $argv
    end
end

function apass
    if test (count $argv) -ne 1
        pass $argv
        return
    end

    asend (pass $argv[1] | head -n1)
end

function qrpass
    if test (count $argv) -ne 1
        pass $argv
        return
    end

    qrsend (pass $argv[1] | head -n1)
end


function qrsend
    if test (count $argv) -ne 1
        echo "No argument given"
        return
    end

    qrencode -o - $argv[1] | feh --geometry 500x500 --auto-zoom -
end


# function remote_alacritty
#     # https://gist.github.com/costis/5135502
#     set fn (mktemp)
#     infocmp alacritty >$fn
#     scp $fn $argv[1]":alacritty.ti"
#     ssh $argv[1] tic "alacritty.ti"
#     ssh $argv[1] rm "alacritty.ti"
# end

# function remarkable
#     if test (count $argv) -lt 1
#         echo "No files given"
#         return
#     end

#     ip addr show up to 10.11.99.0/29 | grep enp0s20f0u2 >/dev/null
#     if test $status -ne 0
#         # not yet connected
#         echo "Connecting to reMarkable internal network"
#         sudo dhcpcd enp0s20f0u2
#     end
#     for f in $argv
#         echo "-> uploading $f"
#         curl --form "file=@\""$f"\"" http://10.11.99.1/upload
#         echo
#     end
#     sudo dhcpcd -k enp2s0f0u3
# end

# Type - to move up to top parent dir which is a repository
function d
    while test $PWD != /
        if test -d .git
            break
        end
        cd ..
    end
end

# Fish git prompt
set __fish_git_prompt_showuntrackedfiles yes
set __fish_git_prompt_showdirtystate yes
set __fish_git_prompt_showstashstate ''
set __fish_git_prompt_showupstream none
set -g fish_prompt_pwd_dir_length 3

# colored man output
# from http://linuxtidbits.wordpress.com/2009/03/23/less-colors-for-man-pages/
setenv LESS_TERMCAP_mb \e'[01;31m' # begin blinking
setenv LESS_TERMCAP_md \e'[01;38;5;74m' # begin bold
setenv LESS_TERMCAP_me \e'[0m' # end mode
setenv LESS_TERMCAP_se \e'[0m' # end standout-mode
setenv LESS_TERMCAP_so \e'[38;5;246m' # begin standout-mode - info box
setenv LESS_TERMCAP_ue \e'[0m' # end underline
setenv LESS_TERMCAP_us \e'[04;38;5;146m' # begin underline

setenv FZF_DEFAULT_COMMAND 'fd --type file --follow'
setenv FZF_CTRL_T_COMMAND 'fd --type file --follow'
setenv FZF_DEFAULT_OPTS '--height 20%'


function fish_user_key_bindings
    bind \cz 'fg>/dev/null ^/dev/null'
    if functions -q fzf_key_bindings
        fzf_key_bindings
    end
end

if test (hostname -s) = Dikshants-MacBook-Air
    set -g fish_prompt_hostname LittleEle
else
    set -g fish_prompt_hostname (hostname -s)
end


function fish_prompt
    set_color brblack
    echo -n "["(date "+%H:%M")"] "
    set_color blue
    echo -n $fish_prompt_hostname
    if [ $PWD != $HOME ]
        set_color brblack
        echo -n ':'
        set_color yellow
        echo -n (basename $PWD)
    end
    set_color green
    printf '%s ' (__fish_git_prompt)
    set_color red
    echo -n '| '
    set_color normal
end

function fish_greeting
    echo
    echo -e (uname -ro | awk '{print " \\\\e[1mOS: \\\\e[0;32m"$0"\\\\e[0m"}')
    echo -e (uptime | grep -o 'up [0-9]* days [0-9]*:[0-9]*' | cut -c 4- | awk '{print " \\\\e[1mUptime: \\\\e[0;32m"$0"\\\\e[0m"}')
    echo -e (uname -n | awk '{print " \\\\e[1mHostname: \\\\e[0;32m"$0"\\\\e[0m"}')
    echo -e " \\e[1mDisk usage:\\e[0m"
    echo
    echo -ne (\
        df -l -h | grep -E 'dev/(disk1s3|disk3s1s1|mapper)' | \
        awk '{printf "\\\\t%s\\\\t%4s / %4s  %s\\\\n\n", $6, $3, $2, $5}' | \
        sed -e 's/^\(.*\([8][5-9]\|[9][0-9]\)%.*\)$/\\\\e[0;31m\1\\\\e[0m/' -e 's/^\(.*\([7][5-9]\|[8][0-4]\)%.*\)$/\\\\e[0;33m\1\\\\e[0m/' | \
        paste -sd ''\
    )
    echo
    echo -e " \\e[1mNetwork:\\e[0m"
    echo
    # Get private IP
    set -l private_ip (ipconfig getifaddr en0)
    if test -n "$private_ip"
        echo -e "\\tPrivate IP: \\e[0;30m$private_ip\\e[0m"
    else
        echo -e "\\t\e[0;31mNo private IP address found\\e[0m"
    end
    # Get public IP
    set -l public_ip (curl -s -4 ifconfig.me)
    if test -n "$public_ip"
        echo -e "\\tPublic IP:  \\e[4;33m$public_ip\\e[0m" # Underlined public IP
    else
        echo -e "\\t\e[0;31mNo public IP address found\\e[0m"
    end

    echo
    set r (random 0 100)
    if [ $r -lt 5 ] # only occasionally show backlog (5%)
        echo -e " \e[1mBacklog\e[0;32m"
        set_color blue
        echo "  [project] <description>"
        echo
    end

    set_color normal
    echo -e " \e[1mTODOs\e[0;32m"
    echo
    if [ $r -lt 10 ]
        # unimportant, so show rarely
        set_color cyan
        # echo "  [project] <description>"
    end
    if [ $r -lt 25 ]
        # back-of-my-mind, so show occasionally
        set_color green
        # echo "  [project] <description>"
    end
    if [ $r -lt 50 ]
        # upcoming, so prompt regularly
        set_color yellow
        # echo "  [project] <description>"
    end

    # urgent, so prompt always
    set_color red
    # echo "  [project] <description>"

    echo

    if test -s ~/todo
        set_color magenta
        cat todo | sed 's/^/ /'
        echo
    end

    set_color normal
end
