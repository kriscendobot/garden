Work complete. Report follows.

---

## Completion report — `investigate-pr721-review-false-peer-resolution`

### 1. The mechanism, reproduced exactly (not a plausible story)

The comment was never deleted. The signal came from the PR, and it was **the matcher being too loose**.

The job ran at **2026-07-15T05:47Z**, two hours after the correlation fix `a2ae7ceb` landed on `main2` (03:43Z) but before that host's deployed root took it — so the gardener ran the **pre-correlation** script `83222fe4`. Its report's wording ("an 'Addressed @kriskowal' acknowledgment … (cid=4701251219)") is a verbatim paraphrase of that old version's log line, which no current version can emit; that alone dates the binary.

**The line that produced exit 2** is the old third matcher:

```sh
elif [ -n "$reviewer" ] && printf '%s\n' "$corpus" \
       | grep -qiE "(addressed[[:space:]]+@${reviewer}([^a-z0-9]|\$)|@${reviewer}'?s[[:space:]]+review)"; then
```

It hit the alternation's **second** branch, `@kriskowal's review`, on **commit `729a0b98`**:

> `refactor(platform): drop conservative-regex seam, share realpath/confinement utils` — **"Addresses @kriskowal's review on #678"**

That commit is for a **different PR (#678)**, was authored **2026-07-13, two days *before* the 07-15 review**, and is in the corpus only because `commits?sha=<head>` walks the head's entire ancestry. The old matcher had **no time correlation and no PR correlation** — any acknowledgment anywhere in the branch's history resolved any review.

Reproduced against the live corpus (head `bee451ef`, unchanged since 07-13): branch 1 (`in_reply_to=4701251219`) → no match; branch 2 (id citation) → no match; branch 3 → exactly one hit, line 258, the `#678` commit. The current script returns **exit 0 / PROCEED** for the same arguments — that hole is closed.

Your independent finding stands: no comment on #721 cites `4701251219`, and none matches "Addressed".

### 2. Why a no-op could assert completion it never checked

Because **exit 2 was worded to consumers as an authority**, in all three emitters: *"do NOT edit or push — complete the job as a clean no-op."* Nothing asked for corroboration, so a clean exit code stood in for a fact.

**Yes — exit 2 must require positive evidence, and the requirement belongs at the consumer, not in the script.** The script matches text; it cannot know what a directive asked for, so it can only ever prove *correlated text exists*, never *the ask was satisfied*. No amount of hardening changes that. This matters most in exactly the #721 shape: the deliverable was a **board artifact** the fleet can enumerate in one command, and one `ls` would have falsified the claim.

### 3. Why the retro inherited the premise

The retro body says the primary loop is "UNCHANGED" and never tells the prosecutor to check it. So the second loop read the primary's report and repeated "a peer had posted the requested plans citing cid=4701251219" verbatim — a check that adds no independent signal and instead **launders an unverified claim into a `not-a-miss` verdict**. It should verify: for a primary that closed as a no-op, confirming the deliverable exists is one board query or one API call, well under the cost of the judgment the retro already performs.

### 4. Blast radius — **10 exit-2 decisions ever, 7 of them false, 3 closed uncorroborated, 2 lasting misses**

All 10 predate the correlation fix. Of the 7 false positives:

- **Caught and overridden** (3): `pr678-8a856783`, `pr682-review-4631723f`, `pr682-review-556953b2` — each independently spotted the stale/unrelated match and did the work. Two even filed the hardening ask that became `a2ae7ceb`.
- **False signal, correct outcome** (1): `pr678-review-d461c045` — hit on the same `#678` commit but verified the rename had actually landed.
- **Closed uncorroborated** (3): `pr722-review-01c311bd`, `pr721-review-56349e18`, `pr721-review-67dcebef`.

Of those three, **2 are real misses, both on PR #721**:

1. **Review `4701251219`** (the case at hand) — the three integration plans, unactioned 14 days.
2. **Review `4690781908`** (2026-07-14, "Please rerun the gauntlet. Emphasis on style.", four inline directives on `store.js`) — `pr721-review-56349e18` no-opped on the *same* `#678` commit. PR #721's head has **not moved since 2026-07-13**, so by construction nothing was addressed; the head still carries `readJSON` (asked: `readJson`) and inline `import('./types.js')` jsdocs (asked: `@import`). **#721 is still open with these outstanding.** Not fixed here, per the job's instruction.

The third, `pr722-review-01c311bd`, was a genuine miss *at the time* — it closed at 22:42Z citing a peer resolution that did not yet exist; the split landed 5 hours later (`a4859f57`, 03:42Z) via another path. Rescued by luck, not by the check.

