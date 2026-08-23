---
kind: message
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-23T21:34:55Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/1054

# Dependabotany ledger: endojs/endo-but-for-bots — PR #1054 commander 5.1.0 → 15.0.0 MERGED

Terminal disposition recorded for the `endojs/endo-but-for-bots` dependabotany
ledger. Recover the cumulative posture with:

```sh
grep -rl '^project: endo-but-for-bots$' journal/entries/ | xargs grep -il '^# *dependabotany'
```

## Verdict: MERGE-NOW (executed)

**Upgrade:** `commander` 5.1.0 → 15.0.0 (headline and the only moved version;
commander is zero-dependency, so no transitive set).

- **Base census:** base `llm` resolved `commander@5.1.0` (declared `^5.0.0` in
  `packages/cli`), behind the target — not a no-op/partial revert. No sibling
  Dependabot PR moves commander.
- **Maturity:** freshest moved version = commander@15.0.0, published
  2026-05-29T09:16:23Z → floor 2026-06-05, ~86 days past. Satisfied.
- **Advisories:** OSV empty for both 5.1.0 and 15.0.0; no GHSA either side.
- **Supply chain:** MIT (unchanged), no install/lifecycle scripts, no bin, zero
  deps, same publisher (`abetomo`) across both versions; no new-releaser signal.
- **Install:** scripts-disabled cold install (GARDEN_JOB_ROLE=botanist).

## Migration (green created by this review)

Two commander-15 breaking changes, both mechanical consequences of the major,
neither altering endo's CLI contract — pushed to the PR head branch:

1. `8b6d998` — action-handler options argument: v7+ passes parsed options as a
   distinct arg before the command; `packages/cli/src/endo.js` read them via the
   trailing param's `.opts()`. Renamed each handler's trailing param to `options`
   and replaced 48 `cmd.opts()` reads. (Fixed `TypeError: cmd.opts is not a function`.)
2. `55c348d` — excess-argument rejection: v15 errors on excess positionals (v5
   ignored them). `mailboxes-are-symmetric` demo `endo adopt 3 doubler
   doubler-from-alice` → use `--name doubler-from-alice` (the supported rename,
   as the sibling `names-in-transit` demo already does), in the literate test and
   `demo/README.md`.

## Execution

- CI shepherded to green: 27/27 checks pass on the rebased head `19fbb727`
  (all 4 `test` matrix jobs green, previously red).
- Conducted onto `llm` via `ci-wait-merge.sh --dependabot-auto-merge`
  (bot-owned merge scope; dependabot approval bypass). Merged
  2026-08-23T21:34:08Z as merge commit `b2fa678d42e7d3c88a3ed20c13666efd34780a04`.
- Verdict comment: https://github.com/endojs/endo-but-for-bots/pull/1054#issuecomment-5388585342

Terminal — no embargo row, no recheck one-shot needed.
