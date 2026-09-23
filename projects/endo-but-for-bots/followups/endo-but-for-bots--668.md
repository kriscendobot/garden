---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 668
created_at: 2026-07-10T14:30:47Z
last_appended_at: 2026-07-10T14:30:47Z
status: parked
---

# Follow-ups for endo-but-for-bots#668

## Items

- [ ] `packages/agentry/src/edit-text.js` `computeUnifiedDiff` — an edit that changes only the trailing newline yields a diff with headers but no hunk (both sides collapse after `splitLines` drops the trailing `\n`). File content is always correct; only diff fidelity is affected.
  **Source juror(s)**: prover, assessor
  **Round**: 1
  **Recommended action**: emit a `\ No newline at end of file` marker so the diff distinguishes trailing-newline presence/absence

- [ ] `packages/fae/src/tool-makers.js` — the `edit` tool description does not state that when both a single `oldText`/`newText` pair and an `edits[]` array arrive, `normalizeEdits` prefers `edits` (dropping the pair).
  **Source juror(s)**: integrator
  **Round**: 1
  **Recommended action**: add a sentence to the tool-schema description documenting the edits-wins precedence

- [ ] `packages/lal/tools/fs.js` — `M.arrayOf` admits an empty `edits[]`, which then throws "At least one edit is required" at runtime rather than being rejected by the param pattern up front.
  **Source juror(s)**: wire-watcher
  **Round**: 1
  **Recommended action**: tighten the pattern to a non-empty array (e.g. require `edits.length >= 1`) so it surfaces at validation

- [ ] `packages/daemon-cas/tsconfig.composite.json` — the added `../platform` project reference is a legitimate build-graph fix but tangential to this feature; isolated in its own `chore(daemon-cas)` commit.
  **Source juror(s)**: packager, spec-keeper
  **Round**: 1
  **Recommended action**: consider splitting the tsconfig chore into a standalone PR if the maintainer prefers a single-purpose diff

- [ ] `packages/fae/test/edit-tool.test.js` — uses raw `ava` + `@endo/init/debug.js` rather than `@endo/ses-ava/prepare-endo.js` like the sibling tests, and its `mkdtemp` dirs are not cleaned.
  **Source juror(s)**: assessor
  **Round**: 1
  **Recommended action**: migrate to the `@endo/ses-ava/prepare-endo.js` harness and add a `t.teardown` that removes the temp dir
