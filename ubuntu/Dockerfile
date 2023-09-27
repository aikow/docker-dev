FROM ubuntu:latest

RUN --mount=type=cache,target=~/.cache/yay \
  apt-get update \
  && apt-get upgrade --yes \
  && apt-get install --yes build-essential git sudo

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
  --mount=type=cache,target=/var/cache/apt/archives \
  --mount=type=bind,target=packages,source=ubuntu/packages \
  sudo apt-get install --yes $(grep -v '^#' <$HOME/packages)

# Setup nightly neovim
ARG neovim_sha
RUN git clone https://github.com/neovim/neovim.git \
  && cd neovim \
  && ([ -n $neovim_sha ] && git reset --hard $neovim_sha) \
  && make CMAKE_BUILD_TYPE=Release \
  && sudo make install \
  && cd ..

# Clone and install dotfiles.
RUN --mount=type=bind,target=/app/install.conf,source=install.conf \
  git clone https://github.com/aikow/dotfiles.git "$HOME/.dotfiles" \
  && cd "$HOME/.dotfiles" \
  && cp /app/install.conf "$HOME/.dotfiles/.install.conf" \
  && ./install

# Configure rustup and cargo.
RUN --mount=type=bind,target=packages.cargo,source=ubuntu/packages.cargo \
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
  && $HOME/.cargo/bin/rustup default stable \
  && $HOME/.cargo/bin/cargo install starship 

RUN mkdir -p nu $HOME/.local/bin \
  && curl -L --output nu/nu.tar.gz https://github.com/nushell/nushell/releases/download/0.85.0/nu-0.85.0-x86_64-unknown-linux-gnu.tar.gz \
  && tar -xzf nu/nu.tar.gz -C nu \
  && pwd && ls -al \
  && find $HOME/nu -type f -executable -exec mv {} $HOME/.local/bin/ \; \
  && rm -r $HOME/nu


# Configure packages.
RUN nvim --headless "+Lazy sync" +qa
# && vim -c "PlugInstall | qa"

CMD ["fish", "--interactive", "--login"]
