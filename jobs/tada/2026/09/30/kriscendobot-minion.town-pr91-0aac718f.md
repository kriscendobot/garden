I've made PR #91's demo CLI defaults plain and visible, pushed the change, replied on the PR, and CI is green.

**The ask:** kriskowal's review on kriscendobot/minion.town#91 (and the re-asked comment 5903022833) says "Please choose more transparent defaults." and ends with "@kriscendobot rsvp". The preflight's exit 2 was a false hint: the only matching text was the bot's own "On it" acknowledgment, so I did the work.

**What changed** (commit `6b25675` on `fix/cli-empty-guest-env-defaults`):
- **Plain defaults:** in `dev/client.ts`, `GUEST_NAME` now defaults to `"demo-note"` and `GUEST_TEXT` to `"Hello from the minion.town demo client"`. The old values, `"b5-daemon-note"` and `"B5 Endo daemon durability probe"`, used an internal milestone code.
- **Documented and printed:** the file header now names both defaults and explains the write, restart, read check without "B5" jargon. The CLI also prints the resolved name and text before the OAuth flow.
- **Empty override still works:** an empty `GUEST_NAME` or `GUEST_TEXT` still falls back to the default. I cut the long rationale comment down to two lines.
- **README:** the sample output matches the new defaults and the new printed line.
- **Rebase:** the branch was 155 commits behind, so I rebased it onto current `main` (`33aac61`) and force-pushed with a lease.

**Where it stands:**
- **Checks:** CI passes on all checks (test, Claude harness amd64 and arm64). Typecheck is clean locally. The local test run has one failure, in `test/git-remote/capability.test.ts` ("propagates a git failure rather than reporting the ref absent"). It's in code this change doesn't touch and matches a host-environment failure noted earlier; I didn't rerun it without the change.
- **PR:** I added a "Transparent defaults" section to the description and replied with the details at https://github.com/kriscendobot/minion.town/pull/91#issuecomment-5904398101.

**Follow-ups:**
- The PR still has kriskowal's CHANGES_REQUESTED review, so it needs their re-review.
- The same ask was first made on 2026-09-04 (comment 5540294847) and never got an answer; this reply covers both.
- The rebase auto-stashed some leftover `package-lock.json` changes from the dependency install. I dropped that stash entry after checking it held nothing else.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr91-0aac718f.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (993746 cached reads)
- Output: 7973 tokens
- Cost: $0.7849132
- Wall-clock: 362s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
