FROM ubuntu:24.04 as builder

RUN apt update && apt upgrade -y

RUN apt install -y \
    build-essential \
    git curl unzip \
    libncurses5-dev

RUN useradd -ms $(which bash) user

WORKDIR /build

COPY .tool-versions .

# For some reason zig required /archive? Too much to think, just createad the file
# and set the ownership of it.
RUN touch /archive

RUN chown user:user /archive

USER user

RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0

# RUN echo '. "$HOME/.asdf/asdf.sh"' > /home/user/.bashrc

# RUN echo '. "$HOME/.asdf/completions/asdf.bash"' > /home/user/.bashrc

ENV PATH="/home/user/.asdf/shims:/home/user/.asdf/bin:$PATH"

ENV ELIXIR_ERL_OPTIONS="+fnu"

RUN asdf plugin add erlang

RUN asdf plugin add elixir

RUN asdf plugin add zig

RUN asdf install

COPY lib lib

COPY mix.exs .

RUN mix deps.get

RUN mix deps.compile

