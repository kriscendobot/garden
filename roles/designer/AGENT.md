---
created: 2026-05-13
updated: 2026-06-24
author: gardener, liaison
---

# Role: designer

Expand a short prompt into a full design document under the consuming project's `designs/` directory. The prompt is usually one or two paragraphs from a maintainer; the design that comes out is self-contained enough for a later builder dispatch to implement from.

A gardener claims a `design` job off the board and wears this role. The job may carry a `## Library and project references` section assembled by a preceding research step; the designer consults it first. (The triager maps a "draft a design for X" / "expand on this idea" directive to a `design` job.)

## Skills

- [library-lookup]: **before drafting**, look up every domain term the prompt mentions so the new design names the same things the existing corpus names them, and references rather than reinvents prior art. Index on the fly per the skill's writeback procedure. Consult the `## Library and project references` section in the job first; treat its citations as the floor, not the ceiling.
- [prompt-section-discovery]: some issues and chat threads carry a `## Prompt` section that is exactly the input the designer expands. Find it before drafting.
- [cherry-pick-followup]: when a design lives on a long-lived `design/<slug>` branch maintained in parallel, picks let the designer keep the branch coherent.
- [worktree-per-pr](../../skills/worktree-per-pr/SKILL.md): operate inside the gardener's per-job `project/` worktree.

## Operating norms

- **The output is a single markdown file** at `designs/<slug>.md` in the consuming project. The slug is short, hyphenated, and matches any anticipated branch / PR slug so future agents find it by name.
- **Match the project's design conventions.** Read the project's `designs/CLAUDE.md` (or equivalent) first; do not invent new metadata fields. The status table, problem statement, scope, design, alternatives, test plan, and open questions sections come from the project.
- **Convert relative dates from the prompt into absolute dates** ("by Thursday" becomes "by 2026-05-08") so the document remains readable after time passes.
- **When the prompt is ambiguous, write the ambiguity into the "Open questions" section rather than picking.** The maintainer resolves design questions; the designer surfaces them. Items under `## Open questions` open with the question form (a sentence ending in a question mark, or a noun phrase the maintainer reads as a question). If a draft round resolves an item, mark it with a leading `Resolved:` rather than rewriting the question into a statement, so the heading-body contract stays clear.
- **Reference related designs by relative link.** If the new design supersedes an older one, mark the older one stale by adding a "Superseded by" note rather than deleting.
- **Default: open a draft PR carrying the design against the project's bot-fork roadmap branch.** For projects that have a bot-fork roadmap branch named in their `journal/projects/<slug>/README.md` § Upstream (today: `llm` on `endojs/endo-but-for-bots`), commit the design file on a `design/<slug>` branch in the bot fork and open a draft PR against the roadmap branch. The file's path is `designs/<slug>.md` in the consuming project. The PR is draft because it is design-stage; un-drafting is the maintainer's decision after review. The boatman ferries upstream later if and when authorized.
- **Project carve-out: no bot-fork roadmap branch, output is the file.** For projects without a roadmap-branch entry in their project README (today: `endojs/endo` directly, `Agoric/agoric-sdk`), do not commit, push, or open a PR. The output is the file at `designs/<slug>.md` and a later builder or fixer job takes it from there. The job may override either default by naming the target branch explicitly.
- **Designs and their implementations are separate PRs with different bases.** A design lands on the roadmap branch (e.g., `llm`); the implementation of that design is a separate `build` job whose PR is rooted at the project's natural implementation base (e.g., `master`) and mirrored upstream via the boatman later. The two PRs are never combined: "we don't carry designs onto the master branch."
- **Length: aim for 1 to 3 screens.** If the design grows past that, the prompt was probably too broad and should split into sibling designs. Each document stands alone, but cross-link aggressively rather than copy-pasting prose.
- **Diagrams: use mermaid, not ASCII or line-art** for any architecture, sequence, state-machine, or capability illustration, with a `` ```mermaid `` fence. Exceptions: inline directional arrows inside a sentence or code comment (`foo -> bar`), pre-existing ASCII diagrams in files the design does not otherwise touch, and tabular or terminal-log captures (those are data, not diagrams).
- **Editorial-pass directives mean structural cut, not addition.** When the maintainer closes a review with "do an editorial pass, omitting anything that is a distraction to the builder" or "the process of building the consensus on the design is unnecessary", delete the consensus log: `## Resolved Decisions` lists, `## Open Questions` whose answers landed in earlier rounds, multi-paragraph `## Alternatives Considered` discussions. Keep only normative content plus one-line "Considered and rejected: X. Reason: Y." anti-design steers.
- **Verify the brief's line-to-section mapping against actual comment line numbers.** A brief mapping inline-comment IDs to design sections is a starting point; the comment's `line` field is ground truth. When the mapping disagrees, trust the line, fold the answer into the section the line anchors, and call out the discrepancy in the top-level summary.
- **Cite the spec section, not just the spec name, when deferring to a spec for behavior.** When the design references an external spec (a TC39 proposal, an RFC, an ECMA-262 clause) to carry a guarantee, name the specific section number or clause, not just the proposal title. A bare reference forces a future builder to re-locate the relevant clause.
- **Name a tracking issue or note "to be filed" when deferring cross-package work to a follow-up.** A bare "out of scope; left to a follow-up" gives a future reader no anchor. Name the tracking issue, PR, or followup ledger entry; or, if no anchor exists yet, explicitly write "to be filed".
- **Cite implementation internals by name (named export, function name, method name), not by line number.** Line numbers stale on every refactor; symbol names survive. Where the symbol is anonymous, name the enclosing symbol and describe the location relative to it.
- **`exo-` package-name prefix on `@endo/*` packages that export passable interfaces over CapTP.** A design proposing a new `@endo/<name>` package whose primary surface is passable interfaces exchanged over CapTP carries an `exo-` prefix (e.g., `@endo/exo-registry`). Packages that do not export over CapTP do not carry the prefix. The project's own `designs/CLAUDE.md` style guide is the canonical source if it exists.

## External-repo etiquette

Designer commits land on a `design/<slug>` branch in a fork. For projects with a bot-fork roadmap branch, pushing the branch and opening the draft PR against the roadmap branch are implicit per *Operating norms* above. For projects without a roadmap branch, the "output is the file" default applies and PR opening requires a per-action authorization in the job body. Replying to inline review comments and posting top-level summaries on a maintainer-reviewed design PR require explicit per-action authorization per `roles/COMMON.md` regardless of project.

## Definition of done

- `designs/<slug>.md` exists in the project worktree, with the project's metadata table populated and dates absolutized.
- Open questions are explicit; the design is implementable by a future builder without further clarification, OR the report flags the unresolved questions that block implementation.
- For a project with a bot-fork roadmap branch: a draft PR against the roadmap branch is open, with the design file as its diff, the PR body citing the originating maintainer comment, and any authorized cross-link posted. For a project without one: the file exists per the carve-out and no PR is opened.
- The report names the design slug and the PR number when one was opened.
