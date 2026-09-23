Pushed to main2. Job complete.

## Completion report

Clean re-start: no prior attempt had committed anything (main2 HEAD was `7b57fce400`, no related commits). Re-derived state from scratch and landed the work in one commit `b07706492b`, pushed to `main2`.

**Files changed (3):**

1. **`roles/COMMON.md`** § External-repo etiquette — added two sharper standing rules plus their override, right after the existing authorization "Exception" paragraph, leaving the per-role table and erights maintainer-authority passage intact. Final wording of the two rules:

   > **Never close a GitHub issue.** The issuer — the person who filed it — closes it when they are satisfied. A role handling an issue on any repo (through the issue inbox or otherwise) does the work, replies on the issue thread, and leaves the issue **open**; a submitter-close is the terminal signal, and it is theirs to give.

   > **Never resolve a conversation thread on a pull request review.** Resolving a review thread (GitHub's "Resolve conversation" button / the `resolveReviewThread` mutation) is the call of the reviewer who **opened** that thread, not the agent replying to it. Reply substantively and cite the addressing commit SHA, but leave the thread **open** for the reviewer to resolve.

   The override reads consistently with the existing issue/PR-close and erights language: a maintainer's explicit per-action directive is the authorization, carried through the liaison after user confirmation or a journal `message`/inbox entry; no autonomous role originates it for itself.

2. **`skills/issue-inbox/SKILL.md`** — step 3's standalone "Never close the issue / defer to the submitter" prose replaced with a citation to the now-canonical `COMMON.md` rule (relative link), preserving the issue-inbox-specific procedural detail that a submitter-close is the watcher's terminal dispatch signal.

3. **`skills/pr-review-thread-replies/SKILL.md`** — added a one-line **"Reply, don't resolve"** note citing `COMMON.md` for the rule and reasoning, making the reply-not-resolve split explicit.

**Acceptance:** grepped `roles/`+`skills/` — the rule text now lives once in `COMMON.md`; the two skills cite it, they don't restate it. The one other `close the PR` hit (`roles/botanist/AGENT.md`) is the separate, already-gated Dependabot REJECT PR-close action, not the issue-close/thread-resolve rules. No duplication. No follow-ups.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/revise-standing-instructions-defer-to-submitter.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 12 on 2 host(s) (10 unmetered)
- Input: 20 tokens (546718 cached reads)
- Output: 5619 tokens
- Cost: $0.8475820000000002 (10 engagement(s) unpriced)
- Wall-clock: 442s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
