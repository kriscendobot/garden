---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-09-04T04:38:38Z
---
---
kind: result
role: decomplector
repo: endojs/endo-but-for-bots
project: endo
---

Design-panel seat `decomplector` on PR #814 (`designs/mount-denied-segments-cli.md`, base `origin/llm`).

### decomplector

**Verdict:** request-changes

**Findings:**
- § Three creation states puts a *daemon* invariant on the CLI: it says the command layer "must not pass `{ deniedSegments: undefined }`" because "formula records intentionally omit the property". But `provideMount`/`provideScratchMount` destructure the option (`packages/daemon/src/host.js:562`, `:632`) and `formulateMount` already conditionally spreads it (`packages/daemon/src/manager.js:4351-4361`), so an explicit `undefined` and an omission are indistinguishable below the host. The design restates an invariant in the one layer that cannot violate it, and Test 3 then claims to protect "the formula-shape invariant" — which no CLI test can observe (it can only observe enforcement, identical either way). Decomplect: the CLI resolves to `undefined`-or-list; record shape stays the daemon's, cited not re-obliged. [proposed-rule: a design states each invariant at the single layer that can enforce and test it, and cites — never restates as a new obligation — an invariant a lower layer already holds.]
- The deny set is modeled as an ordered list, but the value is a case-folded set. `resolveDeniedSegments` builds `new Set([...source].map(toLowerCase))` (`packages/daemon/src/mount.js:207-211`); order, duplicates, and case carry no meaning at match time. Yet "ordered strings" / "maps directly to the ordered list" forwards arrival order verbatim into `MountFormula.deniedSegments` (`packages/daemon/src/types.d.ts:266-272`), so `--denied-segments .SSH --denied-segments .ssh` persists two entries denoting one denied name, and two identical policies persist as different records. § Help and diagnostics never tells the user matching is case-insensitive — the value's identity rule is invisible at the only surface where the user picks it. Name the canonical form (dedupe, case) and the layer that applies it; say case-insensitivity in help. [proposed-rule: a design specifying a CLI over a shipped value names that value's identity rule (order, duplicates, case) and which layer canonicalizes.]
- § Open questions asks which *spelling* the three states get, never whether three states need two flags. The mutual-exclusion rule, the "deliberately not an alias for omission" caveat, and the exclusion error text are all costs of the two-flag shape, not of any spelling. Pin the shape question first. Comment-only: the two-flag shape may well be right (a sentinel value would complect a segment name with "none"), but the design should say so rather than leave it implied. [proposed-rule: when shape determines the accidental complexity, the open question about shape precedes the open question about naming.]

**Notes (out of scope but worth flagging):**
- The `endo mktmp` vs `endo mount --scratch` open question is a command-taxonomy decision orthogonal to the deny set; carrying it here gates a 1-day CLI change on a naming migration. Split it into its own item. [proposed-rule: a design's open questions list only decisions its own work cannot proceed without.]
- Acknowledgment, not a finding: refusing to merge supplied names with `defaultDeniedSegments` keeps replacement the single meaning and matches the shipped contract at `packages/daemon/src/mount.js:173-176`. Good decomplecting.

Self-improvement: no role or skill gap found; the brief's category walk (value-vs-place, minimum viable abstraction, invariant survivability) reached all three findings, and stopping at the boundary of what the design claims kept the block from inventing a fourth.
