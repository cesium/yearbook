[asdf-vm]: https://asdf-vm.com/

# 🚀 Getting Started

These instructions will get you a copy of the project up and running on your
local machine for development and testing purposes.

## 📥 Prerequisites

The following software is required to be installed on your system:

- [Erlang 24+](https://www.erlang.org/downloads)
- [Elixir 1.13+](https://elixir-lang.org/install.html)

We recommend using [asdf version manager][asdf-vm] to install and manage all
the programming languages' requirements.

## 🔧 Setup

First, clone the repository:

```
git clone git@github.com:cesium/yearbook.git
cd yearbook
```

Then, run the setup script to get all dependencies configured. Make sure the database is up and running.

```
bin/setup
```

Then you should change the `.env.dev` file as needed. Run this script again
if needed.

## 🔨 Development

Start the development server and then you can visit `http://localhost:4000`
from your browser.

```
mix phx.server # or iex -S mix phx.server
```

Lint your code.

```
bin/lint
```

Format your code.

```
bin/format
```

## 🔗 References

You can use these resources to learn more about the technologies this project
uses.

- [Getting Started with Elixir](https://elixir-lang.org/getting-started/introduction.html)
- [Erlang/Elixir Syntax: A Crash Course](https://elixir-lang.org/crash-course.html)
- [Elixir School Course](https://elixirschool.com/en/)
- [Phoenix Guides Overview](https://hexdocs.pm/phoenix/overview.html)
- [Phoenix Documentation](https://hexdocs.pm/phoenix)
- [SQLite3](https://sqlite.org/docs.html)
