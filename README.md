# NasaBtt

An exercise project in Elixir

*Congratulations! You have received a contract from NASA for a software application that will help to calculate the fuel required for the flight. This application aims to calculate fuel to launch from one planet of the solar system and land on another planet of the solar system, depending on the flight route.*


## Setting up

The easiest way to setup the correct version of Elixir and Erlang is to install [asdf](https://asdf-vm.com/) and then to run `asdf install` to install the correct version of the languages.

In case of an immtable distro, use a container which shares your home folder, like [fedora toolbox](https://github.com/containers/toolbox).

## Running

### Container

The easier way to compile and run a few examples is to use an OCI. Either docker or podman can be used, but podman will be used in this example:

```bash
# Build the container
podman build . -t nasa_btt

# Tun the container
podman run nasa_btt 28801 '[{:launch, "earth"}, {:land, "moon"}, {:launch, "moon"}, {:land, "earth"}]'
```

As this is a multi-stage container where the output is an alpine container with the app (but with a user without any priviledges), the expected size is around `35MB`.

You can take a look at [./start_container.sh](./start_container.sh) for examples.

### Script

The other way to run this app is using an escript:

```bash
# Build the script
mix escript.build

# Run the script
./nasa_btt 28801 '[{:launch, "earth"}, {:land, "moon"}, {:launch, "moon"}, {:land, "earth"}]'
```

Just keep in mind that this requires the runtime to be intalled! You can look look at [./start.sh](./start.sh) for more examples

### Building

This application also supports building into a single binary file. `mix release nasa_btt_cli` will create a folder named `burrito_out` and inside of it will be the binary version of this application. This is how the [container](#container) version works.

```bash
mix release nasa_btt_cli

./burrito_out/nasa_btt_cli_linux
```

Although is does give some additional output this way so it's discouraged.

## Testing

To run standard tests and doctests, run `mix test`.
