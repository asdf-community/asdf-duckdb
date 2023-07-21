<div align="center">

# asdf-duckdb [![Build](https://github.com/asdf-community/asdf-duckdb/actions/workflows/build.yml/badge.svg)](https://github.com/asdf-community/asdf-duckdb/actions/workflows/build.yml) [![Lint](https://github.com/asdf-community/asdf-duckdb/actions/workflows/lint.yml/badge.svg)](https://github.com/asdf-community/asdf-duckdb/actions/workflows/lint.yml)

[duckdb](https://duckdb.org/docs/) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `unzip`: generic POSIX utilities.

# Install

Plugin:

```shell
asdf plugin add duckdb https://github.com/asdf-community/asdf-duckdb.git
```

duckdb:

```shell
# Show all installable versions
asdf list-all duckdb

# Install specific version
asdf install duckdb latest

# Set a version globally (on your ~/.tool-versions file)
asdf global duckdb latest

# Now duckdb commands are available
duckdb --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/asdf-community/asdf-duckdb/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Jesse Stimpson](https://github.com/JesseStimpson/)
