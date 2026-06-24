---
ts: 2026-05-15T00:40:45Z
kind: dispatch
role: steward
project: endo-but-for-bots
to: "*"
refs:
  - entries/2026/05/14/224630Z-dispatch-steward-e14cd5.md
---

# Dispatch: builder drafts initial tracking PR for `designs/cli-edit-verb.md` (design-to-PR pipeline iter 2)

Dispatch root: `dispatches/builder--5b2109/`. Project worktree on `endojs/endo-but-for-bots@llm`.

## Why this design is next-owed

Walking the roadmap branch's design tree newest-first, `designs/cli-edit-verb.md` is the next uncovered design after `cli-store-verb-text-modes` (covered iter 1 by PR #254).

Coverage audit:

- PR #162 (`design/cli-edit-verb`, MERGED) — the design's landing PR. Adds `designs/cli-edit-verb.md` to llm. Not a tracking PR for implementation.
- PR #204 (`feat/cli-edit-verb`, **CLOSED-not-merged**) — `feat(cli,daemon): tentative endo edit verb impl (per design #162) — surfaces design gaps`. The tentative implementation was abandoned after surfacing gaps in the design. Per `skills/design-to-pr-pipeline/SKILL.md` § What counts as covered, closed-not-merged does not cover; the design re-enters the uncovered set.
- Recent commits to the design itself (`cd21d5c56`, `7ff7a7611`, `fb0d2f51b`, `0d8ed54d2`) addressed the gaps #204 surfaced. The post-revision design now has a tighter API.

No other PR cross-references `designs/cli-edit-verb.md` per `gh pr list --search "cli-edit-verb"`.

Concurrency cap (1 builder for design-PR-drafting in flight) is free; e14cd5 returned via #254 last cycle, judge 883a5d returned this evening.

## Per-action authorization

- Push a single new branch `design/cli-edit-verb-tracking` to the bot fork.
- Open a draft PR against base `llm` per the skill's *Base branch is the roadmap branch* rule.
- No master-base work, no comment on PR #162 or #204, no edit to the design document.

## Task

Read the design at `designs/cli-edit-verb.md` on `llm`. Note the post-revision state (in particular the EndoGuest-API-first reshape from `0d8ed54d2`, the kebab-case discriminated-union shape from `fb0d2f51b`, the single CRC32 anchor + SHA-256 file-rev decision from `7ff7a7611`, and the gaps-folded-in commit `cd21d5c56`).

Pick the initial PR shape per the skill's three options:

- (a) stub-checklist — **contraindicated** per the iter-1 builder's self-improvement (`224908Z-result-builder-e14cd5.md`) for projects whose `pr-formation` discipline forbids author-checklists in PR bodies. Endo-but-for-bots qualifies.
- (b) placeholder-readme — a README addition naming the design and the slug, opening the slot.
- (c) initial-pass skeleton — function signatures, types, failing tests codifying the design's stated acceptance.

The design has precise APIs (EndoGuest interface, hashline patch format, CRC32+SHA-256 anchors) — (c) is a stronger fit than (b) for this design, IF the builder can read the post-revision design and write signatures that compile. If the design's surface is still mixing pre- and post-revision shapes (look for "Status: In Progress" sub-items that contradict the recent commits per `skills/design-queue-drift-check/SKILL.md`), fall back to (b).

Justify the choice in one sentence in the PR body.

The tracking PR's purpose is to *exist* and *cross-reference the canonical design path* so the next inventory pass marks the design as covered. No implementation work in this dispatch.

## Out of scope

- No work on `master` base.
- No comment on PRs #162, #204, #153 (the related design family).
- No edit to the design document; the design is read, not revised.
- No changeset entry.

## Commits

- One commit on `design/cli-edit-verb-tracking` (off `llm`) with the chosen initial-PR shape.
- Conventional-commit message shape per builder role.
- Push at end; open the draft PR.
- PR body must contain a load-bearing reference to `designs/cli-edit-verb.md` (canonical path).

## Report

≤ 400 words: PR number, chosen shape (b/c) with justification, the canonical-path reference quoted from the PR body, any drift-check observation if (c) was contraindicated by post-revision state, one-line `Self-improvement: ...`.
