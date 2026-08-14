---
created: 2026-05-14
updated: 2026-08-14
author: liaison, scholar
---

# Skill: library-lookup

Look up a domain term or phrase in the garden's library, find the relevant section files without having to know which source or topic owns them, and *index on the fly* so the next reader's search succeeds where yours did not, or succeeds faster than yours did.

This skill is the operational form of the library's *concepts* axis (`journal/library/keywords.md` + `journal/library/concepts/<id>.md`). For the data structure see `journal/library/conventions.md` § *Concepts and the keyword index*.

## Purpose

Designers writing new design docs, builders writing code, and jurors reviewing PRs all encounter domain terms whose canonical material lives somewhere in the library but is not necessarily in the section they are reading. Examples: `LOCAL_NODE`, `retention-accumulator`, "destruction by cohort", "Karp/Stiegler/Close", `formulaGraph`, "revocation by withdrawal". The library has four indexing axes (sources, topics, concepts, roles); this skill is the procedure for using the concepts axis correctly and for keeping it healthy.

## Inputs

- A **term** (one or more words; a code symbol; a proper name).
- The **role** invoking the skill (so the writeback step records the caller's role).

## Procedure

### 1. Look up

Grep `journal/library/keywords.md` for the term:

```sh
grep -i "<term>" journal/library/keywords.md
```

If a hit: read `journal/library/concepts/<concept-id>.md`. The page gives a one-paragraph definition + a table of relevant section files + a `See also` list. Read the section files the page points at as needed. **Done.**

### 2. Fall back

If no hit in the keyword index:

(a) Try synonyms and partial matches. Code symbols often have a bare-name form (`retention-accumulator`) and a path form (`retention-accumulator.js`); prose terms often have casing variants. The skill's job is to try them all before giving up.

(b) If still no hit, flat-grep across the section files:

```sh
grep -l -i "<term>" journal/library/sections/*.md
```

Read the matches and decide which (if any) actually answer your query.

(c) If flat-grep finds nothing useful, the term may not be in the library at all. Check `journal/library/topics/README.md` for an adjacent topic that might cover it, and `journal/library/sources/README.md` for adjacent source documents. If still nothing, the term is a library gap — see step 4 below.

### 3. Use the answer

Apply the material in your current work. Note which section(s) you actually consulted and which were distractions — both inform the writeback in step 4.

### 4. Index on the fly (mandatory)

The librarian's job is not just to find but to ensure the next search succeeds where this one did not, or succeeds faster. Three writeback actions, applied in your job's `journal/` worktree:

#### 4a. Add a shortcut

**Trigger:** You reached the right concept page via flat-grep, not via the keyword index — the term you actually used was not in `keywords.md`.

**Action:** Append one line to `journal/library/keywords.md`:

```
- <the term you actually used> -> <concept-id you converged on>
```

Cluster synonyms for the same concept in one comma-separated list before the
arrow, matching the existing rows in `keywords.md`.

Use backticks for code symbols. Letter case as it appears in the domain. Keep alphabetical-ish ordering for readability, but do not spend effort on perfect sort — the file is grepped, not read.

#### 4b. Prune a distraction

**Trigger:** A section came up in flat-grep but was the *wrong* answer for this query (a false positive that wasted reading time).

**Action:** On the concept page you actually converged on, append a `## Common confusions` block (or append to it if it exists):

```markdown
## Common confusions

- "<the misleading term>" sometimes appears in [path/to/distracting-section](../sections/...) but that section is about <X>, not this concept. For <X> see [[other-concept-id-or-section]].
```

This is what *prunes distractions for the next reader* — the next search lands on the same concept page and sees the disambiguation inline.

#### 4c. Draft a missing concept

**Trigger:** No concept page existed for the term, and you have enough context (from the section files you read) to write one.

**Action:** Create `journal/library/concepts/<new-id>.md` following the shape in `conventions.md` § *Concept page shape*. Add `status: draft` to the frontmatter. Add the keyword(s) to `keywords.md`. Add the entry to `concepts/README.md`'s seed-inventory list.

If you do **not** have enough context to write the page (e.g. you only skimmed one section), do not draft — instead queue a scholar review (step 4d).

#### 4d. Queue a scholar review

At the **end of your job** (not per-lookup), if any writebacks happened, tell the scholar so its next ingest cycle audits them. In v2 that is a message on the bus or a `scholar-review-writebacks` board job, not a v1 missive:

```sh
send-msg.sh role/scholar "library-lookup writebacks this job: <summary>"
```

> Added keywords / drafted concept / pruned distraction during library-lookup this job:
> - keyword `<term>` → `<concept-id>` (shortcut, was reached via flat-grep)
> - new concept draft `<new-id>` covering <X>
> - distraction pruned on `<concept-id>`: <which section was misleading and why>

Scholar's next cycle audits the writebacks and integrates drafts into the topic pages.

### 5. Land each writeback through the lander

Land every writeback file with **`scripts/jobs/land-journal-edit.sh <journal2-relative-path>`** (body from a body-file or stdin) — the **only sanctioned way** to land a library content edit. It lands through the isolated producer clone, syncs to the current `origin/journal2` tip first, and CAS-pushes with the silent-loss guard. Never hand-`git add`/`commit`/`rebase` against the live `journal/` worktree: that worktree can be arbitrarily stale and full of a peer's uncommitted WIP, and rebasing it replays already-upstream commits into a destructive conflict (the 2026-06-27 scholar incident).

```sh
# a new concept page (whole-file write):
land-journal-edit.sh library/concepts/<new-id>.md < /path/to/new-page.md

# appending a keyword shortcut: read the CURRENT tip, append your line, land the
# full body (the lander replaces the whole file, so include the existing rows):
printf '%s\n%s\n' "$(git show origin/journal2:library/keywords.md)" \
  "- <term> -> <concept-id>" | land-journal-edit.sh library/keywords.md
```

The lander only writes under the allowlisted trees (`library/`, `projects/`); a path outside them, a `..` traversal, or the live worktree is refused. On a rejected CAS push it re-syncs and retries automatically; a rare concurrent append it cannot see is caught by the scholar's next index-integrity pass.

## Output

A focused brief for the caller:

- The **concept's one-paragraph summary** (from the concept page body).
- The **one most relevant section's bold-fact summary** (from the section file).
- The **source provenance** (source slug + commit + status: current / draft-PR / stale) for any role that needs to verify currency.
- A note on **what writebacks were applied** (the shortcut, distraction-prune, or draft-concept that improved the index for the next reader).

## State

The skill mutates `journal/library/keywords.md`, `journal/library/concepts/`, and (occasionally) `journal/library/concepts/README.md`. All mutations are append-style where possible. The skill does **not** mutate `journal/library/sections/`, `journal/library/sources/`, or `journal/library/topics/` — those are the scholar's province; the queue-a-scholar-review action (step 4d) is how this skill flags larger integration work.

## Notes

- **The keyword index is meant to be grepped, not read.** Do not open `keywords.md` in a reader; grep for what you need.
- **Distinguish code-symbol keywords from prose keywords with backticks** (in both `keywords.md` and concept-page aliases). A maintainer scanning `keywords.md` should be able to tell symbol-vs-prose at a glance.
- **A `[[concept-id]]` link inside a concept page is a wiki-style pointer to another concept page in the same directory.** A non-matching link is acceptable (it marks something worth writing later, not an error) — the same convention as the rest of the library.
- **Concept pages may point at sections that *contradict* the concept** under a different framing (the canonical example is `crdt-in-formula-persistence`, which links both where CRDT shape is used and where a bidirectional CRDT was abandoned). This is the point of the concepts axis: collect all the angles on one term.
- **Concept pages stay short.** A concept page is a *lookup target*, not a primer. If the body exceeds a screen, consider whether the material wants to be a topic page or a section file instead.
