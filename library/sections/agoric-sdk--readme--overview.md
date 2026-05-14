---
title: Agoric Platform SDK (overview)
source: README.md
source_repo: agoric/agoric-sdk
source_commit: 511d4f74bae7144be5bc904dd7a50f01d09648ed
source_date: 2026-03-25
source_authors: [Michael FIG]
ingested: 2026-05-14
ingested_by: scholar
topics: [getting-started, repository-governance]
status: current
notes: The "endo provides the lower layers" frame is the most important architectural fact for any agent navigating between agoric-sdk and endo. The doc explicitly redirects dapp builders to docs.agoric.com getting-started — this repo is for platform contributors only.
---

> Abstract: The Agoric Platform SDK repo contains most of the packages making up the upper layers of the Agoric platform. The lower layers are provided by the [endo repository](https://github.com/endojs/endo). Dapp builders should *not* check out this repo — they should follow the [getting-started guide at docs.agoric.com](https://docs.agoric.com/guides/getting-started/) instead. This repository is for those improving the platform itself.

# Agoric Platform SDK

![unit tests status](https://github.com/Agoric/agoric-sdk/actions/workflows/test-all-packages.yml/badge.svg)
![integration tests status](https://github.com/Agoric/agoric-sdk/actions/workflows/integration.yml/badge.svg)
[![license](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](./LICENSE)

This repository contains most of the packages that make up the upper layers of
the Agoric platform, with [the endo repository](https://github.com/endojs/endo)
providing the lower layers. If you want to build on top of this platform, you
don't need these repositories: instead you should
[follow our instructions for getting started](https://docs.agoric.com/guides/getting-started/)
with the Agoric SDK.

But if you are improving the platform itself, these are the repositories to use.

Source: [README.md](https://github.com/Agoric/agoric-sdk/blob/511d4f74bae7144be5bc904dd7a50f01d09648ed/README.md) at commit `511d4f74`.
