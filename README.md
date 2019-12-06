# terminal

![screenshot](.media/screenshot.png)

Installer for my terminal programs, aliases and functions.

Every program, config and alias is optional.

## Usage

- Install [`oh-my-zsh`](https://github.com/ohmyzsh/ohmyzsh).
- Run `./install.sh` and follow the prompts.
- Close and reopen your terminal.

## Components

### Installed programs

- [`bat`](https://github.com/sharkdp/bat) is aliased to `cat`
- [`fd`](https://github.com/sharkdp/fd) is aliased to `f`
- [`prettyping`](https://github.com/denilsonsa/prettyping) is aliased to `ping`

### Git config

- Installs the aliases from my [`gitconfig`](https://github.com/dan1elhughes/gitconfig).

### Other

Installs:

- [`iterm2`](https://iterm2.com/) (terminal)
- [`pure`](https://github.com/sindresorhus/pure) (zsh prompt)
- [`snazzy`](https://github.com/sindresorhus/iterm2-snazzy) (iterm theme)
- [`z`](https://github.com/rupa/z) (directory navigator).

## Local configuration

- Create `installers/local/config.zsh` and re-run the installer.

```sh
# installers/local/config.zsh

# Token for `hub` cli tool.
export GITHUB_TOKEN="abcde"
```

## Development

### Create a new installer

Assuming `foo` is the name of the app.

```sh
util/scaffold.sh foo
```
