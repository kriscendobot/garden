Fix round 1 for kriscendobot/minion.town#201 is pushed and CI is green: `ci-wait-merge.sh` returned rc 0, with 2 of 2 workflows passing at head `73866dc`.

I applied the latest panel verdict (review 5567058535, round 6, on head `fca3abb`). Its blocking items came from the four seats that asked for changes: saboteur, pruner, decomplector, and corner-prober's must-fix-loop item.

**Commits pushed** with `safe-push-pr-head.sh` (fast-forward `fca3abb..73866dc`):
- **`5d6d0da` power**: `makeApp` now refuses an existing name before it clears the cached space usage. Before, a visitor could repeat a failing `makeApp` to force a full re-measure on the next mutation (saboteur 1). A new test checks this and fails on the old code: 140 reads against a limit of 8. The same commit drops three comments that only restated the code next to them (pruner 5–7).
- **`b7118fd` page (`clips/new-clip/main.js`)**:
  - A connection that timed out, or was replaced by "Try again", now closes its socket and can no longer replace the live session with the "connection lost" screen (corner-prober 2, saboteur 3).
  - A slower, earlier render can no longer overwrite a newer view.
  - Incoming frames are parsed in their own `try`, and a parse error names the socket URL; real errors from `dispatch` are no longer mislabelled and swallowed (saboteur 2).
  - Pressing Enter while an input-method composition is in progress no longer creates an entry (corner-prober 1).
- **`69fc241` shell**: the "+" button's mint request now gives up after 60 seconds and tells the user it did not answer in time, so the button no longer stays disabled until reload (saboteur 4). Test added.
- **`73866dc` design doc (`designs/new-clip.md` § 3)**: it now says why the space is writable and nested — it is the closed-beta requirement in § 1 — and points to the source header instead of repeating it (decomplector 1, pruner 2–4).

I also trimmed the PR body (pruner 1) and posted a follow-up comment listing each fix and what was left (comment 6259985293).

**Checks run locally:** `vitest` on `test/new-clip.test.ts` and `test/new-clip-power.test.ts` passed 34 of 34, `tsc --noEmit` was clean, and `tools/build-new-clip.mjs` built.

**Left for the next panel or the maintainer:**
- Saboteur 5: the power's silent catches stay, because the power's sandbox has no logger to write to.
- Saboteur 6 and 7 were comment-only notes (cookie SameSite setting, duplicate mints) and need no change.
- Decomplector 2 and 3 are structural refactors: deciding app-ness from structure instead of text visitors can write, and minting in a single step. They are for the maintainer to decide.
- Corner-prober 3–7 are extra edge-case tests, not done this round.

**CI wait:** the PR's checks run on one shared self-hosted runner with a queue of other runs, so this took about an hour. The bot token also hit GitHub's API rate limit once. I re-ran `ci-wait-merge.sh` in 580-second foreground chunks, since each run restarts its own deadline. No garden (`main2`) changes.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr201-gauntlet-20261019-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 86 tokens (3563928 cached reads)
- Output: 19788 tokens
- Cost: $1.8733215999999995
- Wall-clock: 3834s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
