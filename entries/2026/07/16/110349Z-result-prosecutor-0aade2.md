---
kind: result
role: prosecutor
host: endolin-garden-ece02cb4
at: 2026-07-16T11:03:51Z
---
---
kind: result
role: prosecutor
project: endo-but-for-bots
refs:
  - review-misses/misses/endojs-endo-but-for-bots-pr671-review-944a6716.md
  - review-misses/clusters/named-imports-over-namespace.md
---

# Review-retrospective — endojs/endo-but-for-bots #671 (review 4700663722, prosecutor)

**Surface:** pr-review-body by kriskowal. **Primary loop (unchanged):** already
addressed and pushed (MVS regression test, platform-boundary cleanup, follow-up
plan; head `1eabe975cb`, CI green).

**Idempotency:** no prior `misses/`|`dismissed/` record for
`endojs-endo-but-for-bots-pr671-review-944a6716` — proceeded.

**Discrimination (grounded in the PR review history, not the comment text).** The
review bundled a body-level ask plus seven inline notes; I recorded its single
strongest, cleanest review-process signal and dispositioned the rest:

- **Recorded MISS — `node:` builtin-protocol prefix** (category `style-convention`,
  cluster `named-imports-over-namespace`, severity minor). The freshly-added
  builtin imports at `bus-daemon-node.js` (`crypto`, and the diff's new `zlib`)
  lack the `node:` prefix. This is the second convention already bundled into that
  cluster's pattern line and the same shape as its #615 member: a generic,
  pre-existing, mechanizable house convention on freshly-authored code that the
  19-seat panel (gauntlet over exactly this diff) let through. Encode-first gap:
  no seat brief, skill, or gate encodes import shape or `node:` today.
- **NOT this miss — the MVS-test body ask.** The panel *precisely sensed and
  articulated* it: the follow-up ledger records "Semver / MVS test-coverage
  expansion (property-based)" from the `corner-prober` + `fast-checker` seats
  (Round 1) with the exact fast-check property list. The maintainer is pulling it
  from `follow-up` to must-fix on an explicitly-staged M3 reference milestone — a
  staging/scope call he owns, first stated as blocking here. New-direction, not a
  sensing failure.
- **NOT this miss — the platform-boundary design asks** (capture `registryPowers`
  at top scope, the `registry-node-powers.js` stub, rename/consolidate
  `registry-user.js`, normalize `Buffer`→`Uint8Array` at Node bindings, dedup
  `gunzipBuffer`, post a promotable follow-up plan). Architecture directions on
  novel module structure, owned by the primary fixer loop.

**Recorded:** `review-misses/misses/endojs-endo-but-for-bots-pr671-review-944a6716.md`
via the store writer → cluster `named-imports-over-namespace` **count=2,
prs={615,671}, status=open, recurrence=0**.

**Threshold: HELD (no improvement dispatched).** Floor is K≥3 misses across ≥2
distinct PRs; the cluster is at count=2 (two distinct PRs, but one short of K≥3).
No severity bypass: the miss is `minor`, and the grounds are encode-first (no
standing rule bound and failed) rather than a sense-and-correct failure against an
existing rule. When a third instance across a third PR (or a clear `major`) trips
the floor, the natural improvement mirrors `avoid-name-abbreviations`: a tier-1
lint-style pre-push gate for named-import/`node:`-prefix shape plus a
`stylist`/`purist` seat-brief line and a panel-hints probe on the diff signal.

**Changed:** journal2 only (the miss record + cluster join, both pushed by the
store writer; this result entry). No `main2` changes — a retro records and routes;
it does not edit garden source.

**Follow-ups:** none owed. Cluster `named-imports-over-namespace` sits one PR short
of its dispatch floor; the next builtin-import-shape miss on a distinct PR trips it.

Self-improvement: nothing this time.
