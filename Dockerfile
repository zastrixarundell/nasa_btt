FROM ubuntu:24.04 as builder

RUN apt update && apt upgrade -y

RUN apt install -y \
    build-essential \
    git curl unzip \
    libncurses5-dev \
    libssl-dev

RUN useradd -ms $(which bash) user

WORKDIR /build

COPY .tool-versions .

# For some reason zig required /archive? Too much to think, just createad the file
# and set the ownership of it.
RUN touch /archive

RUN chown user:user /archive

USER user

RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0

ENV PATH="/home/user/.asdf/shims:/home/user/.asdf/bin:$PATH"

ENV ELIXIR_ERL_OPTIONS="+fnu"

ENV MIX_ENV="prod"

RUN asdf plugin add erlang

RUN asdf plugin add elixir

RUN asdf plugin add zig

RUN asdf install

COPY lib lib

COPY mix.exs .

COPY mix.lock .

USER root

RUN mkdir _build deps burrito_out

RUN chown user:user _build deps mix.lock burrito_out

RUN chmod 744 _build deps mix.lock burrito_out

USER user

RUN mix deps.get

RUN mix deps.compile

RUN mix release nasa_btt_cli

# Exit stage

FROM alpine:3.19.1

ENV CD_USER=user

RUN adduser -D $CD_USER

WORKDIR /app

COPY --from=builder /build/burrito_out/nasa_btt_cli_linux nasa_btt_cli

RUN chown $CD_USER:$CD_USER /app/nasa_btt_cli

USER $CD_USER

ENTRYPOINT ["/app/nasa_btt_cli"]