**True positives: 3** (`pr611-review-a38660ea`, `pr615-review-330a01ca`, `pr671-review-93271f57`) — all three corroborated independently before closing. That is the behavior now made mandatory.

### 5. Auto-conduct on a green bot PR

**An approval-triggered rule already exists** — `comment-watcher.sh`: a trusted APPROVED review runs a mergeable/green probe and mints the conductor, gated to bot repos, degrading to a shepherd when not green. It **could not have fired for #883**, which has zero reviews.

**But "green + mergeable" is the wrong trigger, and adding it would manufacture this bug's twin.** The merge spine `ci-wait-merge.sh` **independently requires a current maintainer approval on the exact head SHA** (`pr-maintainer-approval-gh.sh`), regardless of branch protection. A conductor posted for #883 today would claim, run, and stall at that gate — a job that cannot succeed, whose report reads like progress. The merge authority is approval-anchored, so the trigger must stay approval-anchored.

What #883 actually needs is **surfacing, not conducting**: it is open, undrafted, `mergeable_state: clean`, bot-authored, and waiting on a human who does not know it is waiting. Two concrete recommendations:

- **Ready-for-approval notice** (the real gap): a leader-only sweep of open bot-repo PRs that are undrafted, green, mergeable, and have no maintainer approval → one deduped maintainer notice, not a job. This is what would have surfaced #883.
- **Approval reconciler** (closes a real hole): the current trigger is event-driven off the comment feed, so an approval submitted while the watcher is down or over a cursor gap never fires — and there is no periodic backstop in `schedules/`. A sweep for `pr-maintainer-approval-gh.sh == 0` with no live conductor job would catch those. It is approval-anchored, so it can never merge unapproved work.

I did not build either — both are new automation beyond an investigation's scope. They are the follow-up worth posting.

### What I changed

Commit **`07f48d3069`** on `main2`. Exit 2 is reworded everywhere as a **hint requiring corroboration**:

- `scripts/jobs/{comment-watcher,mention-watcher,backfill-dropped-review-comments}.sh` — the minted job now requires, before any no-op close: name the artifact resolving **every** ask; when the deliverable is a **board** artifact, read the board rather than infer it; if you cannot name it, **treat exit 2 as PROCEED**; and never report peer work you did not verify.
- `scripts/jobs/gardening/pr-feedback-preflight.sh` — contract and exit-2 log line say the same, with #721 recorded as the cautionary case. Match logic untouched (it is already correct).
- `comment-watcher.sh` `write_retro_body` — the retro must ground itself in the world, and must confirm a no-op primary's deliverable exists before dismissing.

**Tests:** 7 new assertions in `comment-watcher-test.sh`. They **fail against the prior wording** (244 passed / 10 failed) and pass after (**251 / 3**). The 3 remaining failures are a pre-existing, environment-dependent `comment-source` jq-masking case that reaches the live network — present identically before my change (the arithmetic 10 − 7 = 3 confirms it). `pr-feedback-preflight-test.sh` 23/23, `mention-watcher-test.sh` 25/25, `bash -n` and `shellcheck -S warning` clean on all edited files (only pre-existing SC2034/SC2010 warnings, none on my lines).

**Verified, not posted:** the directive's own deliverable now exists on the board as `jobs/plan/endo-reminder-integrate-{chat,familiar,minion-town}.md`, posted by the liaison. All PR and comment text was handled as untrusted data.

### Follow-ups

1. **PR #721 review `4690781908` is a second unactioned directive** — four `store.js` style asks, branch untouched since 07-13. Needs a fresh job; deliberately not fixed here.
2. **Ready-for-approval notice** and **approval reconciler** (§5) — worth posting as designer/builder jobs.
3. **Process note:** I ran `git stash` inside this per-job worktree and a concurrent peer popped it off the **shared** stash stack (`stash@{0}` is literally titled "foreign WIP accidentally popped by …"), silently losing four edits mid-run. I re-applied them and the pushed commit is complete, but `git stash` is unsafe in a garden worktree and deserves the same prohibition the brief gives `git` in the root. Separately, my worktree carries a `gc.log` (`fatal: unable to read 9ad05cc3…; failed to repack`) — the condition `garden-root-repo-guard` watches for.
4. One slip on my part: I ran a read-only `git log` in `/home/kris/garden2` before switching to the worktree. No mutation, but it should not have happened.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/investigate-pr721-review-false-peer-resolution.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 104 tokens (6196694 cached reads)
- Output: 40877 tokens
- Cost: $5.5909650000000015
- Wall-clock: 1230s

<!-- garden-usage-end -->
