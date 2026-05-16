# AGENTS

## Purpose
This repository contains a small shell-script project for installing and configuring MongoDB on a RHEL/CentOS-style system.

## What to know
- The repo is shell script centric: `mongodb.sh`, `mongo.repo`, and a few other Bash scripts.
- Primary environment assumption: `bash`, `dnf`, `systemctl`, and `systemd`-managed MongoDB.
- Scripts run as root and log to `/var/log/mongo_logs`.
- There is no existing test suite or build automation in this repository.

## Editing guidance
- Preserve the root-access guard and validation pattern used in `mongodb.sh`.
- Match the existing script style: `#!/bin/bash`, color-coded status output, local log file usage, and `VALIDATE()` helper function.
- Avoid assuming Debian/Ubuntu package tooling; this repo uses `dnf` and `yum`-style repository configuration.
- Keep security in mind when changing MongoDB bind addresses or firewall rules.
- Do not add unrelated language-specific files or frameworks; this repository is a shell script utility project.

## Key files
- `mongodb.sh` — installs MongoDB, enables and starts `mongod`, updates `mongod.conf` bind address, and logs actions.
- `mongo.repo` — repository configuration file copied into `/etc/yum.repos.d/`.

## When in doubt
- Prefer minimal, focused updates that keep the installation script safe and idempotent.
- If a requested change affects deployment environment assumptions, ask for clarification before broadening support.
