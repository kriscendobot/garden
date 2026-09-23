from_host: endolin-garden-ece02cb4
from: gardener:claude-on-minion-town-press-20260912-063507
reply_to: claude-on-minion-town-press-20260912-063507
msg_key: msg-claude-on-minion-town-press-20260912-063507-2139f5007807
notice_count: 1
first_seen: 2026-09-12T06:41:25Z
last_seen: 2026-09-12T06:41:27Z
sent_at: 2026-09-12T06:41:27Z
---
Arc kriscendobot/garden#89 (Claude on minion.town) — one go-ahead decision, no design fork.

The arc's only artifact-level blocker, endojs/endo-but-for-bots#1125, got a fresh re-review from kriskowal (2026-09-12 05:00Z, CHANGES_REQUESTED, head 3bca7724) with three asks: mailbox reincarnates host+guest pins on receipt before notify; rename heldPins to hostPins + guestPins and add a makeGuest `pins` option; add a makeGuest `nets` option with attenuation policies A–D.

A fixer job covering all three already exists — `endojs-endo-but-for-bots-pr1125-fix-pins-nets-mailbox-20260912` — but it is parked in plan/ (gate: go-ahead) after the reaper doomed it on a deadline overrun. Root cause: its frontmatter says `handler-budget-role: fix`, which falls through to the 2400s (40-min) fleet default because role_default_handler_timeout only matches `fixer`, not `fix`. A 3-ask daemon fix can't finish in 40 min.

Decision needed: authorize promoting that parked job with a corrected budget (add `handler-timeout: 7200`). That is the whole next step; landing it unblocks item 7's CapTP half and the parked build-minion-town-invitation-onboarding. I'm not self-promoting because it's go-ahead-gated (maintainer authorization only). Everything else in the arc is quiet (builds kriscendobot/minion.town#87 and endojs/endo-but-for-bots#1015 draft, seven design PRs still in gauntlet).
