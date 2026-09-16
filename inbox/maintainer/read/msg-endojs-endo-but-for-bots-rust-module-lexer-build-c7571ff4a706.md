from_host: endolin-garden-ece02cb4
from: gardener:endojs-endo-but-for-bots-rust-module-lexer-build
reply_to: endojs-endo-but-for-bots-rust-module-lexer-build
msg_key: msg-endojs-endo-but-for-bots-rust-module-lexer-build-c7571ff4a706
notice_count: 1
first_seen: 2026-09-16T13:07:21Z
last_seen: 2026-09-16T13:07:23Z
sent_at: 2026-09-16T13:07:23Z
---
Re: build job `endojs-endo-but-for-bots-rust-module-lexer-build` (consolidate the Rust module lexer, design PR endojs/endo-but-for-bots#1019).

I did NOT start the build — its precondition is unmet and its premise is stale. Re-parked it blocked on endojs/endo-but-for-bots#1019 instead of burning a large multi-phase Rust refactor. Details:

1. Design PR endojs/endo-but-for-bots#1019 is NOT maintainer-accepted. Still OPEN; zero reviews from you. All reviews are the bot design panel, which across 6 rounds still aggregates to **must-fix** with unresolved should-fix items (corpus fixture home; template-literal divergence). The job body is explicit: "promote only after design PR endojs/endo-but-for-bots#1019 is reviewed/accepted by the maintainer. Do not start ahead of design acceptance." It was promoted off the plan queue today (cleared=none), but the design-acceptance gate was not satisfied.

2. Stale premise: job targets branch `feat/endor-run-entry-point-deps` "where entry_walk.rs lives, not yet on llm." But PR endojs/endo-but-for-bots#282 MERGED 2026-08-27 — both `entry_walk.rs` and `cjs_lexer.rs` are on `llm` now. Any real build should target `llm`, and I updated the re-parked body to say so.

3. Substantive design contradiction the panel flagged: the two scanners the design unifies "with no behavior change" actually DISAGREE on nested template literals — `cjs_lexer.rs` uses a correct depth stack; `entry_walk.rs::scan_static_imports` uses a single counter its own comment admits is incomplete. "Unify byte-identically" is not literally achievable as written; the design must first pick which behavior wins.

Recommendation: land/accept endojs/endo-but-for-bots#1019 (resolving the template-literal-behavior question and the corpus-home should-fix) before I build. Once it merges, the re-parked job auto-unblocks. Or, if you want to proceed now against `llm` accepting the design as-is, reply and I'll pick it up.
