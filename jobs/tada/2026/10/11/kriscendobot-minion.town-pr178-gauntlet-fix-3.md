**Gauntlet fix round 3 on kriscendobot/minion.town PR #178: done. The round-3 must-fix is applied, pushed, and CI is green.**

**What I changed.** The panel's one must-fix (from the decomplector seat) was to remove the code that faked git's own refusal messages when a push was refused at upload time. I removed it:
- In `limits.ts`: the command-list parser, the refusal-report builder, the side-band chunking, the body-prefix reader and `refusePushWithHead`.
- In `git-backend.ts`: the `onBodyLimit` hook and the 64 KiB head buffer.

What still refuses a push:
- **Before upload:** the `ERR` packet in the ref advertisement, so a stock `git` client still prints the reason.
- **At upload:** a plain 413, 429 or 507 HTTP status, sent from `refusePushRequest`. The upload is read and thrown away, and the connection is closed.
- **Pack too large:** git rejects it itself, through the `receive.maxInputSize` and `receive.unpackLimit=1` settings the PR passes.

What users will notice: if a push is refused at upload time, the client now shows `HTTP 413/429/507` instead of the reason. That happens only in a race, or with a client that skips the ref advertisement.

I also took the cheap should-fix items from the same review:
- **Rate exemption:** a gzipped (or otherwise encoded) upload no longer counts as a small probe, so it can't skip the push-rate limit and still reserve space (breaker).
- **Order of checks:** the push-rate check now runs before the disk-size scan, so a push refused for rate costs no scan (saboteur). The `try` blocks now wrap only the disk-size scan (saboteur).
- **Comments and docs** now say:
  - the size cap is soft: git's thin-pack completion and index files can push one partition past it by one push;
  - the cut-off of an oversized upload depends on timing;
  - `onComplete` fires on every close, including a failed spawn.
- **Docs:** `DEPLOYMENT.md` now says what each refusal prints. The design doc's item 3 is cut down to its status and links to `limits.ts` and `DEPLOYMENT.md`; the duplicated env table, test list and padding JSDoc are removed (pruner, archivist).
- **Tests:** `git-remote-limits.test.ts` now expects the plain HTTP statuses, and adds a case for a gzipped probe-sized upload being rate-counted.

**Commits** (pushed to `git-remote-push-caps` with `safe-push-pr-head.sh`, advancing `ec1fb1d` → `3de6adc`):
- `52fe811` fix(git-remote): refuse a POST-time push with a plain HTTP status
- `3de6adc` docs(git-remote): describe the plain-status POST refusal and soft cap

**Checks.** Typecheck passes and all 90 `test/git-remote` tests pass. They have to be run with the real `git` first on PATH. With the garden's `git` wrapper first on PATH, the concurrent-push tests and one `capability.test.ts` case fail, and leftover `http-backend` processes keep holding the repo lock. I killed those processes myself. CI isn't affected because it uses plain git. `ci-wait-merge.sh` reported 3 of 3 checks passing.

**Left open:**
- **Push per partition:** the decomplector suggested allowing one push per partition at a time instead of the space-reservation map. Not done; it's a should-fix.
- **Thin-pack overshoot:** re-measuring after a push, or refusing thin packs, would make the size cap exact. For now it is only documented.
- **Ref-only pushes:** a push with no pack can create many refs without being counted against the size cap (wire-watcher). Still open.
- **Next step:** the driver re-posts panel-4.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr178-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 66 tokens (3190510 cached reads)
- Output: 18922 tokens
- Cost: $1.9181099999999998
- Wall-clock: 1076s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
