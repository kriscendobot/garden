---
title: "kriskowal/garden/WORKTREES.md — worktree management discipline (168 lines); second garden source ingested"
source-slug: garden--WORKTREES-md
url: https://github.com/kriskowal/garden/blob/main/WORKTREES.md
authors: [Endo project (collective; the garden's named-role-as-author convention; the doc's frontmatter author IS liaison)]
repo: kriskowal/garden
path: WORKTREES.md
total-lines: 168
ingest-cycle: 297
ingest-date: 2026-06-11
lane: designs
---

# `kriskowal/garden/WORKTREES.md`

A 168-line document specifying the garden's worktree management discipline. **The second design from the garden's own repository ingested** (after cycle 281's `designs/driver.md`). Distinct shape: cycle 281 was a *proposed design* (Status Proposed); cycle 297 IS a *standing reference* document.

## Key moves

- **§the-second-named-garden-source-document-ingested** — §two-cycles-with-garden-repo-source-ingest (281 + 297); §two-named-shapes-of-garden-self-documentation (proposed-design + standing-reference).
- **§the-`---` YAML frontmatter with named-role-author** — `author: liaison`; §the-named-author-field-IS-a-role-not-a-person; extends cycle 281's §multi-author-attribution-by-role-name into the single-author shape.
- **§two-named-metadata-shapes-for-design-docs-in-the-garden's-orbit** — endo `**Created** | YYYY-MM-DD` table vs garden YAML frontmatter.
- **§the-three-named-worktree-kinds** — journal (singleton-persistent) + fork (long-lived-on-demand) + per-dispatch (per-invocation-ephemeral); §the-named-three-tier-lifecycle-categorization.
- **§the-named-orphan-branch-discipline** — journal branch shares zero history with main; §the-orphan-branch-as-named-zero-history-separation.
- **§the-named-`--`-separator-discipline-for-filenames** — `awk -F'--'`-friendly; §the-named-no-other-double-dash-invariant; §the-named-`-`-vs-`--`-distinction (single-dash for hyphen-within-slug + double-dash for field-separator).
- **§the-named-`<purpose-slug>--<role>--<UTC-ts>` triple-field-naming** for fork worktrees; named-three-field-identifier-shape.
- **§the-named-UTC-timestamp-ensures-uniqueness-across-concurrent-dispatchers-without-coordination**.
- **§the-worktree-state-lives-in-the-journal-discipline** — the-no-per-worktree-TOML-IS-named-explicitly; the-named-state-IS-centralized-not-distributed.
- **§the-named-`<hostname>/`-IS-the-per-machine-index-scope** — concurrent edits merge cleanly because each worktree has its own file (file-per-worktree discipline).
- **§the-named-`.garden/`-IS-role-private-high-frequency-state** — named-non-authoritative-local-state-shape.
- **§the-named-four-conditions-for-worktree-collectability** — status + no-uncommitted + no-unpushed-or-merged + heartbeat > 1 hour; the-named-conjunction-IS-the-named-safety; named-conservative-collection-discipline.
- **§the-named-collection-procedure with-explicit-`worktree remove`-not-`rm -rf`** — the-named-safe-removal-via-git-vs-unsafe-removal-via-shell.
- **§the-named-cooperative-reservation-no-lock** — the-named-trust-based-coordination.
- **§the-per-dispatch-worktree-triple-discipline** — garden + journal + project sub-worktrees; the-named-isolation-per-dispatch.
- **§the-named-`<short-id>`-IS-6-hex-chars + cross-reference-shape** between dispatch path and journal entry.
- **§the-detached-HEAD-discipline-for-per-dispatch-checkouts** — the-named-detached-HEAD-IS-the-named-branch-ownership-non-contention-discipline; the-named-`git push origin HEAD:<branch>`-IS-the-canonical-push-form.
- **§the-named-orchestrator-helper-scripts** — dispatch-prepare.sh + dispatch-teardown.sh; the-named-prepare-and-teardown-pair-shape; named-idempotent-cleanup-as-named-robustness-discipline.
- **§the-named-subagent-never-creates-or-removes-worktrees-itself** — the-named-asymmetry-of-lifecycle-management.
- **§the-named-standing-exceptions** — two named categories (bash poll daemons + standing monitor worktrees); the-named-state-that-must-survive-IS-named-explicitly-as-exception.
- **§the-named-anti-pattern-warning** — "If you find yourself wanting to grow per-dispatch state inside a standing worktree, that is a sign the design has drifted; route it through a journal entry instead."
- **§the-named-hostname-resolution-IS-`hostname -s`** — named-host-identity-IS-derived-from-the-system-call.
- **§the-named-bare-clone-`info/exclude` pattern** — the-named-`.git`-file-vs-directory-distinction; the-named-where-to-set-exclude-rules-when-the-worktree's-.git-IS-a-file.
- **§the-named-"worktrees should be as independent as possible" pedagogy** — the-named-mechanization-of-the-independence-principle.
- **§the-named-Markdown-link-to-the-other-garden-document** — `CLAUDE.md § Dispatch prompt template` (named exact section).
- **§the-named-asymmetric-three-fields-in-the-per-dispatch-naming** — fork-worktrees IS three-field (purpose + role + ts); per-dispatch IS four-field (role + purpose + ts + short-id); §two-named-naming-conventions-with-different-field-counts.

## Section files

- [§the-second-named-garden-source-document-ingested + §three-named-worktree-kinds + §the-named-`--`-separator-discipline + §the-detached-HEAD-discipline + §named-standing-exceptions](../sections/garden--WORKTREES-md--second-garden-design-and-three-named-worktree-kinds-and-the-named-dash-dash-separator-discipline-and-detached-HEAD-as-discipline-and-named-standing-exceptions.md) — full 168-line document in scope.

## Ingest scope

Cycle 297 (designs-lane after cycle 296 chat-lane @endo/zip/src/format-reader.js completing the zip cluster source-file deep ingest). Full 168-line document in scope. **First-explicit-observations (sixty-three)** at full scope covering the three named worktree kinds, the YAML frontmatter with role-as-author, the named `--` separator discipline, the orphan-branch zero-history separation, the four named collectability conditions, the named-safe-removal vs rm -rf, the cooperative-reservation-no-lock, the per-dispatch worktree triple, the detached-HEAD-discipline, the named orchestrator helper scripts, the named standing exceptions for long-lived state, the named bare-clone exclude pattern, and the named pedagogy bridging the independence principle to its mechanization.
