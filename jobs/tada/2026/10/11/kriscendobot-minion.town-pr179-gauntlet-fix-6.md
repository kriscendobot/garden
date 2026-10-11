CI finished green on the new head. `ci-wait-merge.sh` couldn't confirm it from this host, so I checked the Actions runs API directly.

Round-6 fix for PR #179 (https://github.com/kriscendobot/minion.town/pull/179) is pushed as `231810f`, and the PR's only workflow run passed on it.

**The must-fix: the clip name is now saved when the clip is published.**
- **Publish:** `publish` takes the `<title>` from the `index.html` bytes it already has, sanitizes it once and saves it as `name` on the clip's stored record.
- **Upgrade:** an `upgrade` with new content replaces that name, or removes it if the new page has no title.
- **List:** `list` just reads the saved field. The daemon registry returns records without a name, so for those it reads the name from the clip store's record instead.
- **If the name fails:** a failure to save or read a name is logged (new optional `logError`) and never fails the publish or the listing.
- **Older clips:** clips published before this change have no saved name and show as "Clip N" until they are republished or upgraded.

**What this removed:** the whole list-time name reader. That is the fair limiter, the timeouts and slot ceiling, the cache, the in-flight lookup map and the abort handling. `clip-title.ts` now holds only the sanitizer, the title extractor and a new `clipNameFromHtml`. The reader's wiring in `src/http.ts` is gone and `gateway.ts` is back to its base form. `vhost-table.ts` is too, except for the new optional `name` field. The `/account/clips` endpoint now passes the name through instead of sanitizing it again. In all, 12 files changed, with 200 lines added and 664 removed.

**Should-fix items also done:**
- The HTTP test listens on port 0.
- The linear-scan test uses a 1 MiB input, so a scan that slows down quadratically would fail it.
- The design doc and `DEPLOYMENT.md` describe the publish-time name.
- Two reviewer concerns went away with the reader: two clips sharing one cached title, and a long listing falling back to "Clip N" on first load.

**Tests:**
- The affected suites passed: 262 tests in 18 files.
- In the full local run, 2 tests failed: `test/endo-guest-lockdown.test.ts` and `test/git-remote/capability.test.ts`. They also fail on the previous head `bbf1c71` without my changes, so they are a problem with this machine, not the PR.
- The full run also showed a git-remote e2e failure on "dubious ownership", which looks like the same machine problem, but I did not check it against the old head.

**CI:** `ci-wait-merge.sh` exited with rc 4 because every `gh pr view` call failed on this host. This is the known gap where the bot token can't read check status on oros-studio. Polling the Actions runs API instead showed "test (typecheck + vitest)" completed with success on `231810f`. My first `ci-wait-merge` attempt ran in the background and was stopped at its time limit; the rc 4 above is from a second run in the foreground.

**Not done this round (should-fix only):**
- The shell's copy of the sanitizer was not trimmed down.
- Titles can still pick a gutter icon that looks like a trust signal, such as 🔒; there is no allowlist yet.
- Title parsing still doesn't fully follow the HTML spec.

I posted a summary of the fixes as a comment on the PR.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr179-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 78 tokens (4126382 cached reads)
- Output: 25092 tokens
- Cost: $2.3067644
- Wall-clock: 2115s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
