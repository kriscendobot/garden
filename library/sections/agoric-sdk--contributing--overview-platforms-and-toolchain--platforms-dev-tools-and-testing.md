---
title: Platforms, Dev Tools and Testing
source: CONTRIBUTING.md
source_repo: agoric/agoric-sdk
source_commit: de2c4cbc6c6e75989cf6f8594dcb26f9b6f36f22
source_date: 2026-02-27
source_authors: [Turadg Aleahmad]
ingested: 2026-05-14
ingested_by: scholar
topics: [repository-governance, tooling, getting-started]
status: current
parent: agoric-sdk--contributing--overview-platforms-and-toolchain
---

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
