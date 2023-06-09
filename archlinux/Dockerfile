FROM archlinux:latest

# Install basic dependencies needed to bootstrap the image.
RUN --mount=type=cache,target=/var/cache/pacman/pkg \
  pacman -Syu --noconfirm git base-devel go

# Create a user and set the working directory.
ARG user=aikow
RUN useradd --system --create-home $user \
  && echo "$user ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/$user
USER $user
WORKDIR /home/$user

# Download and install yay the AUR helper.
# RUN --mount=type=cache,target=${USER}/.cache/go-build \
#   git clone https://aur.archlinux.org/yay.git yay \
#   && cd yay \
#   && makepkg -sri \
#   && cd \
#   && rm -rf yay

# Install base packages.
RUN --mount=type=cache,target=/var/cache/pacman/pkg \
  --mount=type=bind,target=packages,source=archlinux/packages \
  sudo pacman -Syu --noconfirm - <${HOME}/packages

# Clone and install dotfiles.
RUN --mount=type=bind,target=install.conf,source=install.conf \
  git clone https://github.com/aikow/dotfiles.git "${HOME}/.dotfiles" \
  && cd "${HOME}/.dotfiles" \
  && cp ${HOME}/install.conf "${HOME}/.dotfiles/.install.conf" \
  && ./install

# Configure packages.
RUN rustup default stable \
  && nvim --headless "+Lazy sync" +qa
# && vim -c "PlugInstall | qa"

# Set the default command.
CMD ["fish", "--interactive", "--login"]
