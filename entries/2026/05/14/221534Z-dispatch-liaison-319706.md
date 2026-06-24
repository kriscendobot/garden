---
ts: 2026-05-14T22:15:34Z
kind: dispatch
role: liaison
project: garden
to: "*"
---

# Dispatch: gardener encodes the liaison's vocabulary section

Dispatch root: `dispatches/gardener--319706/`. Garden-meta only.

## The directive

Maintainer 2026-05-14: confirmed the list of verb / verb-phrase → role-action mappings (with "ferry" promoted to first-class). Encode as a *Vocabulary* section on `roles/liaison/AGENT.md` (parallel to the *Vocabulary: the gamut* section the previous gardener landed today). Mirror the relevant subset onto `roles/steward/AGENT.md` so autonomous operation recognizes the same shorthand when it appears in `to: steward` messages.

## The vocabulary to encode

### Direct-dispatch verbs (verb = role; orchestrator dispatches that role against the named target)

- **shepherd #N** / **shepherd it** — dispatch shepherd to drive CI to green.
- **cleanup #N** / **clean up #N** — dispatch cleaner (coverage + dead-code).
- **judge #N** / **panel #N** — dispatch judge (runs panel + fixer-loop until in-scope clean; un-drafts on termination).
- **build #N** / **build a PR for X** — dispatch builder.
- **design X** / **propose X** / **spec X** — dispatch designer (draft PR against `llm` per the design-PR policy landed today).
- **fix #N** — dispatch fixer.
- **weave #N** / **rebase #N** — dispatch weaver.
- **ferry #N** / **carry #N upstream** / **ship #N upstream** — dispatch boatman.
- **merge #N** — dispatch conductor.
- **groom the roadmap** — dispatch groom.
- **investigate X** / **look into X** / **find out why X** — dispatch investigator.
- **scout X** / **measure X** — dispatch scout.

### Compound chain idioms (multiple sequential dispatches)

- **run the gamut on #N** — the full PR-creation-flow chain to un-draft (encoded in its own section; cross-reference).
- **mirror #N** / **fork #N onto bots** — builder ports the upstream PR's diff onto the bot fork; chain proceeds from there.
- **carry feedback from #N** / **respond to feedback on #N** / **respond in kind on #N** — fixer applies inline-review feedback on the bot-side mirror.
- **address #N** / **wrap up #N** — fixer-loop on whatever is owed (CHANGES_REQUESTED, lint failure, etc.).

### Garden-meta phrases (gardener)

- **encode this** / **encode the lesson** / **make this a rule** — gardener authors or revises role / skill files.
- **amend [role|skill]** / **the [role] should know that X** — gardener edits the named file.
- **carve a role for X** / **add a role for X** — gardener authors a new role file.
- **retire [role|skill]** — gardener removes / deprecates with a redirect.
- **what should we improve** / **self-improve** — gardener cycle for recently-surfaced lessons.

### Bulletin / journal phrases (liaison directly)

- **surface X** / **note X on the bulletin** / **flag X** — liaison adds a bulletin row in the appropriate section.
- **make sure X is tracked** — bulletin row + (optional) journal message.
- **let the [role] know that X** — `message: liaison → [role]` journal entry.
- **remember X** / **don't forget X** — persistent memory or bulletin row.

### Authorization shapes

- **go ahead and X** / **feel free to X** — per-action authorization, scope = X.
- **comment on Y** / **post X** — per-action comment authorization on non-standing repos.
- **you can push to Z** — pre-staged authorization row on the bulletin.

### Negation / discipline observation

- **don't X** — encode as a rule if recurring (gardener); reactive otherwise.
- **stop X-ing** — discipline observation; reactive.
- **never X** — standing rule (gardener-tracked).

### Bring-up-to-date

- **bring X up to date** — boatman/weaver if branch drift; fixer if stale PR body / changeset.

## Per-action authorization

Standing on the garden repo. No project-side actions.

## Task

1. **Read** `roles/COMMON.md`, `roles/liaison/AGENT.md` (note the existing *Vocabulary: the gamut* section), `roles/steward/AGENT.md` (note its existing *Vocabulary: the gamut* section), `skills/pr-creation-flow/SKILL.md` § Vocabulary.

2. **Add a *Vocabulary* section to `roles/liaison/AGENT.md`** immediately after the existing *Vocabulary: the gamut* section (or restructure to combine). The new section's body is the categorized table above. Mark each entry terse: verb-phrase on the left, the one-line "what the orchestrator does" on the right.

3. **Mirror the relevant subset onto `roles/steward/AGENT.md`** § Vocabulary. Steward-relevant entries are the direct-dispatch verbs (most of them), the compound chain idioms (the steward runs autonomously through these), and the negation patterns (the steward should not silently violate "don't" or "never" rules forwarded via messages). The bulletin/journal phrases and authorization shapes are liaison-only (user-facing); skip those on the steward.

4. **Promote "ferry" explicitly** — the user reaffirmed it as a first-class verb for the boatman. Make sure the boatman entry stands out (perhaps as the canonical / preferred phrase among synonyms).

5. **Update `CLAUDE.md`** § Orchestrator vocabulary (the subsection the prior gardener added today): expand the one-line glossary-style entry for "the gamut" into a short table covering the most common direct-dispatch verbs (shepherd, judge, ferry, build, design, fix, weave, merge), with pointers to the full Vocabulary sections on `roles/liaison/AGENT.md` and `roles/steward/AGENT.md`. The CLAUDE.md entries are the brief glossary; the role files carry the full table.

6. **Cite the maintainer's framing** in a notes-from-the-field row: 2026-05-14 "the user confirmed the verb-vocabulary list and promoted 'ferry' to first-class". Reference the precipitating conversation in the gardener's `result` entry.

## Out of scope

- No edit to existing role files beyond liaison + steward + CLAUDE.md.
- No new skill.
- No new role.

## Commits

- One commit per substantively-revised file: `roles/liaison/AGENT.md`, `roles/steward/AGENT.md`, `CLAUDE.md`.

Push at end. Journal result entry.

## Report

≤ 250 words: each file's new section's shape (one line per file), one-line confirmation that the next user prompt with a recognized verb routes correctly, one-line `Self-improvement: ...` per `skills/self-improvement/SKILL.md`.
