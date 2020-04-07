# homebrew
brewPrefix=""

case "$(uname)" in
  "Darwin")
    brewPrefix="/usr/local"
    ;;
  "Linux")
    brewPrefix="/home/linuxbrew/.linuxbrew"
    if [ ! -d "$brewPrefix" ]; then
      brewPrefix="/home/$USER/.linuxbrew"
    fi
esac

if [ -f "$brewPrefix/bin/brew" ]; then
  eval $($brewPrefix/bin/brew shellenv)
fi
