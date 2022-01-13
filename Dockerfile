FROM ubuntu:rolling

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y locales  \
	&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

RUN yes | unminimize

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
	git \
	sudo \
	zsh \
	autojump \
	fzf \
	bat \
	httpie \
	ncdu \
	htop \
	fd-find \
	exa \
	duf \
	tldr \
	neovim \
	curl \
	wget  \
	man-db \
	fontconfig \
	unzip \
	golang \
	build-essential

RUN curl -fsSL https://starship.rs/install.sh | bash -s -- -y
RUN groupadd --gid 1000 user \
	&& useradd -G sudo --uid 1000 --gid user --shell /bin/zsh --create-home user

# Bat cat link
RUN ln -s /usr/bin/batcat /usr/local/bin/bat

USER user
WORKDIR /home/user
ENV LC_ALL=C

# Install FZF, Fuzzy search
RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install

# install nerd fonts (ligatures and shell icons)
ADD FiraCode.tar.gz ./.fonts
RUN fc-cache -v

# install zimfw (zsh framework, just like oh-my-zsh, but cleaner and lighter)
RUN curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh

# install FNM (node version manager, just like nvm, but lighter)
RUN curl -fsSL https://fnm.vercel.app/install | bash

# install Rustup (rust language tools)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Integrate starship prompt to our shell
RUN echo 'eval "$(starship init zsh)"' >> ~/.zshrc

# Install autojump
RUN echo '. /usr/share/autojump/autojump.sh' >> ~/.zshrc

# Add zimfw plugins
RUN echo 'zmodule fzf' >> ~/.zimrc \
	&& echo 'zmodule archive' >> ~/.zimrc \
	&& echo 'zmodule exa' >> ~/.zimrc

RUN zsh ~/.zim/zimfw.zsh install
