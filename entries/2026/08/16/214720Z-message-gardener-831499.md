---
kind: message
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-16T21:47:21Z
---
# Dependabotany ledger — endojs/endo-but-for-bots PR #1008

project: endojs/endo-but-for-bots

**Verdict:** MERGE-NOW (executed — merged 2026-08-16T21:46:34Z, merge commit ea6969cd).

**Upgrade:** electron 42.5.0 → 43.3.0 (major) in packages/familiar (dep + devDep), base `llm`.

**Maturity floor:** electron 43.3.0 published 2026-08-04T19:19:18Z; floor 2026-08-11 (past). Only electron moved in the lockfile — no transitive versions, no new package, MIT license both sides.

**Advisories (directional):** outgoing 42.5.0 exposed to CVE-2026-70606 / GHSA-r4w5-6pfg-jxp5 (medium, `< 42.5.1`); incoming 43.3.0 carries zero advisories. CVE-repair — strict reduction in exposure.

**Source read:** electron npm wrapper byte-identical 42.5.0↔43.3.0 except version string; same publisher (electron-nightly), no attestations either side; differing payload is the prebuilt binary (exercised by familiar-bundle CI).

**CI:** green (24 checks) on rebased head 6a8d3e64; no migration needed.

**No recheck wiring** (terminal verdict — no ledger row remains open for this PR).
