## Report

**Job:** review directive on https://github.com/endojs/endo-but-for-bots/pull/825 (review https://github.com/endojs/endo-but-for-bots/pull/825#pullrequestreview-4798529077, @dckc).

Preflight `pr-feedback-preflight.sh` returned exit 0 (PROCEED, no peer resolution). The review body is empty; the review carries exactly **one** inline comment, which I enumerated and treated as data:

- `packages/daemon/src/collection-store.js:33` — on the phrase *"and that is load-bearing rather than incidental"*: "what do those words contribute? strike them? never use them again?"

Two asks, both resolved: the strike, and the standing "never use them again".

### 1. The strike (project repo)

Struck the clause from the `collection-store.js` module comment and reflowed the paragraph. It asserted the importance of the store's synchrony; the three sentences after it already established it (what synchrony buys `collectWeakEntries` and restart, and why the asynchronous daemon boundary forecloses it), so the clause asked the reader to accept a label ahead of the evidence.

- Commit https://github.com/endojs/endo-but-for-bots/commit/686d8b98f84316ebc991d9dbc11f548f46bc789f, pushed to `daemon-store-phase4-sorted`.
- Grepped the full PR diff for the same construction (`load-bearing`, `rather than incidental`, `note that`, `is important`) — this was the only instance.

### 2. The standing rule (garden library)

Landed on `main2` as https://github.com/kriscendobot/garden/commit/92afc9f5b7761df1791515b0d9bb46126888769b:

- `skills/gricean-maxims/SKILL.md` gains a Quantity subsection, **"The sharpest instance: empty emphasis"** — do not tell the reader something matters; show what it buys. It names the tell (contrastive negation with no candidate: "X rather than incidental"), carries the #825 line as the worked example, and scopes itself: not a ban on "load-bearing" where the word marks which premise an argument rests on, only on asserting importance in place of establishing it.
- Extended that skill's scope from bot reports/messages to **prose the fleet lands in a project repo** (code comments, design docs, commit bodies). That is where this failure landed and it has the longest half-life — a report is read once, a padded module comment on every open.
- `roles/COMMON.md` § House style and the liaison brief updated to match.
- My own additions were re-checked against `em-dash-style`; `scripts/checks/run-all.sh` clean (5/5 gates).

### Communication

- Inline reply: https://github.com/endojs/endo-but-for-bots/pull/825#discussion_r3669778618
- Top-level summary: https://github.com/endojs/endo-but-for-bots/pull/825#issuecomment-5110649537, plus a verification update: https://github.com/endojs/endo-but-for-bots/pull/825#issuecomment-5110692446
- Inbox drained (empty).

### Verification

`lint` **passed** on the new head (7m34s, https://github.com/endojs/endo-but-for-bots/actions/runs/30406831226/job/90434038155). 17 checks pass, 4 still running, none failing. I did not run `yarn lint`/`yarn test` locally — see follow-up 2.

### Follow-ups (neither blocks this job)

1. **Garden root repo health.** The `main2` push emitted `fatal: unable to read 9ad05cc3563a7ba4b8f3a0b3e7941090e4d427d6` / `failed to run repack`, and a stale `.git/worktrees/.../gc.log` blocking automatic cleanup. The push itself succeeded. I deliberately did not touch it — it is the shared root repo. Worth a sysop/maintainer pass.
2. **Warm-cache miss.** `ensure-project-worktree.sh` reported `WARM-CACHE hit ... populated 100 node_modules tree(s)`, but neither the root nor `packages/daemon` had a populated `node_modules/.bin`, so no local lint/test was runnable. The report and the reality disagreed; if that is general rather than specific to this checkout, it silently degrades every gardener's local verification.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr825-review-18fde0da.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 88 tokens (2965675 cached reads)
- Output: 21218 tokens
- Cost: $2.6963674999999996
- Wall-clock: 631s

<!-- garden-usage-end -->
