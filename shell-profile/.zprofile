# Load machine-local credentials without storing them in the dotfiles repository.
private_env="${XDG_CONFIG_HOME:-$HOME/.config}/dotfiles-private/env.sh"
if [[ -r $private_env ]]; then
  source "$private_env"
fi
unset private_env
