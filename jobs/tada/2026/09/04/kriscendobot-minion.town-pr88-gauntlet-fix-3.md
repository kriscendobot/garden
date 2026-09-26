CI is green (rc 0). The round-3 fix is pushed and CI passes. Job complete.

## Completion report

**Job:** `kriscendobot-minion.town-pr88-gauntlet-fix-3` — FIX round 3 for [PR #88](https://github.com/kriscendobot/minion.town/pull/88) (`design(clip): immutable content, nonce-locator session, fresh-id-on-upgrade`).

**Re-derived state:** clean start after reaper requeue. PR head was at `3875ac4` (round-2 fix); no round-3 fix had been pushed. This is a **design-doc** PR touching only `designs/clip-immutable-nonce-locator.md`.

**Applied the round-3 panel must-fix items** (request-changes seats: critic, skeptic, copyeditor, novice; plus decomplector should-fix and the mechanical ergonomist/pedant items):

- **critic** — (1) Re-scoped the "cold open is a dead end" claim: a fragment-carrying old link opened cold still redeems its locator and is carried forward by redirect-on-connect; only **fragment-less** opens are genuinely stranded. Reworked §1, §4, and §10 Q1 accordingly, and stated the backend must push redirect on *any* newly established session. (2) Added migration-readiness as a §1 honest-tradeoff cost and a mandatory §7 item 6 primer obligation (immutable bytes can't retrofit the migration listener).
- **skeptic** — (1) Fixed the wrong-file unguessability citation: the CSPRNG number-generation is an upstream `@endo/daemon` guarantee, not `site-registry-exo.ts` (whose `formulaNumber()` only strips the node suffix); the design now depends on it without over-citing. (2) Added a §8 unit-6 test asserting the locator never appears in the WS handshake URL / request line / access log.
- **decomplector** (should-fix) — Gave the locator's authorization scope first-class treatment in §3.1 (bearer capability valid at *any* of the guest's origins, not origin-bound; CSP only bounds in-browser JS) and added §10 Q9.
- **novice** — Defined **formula** in Terminology, expanded the CapTP/OCapN vocabulary (bootstrap object / sturdyref / swissnum + *why* the property is borrowed) in §3.1, and declared the `s`/`s'` symbols before use.
- **copyeditor/pedant** — tense fixes (`are immutable`, `is handed`), comma-splice fix, typist-friendly `...`/`->` for ellipsis/arrow glyphs, and bare `guest-primer.md` path form (dropped `designs/` prefix, 4 sites).
- **ergonomist** — renamed `mintLiveLink` → `publishLiveLink` (publish-family verb) with the `serving`/`warning` visible-degraded-state convention stated. Left the file/branch "nonce" name as-is (comment-only; renaming the head branch mid-gauntlet would break the PR ref — the Terminology note already disowns the name).

**Pushed** `3e14e98` to the PR head via `safe-push-pr-head.sh`. **CI: GREEN** (rc 0). Stopped without re-running the panel, per stage contract (driver re-posts panel-4).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr88-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 86 tokens (3344759 cached reads)
- Output: 23617 tokens
- Cost: $3.1706055000000006
- Wall-clock: 423s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
