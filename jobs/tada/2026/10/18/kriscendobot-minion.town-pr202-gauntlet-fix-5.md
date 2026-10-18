# Gauntlet fix round 5 — kriscendobot/minion.town PR #202

I applied the panel-5 must-fix items to PR #202. CI is green at the new head `fedda269`: `ci-wait-merge` returned rc 0 with 3 checks, 0 failed.

There was no pre-pass block, so I worked from the latest panel verdict, review 5564844114. Seven seats asked for changes: locksmith, wire-watcher, breaker, saboteur, purist, pruner and coverage-auditor.

## Code fixes (commit `6d124fae`, in `src/endo/gateway/new-clip.ts`)

- **`resolveRequest` race (locksmith, wire-watcher, saboteur, purist, breaker):**
  - It now runs under `exclusive`, the same lock the inventory writes take.
  - It refuses a value that is not there ("no such value in this inventory").
  - It reads the value's kind with a new strict lookup, `strictKindOf`, so a failed lookup throws instead of counting as "not a directory".
  - `rejectRequest` and `dismissMessage` also run under the lock now.
- **`metamorphose` could overwrite a peer (breaker):** it now runs under `exclusive` and through `notPeerEntry`. It also refuses when the app already has a directory named `form`, which covers a nested app with that name.
- **Directory guard failed open (breaker, purist):** `refuseDirectory` now treats an entry whose kind can't be read as a directory, so it removes the entry and refuses it.
- **Comment fixes (pruner, locksmith #3):** the long header that restated the design is now a pointer to `designs/chat-clip.md` § 3 plus the locking rule. The guard's comment now says only plain directories are refused, because host and guest handles can still move. I deleted the comment that narrated the code next to it.
- **New tests in `test/chat-clip-power.test.ts`:**
  - `resolveRequest` racing a `makeDirectory` on the same name.
  - `metamorphose` against a peer named `form`, and against an app named `form`.
  - An absent value passed to `resolveRequest`.
  - An imported locator whose kind can't be read.
  
  Run against the old `new-clip.ts`, 3 tests fail (the two new ones and the one I extended); with the fix they pass. The power, page, model and new-clip suites pass locally (44 tests), and `tsc --noEmit` is clean.

## Docs fixes (commit `fedda269`, plus the PR body)

- **`designs/chat-clip.md` § 3:**
  - Adds `metamorphose` to the list of writes that take the lock.
  - Says the mailbox actions take the same lock.
  - States the fail-closed rule and that an absent value is refused.
  - Narrows the rule to plain directories.
- **Pruner cuts:** I deleted the repeated "What this does not fix" paragraph and folded the hypothetical own-guest paragraph into one sentence.
- **Coverage-auditor:**
  - The header of `test/chat-clip-page.test.ts` now says it is shim-only (happy-dom) evidence. It names `dev/chat-clip-browser-demo.mjs` as the real-browser run that checks the same behaviors: polling, Enter to send, and `aria-current`.
  - Design § 5 and the PR body now say why the browser demos are local only: Playwright isn't a dependency, and each run needs a Chromium download and a writable TMPDIR that allows exec.
  - Wiring the demos into CI is now a follow-on in design § 6.

## Not done

- I did not wire the Playwright demos into CI. The finding allowed stating the reason in the PR body instead, so I did that.
- The coverage-auditor's line-coverage item is a pre-pass gap: no c8 report exists for this PR. The panel's coverage setup has to fix that, not this PR.
- I left should-fix items alone:
  - Pairwise filtering in `project`.
  - The collapsing `ChatMessage.type` union.
  - Narrower return guards.
  - Moving the non-inventory `accept` outside the lock.
  - The stylist's renames of short lambda names.
  - The `submit` refresh error handling in the assessor's finding.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr202-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 60 tokens (2870712 cached reads)
- Output: 16934 tokens
- Cost: $1.8099184000000004
- Wall-clock: 1076s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
