---
created: 2026-05-13
updated: 2026-06-24
author: gardener
---

# Skill: pr-formation

How to author or redraft a pull request's title and description so a maintainer can review the change without first having to read the diff. Applies to initial PR creation (the gardening script's PR-open step, the `ferry` job's upstream PR open, follow-up PRs), to body rewrites after substantive scope change, and to maintainer-directed redrafts ("redraft the description per the template").

Canonical for any work that authors PR prose. The gardening state machine (`scripts/jobs/gardening/garden-pr.sh`, design: [`designs/gardening-state-machine.md`](../../designs/gardening-state-machine.md)) consumes this skill at its PR-open step; the `ferry` job (carry a PR upstream) consumes it via [pr-handoff](../pr-handoff/SKILL.md). The [pre-pr-checklist] skill covers the template-fetch mechanics, but the discipline of *what to write inside the sections* lives here.

## When to use

- Opening a new PR (the gardening script's PR-open step, ferry-opened upstream PRs, follow-up PRs).
- Rewriting a PR body after a `CHANGES_REQUESTED` review that asks for a description redraft.
- Scope grew enough that the original body no longer reflects the PR. Reset to the template, do not append.

## The discipline

### Use the upstream template, section for section

Fetch `.github/PULL_REQUEST_TEMPLATE.md` from the base repo at the head of the base branch and fill the section headings verbatim. Do not invent new sections, do not reorder, do not skip a section the template provides. If a section does not apply, write one sentence saying so (e.g. "No documentation changes."); do not delete the heading.

```sh
gh api "repos/<owner>/<repo>/contents/.github/PULL_REQUEST_TEMPLATE.md?ref=<base>" \
  --jq '.content' | base64 -d > /tmp/pr-body.md
```

The fetch mechanics and the no-line-wrap rule are in [pre-pr-checklist]; this skill is about what to put inside the sections.

### No checklists

The template's guidance prose under each heading is for the human author; delete it before submitting. Do not author your own checklists (`- [ ] item`) in the PR body. A reviewer who sees a checklist tries to verify each item, which is the wrong cognitive load for a description. State the verification once in prose; if a longer audit trail is useful, link to it from the body rather than expanding it inline.

### No file callouts

The PR body describes *behavior* and *intent*, not the diff. Do not write "I changed `packages/foo/src/bar.js` by adding …" or "see the diff in `packages/foo/test/bar.test.js`". The diff itself is the file-by-file record; the body's job is the part of the change the diff cannot show. Cite a file path only when it is load-bearing in the description (e.g., "the public entry point moved from `foo/index.js` to `foo/lib/index.js`"), and even then state the user-facing fact rather than the code-level edit.

### Behavior and intent, not diff

The reader is a maintainer deciding whether the change is the right shape. They will read the diff once they have decided to engage. What the body has to give them, in order:

1. **What the PR does** in one or two sentences of user-facing or API-facing prose. The first sentence is also the title's source.
2. **Why** the change is being made. Cite the issue, the design document, or the directive that motivated it. Do not paraphrase the issue body; cite and move on.
3. **What the maintainer should attend to** when reviewing. The riskiest invariant, the place a backward-incompatibility lurks, the assumption the diff makes. One short paragraph.
4. **What is intentionally out of scope.** A negative scope statement saves a review round when the diff stops short of an adjacent fix the reviewer would otherwise ask about.

### Branch naming (head and base)

Head branch name is project-specific (`feat/<topic>`, `fix/<issue>-<topic>`, etc.; follow whatever convention the upstream project uses). The base branch is **not** the moving upstream branch on fork-side PRs; the gardening script creates a frozen-base branch named `<base>-<7-char-short-sha>` (e.g., `master-abc1234`, `llm-def5678`) snapshotting upstream at PR-open time and uses that as the PR's base. Full procedure on [frozen-base-branch]. Upstream PRs after ferry use upstream's natural branch as base (the frozen-base convention does not propagate to upstream).

### Title

The title carries the same discipline at miniature scale. Conventional-commit prefix per the project's convention (`feat(<slug>):`, `fix(<slug>):`, `design(<slug>):`, etc.). The rest is the same one-sentence summary the body's first sentence elaborates. Do not put PR numbers, file paths, or methodology in the title.

### No methodology leak

Per [pre-pr-checklist] § No methodology leak: the body never names an internal agent role, a skill file, a job, an inbox, or any garden-internal artifact. The maintainer's reading experience is *the change*, not *how the garden assembled it*.

## Examples

### Title rewrites

- Bad: `feat(cli): assorted CLI additions, workers, zip checkin/out, read-text, write-text (re-opened from #38 under the bot)`. The list-of-features and the parenthetical history are noise.
- Better: `feat(cli): workers, zip in/out, and text-file IO verbs`. One slug, one sentence; the history goes in the body.

### Body shape (per the four-part order above)

```markdown
## What

The `endo` CLI gains a `workers` verb that prints the worker process tree, a pair of `zip checkin` and `zip checkout` verbs that move directory bundles in and out of the daemon's local store, and `read-text` / `write-text` verbs for round-tripping a single text file by name.

## Why

Closes endojs/endo-but-for-bots#38. The CLI surface for daemon-resident data lacked direct affordances for the cases the design discussion called out.

## What to attend to

The zip verbs assume the daemon's local store accepts directory bundles by name; if you want the verb's name pair to differ from `checkin`/`checkout`, the design discussion on #160 is the place to land that decision rather than here.

## Out of scope

This PR does not add the chat-side surface for the new verbs; that is tracked separately in #203.
```

Note: no checklists, no file paths in the prose, no `roles/` or `skills/` reference, no list of which directories were touched.

## Where the maintainer's directive came from

This skill captures the discipline in
[endojs/endo-but-for-bots#128#issuecomment-4437027474](https://github.com/endojs/endo-but-for-bots/pull/128#issuecomment-4437027474)
(kriskowal, 2026-05-13): *"Please redraft the PR description and title to reflect the proposed changes. Use the github template for pull requests. Do not include checklists or draw attention to specific files."*

The directive was framed as relevant to PR formation in general. This skill is the canonical capture.

## Notes from the field

- _2026-05-13_: extracted from kriskowal's #128 directive. The four-part body order (what / why / attend-to / out-of-scope) is the reusable core.
- _2026-06-24_: migrated from v1. Rewired the cite sites (boatman/builder/fixer PR opens) to the v2 model: the gardening state machine's PR-open step and the `ferry` job consume this skill; producers no longer "dispatch" an authoring role.
