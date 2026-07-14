Pushed cleanly to `origin/main2` (HEAD matches). The work is complete.

## Completion report

**Job:** Adopt the git-fixup/autosquash plan (gist `0xpatrickdev/4100622d`) into the garden library on main2.

**Reconciled drift.** The gist's two patches target an **older** library state — v1 vocabulary (`judge`, `jury-fixer loop`, `orchestrator`, `panel-review`, "For each PR at the head of the queue") and a differently-worded yarn-lock bullet. Current main2 has migrated to `gardener`/`panel→fixer loop`/`gauntlet` and "For each PR in the job". I encoded the **intent** against current text rather than applying the patch hunks, so the line anchors and terminology stay consistent with today's library.

**Adopted the workflow consistently across the four required files, plus one cross-link:**

- **`skills/retcon/SKILL.md`** — new "What the retcon produces" bullet: post-retcon minor corrections (small bug fix, added test, docs, lint, formatting) use `git commit --fixup=<introducing-sha>`, not standalone `fix:`/`style:`/`chore: prettier`; autosquash before push if no panel/review yet, else leave `fixup!` commits visible at the tip for the conductor; keep `feat:`/`fix:` only for distinct reviewable behavior; tree stays byte-identical. Added a procedure comment after the `reset --mixed` step and a dated "Notes from the field" entry.
- **`roles/fixer/AGENT.md`** — new operating norm: post-retcon CI style/lint/format fix commits use `--fixup` targeting the introducing commit; binds shepherd commits too; links conductor step 3 and the retcon skill.
- **`roles/shepherd/AGENT.md`** — parallel norm + dated field note for shepherd-authored style/lint/format fixes.
- **`roles/conductor/AGENT.md`** — step 3 "Tidy" now uses the **noninteractive** `GIT_SEQUENCE_EDITOR=: git rebase -i --autosquash <base>` to auto-absorb `fixup!` commits, with a fallback to manual `pick`→`fixup` when none are present; retained the byte-identical-tree assertion; added a dated field note.
- **`skills/review-feedback-followup-commits/SKILL.md`** (related-guidance cross-link) — added a "post-retcon style/lint/format correction" trigger so the "one concern per commit / conventional message" guidance doesn't read as contradicting the fixup carve-out.

**Checks run.** Diff-scoped `double-space-sentence-separator` gate: exit 0. No em-dashes and no Latin shorthand in added lines (both are enforced house-style rules). All eight new relative links resolve. `updated:` metadata bumped to today (2026-07-14) on every touched file; `created:`/`author:` preserved. The whole-tree `maintainer-inbox-information-hiding` gate fired, but only on **pre-existing, unrelated files** (botanist, orchestrator, prosecutor, COMMON.md, restore, schedule) — none of my five changed files appear, so it's not my regression.

**Deliberate deviations from the gist:**
- Rewrote all prose to current v2 vocabulary (panel/gardener/gauntlet) instead of the gist's v1 terms.
- Used the gist author's intended `updated` semantics but with today's date (2026-07-14) rather than their fabricated 2026-07-10.
- Wrote new lines **sentence-per-line** and em-dash-free (the gist's paragraph-wrapped multi-sentence bullets would trip the enforced style gate).
- Added the `review-feedback-followup-commits` cross-link (beyond the gist's scope) to keep related guidance non-conflicting.
- Committed and pushed **directly to origin/main2** per the garden's no-PR-for-its-own-repo convention.

**Follow-ups:** none required for this job. The pre-existing `maintainer-inbox-information-hiding` gate leaks are a separate, standing drift unrelated to this change.
