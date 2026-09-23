---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 290
upstream_mirror_repo: null
upstream_mirror_pr: null
created_at: 2026-06-18T22:14:00Z
last_appended_at: 2026-06-18T22:14:00Z
status: parked
actioned_at: null
actioned_via: null
merge_event: null
---

# Follow-ups for endo-but-for-bots#290

## Items

- [ ] `resolveModelString` provider-detection uses `host.includes(...)` URL-string matching rather than a proper URL parse on the hostname component. An adversarially crafted `LAL_HOST` value of `https://evil.com/openai.com/path` would match the `openai.com` detection string. Follow-up: validate `LAL_HOST` as a proper URL before string-matching on the hostname component.
  **Source juror(s)**: saboteur
  **Round**: 1
  **Recommended action**: file as issue on endojs/endo-but-for-bots or open a follow-up PR that narrows `resolveModelString` to parse the URL and match on `hostname` (not `includes` on the raw string)
