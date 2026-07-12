---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr678-review-4d666bb1
verdict: miss
category: correctness-bug
pr: 678
repo: endojs/endo-but-for-bots
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/678#pullrequestreview-4680172450
identity: endojs/endo-but-for-bots#678:review:4680172450:retro
producing_role: gardener
producing_job: build-endo-glob-grep-pushdown
missed_by: saboteur
severity: minor
cluster: catch-all-error-swallow
cluster_pattern: A bare `catch {}` / `catch (_) {}` that returns a sentinel (undefined/null/default) for EVERY error class when the code's documented intent is to absorb only one expected class (ENOENT, not-found, broken-symlink); the saboteur's Tight-try discipline fires on try-body *width* but not on error-class *breadth*, so a tight try whose catch still swallows all classes slips the panel.
---

# Miss: bare-catch `maybeRealPath` swallows every error class on #678

kriskowal's CHANGES_REQUESTED review on #678 (review `4680172450`, empty body)
carried four inline comments on `packages/platform/src/fs/search.js`, all
paraphrased here (verbatim untrusted text at `comment_url`):

1. **conservative-regex machinery** — suspicion it cannot be correct without a
   full regex lexer; drop it and mitigate the availability risk elsewhere, or
   revisit later with greater rigor.
2. **`maybeRealPath` error classification** — the function belongs next to
   `realPath` and could be factored into a dependency PR; it should classify
   errors more rigorously so that, e.g., a `RangeError` passes through, promoting
   to `undefined` **only** when the referent does not exist.
3. **`isWithin`** — almost certainly a shared utility with the daemon mounts;
   factor it out.
4. **duplicated `maybeRealPath`** — the same block appears twice in the file.

## Grounds (miss — comments 2 and 4, one pattern)

The recordable review miss is the **error-class breadth of `maybeRealPath`**, and
comments 2 and 4 are the same defect surfaced twice. In the reviewed tree
(`0e92634`), the helper (line 257) is a bare swallow —

    try { return await powers.maybeRealPath(path); } catch { return undefined; }

— and the identical block is **duplicated** in `provideSearch`'s `maybeRealPath`
adapter (line 619), which comment 4 ("Duplicated. See above in same file.")
points at. Both `catch {}` clauses return `undefined` for **every** error class,
so a genuine bug — the maintainer's example `RangeError`, or any programmer error
inside the powers call — is silently reported as "path does not exist." Because
that resolved path feeds the confinement check (`isWithin(real, root)`), a
swallowed error also degrades a security-relevant decision to the not-confined
path, which is why this is a correctness miss rather than a nit. The primary loop
confirmed the diagnosis: its fix promotes **only** `ENOENT`/`ENOTDIR`/`ELOOP` to
`undefined` and lets bugs like `RangeError` propagate.

This is a second instance of the `catch-all-error-swallow` pattern (first: #653),
now on a **distinct PR**. A design-tension panel of five reviewers demonstrably
ran on #678 in the stack gauntlet (`gauntlet-endo-glob-grep-stack`) over this
exact diff, and the taxonomy assigns catch-all error swallowing to the
adversarial `saboteur`/`breaker` lens — yet the panel weighed the *design*
tensions (platform/daemon seam, batching, glob↔grep decoupling) and let both bare
catches through. It matches the cluster's own diagnosis precisely: the saboteur's
Tight-try discipline fires on try-**body width** (both try bodies here are a
single statement — maximally tight) but not on error-**class breadth**, so a tight
try whose catch still swallows all classes slips the seat. Genuine review miss.

## Why comments 1 and 3 are NOT separate misses

- **Comment 1 (drop the conservative-regex machinery).** The gauntlet panel
  *explicitly* weighed the `isConservativeRegex` native-portability seam and
  recorded it as a resolved design tension (with "doc sharpening" as a follow-up);
  it also referred the grep-ReDoS question up to the maintainer, tied to the
  in-flight `@endo/regexp` #676. The maintainer's "drop it — I doubt it can be
  correct without a full lexer" is a rigor/direction call that overrides a
  defensible panel judgment, not a check the panel failed to run. New direction,
  not a review miss.
- **Comment 3 (factor `isWithin` out to share with mounts).** This is
  cross-package code-organization direction — hoisting a confinement helper across
  the `@endo/platform`/daemon seam into a shared home, work the later stack layers
  were already staged to do. A panel could reasonably not pre-empt where a
  utility should live across a multi-PR seam. Code-organization direction, not a
  review miss. (Recorded here so neither comment is separately re-litigated;
  neither mints a cluster.)

## Threshold call recorded at this record's tail

Joining this miss bumps `catch-all-error-swallow` to **count=2** across
**prs={653, 678}** — two *distinct* PRs, but still one short of the floor
(**K≥3** misses across ≥2 PRs). **Hold below the floor and accumulate.** The
severity bypass does not apply: this is `severity: minor` (a path-resolution
helper whose blast radius is a degraded confinement decision, not a crash or data
loss), and — decisively — no standing rule *bound* on the axis that failed. The
saboteur's Tight-try discipline is written for try-body width, and the cluster
exists precisely because error-class breadth has **no** encoded check yet; this is
a prevention-gap to be created, not a sense-and-correct failure of a rule that
already existed. Unlike the `avoid-name-abbreviations` cluster (which sat on a
single PR), this pattern now genuinely spans two PRs, so **one more panelled
bare-catch swallow on any PR trips the floor** and should dispatch
`review-improve-catch-all-error-swallow` (prevention: a saboteur-brief line on
error-class breadth + a pre-push/panel probe on `catch {}`-returns-sentinel;
sensing: the probe fires on the historical #653 and #678 diffs).
