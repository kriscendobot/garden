---
title: Testing
source: AGENTS.md
source_repo: endojs/endo
source_commit: 6ea51ece638e2c842a12ec23164c21cbc24f3cbe
source_date: 2026-03-21
source_authors: [Turadg Aleahmad]
ingested: 2026-05-13
ingested_by: liaison
topics: [testing, agent-conventions]
status: current
---

> Abstract: Endo's three test commands are `yarn test` (ava, runtime), `yarn lint:types` (tsd, type tests in `test/types.test-d.ts`), and `yarn lint` (runs both `lint:types` and `lint:eslint`). Always run `yarn lint` in each modified package before committing.

## Testing

- Runtime tests: `yarn test` (uses `ava`)
- Type tests: `yarn lint:types` (uses `tsd`. Test files are `test/types.test-d.ts`)
- Lint: `yarn lint` (runs both `lint:types` and `lint:eslint`)

Always run `yarn lint` in each package you've modified before committing.

Source: [AGENTS.md](https://github.com/endojs/endo/blob/6ea51ece638e2c842a12ec23164c21cbc24f3cbe/AGENTS.md) at commit `6ea51ece`.
