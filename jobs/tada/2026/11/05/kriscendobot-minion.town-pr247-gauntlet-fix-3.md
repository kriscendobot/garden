FIX round 3 is done: I applied all the must-fix items from the latest panel verdict (review 5780094816) and pushed `4a49abc9` to PR #247. CI is green (`ci-wait-merge.sh` rc 0, 1 of 1 run passed). That covers GitHub Actions only, because this host's PAT can't read `statusCheckRollup`, so commit statuses and non-Actions checks weren't visible.

Only `designs/ordered-gutter-context-menu.md` changed, as a follow-up commit (fast-forward from `aaaad640`, confirmed with `ls-remote`). No tests ran beyond CI, since this is a design-only change.

**Must-fix items**
- **skeptic, replay idempotency:**
  - Replay now cites #142 § 4 and `register` in `site-registry-exo.ts`, instead of asserting that the id derives from the formula.
  - A new `discarding` mark means an intent clears only after its clip is bound or unpublished, so a served origin can't outlive its record.
  - `catalog-recovering` never discards an intent.
  - Crash and replay tests are added, plus a worked example of a crash between steps 3 and 4.
- **decomplector, other writers of `clips/`:** a new § 2 section accepts that the catalog can't be the only writer and specifies reconciliation.
  - A classification table covers publish deposits, second names, dead controllers and revokers.
  - It also covers name collisions at bind and rename, and outside removals, with re-registration where the directory survives.
  - A clip that can't be recovered is listed in a new `unheld` field.
- **decomplector, directory remover:**
  - Directory names are now flat `clip-<operationId>`, which pass the registry's validator and can't collide with `clip-N-<entropy>`.
  - The catalog is the only remover on its own paths, and the legacy takedown in `publish.ts` is reconciled.
- **novice, background:** added a Background glossary, a legend for the #230 rungs, and an early worked picture of `clips/` beside the order list.

**Should-fix and comment-only items also applied**
- **Entry arguments:** they are now plain `entryId`s, with handles kept only for powers. This removes the conflict that blocked retries.
- **Freeze:** `freezable` is derived at read time, and a failed `freeze()` has a defined display.
- **Version:** `version` now covers only what the catalog commits.
- **Migration:**
  - The marker decides which path owns order: REST before it, the catalog after it.
  - Migration defers when no controllers exist.
  - The design now states what a fresh-id upgrade loses: a position, never a clip.
  - A three-clip example is included.
- **Receipts:** behavior after the 256-receipt cap is specified.
- **Testing:** added a real-browser test list for the long-press, including iOS Safari.
- **Copyedits:** all copyeditor items, and novice's §§ 4 and 5.1 fixes.

**Not applied or still open**
- **Prose density:** novice's finding is only partly addressed. Some § 6 table cells are still long, and the panel may raise this again.
- **First-run rationale:** novice's comment-only note wasn't applied.
- **`register` dependency:** the replay guarantee relies on `register` returning a controller, which #142 specifies but hasn't built. Today's registry shows only the idempotence part, and increment 2 adds a test for the rest.

I stopped here as instructed; the driver re-posts panel-4.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr247-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (884927 cached reads)
- Output: 29909 tokens
- Cost: $1.6399014
- Wall-clock: 663s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
