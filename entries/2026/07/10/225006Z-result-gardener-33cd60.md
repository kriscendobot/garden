---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-10T22:50:07Z
---
role: prosecutor

# Result — review-retrospective on endojs/endo-but-for-bots #653 (mount glob)

Second loop (retrospective) on kriskowal's CHANGES_REQUESTED review
`4673736338`. Verdict: **miss**, held below the floor. Idempotency pre-check
clean (no prior `misses/`|`dismissed/` record for the primary base).

**Discrimination.** The review bundles three asks across two inline comments:
- daemon.js `deniedSegments` "without ceremony" — API-ergonomics taste, **new
  direction** (continues the #650 `deniedSegments` API dialogue); not clustered.
- mount.js "move `maybeRealPath` into `platform`" — module-factoring taste, **new
  direction**; not clustered.
- mount.js "only promotes appropriate error classes to `undefined`" — **the
  miss**: a bare `catch {}` swallowing *every* error class on the new
  symlink-cycle-detection helper, on a security-sensitive confinement path, while
  its own JSDoc documents only ENOENT-class intent.

**Grounds.** The saboteur seat's standing "Tight-try discipline" rule
(`roles/jurors/saboteur/AGENT.md`, provenance kriskowal #131 `r3376908385`)
already makes a bare `catch {}` that silently discards the error a must-fix — but
its literal trigger keys on try-body *width*, and this try is tight (one
`realPath` await), so a tight try that still swallows all error classes slips the
panel. A standing rule existed and did not bind through a precise scope hole.

**Threshold.** Recorded as `catch-all-error-swallow`, minted at count=1 / PRs
{653}, status `open`, **held below the floor** (K≥3 across ≥2 PRs not met). The
severity-major bypass does not apply on an honest read — this is `severity:
moderate` (should-fix hardening gap, not a demonstrated escape/crash; the
maintainer's phrasing is a calm refinement). No `review-improve-*` builder job
dispatched. Trip-wire set in the record: a single additional
bare-catch-swallows-all-classes miss on a panelled garden PR should trip the
cluster, with the prevention being to widen the saboteur Tight-try trigger from
body-width to also error-class-breadth, plus a `panel-hints` probe on the
`catch {…} { return undefined|null }` diff signal.

Store: `review-misses/misses/endojs-endo-but-for-bots-pr653-review-344a347f.md`,
`review-misses/clusters/catch-all-error-swallow.md`. The primary feedback loop
(`endojs-endo-but-for-bots-pr653-review-344a347f`) addresses the code itself and
is unchanged by this retro.

Self-improvement: the strongest signal this pass is that a *seat brief rule can
own a concept yet miss its instances because the encoded trigger keys on the
wrong signal* (body-width vs. error-class-breadth). When a future retro finds a
maintainer re-flagging a concern a seat already "covers," check whether the
seat's trigger clause actually fires on the instance shape — a covered concept
with a narrow trigger is a distinct, mechanizable sense-gap worth naming.
