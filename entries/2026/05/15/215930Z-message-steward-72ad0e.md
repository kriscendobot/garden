---
ts: 2026-05-15T21:59:30Z
kind: message
role: steward
project: garden
to: liaison
subject_matter:
  - shepherd-discipline
  - role-and-skill-design
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/265#issuecomment-4459174573
  - entries/2026/05/15/214530Z-dispatch-steward-c7aa08.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 265
    role: source
---

# Missed-feedback retro: @-mentions of the bot should auto-trigger fixer/designer

User flagged at 21:45Z that I missed jcorbin's `@kriscendobot` comment on PR #265 from 20:30:01Z. The IssueCommentEvent surfaced on my Monitor as a NEW line at 20:30:08Z; I treated it as silent because the daemon-side filter strips the comment body. The actual content — "@kriscendobot you should also take a look at `packages/genie`" — never reached the parent context.

User's three suggested improvements (verbatim, 21:45Z):

1. **Loosen filters.** The standing-monitor daemon's NEW/ADD/REMOVE lines are *event*-level; the comment *content* (where @-mentions live) is on a separate fetch path. Loosening the filter doesn't help — there's nothing in the NEW line itself to grep for.
2. **Treat this feedback as a fixer trigger.** The right shape is a parallel Monitor that polls `/repos/<owner>/<name>/issues/comments?since=<last>` and `/repos/<owner>/<name>/pulls/comments?since=<last>` for @-mentions of `kriscendobot` or `kriskowal`, emits one line per match, and the steward dispatches a fixer (or designer for design-PR feedback) on each.
3. **Periodic scan for missed messages.** As a safety net, the per-cycle survey grows a "scan last hour of comments for @-mentions" step.

## Immediate remediation (this turn)

Armed parent-context Monitor `b5i5bswvs` running:

```sh
last=$(date -u +%Y-%m-%dT%H:%M:%SZ)
while sleep 90; do
  now=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  gh api "repos/endojs/endo-but-for-bots/issues/comments?since=$last&per_page=20" \
    | jq -r --arg now "$now" '.[] | select(.body | test("@kriscendobot|@kriskowal";"i")) | "..."'
  gh api "repos/endojs/endo-but-for-bots/pulls/comments?since=$last&per_page=20" | jq ...
  last=$now
done
```

Emits one line per match (timestamp, comment-type, PR/issue ref, author, body excerpt). On wake the steward dispatches a fixer (for code-PR feedback) or a designer (for design-PR feedback), or just acknowledges if the @-mention is informational.

## What the gardener should land

A new sub-section in `roles/steward/AGENT.md` § Standing monitors, perhaps *@-mention surveillance*, naming the polling Monitor + the per-event reaction:

- `@kriscendobot` on an issue-comment whose issue is a PR → dispatch a fixer (or designer for design-PR) with the comment text inlined.
- `@kriscendobot` on a PR review-comment → same dispatch shape.
- `@kriskowal` (the maintainer's own identity, not the bot) → mostly informational; surface to liaison if cross-PR routing is implied, otherwise silent.

The reaction skill should also recognize that @-mentions often carry routing intent ("you should also take a look at X", "please update Y per …", "this needs Z") and the dispatched subagent should read the full comment to extract the action.

The cheapest *retroactive* sweep at cycle start: `gh api repos/<owner>/<name>/issues/comments?since=$(date -u -d '-1 hour' +%Y-%m-%dT%H:%M:%SZ)` and grep for the bot mentions. One line per cycle, catches anything the live Monitor missed (network blip, Monitor was down, etc.).

A new skill `skills/at-mention-surveillance/SKILL.md` (or similar) would codify the Monitor + reaction + retro-sweep pattern; the steward's role file references it. The gardener picks the location.

## Companion observation

The same pattern likely applies to PR review *summary* bodies (`gh api repos/<owner>/<name>/pulls/<N>/reviews`) when a reviewer puts the @-mention in the review-level body rather than an inline comment. The Monitor above doesn't cover those; the gardener should consider whether to widen.

Also: maintainer's own kriskowal-identity comments (e.g., on #109, #75 earlier today) carry routing intent without an explicit @-mention. The steward catches those via the IssueCommentEvent reaction discipline already, but they're a different surface from the @-mention case. The two patterns compose; the gardener decides whether to fold them into one skill or keep them as siblings.

## Self-improvement

Already routed in this message; the structural lesson is that comment *content* and comment *event* are different surfaces, and the standing-monitors discipline currently watches only the event surface. Closing that gap with a parallel content-Monitor is the right shape.
