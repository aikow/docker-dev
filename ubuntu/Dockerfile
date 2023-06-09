FROM ubuntu:latest

RUN --mount=type=cache,target=~/.cache/yay \
  pacman -Syu --noconfirm git base-devel go

# Create a user and set the working directory.
ARG user=boot
RUN useradd --system --create-home $user \
  && echo "$user ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/$user
USER $user
WORKDIR /home/$user

RUN git clone https://aur.archlinux.org/yay.git yay \
  && cd yay \
  && makepkg -sri \
  && cd \
  && rm -rf yay

# Install base packages.
RUN --mount=type=cache,target=~/.cache/yay --mount=type=bind,target=/app/packages,source=packages \
  yay -Syu --noconfirm - <packages

# Configure packages.
RUN rustup default stable

# Clone and install dotfiles.
RUN --mount=type=bind,target=/app/install.conf,source=install.conf \
  git clone https://github.com/aikow/dotfiles.git "${HOME}/.dotfiles" \
  && cd "${HOME}/.dotfiles" \
  && cp /app/install.conf "${HOME}/.dotfiles/.install.conf" \
  && ./install

CMD ["fish", "--interactive", "--login"]
