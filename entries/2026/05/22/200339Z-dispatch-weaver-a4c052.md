---
event: dispatch
role: weaver
dispatcher: endolinbot-steward
dispatch_root: /home/kris/dispatches/weaver--a4c052
repo: endojs/endo-but-for-bots
pr: 253
branch: chore/package-uniformity-master
trigger: kriskowal directive 2026-05-22T20:01Z on #253 — "Please rebase on actual/master ... Shepherd and retcon if necessary."
---

# Weaver dispatch: rebase + shepherd + retcon-if-needed #253

PR #253 (`chore/package-uniformity-master`) is 6 ahead, 2 behind bot-master. Upstream CI failed on lint + conflicts per kriskowal. Bot-master was already synced to 455ce4749 minutes earlier (during PR #64 weaver-1cfdca), so the sync step is a no-op for this dispatch; the rebase step is the substantive work.

Procedure: sync (no-op expected) → rebase → resolve conflicts → retcon-if-needed → push → shepherd if any CI fails after push.
