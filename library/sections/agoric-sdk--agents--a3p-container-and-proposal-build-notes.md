---
title: A3P Container & Proposal Build Notes
source: AGENTS.md
source_repo: agoric/agoric-sdk
source_commit: 08e3d64d81c7feb73d455fcc58dbc2c731d69c77
source_date: 2026-03-23
source_authors: [Turadg Aleahmad]
ingested: 2026-05-14
ingested_by: scholar
topics: [agent-conventions, tooling]
status: current
---

> Abstract: A3P tests run inside a Docker container built from an agoric-sdk checkout (full repo filesystem, not just published npm packages). The container's canonical agoric-sdk checkout is the last formal release, so any workspace updates A3P needs must be copied into the image and resolved correctly. A3P supports building proposals from agoric-sdk HEAD and copying artifacts into the image (avoids copying all sources); configured by `agoricProposal.sdk-generate` in the proposal's `package.json`; executed by `a3p-integration/build-submission.sh`.

## A3P Container & Proposal Build Notes
- A3P tests run inside a Docker container built from an agoric-sdk checkout, so the container can access the full repo filesystem, not just published npm packages.
- The container's canonical agoric-sdk checkout is based on the last formal release, so any workspace updates needed by A3P must be copied into the image and resolved correctly.
- A3P supports building proposals from agoric-sdk `HEAD` and copying the artifacts into the image
   - this avoids copying all sources needed to build proposals.
   - it's configured by `agoricProposal.sdk-generate` in the proposal package.json
   - it's performed by `a3p-integration/build-submission.sh`

Source: [AGENTS.md](https://github.com/Agoric/agoric-sdk/blob/08e3d64d81c7feb73d455fcc58dbc2c731d69c77/AGENTS.md) at commit `08e3d64d`.
