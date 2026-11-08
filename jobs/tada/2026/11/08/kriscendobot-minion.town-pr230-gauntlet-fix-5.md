I applied panel-5's must-fix items to the design for PR #230 and pushed them as one follow-up commit (`448b347`). CI is green (`ci-wait-merge` returned 0: 3 checks, 0 failed).

**What changed in `designs/clip-governor-column.md`:**

- **The locator is no longer an authority.** This answers skeptic #1 and decomplector #1–#3.
  - The login cookie is now the session's only authority. The locator is a per-tab session handle, kept for one stated reason: per-tab lifetime. A tab's entry handles survive a reconnect, and one tab's session can end without touching the others.
  - The door now refuses a locator minted for a different owner, so a leaked locator alone opens nothing.
  - That removes the leak threat model, the rung-by-rung re-justification table and the "re-state the threat model" line in each exit criterion.
  - § 14 now presents "cookie only, no locator" as the real simpler alternative and says exactly what it would cost. If the maintainer prefers it, only rung 0a changes.
- **New § 3.7 lists every method, result and error in one place.** This answers ergonomist #1–#3 and #6.
  - It has one signature table and one error-code table.
  - Every method returns a record. A method rejects only when it committed nothing, and a mutation returns what it committed.
  - Both `select` methods return the same `{ governor, selected }`, so a caller can see when a later select overrode theirs.
  - The two `endow` signatures differ in their third argument on purpose, and the table says so.
- **Skeptic should-fixes:**
  - The per-tab revoke test is fixed: a tab knows only its own locator, so no tab revokes another's.
  - `setOrder` is now listed under rung 0b.
  - Rung 2's revocation claim is marked as not verified.
  - Destroy now also closes the destroyed clip's open connections, with a test where a hostile clip holds an open frame while it is destroyed.
- **Ergonomist should-fixes:**
  - A visible "Powers" toggle with `aria-expanded`.
  - Each clone-plan row is a radio group, with keyboard order and the `front` row's disabled choices defined.
  - The clip id suffix lengthens when two clips on screen share one.
  - The rung 0a exit criterion is split into three checkable parts.
- **Copyeditor items #1–#7:** added glossary entries, fixed the wrong cross-reference, the ambiguous clauses, the unclear status of §§ 7–12 and the decision stated inside open question (k), and noted why the question letters skip.

**Follow-ups:**

- **#231 needs a change.** Its door currently skips the owner (subject) check, and the design now requires it. § 3.6 says so.
- **The project-worktree helper failed** with a read-only file system error under the sandbox. This is the known issue in memory; the fix commit 7fd074b62d5 may not be deployed on this host yet. I worked in a clone under `$TMPDIR` instead.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr230-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 80 tokens (3967428 cached reads)
- Output: 25829 tokens
- Cost: $2.2416495999999997
- Wall-clock: 1488s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
