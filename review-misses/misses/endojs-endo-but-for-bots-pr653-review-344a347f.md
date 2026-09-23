---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr653-review-344a347f
verdict: miss
category: correctness-bug
pr: 653
repo: endojs/endo-but-for-bots
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/653#pullrequestreview-4673736338
identity: endojs/endo-but-for-bots#653:review:4673736338:retro
producing_role: gardener
producing_job: gauntlet-endo-but-for-bots-pr653-mount-glob
missed_by: saboteur
severity: moderate
cluster: catch-all-error-swallow
cluster_pattern: A bare `catch {}` / `catch (_) {}` that returns a sentinel (undefined/null/default) for EVERY error class when the code's documented intent is to absorb only one expected class (ENOENT, not-found, broken-symlink); the saboteur's Tight-try discipline fires on try-body *width* but not on error-class *breadth*, so a tight try whose catch still swallows all classes slips the panel.
---

# Miss: swallow-all `catch` in `maybeRealPath` on #653 (mount glob)

kriskowal's CHANGES_REQUESTED review on #653 ("feat(daemon): mount glob")
carried two inline comments; both are paraphrased here (verbatim untrusted text
at `comment_url`):

1. **`packages/daemon/src/daemon.js`** — an API-ergonomics ask: the current way
   of expressing a denial is a *cumbersome pattern* when a plain `deniedSegments`
   option (without extra ceremony) should have the same effect.
2. **`packages/daemon/src/mount.js`**, on the newly-added `maybeRealPath` helper —
   two asks: **(a)** move the helper into the `platform` module, and **(b)** make
   sure it *only promotes appropriate error classes to `undefined`*.

The flagged helper (paraphrased shape; the JSDoc documents a narrow intent —
"removed mid-walk, broken symlink"):

```
const maybeRealPath = async (candidatePath, filePowers) => {
  try { return await filePowers.realPath(candidatePath); }
  catch { return undefined; }   // <- bare catch: swallows EVERY error class
};
```

## Grounds — comment 2(b) IS a review miss

The defect is a bare `catch {}` that promotes **all** error classes to
`undefined`, on a **security-sensitive confinement path**: `maybeRealPath` exists
to detect symlink cycles "by physical identity" so the new `**` descent stays
bounded (the gauntlet report on this same PR records that the `**`-recursion
cycle guard depends on this realpath identity). The JSDoc documents a *narrow*
intent — undefined only when the path "cannot be resolved (removed mid-walk,
broken symlink)", i.e. ENOENT-class — yet the implementation catches everything.
An unexpected error (EACCES, EMFILE/EIO, an ELOOP past the OS limit, or a
programming `TypeError`) is silently converted to "no physical identity", which
the cycle guard then cannot distinguish from a genuinely-absent path. That is a
mismatch between a published contract and the code — the breaker/saboteur lens —
and a hardening gap on a capability-confinement boundary.

**A standing rule already existed and did not bind.** The saboteur seat brief
(`roles/jurors/saboteur/AGENT.md`, "Tight-try discipline") explicitly makes a
bare `catch {}` / `catch (_) {}` that "silently discards the error" a **must-fix**,
with provenance from *this same maintainer* on `endojs/endo-but-for-bots#131`
inline `r3376908385` (2026-06-09): the try/catch swallowing "real errors beyond
those thrown by JSON.parse." But that rule's literal **trigger** is scoped to a
try body "wider than the operation that can throw." Here the try body is *tight*
(exactly the one `realPath` await), so the rule's trigger never fires even though
its underlying concern — a bare catch discarding every error class — is exactly
what the maintainer flagged again. This is a genuine sense-gap: the panel owned
the concept and still missed the instance because the encoded trigger keyed on
the wrong signal (body width, not error-class breadth). It is a review miss, not
new direction: the maintainer is asking the code to narrow an over-broad catch, a
recurring correctness/hardening class, not proposing a first-stated requirement.

## Why the other asks are NOT clustered as misses

- **Comment 1 (daemon.js `deniedSegments` "without ceremony")** is API-ergonomics
  taste / new direction. It expresses a preference for a simpler denial surface
  (a plain `deniedSegments` option in place of a more ceremonious pattern). No
  seat brief, skill, or standing instruction encodes "prefer the un-ceremonious
  `deniedSegments` shape"; nobody could have anticipated this specific ergonomic
  preference. This continues the ongoing `deniedSegments` API dialogue also seen
  on #650 (record `…-pr650-review-35ff43ca`). Not a defect the panel let through;
  mints no cluster.
- **Comment 2(a) ("move `maybeRealPath` into `platform`")** is module-factoring
  taste. Where a small helper belongs is an architectural placement decision, not
  a review-catchable defect the panel demonstrably knows. Recorded here so it is
  not separately re-litigated; mints no cluster.

## Threshold call recorded at this record's tail

The `catch-all-error-swallow` cluster is **minted at count=1 (PRs {653})** and
**HELD below the floor** (K ≥ 3 across ≥ 2 PRs not met). The severity bypass does
**not** apply here on an honest reading: the bypass requires a `severity: major`
miss, and this is `severity: moderate` — a should-fix hardening/robustness gap on
a confinement path, not a demonstrated escape, crash, or data loss. The
maintainer's own framing is a calm refinement ("Please make sure that it only
promotes appropriate error classes"), paired with a pure-taste factoring ask —
should-fix tenor, not a critical-defect flag.

The grounds here are nonetheless materially **stronger** than a "no rule exists"
prevention gap (contrast the `avoid-name-abbreviations` cluster, held at count=1
because *no* seat encodes the rule). Here a rule DOES exist with a precise,
demonstrable scope hole. Explicit trip-wire: a **single** additional
bare-catch-swallows-all-classes miss on any garden-authored panelled PR should
trip this cluster for a `review-improve-catch-all-error-swallow` dispatch whose
prevention widens the saboteur's Tight-try trigger from try-body *width* to also
cover error-class *breadth* (a bare `catch`/`catch (_)` returning a sentinel for
all classes when a narrower expected class is documented), and whose sensing adds
a `panel-hints` probe that fires the saboteur seat on the
`catch {…} { return undefined|null }` diff signal. See `comment_url` for the
verbatim review.
