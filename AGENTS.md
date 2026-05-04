# AGENTS.md

## Overview

Collection of shell scripts for provisioning and configuring a Debian server ("Skynet"). No build system, tests, CI, or linters — this is plain shell.

## Architecture

```
bin/      Executable Bash scripts (user mgmt, system setup, Zsh config, cron jobs)
shell/    Sourced shell snippets (aliases for git, docker, utils) — NOT executable
config/   Prompt theme configs (starship.toml, .p10k.zsh)
```

## Deployment context

Scripts are deployed to and run from `~/.local/myscripts/` (some older references use `~/.local/.my-scripts/`). The repo is the source of truth; target machines get a copy or symlink.

The `zsh-lite.sh` and `zsh-root.sh` scripts write `PATH` and `source` lines into `~/.zshrc` pointing at those deployment paths — not at the repo location.

## Commands

No `make`, `npm`, or equivalent. Just run scripts directly:

```sh
sudo ./bin/basic-root.sh          # install base packages (requires root)
sudo ./bin/locale-config.sh        # set es_BO.UTF-8 locale (requires root)
./bin/zsh-lite.sh                  # install Zsh plugins + configure .zshrc (user-level)
./bin/prompt-lite.sh               # install Powerlevel10k prompt
```

The `shell/` files are sourced, not run. They define shell aliases and helper functions.

## Conventions

- **Language**: All user-facing text, prompts, and comments are in Spanish.
- **Target OS**: Debian (apt). Scripts are NOT portable to other distros without changes.
- **Strict mode**: Inconsistent across scripts. Some use `set -euo pipefail`, some use only `set -e`, some use nothing. When editing, match the existing script's style.
- **Color palette**: ANSI 256-color blue tones — B1=21, B2=27, B3=33, B4=39, B5=45, B6=51, NC=0.
- **Shebangs**: Mix of `#!/bin/bash` and `#!/usr/bin/env bash`. Prefer `#!/usr/bin/env bash` for new scripts.

## Scripts requiring root

- `basic-root.sh`
- `add-user.sh`
- `del-user.sh`
- `locale-config.sh`

These check `EUID` and exit with a Spanish error message if not root.

## Hardcoded paths

Several scripts hardcode local user paths that won't exist on other machines:

- `backup-demodb.sh`: `PGUSER=postgres`, `OUTPUT_DIR=/home/nathan/pgdump/demodb`
- `howto-autocommit.sh`: `REPO_DIR=/mnt/emmc/repository/howto-sync`
- `commit-howto.sh`: `REPO_DIR=/home/nathan/repository/howto-sync`, `LOG_FILE=/home/nathan/repository/logs/howwto.log`

These need to be edited before running elsewhere.
