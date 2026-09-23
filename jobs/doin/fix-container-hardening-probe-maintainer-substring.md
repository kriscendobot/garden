---
role: fixer
priority: high
posted_by: liaison
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Fix: check-container-hardening.sh check 6 flags "kriskowal" by substring (false positive)

Repo: the garden itself (`kriscendobot/garden`, `main2`, push direct, no PR).

`scripts/check-container-hardening.sh` (added in 3d453e30784) check 6 fails when
`gh auth status 2>&1 | grep -qi kriskowal` or `grep -qi kriskowal ~/.config/gh/hosts.yml`
matches (~lines 109-122). On the leader (endolin-garden-ece02cb4) this reported "kriskowal logged
into the bot's gh", but the maintainer CONFIRMED (2026-09-23) that the account there is
`kriscendobot` only. So something else in that text contains the substring (a
`kriskowal/garden` repo path, a gh-wrapper notice, a config key, …). Once deployed, the
twice-daily `garden-container-hardening` timer would false-alarm.

## Ask
- Compare ACCOUNT LOGINS, not text. Enumerate the logged-in users structurally, e.g.
  `gh auth status --json hosts` (when available on the installed gh; otherwise parse `hosts.yml`'s
  `users:` map keys and each host's `user:` field with a YAML-aware or strictly anchored parse), and
  fail only if a login equals the maintainer login. Take that login from config (e.g.
  `GARDEN_MAINTAINER_LOGIN`, defaulting to kriskowal, or the journal `maintainers/allowlist`) rather
  than hardcoding it. Also check `GH_TOKEN`/`GITHUB_TOKEN` in the env by resolving the token's
  login (`gh api user` with that token), not by grepping.
- Make sure the check runs as the bot user WITHOUT the fleet gh wrapper's identity pin
  masking the truth (call the real gh binary or read the files directly).
- Add tests: a hosts.yml mentioning `kriskowal/garden` in a non-user field → PASS; a real
  `users: {kriskowal: …}` entry → FAIL; env token resolving to the maintainer → FAIL.
- If you can learn what actually matched on the leader, say so in the report (read-only).
  Run the hardening probe tests and push to `main2`.
- **Complete the job via the normal completion path when done.**

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-23T17:30:59Z
