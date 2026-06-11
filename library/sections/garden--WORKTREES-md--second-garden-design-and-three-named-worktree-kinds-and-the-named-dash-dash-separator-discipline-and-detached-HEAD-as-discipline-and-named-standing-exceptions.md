---
title: "kriskowal/garden/WORKTREES.md — second garden design ingested (after cycle 281's designs/driver.md); three named worktree kinds (journal + fork + per-dispatch); the named `--` separator discipline; detached-HEAD-as-named-discipline-for-per-dispatch-checkouts; named standing exceptions for long-lived state"
section-slug: garden--WORKTREES-md--second-garden-design-and-three-named-worktree-kinds-and-the-named-dash-dash-separator-discipline-and-detached-HEAD-as-discipline-and-named-standing-exceptions
source-slug: garden--WORKTREES-md
url: https://github.com/kriskowal/garden/blob/main/WORKTREES.md
authors: [Endo project (collective; the garden's authorship convention names roles not individuals)]
status: (no explicit metadata table, but YAML frontmatter declares created/updated/author = liaison)
ingest-cycle: 297
ingest-date: 2026-06-11
lane: designs
scope: full
total-lines: 168
---

# `kriskowal/garden/WORKTREES.md` (full file)

A 168-line document specifying the garden's worktree management discipline. **The second design from the garden's own repository ingested** (after cycle 281's `designs/driver.md`). Distinct shape from cycle 281: that was a *proposed design* (Status Proposed); WORKTREES.md IS a *standing reference* document that names the existing worktree shapes the garden operates on.

## Key moves

- **§the-second-named-garden-source-document-ingested** (first-explicit-observation): the garden's repo has been ingested twice now — cycle 281 (`designs/driver.md`) + cycle 297 (`WORKTREES.md`). **§two-cycles-with-garden-repo-source-ingest** (281 + 297). §the-garden-IS-named-as-its-own-named-source.

§the-named-distinct-shapes-of-the-two-garden-ingests: 281 was a `designs/X.md` Proposed design; 297 IS a top-level `WORKTREES.md` standing-reference. **§two-named-shapes-of-garden-self-documentation**: proposed-design + standing-reference.

- **§the-`---` YAML frontmatter with named-role-author** (first-explicit-observation):

```yaml
---
created: 2026-05-12
updated: 2026-05-12
author: liaison
---
```

**§the-named-author-field-IS-a-role-not-a-person**: `author: liaison`. The garden's authorship-attribution-discipline names *roles* (liaison + designer + gardener + etc.) rather than individual humans. **§the-named-role-as-author-shape** — extends cycle 281's §multi-author-attribution-by-role-name (gardener + fixer + designer) into the single-author shape.

§three-cycles-with-named-role-as-author-shape-in-the-garden's-own-documents (cycle 281 multi-author + cycle 297 single-author).

§the-frontmatter-IS-YAML-not-the-canonical-endo-`| |` metadata-table-shape: distinct from cycle 287's compartment-mapper design or cycle 283's endo-gateway. §two-named-metadata-shapes-for-design-docs-in-the-garden's-orbit (endo `**Created** | YYYY-MM-DD` table + garden YAML frontmatter).

- **§the-three-named-worktree-kinds** (first-explicit-observation):

```
1. Journal (`journal/`). A worktree of *this* repo on the orphan branch `journal`.
2. Fork worktrees (`worktrees/<owner>-<repo>/<name>/`). Worktrees added from a bare clone at `worktrees/<owner>-<repo>.git/`.
3. Per-dispatch worktrees (`dispatches/<role>--<purpose>--<UTC-ts>--<id>/{garden,journal,project}/`).
```

**§three-named-worktree-categories with-distinct-lifecycle-conventions**: journal (singleton, persistent) + fork (long-lived, on-demand) + per-dispatch (per-invocation, ephemeral). **§the-named-three-tier-lifecycle-categorization**.

§the-named-singleton-persistent-vs-on-demand-long-lived-vs-per-invocation-ephemeral: three named lifecycle-shapes that the worktree system supports.

- **§the-named-orphan-branch-discipline** (first-explicit-observation):

> "Journal (`journal/`). A worktree of *this* repo on the orphan branch `journal`. Created once per machine. Never delete unless intentionally archiving the garden's history."

**§the-journal-branch-IS-orphan + shares-zero-history-with-`main`**. **§the-orphan-branch-as-named-zero-history-separation**: a git branch that intentionally has no common ancestor with main. The journal IS *append-only* and *never-merged*.

§the-named-bootstrap-creates-the-orphan-branch: explicit step `git checkout --orphan journal` + `git rm -rf .` + initial empty commit.

§the-named-PR-comparisons-against-main-are-meaningless: the garden's CLAUDE.md (sibling-document; see the current session's project instructions) names this invariant.

- **§the-named-`--`-separator-discipline-for-filenames** (first-explicit-observation):

```
worktrees/<owner>-<repo>/<purpose-slug>--<role>--<YYYYMMDD-HHMMSS>
```

> "The `--` separators are deliberate: filenames contain no other double-dashes, so a quick `awk -F'--'` parses fields cleanly."

**§the-named-`--`-IS-the-deliberate-field-separator + the-named-no-other-double-dash-invariant**. The choice IS *for tooling-friendliness*: `awk -F'--'` parses field-by-field without escaping. **§the-named-CLI-parser-friendly-naming-convention**.

§the-named-`-`-vs-`--`-distinction: single-dash for hyphen-within-slug + double-dash for field-separator. **§the-named-two-uses-of-dash-distinguished-by-count**.

§the-named-UTC-timestamp-ensures-uniqueness: `<YYYYMMDD-HHMMSS>` in UTC + "ensures uniqueness across concurrent dispatchers without coordination". **§the-named-uniqueness-via-timestamp-not-coordination**.

- **§the-named-`<purpose-slug>--<role>--<UTC-ts>` triple-field-naming** (first-explicit-observation): three named components encode the worktree's identity. **§the-named-three-field-identifier-shape**: purpose + role + timestamp. The purpose answers "what's this for?"; the role answers "who's using it?"; the timestamp answers "when did it start?".

§the-named-cross-machine-uniqueness-discipline (no coordination needed across concurrent dispatchers).

- **§the-worktree-state-lives-in-the-journal-discipline** (first-explicit-observation):

> "Every fork worktree has a single authoritative state file: an entry in the journal index at `journal/worktrees/<hostname>/<worktree-name>.md`. There is no per-worktree TOML."

**§the-no-per-worktree-TOML-IS-named-explicitly**: distinct from systems that put state in each worktree's directory. **§the-named-state-IS-centralized-not-distributed**.

§the-named-`<hostname>/`-IS-the-per-machine-index-scope: each host has its own directory; cross-host conflicts IS impossible by construction.

§the-named-concurrent-edits-merge-cleanly-because-each-worktree-has-its-own-file: §the-named-file-per-worktree-discipline IS the named git-merge-friendliness.

§the-named-`.garden/`-IS-role-private-high-frequency-state: state local to a worktree that's NOT authoritative. **§the-named-non-authoritative-local-state-shape**.

- **§the-named-four-conditions-for-worktree-collectability** (first-explicit-observation):

> A worktree is **collectable** when ALL of:
> - The journal index entry's `status` is not `active` and not `reserved`,
> - `git -C <worktree> status --porcelain` is empty (no uncommitted changes),
> - `git -C <worktree> log @{u}..` is empty, or the branch is local-only and has been merged or abandoned,
> - The journal index entry's `last_heartbeat` is older than 1 hour.

**§four-named-conditions-for-collectability** — all must be true; **§the-named-conjunction-IS-the-named-safety**. §the-named-conservative-collection-discipline: a worktree IS *only* collectable when ALL four signals agree.

§the-named-`1 hour`-IS-the-default-idle-threshold-(tunable-per-role): a named-default with named-override-mechanism.

- **§the-named-collection-procedure with-explicit-`worktree remove`-not-`rm -rf`** (first-explicit-observation):

```sh
git --git-dir=worktrees/<owner>-<repo>.git worktree remove <path>
```

> "Never `rm -rf`. Git tracks the worktree in its admin tree, and `worktree remove` keeps that consistent."

**§the-named-safe-removal-via-git-vs-unsafe-removal-via-shell**: `worktree remove` updates git's internal admin tree; `rm -rf` leaves dangling references. **§the-named-tool-IS-the-only-safe-removal**.

§the-named-warning-against-`rm -rf`-IS-the-named-bug-prevention.

- **§the-named-cooperative-reservation-no-lock** (first-explicit-observation):

> "Reservation is cooperative (no lock), so reserve only as long as you need."

**§the-named-cooperative-vs-mandatory-discipline**: reservation IS *advisory*, not enforced by file-locks. **§the-named-trust-based-coordination**.

§the-named-instruction-to-reserve-only-as-long-as-you-need.

- **§the-per-dispatch-worktree-triple-discipline** (first-explicit-observation):

```
dispatches/<role>--<purpose>--<UTC-YYYYMMDD-HHMMSS>--<short-id>/
  garden/    # detached worktree of garden's `main` branch
  journal/   # detached worktree of garden's `journal` branch
  project/   # (only when applicable) detached worktree of the fork@branch
```

**§the-named-three-sub-worktree-triple**: garden + journal + project (where applicable). **§the-named-isolation-per-dispatch via three-named-sub-worktrees**. §the-named-"no two subagents share filesystem state during a dispatch".

§the-named-`<short-id>`-IS-6-hex-chars + same-generation-rule-as-the-journal-entry-short-id: cross-reference between filesystem (dispatch root path) + journal (the matching dispatch entry).

§the-named-cross-reference-shape: the short-id appears in BOTH the path and the journal entry → human/grep can find the matching pair.

- **§the-detached-HEAD-discipline-for-per-dispatch-checkouts** (first-explicit-observation):

> "All three sub-worktrees are checked out in **detached-HEAD** so the subagent can `git fetch` and rebase or reset its HEAD freely without competing for branch ownership with the orchestrator's own checkouts."

**§the-named-detached-HEAD-IS-the-named-branch-ownership-non-contention-discipline**. The orchestrator owns the named branches (main + journal); the subagent operates in detached-HEAD mode and pushes back via `git push origin HEAD:<branch>`. **§the-named-push-via-detached-HEAD-form**.

§the-named-no-branch-ownership-contention-between-orchestrator-and-subagent.

§the-named-`git push origin HEAD:<branch>`-IS-the-canonical-push-form for detached-HEAD commits.

- **§the-named-orchestrator-helper-scripts** (first-explicit-observation):

```sh
DISPATCH_ROOT=$(scripts/dispatch-prepare.sh <role> <purpose> [<owner>/<repo> <branch>])
# ... Agent invocation ...
scripts/dispatch-teardown.sh "$DISPATCH_ROOT"
```

**§two-named-helper-scripts** as the named lifecycle-encapsulation. §the-named-prepare-and-teardown-pair shape (sibling to the constructor-validator-pair shape from cycle 268+270).

§the-named-idempotent-teardown: "It is idempotent: missing pieces are tolerated." **§the-named-idempotent-cleanup-as-named-robustness-discipline**.

§the-named-subagent-never-creates-or-removes-worktrees-itself: the lifecycle IS *only* the orchestrator's responsibility. **§the-named-asymmetry-of-lifecycle-management**.

- **§the-named-standing-exceptions** (first-explicit-observation):

> "A few daemons and long-lived state holders are *not* per-dispatch entities and are not torn down between dispatches"

**§two-named-standing-exception-categories**:
1. **Bash poll daemons** (`scripts/monitor-poll.sh` + `scripts/review-queue-poll.sh`) — own state that must survive across LLM ticks.
2. **Standing monitor worktrees** at `worktrees/<owner>-<repo>/watch-<slug>--monitor--<ts>/` — host the `.garden-monitor/<owner>-<repo>/` polling state.

**§the-named-exception-IS-the-named-survival-of-cross-tick-state**. §the-named-state-that-must-survive-IS-named-explicitly-as-exception.

§the-named-anti-pattern-warning: "If you find yourself wanting to grow per-dispatch state inside a standing worktree, that is a sign the design has drifted; route it through a journal entry instead."

§the-named-design-drift-IS-the-named-anti-pattern-marker.

- **§the-named-hostname-resolution-IS-`hostname -s`** (first-explicit-observation): the journal's per-machine index uses `journal/worktrees/<host>/` where `<host>` IS `hostname -s`. **§the-named-short-hostname-IS-the-machine-identity**.

§the-named-host-identity-IS-derived-from-the-system-call-not-from-config: any machine that runs the garden uses its own short hostname automatically.

- **§the-named-bare-clone-`info/exclude` pattern** (first-explicit-observation):

```sh
echo '.garden/' >> worktrees/<owner>-<repo>.git/info/exclude
```

> "Once per bare clone: tell git to ignore our metadata directory in every worktree created from it. The per-worktree `.git` is a *file* (worktree pointer), not a directory, so the usual `<worktree>/.git/info/exclude` trick does not work; append to the bare clone's shared exclude instead."

**§the-named-`.git`-file-vs-directory-distinction**: worktree-`.git` IS a *file* (pointer to the shared admin tree); bare-clone-`.git` IS the directory holding the admin tree. **§the-named-where-to-set-exclude-rules-when-the-worktree's-.git-IS-a-file**.

§the-named-bare-clone's-`info/exclude`-IS-the-shared-exclude. §the-named-once-per-bare-clone-discipline.

- **§the-named-"worktrees should be as independent as possible" pedagogy** (first-explicit-observation):

> "This is how 'subagents should be as independent as possible' is mechanized: each subagent reads its own copy of `roles/`, writes journal entries from its own copy of `journal/`, and (when applicable) operates on its own copy of the upstream fork."

**§the-named-mechanization-of-the-independence-principle**: a principle IS named (subagents-should-be-as-independent-as-possible); the named-mechanism IS the per-dispatch worktree triple. **§the-named-principle-IS-mechanized-via-named-implementation**.

§the-named-bridge-from-principle-to-implementation: the doc names *what* and *how* in adjacent sentences.

## §the-named-Markdown-link-to-the-other-garden-document (first-explicit-observation)

The doc references `CLAUDE.md § Dispatch prompt template` for "the wording" of dispatch prompts. **§the-named-cross-document-section-reference**: not just "see CLAUDE.md" but "see CLAUDE.md § Dispatch prompt template" — naming the *exact section*.

§the-named-section-anchor-IS-the-named-precision-reference. §named-Markdown-link-precision (sibling-pattern to cycle 287's §the-Implementation-section-organized-by-source-file).

## §the-named-asymmetric-three-fields-in-the-per-dispatch-naming (first-explicit-observation)

Per-dispatch directory IS named `<role>--<purpose>--<UTC-ts>--<id>` — FOUR fields, not three. The fork-worktree IS named `<purpose-slug>--<role>--<YYYYMMDD-HHMMSS>` — THREE fields. **§two-named-naming-conventions-with-different-field-counts**: fork-worktrees IS three-field; per-dispatch IS four-field (with the short-id added).

§the-named-extra-id-field-for-per-dispatch IS the discipline that supports running multiple-per-second dispatches with the same role+purpose+timestamp (e.g., multiple stewards firing simultaneously).

§the-named-resolution-via-short-id IS distinct from §the-named-resolution-via-timestamp: timestamps have 1-second granularity; short-ids have 16-million-value granularity.

## Patterns from prior cycles, reaffirmed

- **§two-cycles-with-garden-repo-source-ingest** (cycle 281 designs/driver.md + cycle 297 WORKTREES.md).
- **§the-named-role-as-author-shape** — cycle 281 noted multi-author by role; cycle 297 instantiates the single-author-by-role shape.
- **§the-named-cross-document-section-reference** — multiple cycles now have noted this discipline.

## Borrowing tiers

- **Tier 1 (direct, exact-shape)**: §the-second-named-garden-source-document-ingested + §the-`---`-YAML-frontmatter-with-named-role-author + §the-named-author-field-IS-a-role-not-a-person + §the-frontmatter-IS-YAML-not-the-canonical-endo-`| |`-metadata-table-shape + §the-three-named-worktree-kinds + §three-named-worktree-categories-with-distinct-lifecycle-conventions + §the-named-three-tier-lifecycle-categorization + §the-named-singleton-persistent-vs-on-demand-long-lived-vs-per-invocation-ephemeral + §the-named-orphan-branch-discipline + §the-orphan-branch-as-named-zero-history-separation + §the-named-`--`-separator-discipline-for-filenames + §the-named-no-other-double-dash-invariant + §the-named-CLI-parser-friendly-naming-convention + §the-named-`-`-vs-`--`-distinction + §the-named-two-uses-of-dash-distinguished-by-count + §the-named-UTC-timestamp-ensures-uniqueness + §the-named-uniqueness-via-timestamp-not-coordination + §the-named-`<purpose-slug>--<role>--<UTC-ts>`-triple-field-naming + §the-named-three-field-identifier-shape + §the-named-cross-machine-uniqueness-discipline + §the-worktree-state-lives-in-the-journal-discipline + §the-no-per-worktree-TOML-IS-named-explicitly + §the-named-state-IS-centralized-not-distributed + §the-named-`<hostname>/`-IS-the-per-machine-index-scope + §the-named-concurrent-edits-merge-cleanly-because-each-worktree-has-its-own-file + §the-named-file-per-worktree-discipline + §the-named-`.garden/`-IS-role-private-high-frequency-state + §the-named-non-authoritative-local-state-shape + §the-named-four-conditions-for-worktree-collectability + §the-named-conjunction-IS-the-named-safety + §the-named-conservative-collection-discipline + §the-named-`1 hour`-IS-the-default-idle-threshold-(tunable-per-role) + §the-named-collection-procedure-with-explicit-`worktree remove`-not-`rm -rf` + §the-named-safe-removal-via-git-vs-unsafe-removal-via-shell + §the-named-tool-IS-the-only-safe-removal + §the-named-cooperative-reservation-no-lock + §the-named-cooperative-vs-mandatory-discipline + §the-named-trust-based-coordination + §the-per-dispatch-worktree-triple-discipline + §the-named-three-sub-worktree-triple + §the-named-isolation-per-dispatch-via-three-named-sub-worktrees + §the-named-`<short-id>`-IS-6-hex-chars + §the-named-cross-reference-shape + §the-detached-HEAD-discipline-for-per-dispatch-checkouts + §the-named-detached-HEAD-IS-the-named-branch-ownership-non-contention-discipline + §the-named-push-via-detached-HEAD-form + §the-named-`git push origin HEAD:<branch>`-IS-the-canonical-push-form + §the-named-orchestrator-helper-scripts + §two-named-helper-scripts-as-the-named-lifecycle-encapsulation + §the-named-prepare-and-teardown-pair-shape + §the-named-idempotent-teardown + §the-named-idempotent-cleanup-as-named-robustness-discipline + §the-named-subagent-never-creates-or-removes-worktrees-itself + §the-named-asymmetry-of-lifecycle-management + §the-named-standing-exceptions + §two-named-standing-exception-categories + §the-named-exception-IS-the-named-survival-of-cross-tick-state + §the-named-anti-pattern-warning + §the-named-design-drift-IS-the-named-anti-pattern-marker + §the-named-hostname-resolution-IS-`hostname -s` + §the-named-short-hostname-IS-the-machine-identity + §the-named-host-identity-IS-derived-from-the-system-call-not-from-config + §the-named-bare-clone-`info/exclude`-pattern + §the-named-`.git`-file-vs-directory-distinction + §the-named-where-to-set-exclude-rules-when-the-worktree's-.git-IS-a-file + §the-named-once-per-bare-clone-discipline + §the-named-"worktrees-should-be-as-independent-as-possible"-pedagogy + §the-named-mechanization-of-the-independence-principle + §the-named-principle-IS-mechanized-via-named-implementation + §the-named-bridge-from-principle-to-implementation + §the-named-Markdown-link-to-the-other-garden-document + §the-named-cross-document-section-reference + §the-named-section-anchor-IS-the-named-precision-reference + §the-named-asymmetric-three-fields-in-the-per-dispatch-naming + §two-named-naming-conventions-with-different-field-counts + §the-named-extra-id-field-for-per-dispatch + §the-named-resolution-via-short-id-IS-distinct-from-the-named-resolution-via-timestamp — all sixty-three first-explicit-observations.
- **Tier 2 (clear analogue, named-shape)**: §two-cycles-with-garden-repo-source-ingest (281 + 297) + §the-named-role-as-author-shape (cycle 281 multi-author + cycle 297 single-author) + §two-named-shapes-of-garden-self-documentation (proposed-design + standing-reference) + §three-cycles-with-named-role-as-author-shape-in-the-garden's-own-documents (cycle 281 + cycle 297; second cycle).
- **Tier 3 (multi-cycle pattern recognition)**: §the-garden-IS-named-as-its-own-named-source + §the-named-distinct-shapes-of-the-two-garden-ingests.

## Synthesis target

Slot machine library `@game/WORKTREES.md`: three-named-worktree-kinds (state + game-fork + per-tournament-ephemeral); the named `--` separator discipline for filenames with named-`awk -F'--'`-friendliness; the named-orphan-branch shape for the state-log (zero-history-shared with main); the four-named-conditions-for-game-table-collectability (status not active/reserved + no uncommitted changes + branch merged + heartbeat > 1 hour); the named-safe-removal-via-git-vs-rm-rf; the named-cooperative-reservation-no-lock; the per-tournament-worktree-triple discipline (game-state + history + table-fork); the detached-HEAD discipline; the named-helper-scripts (prepare + teardown) with named-idempotent-cleanup; the named-standing-exceptions for long-lived state; the named-bare-clone-`info/exclude` pattern; the named-asymmetric-three-vs-four-field-naming-conventions.

## Single most structurally interesting move

**§the-detached-HEAD-discipline-for-per-dispatch-checkouts** combined with **§the-named-no-branch-ownership-contention-between-orchestrator-and-subagent** — the per-dispatch worktree triple uses **detached HEAD** for all three sub-worktrees. The orchestrator owns the named branches (main + journal); the subagent operates in detached-HEAD mode and pushes back via `git push origin HEAD:<branch>`.

This generalizes a deep pattern about *concurrent git use*: **branches IS a singleton resource per checkout**, and two checkouts that both have the same branch checked out *fight over which one IS authoritative*. Detached-HEAD removes the branch-ownership question entirely: the subagent's checkout has no branch, just a commit. **§the-named-detached-HEAD-eliminates-the-branch-singleton-contention**.

The discipline generalizes far beyond the garden: any orchestrator that wants to launch many concurrent workers against the same git repo can use detached-HEAD-per-worker to avoid coordination overhead. The workers push via `git push origin HEAD:<branch>` which lets the remote's branch-update path serialize the writes naturally (with retries on rejection).

§the-named-pattern-eliminates-coordination-by-removing-the-contended-resource. The same pattern shows up in distributed-system design as **"contention reduction through removal of the singleton"** (queue-based work distribution avoids singleton-lock + CRDT-based replication avoids singleton-leader + content-addressed storage avoids singleton-name).
