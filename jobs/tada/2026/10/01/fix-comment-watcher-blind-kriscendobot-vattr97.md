I fixed the bug behind this alert. The cause was a flaw in the self-test probe itself: it is not a jq outage and nothing is specific to vattr97. The fix is pushed to `main2` as `c5416eb373b`.

**What I found on `endolin-garden-ece02cb4`**
- **jq and gh are healthy:** jq 1.7 is at `/usr/bin/jq`, and the fleet `gh` wrapper is on PATH.
- **One failure only:** the vattr97 self-test failed once, on Sep 30 at 21:37. It passed in the window before that and every time since. Across the host's last 7 days of logs, that was the only `SELF-TEST FAILED` line for any repo.
- **Nothing repo-specific:** `kriscendobot/vattr97` has no comments at all, issue or inline review. The probe has no stored comment it could lose track of. A normal empty `[]` answer always counts as "inconclusive" and is never paged. So the only way to get a "blind" result on this repo is an error response mistaken for a comment.
- **The mechanism, reproduced live:** at the start of this job GitHub was returning HTTP 403 "rate limit exceeded" to `gh api` calls. When that happens, `gh api` exits 1 but still writes the error message (a JSON object) to stdout. The probe ignored the exit status (`|| true`) and took any output containing `{` as a fetched comment. It then ran `jq '.[0].id'` on that object, which errors, so it reported BLIND. A brief rate-limit or server error therefore paged blindness.
- **Same flaw, second effect:** when a fork has Issues turned off, `issues/comments` returns a 404 error body. That body also matched, so the probe never fell back to checking `pulls/comments`.

**What changed** (`scripts/jobs/comment-watcher.sh`, `source_path_healthy`)
- The probe only uses a `gh` call's output when the call succeeded. This fixes the false alarm and makes the 404 fallback work.
- Any response that isn't a JSON array (i.e. an error) now counts as inconclusive, not blind.
- I replaced the outdated "KNOWN LIMITATION" comment, which said the 404 already came back empty.
- It still reports BLIND when gh returns a real comment and jq is missing or broken, which is the 2026-06-24 case it exists to catch.

**Tests** (`scripts/jobs/test/comment-watcher-test.sh`, new section JP): five cases run the real probe against a stub `gh`:
- a rate-limit 403 is inconclusive;
- a real comment passes;
- a 404 falls back to `pulls/comments` and passes;
- both endpoints erroring is inconclusive;
- a broken jq is still BLIND.

The full suite passes, 425/0. Against the old code, three of the JP cases fail, which confirms they catch the bug. That old-code run also failed the BQ quote-reply test once. It is unrelated to this change and passed in the fixed run, so it looks like a flake.

**Self-test status:** the live vattr97 self-test has passed on every run since the single failure. Both endpoints answer `rc=0` with an empty list right now, so the fixed probe treats the repo as quiet. The fix reaches the deployed root checkout through the normal rolling deploy.

**Follow-up:** none required. The 403s during this job show the bot's GitHub REST rate limit is under pressure on this host, which is worth watching separately. With this fix, a rate-limit hit should no longer show up as a blind-watcher alert.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-comment-watcher-blind-kriscendobot-vattr97.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1248765 cached reads)
- Output: 11024 tokens
- Cost: $1.035921
- Wall-clock: 1447s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
