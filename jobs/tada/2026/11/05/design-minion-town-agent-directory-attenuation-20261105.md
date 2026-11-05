Opened draft design PR https://github.com/kriscendobot/minion.town/pull/250.

Added `designs/api-key-agent-directory-authorization.md`, choosing option 1: the owner-wide directory is an intentional administration boundary, not an established security gap. Option 2 would provide no attenuation behind the same identity-derived REST interface; it becomes warranted only for a less-trusted, single-agent consumer. A full redesign is rejected.

The design includes gap criteria, REST/CapTP scoring, an ownership map, and concludes no architecture implementation follow-up is needed.

Verification: `git diff --check`; 60 targeted tests passed; PR CI passed. The draft PR is pinned to `main-7a0bcc9`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-minion-town-agent-directory-attenuation-20261105.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 700s

<!-- garden-usage-end -->
