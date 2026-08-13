---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: builder
repo: kriskowal/garden (branch main2, pushed directly; no PR)

Fix a misclassification in the triager that produced a flood of false, alarming
maintainer notices tonight.

## What happened

Between 14:32Z and 14:37Z on 2026-08-13, `garden-repo-watcher` posted
`triager-upstream-gone-*` watchdog notices for THIRTEEN repos in about four
minutes: kriscendobot's cosgov, list, agoric-3-proposals, endo-but-for-bots,
moddable, finbot, vattr97, ymax-stdio-mcp, endo, minion.town, ocapn,
proposal-compartments, ymax-e2e. Each said:

> the UPSTREAM APPEARS GONE (deleted/renamed fork, or this host's credentials
> lost access) ... This does NOT self-heal by retrying

Both claims were false. Verified from the same host minutes later:
`ssh -T git@github.com` returns "Hi kriscendobot! You've successfully
authenticated", `gh api repos/kriscendobot/<name>` shows the repos exist and are
public, and `git ls-remote` succeeds on the very clones that "failed". The git
error in every case was `git@github.com: Permission denied (publickey)`.

The near-certain cause is **GitHub SSH rate limiting under a thundering herd**:
a sysop `deploy` op landed at 14:36:15Z, restarting the watchers, after which
~13 triagers attempted SSH auth against github.com within seconds of each other.
GitHub throttles that and rejects with exactly this message.

## The defect

The triager treats `Permission denied (publickey)` as evidence that the upstream
is gone or credentials are lost. Those are durable, human-remediable conditions,
so it fires a watchdog telling the maintainer to verify the repo and consider a
`watch-optout` tombstone. But a throttled auth is transient and DOES self-heal.
The result is a burst of scary, wrong notices whose prescribed remedy — disarm
the watch — would be actively harmful if followed.

## The fix

1. **Distinguish the failure modes by what git actually says**, rather than
   lumping all rc=128 fetch failures into "upstream gone":
   - `Permission denied (publickey)` / auth rejections / connection resets /
     timeouts -> TRANSIENT. Retry with backoff; do not post an
     `upstream-gone` notice. Escalate only if it persists across a meaningful
     window (make the threshold explicit and configurable), and even then say
     "authentication is failing", not "the upstream appears gone".
   - `ERROR: Repository not found` / `remote: Repository not found` / 404 ->
     genuinely gone or inaccessible. That is what the existing notice is for.
   Read `scripts/jobs/repo-watcher.sh` (and any shared fetch helper in
   `scripts/jobs/common.sh`) for where the classification lives now.
2. **Confirm before claiming "gone".** Before posting an upstream-gone notice,
   have the watcher do what the notice tells the human to do: check
   `gh api repos/<owner>/<name>`. If the repo answers, it is not gone, and the
   notice must not say it is. This alone would have suppressed all thirteen.
3. **Damp the herd.** Stagger or jitter per-repo fetches so a restart does not
   fire every triager at github.com simultaneously. A small random delay per
   repo is enough.
4. Correct the notice text: "does NOT self-heal by retrying" is only true of the
   genuinely-gone case, and should not appear on a transient one.

## Tests

Cover the classifier directly: a `Permission denied (publickey)` stderr must NOT
produce an upstream-gone verdict; a `Repository not found` stderr must; and the
`gh api` confirmation must veto the notice when the repo exists.

## Notes

- Garden repo convention: land on `main2` directly, no PR.
- Do not disarm any watch and do not add any `watch-optout` tombstone. Every one
  of those thirteen repos is legitimately watched; the notices were wrong, not
  the watch set.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-13T16:08:47Z
