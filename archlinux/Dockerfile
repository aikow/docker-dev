FROM archlinux:latest

# Install basic dependencies needed to bootstrap the image.
RUN --mount=type=cache,target=/var/cache/pacman/pkg \
  pacman -Syu --noconfirm git base-devel

# Create a user and set the working directory.
ARG user=aikow
ARG uid=1000
ARG gid=1000
RUN groupadd --gid $gid $user \
  && useradd --system --create-home --uid $uid --gid $gid $user \
  && echo "$user ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/$user
USER $user
WORKDIR /home/$user

# Install base packages.
RUN \
  --mount=type=cache,target=/var/cache/pacman/pkg \
  --mount=type=bind,target=packages,source=archlinux/packages \
  sudo pacman -Syu --noconfirm - < <(grep -v '^#' <$HOME/packages)

# Setup nightly neovim
ARG neovim_sha
RUN git clone https://github.com/neovim/neovim.git \
  && cd neovim \
  && ([[ -n $neovim_sha ]] && git reset --hard $neovim_sha) \
  && make CMAKE_BUILD_TYPE=Release \
  && sudo make install \
  && cd ..

# Clone and install dotfiles.
RUN --mount=type=bind,target=install.conf,source=install.conf \
  git clone https://github.com/aikow/dotfiles.git "$HOME/.dotfiles" \
  && cd $HOME/.dotfiles \
  && cp $HOME/install.conf "$HOME/.dotfiles/.install.conf" \
  && ./install \
  && cd ..

# Configure packages.
RUN rustup default stable \
  && nvim --headless "+Lazy sync" +qa
# && vim -c "PlugInstall | qa"

# Set the default command.
CMD ["fish", "--interactive", "--login"]
