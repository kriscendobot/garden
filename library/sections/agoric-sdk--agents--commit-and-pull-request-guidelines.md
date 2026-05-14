---
title: Commit & Pull Request Guidelines
source: AGENTS.md
source_repo: agoric/agoric-sdk
source_commit: 08e3d64d81c7feb73d455fcc58dbc2c731d69c77
source_date: 2026-03-23
source_authors: [Turadg Aleahmad]
ingested: 2026-05-14
ingested_by: scholar
topics: [agent-conventions, repository-governance]
status: current
notes: Pointer to docs/commit-hygiene.md (already ingested as agoric-sdk--docs-commit-hygiene--*). Conventional Commits requirement is shared with agoric-sdk--contributing--landing-pull-requests.
---

> Abstract: agoric-sdk PR rules: Conventional Commits in titles and per-commit messages. Branch names should reference an issue number (e.g., `123-fix-solo-reconnect`). PRs link issues, describe changes and risks, ensure build/test/lint pass. Prefer "Squash and merge." Integration tests: labels `force:integration` / `bypass:integration` available; otherwise they run as part of the merge queue. For commit hygiene rules (codegen, lockfile updates, formatting, linting, tests) see `docs/commit-hygiene.md`.

## Commit & Pull Request Guidelines
- Use Conventional Commits in titles and commits (e.g., `feat(swingstore): add snapshot…`).
- Branches should reference an issue number (e.g., `123-fix-solo-reconnect`).
- PRs: link related issues, describe changes and risks; ensure `yarn build`, `yarn test`, and `yarn lint` pass. Prefer "Squash and merge."
- Integration tests: use labels `force:integration`/`bypass:integration` when appropriate; otherwise they run as part of the merge queue.
- Commit hygiene (codegen, lockfile updates, formatting, linting, tests): see `docs/commit-hygiene.md`.

Source: [AGENTS.md](https://github.com/Agoric/agoric-sdk/blob/08e3d64d81c7feb73d455fcc58dbc2c731d69c77/AGENTS.md) at commit `08e3d64d`.
