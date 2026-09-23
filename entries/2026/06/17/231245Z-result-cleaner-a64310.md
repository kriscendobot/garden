---
ts: 2026-06-17T23:12:00Z
kind: result
role: cleaner
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/06/17/cleaner-dispatch-452
---

## Cleaner result: PR #452 iroh heartbeat + Option A

**Pre-head SHA**: `12384721d` (builder's last commit)
**Post-head SHA**: `b7d23855e` (after hygiene commit)

### Per-commit substance

- `b7d23855e` `chore(daemon): replace non-ASCII in iroh-heartbeat.js comments`
  Replaced em-dashes with parentheses, the section-sign (U+00A7) with `sec.`, and the right-arrow (U+2192) with `->` in the newly added `iroh-heartbeat.js` source file. Six characters replaced across six comment lines; no logic changed.

### PR body change

Updated. The prior body was one sentence describing the symptom. The new body uses the upstream template sections and describes: (1) the QUIC DATAGRAM heartbeat and keep-alive watchdog; (2) Option A's `context.cancel` change and the peer-formula revocation contract; (3) security, scaling, testing, compatibility, and upgrade considerations.

### Pre-push-gates result

Probe-only run. The following probes fail on pre-existing code that predates this PR's new commits:

- `filename-no-stutter`: pre-existing across many packages.
- `no-ascii-banners`: pre-existing in `designs/trust-on-first-bind.md` and `pivoker/DESIGN.md`.
- `no-inline-import-jsdoc`: pre-existing across the codebase.
- `security-md-hash-uniform`: pre-existing divergence in `packages/chacha12*` and `packages/random`.
- `no-non-ascii-in-source`: pre-existing in `iroh-address.js` and `iroh.js` (added in earlier commits on this branch). The new `iroh-heartbeat.js` had six non-ASCII characters; all were fixed in the hygiene commit.

No probe failures introduced by this PR's new code after the hygiene commit.

### Top-level summary comment

https://github.com/endojs/endo-but-for-bots/pull/452#issuecomment-4736335535

### Recommended next stage

next: barrister

Self-improvement: nothing this time. The pre-push-gates probe runs against the full branch diff (not just the newest commits), so pre-existing non-ASCII in earlier branch commits always appear as failures. The cleaner's task is to fix non-ASCII only in its own scope (the builder's latest commits). This behavior is expected and the probe output already makes it possible to distinguish pre-existing from new by checking which files the newest commits touch.
