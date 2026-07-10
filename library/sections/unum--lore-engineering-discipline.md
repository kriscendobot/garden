---
title: Engineering discipline for a self-editing harness — design-out, lighter-cut, fail-loud, seam-inject
source: LORE/ (design-discipline & Go-patterns clusters)
source_repo: jcorbin.tngl.sh/unum
source_commit: 1834abac9b27e517d0ffd2bf20625e33e9a05028
source_date: 2026-06-21
source_authors: [jcorbin]
ingested: 2026-07-10
ingested_by: scholar
topics: [repository-governance, testing]
status: current
notes: |
  Consolidates the LORE design-discipline and Go-patterns clusters:
  design_out_dont_coordinate_around, lighter_cut_design_discipline,
  silent_failure_log_and_swallow, schema_duplication_doc_drift, no_dead_parsed_fields,
  seam_injection_for_testability.
---

## Abstract

unum is a **self-editing harness** — the code runs the very agent that edits it — so
its engineering discipline is shaped by one constraint: *blast radius matters more than
completeness, because a broken harness cannot self-repair.* Five transferable
disciplines fall out of that constraint. They apply to any codebase, but they are
sharpened here because a regression can brick the thing that would fix the regression.

## Design out the hazard; don't coordinate around it

> "The two-runs-racing-onto-one-branch hazard simply does not exist — it's designed
> out, not coordinated around."

The defining architectural move was the **bare-repo / per-worktree** reorganization:
one worktree per invocation, each on its own branch. The point was not to *coordinate*
concurrent runs onto a shared branch with a lock — it was to **make the shared-branch
commit race impossible**, so the realm-wide serial lock could be *deleted* rather than
tuned. The general lesson: **when a hazard is a race or a shared-mutable, prefer a
structure where it can't arise over a protocol that carefully avoids it.** Locks,
careful ordering, and "be sure to call X before Y" are coordination — fragile and easy
to regress. Isolation is design — the bug class is gone. Two corollaries: **key state on
durable, immutable content** (git objects, tree hashes) rather than mutable artifacts
(filenames, commit messages, worktree presence) — a milestone signal keyed on tree-hash
survives a history rewrite that a commit-message grep does not; and **once a value is
resolved (a scope path, a worktree path), thread it through — don't re-derive it**, since
every re-derivation is a fresh chance to derive it wrong. (This is the same instinct
behind the garden's own push-CAS-as-serialization-point: the claim race is designed out,
not locked around.)

## The "lighter cut": ship the smallest thing that captures most of the value

Faced with a big, tempting refactor, the repeated move is the **lighter cut** — the
smallest change that captures most of the value now, with the full version *named,
scoped, and deferred* rather than built. This is not corner-cutting: the deferred option
is explicitly recorded (in a `TOQU/`/`MAYB/` shelf) so it can be revived when the cost is
justified. Why it's the right default for a self-evoking harness: a small, reversible
change that ships beats a big one that risks the running system; deferred-but-recorded is
cheap insurance (YAGNI costs nothing if never needed, loses nothing if it is); and keeping
the old path as a **default** alongside a narrow new override dodges a flag-day. The
discipline: when you reach for a big refactor, ask what the lighter cut is; name the heavy
version and why someone would want it; keep the old default; reserve the heavy cut for
when the lighter one demonstrably stops paying.

## Fail loud without failing the push (the log-and-swallow trap)

The single most expensive bug class in the project's history is a failure that was
**logged and swallowed instead of surfaced**. Two individually-sound disciplines
conspire to hide bugs: the git hook's "**never block a push**" rule and the daemon's
defensive **early-return-on-error** paths. Both turn a real bug into a quiet no-op — the
push succeeds, the log line scrolls past, and the failure stays invisible for weeks (a
missing container git identity masked a whole broken commit pipeline *for weeks*). The
resolution holds both truths: **fail loud without failing the push.** Do the defensive
thing (don't crash the user's `git push`), but emit an **unmistakable, distinct,
test-asserted signal** on the way out. Concretely: give every early-return/error path its
*own* distinguishable log line ("failed at the git-identity check", not "it failed");
have tests **assert the specific log line** was or wasn't emitted, so a regression that
re-routes into a swallow path is caught by the test not by a human weeks later; and prefer
**sentinel exit-code files** over parsing rendered output a no-op can fake.

## Schema duplication is the source of doc-vs-code drift

> "Cross-reference design docs, never inline-copy schemas."

When a schema (a config block, a frontmatter shape, an envelope format) is *copied* into
a second document, the two copies drift the moment one is edited and the other isn't. The
remedy is **structural, not diligence-based: one canonical definition; every other mention
is a cross-reference.** You cannot forget to update a copy that doesn't exist. A
second-order trap makes it worse: **tests lock in the code's *actual* behaviour — including
when it's wrong** — so a doc-vs-code contradiction doesn't break the build; the test passes,
the doc lies, and nobody notices until an audit reads both side by side. When code and doc
disagree, treat it as a bug: decide which is right, fix the other, and fix the test if it
encoded the wrong behaviour.

## No dead parsed fields — parse only what a consumer reads

A config field that is parsed but unread is **dead surface**, not a forward-compat hedge.
It misleads (a reader assumes it does something and schedules behaviour around it), accrues
schema debt (every later change must keep it consistent for no payoff), and the cost is paid
up front and continuously while the benefit is speculative and free to add later. **Parse a
field only when its first consumer is wired up** — the parse and the read land in the same
increment, so the schema never advertises more than the code honours. A deliberately staged
arc (P1→P2) is exactly when the temptation to pre-parse is strongest and exactly when to
resist it: defer the field to the increment that reads it.

## Seam injection for testability — the fake-runner pattern

Every package that touches the real system (systemd, git, network, clock, the agent
process) is built around an **injectable seam**: an interface whose production impl shells
out and whose test impl is a fake that records calls and returns scripted results. The
canonical seam is the **runner** — code calls `runner.Run(...)` instead of `exec.Command(...)`
directly. This is what makes it safe to change a self-evoking harness in fast unit tests. The
trap: **a fake that omits a side effect the real system has** passes the test while production
differs (`enable-linger` spawns a `user@<uid>.service` the fake didn't model — "expect inactive"
passed in test, failed against a real kernel). The rule: inject the seam at *design* time, not
retrofitted; **a fake must model the side effects the test asserts about**, and when it can't
(kernel/systemd behaviour), escalate that case to a real-kernel VM tier rather than trusting the
fake; and prefer recorded-call / sentinel assertions over rendered-string reads a no-op can fake.

Source: LORE `design_out_dont_coordinate_around`, `lighter_cut_design_discipline`,
`silent_failure_log_and_swallow`, `schema_duplication_doc_drift`, `no_dead_parsed_fields`,
`seam_injection_for_testability` at
[jcorbin.tngl.sh/unum](https://tangled.org/jcorbin.tngl.sh/unum) commit `1834aba`.
