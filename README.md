# Dotfiles

## Installation

```
$ curl -L raw.github.com/izumin5210/dotfiles/master/install.sh | bash
```

### zsh

```
$ chsh -s /bin/zsh
```

When you use installed via homebrew one:

```
$ sudo sh -c "echo '/usr/local/bin/zsh' >> /etc/shells"
$ chsh -s /usr/local/bin/zsh
```

## Development
Execute the following command to run [Serverspec](http://serverspec.org/) on Docker container:

```
$ docker build -t dotfiles
$ docker run -t dotfiles
```

## Inspired
Inspired by [b4b4r07/dotfiles](https://github.com/b4b4r07/dotfiles) and [creasty/dotfiles](https://github.com/creasty/dotfiles).

## License
Licensed under the [MIT license](http://izumin.mit-license.org/2015).
