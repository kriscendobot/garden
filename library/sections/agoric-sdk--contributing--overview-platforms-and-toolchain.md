---
title: Overview, Platforms, Dev Tools and Testing
source: CONTRIBUTING.md
source_repo: agoric/agoric-sdk
source_commit: de2c4cbc6c6e75989cf6f8594dcb26f9b6f36f22
source_date: 2026-02-27
source_authors: [Turadg Aleahmad]
ingested: 2026-05-14
ingested_by: scholar
topics: [repository-governance, tooling, getting-started]
status: current
---

> Abstract: Frame and toolchain prerequisites. Document opens by pointing at AGENTS.md (the robot-facing companion) and offers this as the human guide. Supported platforms: MacOS, Linux, WSL. JS-only work needs node LTS + yarn; full-repo work also needs Golang ≥1.17 and a C compiler + make (or `nmake` on WSL). The sanity-check sequence is `yarn` → `yarn build` → `yarn test` → `yarn lint`. VSCode setup is `scripts/configure-vscode.sh`. Coding style and unit-testing detail live on the agoric-sdk wiki (external).

# Contributing to the Agoric SDK

Thanks for getting involved!

The below is written for people. [AGENTS](./AGENTS.md) has guidelines for robots, which you may also find useful.

## Platforms, Dev Tools and Testing

We support MacOS, Linux, and Windows Subsystem for Linux (WSL).

For many of the packages here, JavaScript development tools suffice:

 - [node](https://nodejs.org/) LTS
 - [yarn](https://classic.yarnpkg.com/en/docs/install) (`npm install -g yarn`)

But to ensure contributions are compatible with all packages, you will
also need:

 - [Golang](https://golang.org/doc/install) (version 1.17 or higher)
 - a C compiler and make
   - On linux, `apt install build-essentials` or the like
   - On MacOS, `xcode-select --install` or similar
   - On WSL, use `nmake` instead of `make`

To check that everything is working before you start, or
to thoroughly check a contribution, run:

```sh
yarn # short for: yarn install
yarn build
yarn test
yarn lint
```

A standard Visual Studio Code configuration can be initialized or updated by running [`scripts/configure-vscode.sh`](scripts/configure-vscode.sh).

See also notes on [Coding style](https://github.com/Agoric/agoric-sdk/wiki/Coding-Style), including [unit testing](https://github.com/Agoric/agoric-sdk/wiki/agoric-sdk-unit-testing) etc.

Source: [CONTRIBUTING.md](https://github.com/Agoric/agoric-sdk/blob/de2c4cbc6c6e75989cf6f8594dcb26f9b6f36f22/CONTRIBUTING.md) at commit `de2c4cbc`.
