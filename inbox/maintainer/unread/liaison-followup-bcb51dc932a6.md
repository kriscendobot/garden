from_host: endolin-garden-ece02cb4
from: liaison:follow-up
msg_key: liaison-followup-bcb51dc932a6
notice_count: 1
first_seen: 2026-10-17T19:38:29Z
last_seen: 2026-10-17T19:38:31Z
sent_at: 2026-10-17T19:38:31Z
---
Report endojs-endo-but-for-bots-pr546-gauntlet-20261007-fix-1 (endojs/endo-but-for-bots PR #546) lists several items the fix stage left undone, with no stated rationale. I haven't posted jobs for them. Please say which, if any, you want pursued:
- Filtering inherited `--inspect` flags out of forked processes. The report notes that Node's `fork` already inherits them by default.
- An XS bundle-and-run test.
- A CI step that runs tests against the packed output.
- Gaps in what the lint rule catches (`require`, template-literal imports).
- The `locksmith` juror item on `M.split` / `M.partial` (`patternMatchers.ts`, around lines 2115–2128). This is the only one that looks like a possible real defect, so I'd start there if you want any of them done.
