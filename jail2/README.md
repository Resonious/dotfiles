# jail2

A faster, lower-maintenance rewrite of `jail`.

## What changed vs v1

- **Runs as container-root.** With rootless podman, the default userns maps
  container `root` → your host user, so files created on bind mounts are owned
  by you — with none of the `--userns=keep-id` image-idmap cost that made v1
  slow to boot on big projects. (Some tools grumble about running as root; we
  don't care.)
- **`--security-opt label=disable`** instead of `:Z`, so SELinux doesn't
  relabel the entire project tree on every run.
- **Languages/runtimes come from [mise](https://mise.jdx.dev)**, not the
  Dockerfile. The image is just Ubuntu 26.04 + system tools + mise. Adding a
  language no longer means editing the Dockerfile and rebuilding.

## Usage

```sh
cd ~/some-project
/path/to/jail2/jail          # run: mounts cwd at /root/<project>, drops you in fish
/path/to/jail2/jail exec     # open another fish in the running jail
/path/to/jail2/jail home     # mount cwd as the whole /root instead
```

Build the image:

```sh
/path/to/jail2/build-jail.sh
```

## Managing languages

`mise.toml` is bind-mounted into every jail as the global mise config. To add a
runtime, edit `mise.toml` here, then inside a running jail:

```sh
mise install
```

No image rebuild. Installed runtimes live in the persistent `jail2-mise-data`
volume, so first install pays the cost once and later boots are instant.

Heavy tools (`ruby`, `erlang`) compile from source on first install — comment
out what you don't use.

## Persistent volumes

| Volume                 | Mount                          | Holds                          |
| ---------------------- | ------------------------------ | ------------------------------ |
| `jail2-mise-data`      | `/root/.local/share/mise`      | mise-installed runtimes        |
| `jail2-claude-home`    | `/root/.claude`                | Claude login / state           |
| `jail2-local-bin`      | `/root/.local/bin`             | the `claude` binary            |
| `jail2-claude-share`   | `/root/.local/share/claude`    | Claude data                    |
| `jail2-npm-global`     | `/root/.npm-global`            | codex, pi, openapi-generator   |
| `jail2-cargo`          | `/root/.cargo`                 | cargo + rustup binary          |
| `jail2-rustup`         | `/root/.rustup`                | rust toolchains (rustup)       |
| `jail2-codex`          | `/root/.codex`                 | codex state                    |

Claude Code, codex, pi and openapi-generator-cli are installed on first boot
(they need node from mise) and persist in their volumes thereafter.

Rust is installed via native `rustup` in the image (not mise — mise's rust
support wraps rustup and caused toolchain corruption across fresh containers).
The toolchain lives in `~/.rustup` / `~/.cargo`, persisted as volumes. Use
`rustup`/`cargo` directly; `rustup update` etc. persist.
