Reorg complete and landed on `main2` (commit `d46badb6e9`).

## What I did

Read `skills/local-verify/SKILL.md` (557 lines / 14 level-two sections) and applied a **mixed remedy** — tighten in place plus factor supplementary material into linked sibling files, following the `skills/agoric-chain-snapshot/repro` pattern. Kept `SKILL.md` a single file with its required shape (purpose, inputs, state, procedure, output, notes); did **not** do a `context/`-style directory split.

**Factored out into reference-only siblings** (SKILL.md keeps a short pointer to each):
- `field-notes.md` (195 lines) — the entire dated "Notes from the field" divergence/coverage-gap log (was ~190 lines inline, the dominant bulk).
- `pitfalls.md` (37 lines) — the five recurring gotchas.
- `debugging-contract.md` (32 lines) — the selective-inspection recipes + cross-host `anchor_blob` note.

**Tightened in place** (kept inline, compressed): merged the intro's invariant tail with the overlapping "Why it exists" section (dropped duplicated offload/speed prose); compressed the "Tests" walkthrough from ~25 lines to a single dense paragraph.

**Left inline unchanged** (core procedure a claiming agent needs on the skim): Parity is the contract, The steps, When to use, Inputs, State, Procedure, Output, How it plugs in, Composition.

## What changed
- `skills/local-verify/SKILL.md`: **557 → 318 lines**. Three new sibling files total 264 lines.
- Rewrote two intra-file references that pointed at now-moved field notes ("see the 2026-07-29 field note" / "2026-07-28 rerere field note below") to link into `field-notes.md`.

## Cross-references
- Inbound links: 7 files link to `skills/local-verify/SKILL.md` — all are whole-file links (grepped: **zero** `#anchor` fragment links from other files), so all still resolve.
- Internal anchors `#parity-is-the-contract` and `#the-steps-in-order` still target present sections; the sibling files' outbound links (`../prompt-on-failure-capture`, `../../context/operations/deploy.md`, `SKILL.md#parity-is-the-contract`) all verified to exist. House style (em-dash, no latin-shorthand, relative paths) checked clean.

## Follow-ups
None. No PR needed (landed directly on `main2` per `CLAUDE.md` § Conventions). Docs-only change; the harness script `local-verify.sh` and its tests were untouched.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/reorg-skill-local-verify.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 41 tokens (1592820 cached reads)
- Output: 27287 tokens
- Cost: $2.248089
- Wall-clock: 343s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
