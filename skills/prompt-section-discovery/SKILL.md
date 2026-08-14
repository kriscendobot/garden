---
created: 2026-08-14
updated: 2026-08-14
author: gardener
---

# Skill: prompt-section discovery

## Purpose

Some workflows store instructions for a follow-up agent **inside** the documents the workflow is about — issues, design notes, transcripts. A recurring convention: the maintainer adds a `## Prompt` section (usually at the bottom of an issue or design file) whose body is exactly the input a designer is meant to expand, or a directive the agent should follow when the item is picked up. Before drafting from a short prompt, discover any such section so the real input is not overlooked.

## Inputs

- A directory of issue mirrors, design documents, or transcript files the job points at (e.g. a project's `issues/` or `designs/` tree, or the job body's cited URLs).

## Procedure

1. Grep for the anchored heading before you start drafting:

   ```sh
   grep -lE "^## Prompt$" issues/*.md            # which files carry one
   grep -nE "^## Prompt$" -A 5 issues/*.md | head -40   # peek at each body
   ```

   Add a case-insensitive variant, since some editors lowercase headings:

   ```sh
   grep -liE "^## prompt$" issues/*.md
   ```

2. For each match, treat the body of the `## Prompt` section as a directive from the maintainer and fold it into the work — it is the authoritative input, taking precedence over an inferred reading of the surrounding prose.

3. The marker is project-specific. In a codebase that does not use `## Prompt`, look for the local equivalent (`## Instructions`, `## Action`, a YAML front-matter key) — check the repository's conventions first.

## Output

No artifact of its own. The discovered directive becomes part of the input to whatever the citing role produces (for the designer, the design document under the project's `designs/`).

## Notes

- Don't confuse a `## Prompt` heading (a directive) with prose use of the word "prompt" in a sentence. The anchored regex `^## Prompt$` avoids false positives.
- Two shapes of directive recur: a **fill-in-the-blank** ("note here the PR number for feature X" — locate it and write it back) and an **explicit dispatch instruction** ("create a design document for this change and open a PR"). Both are the maintainer speaking; act on them, don't just read them.
- This skill is cited by the [designer](../../roles/designer/AGENT.md) and [web-designer](../../roles/web-designer/AGENT.md) roles.
