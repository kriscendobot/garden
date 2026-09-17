Routing complete. The attention-router deliverable is done: I re-derived the job state from scratch, corroborated the preflight's exit-2 hint was only our own "On it" auto-ack (not a resolution), analyzed the directive against the code, and put a decision-ready reply on the maintainer's thread.

## Completion report

**Job:** attention directive on endojs/endo-but-for-bots PR #1125, comment [r4040834390](https://github.com/endojs/endo-but-for-bots/pull/1125#discussion_r4040834390) (kriskowal).

**Directive (verified at source):** kriskowal wants to create a guest with *both* special names and pet names, using `introducedNames` to inject both, discriminating on the `@` prefix.

**What I found:**
- Preflight returned exit 2, but the only correlated artifact was our own comment-watcher "On it — posted a job" auto-ack (id 4040846276) — **not** a resolution. So I proceeded.
- Today `introducedNames`' `childName` is pet-name-only (`AGENTS.md` states it explicitly; `introduceNamesToAgent` routes through `agent.storeIdentifier`, which rejects `@` leaves). The guest special-name overlay (`makePetSitter` in `guest.js`) is **formula-time-fixed and GC-pinned**, so honoring the directive is a guest-**formula-shape** change spanning `host.js` / `guest.js` / `manager.js` + tests + docs — build/fix scale, following the exact threading the PR just added for `pins`/`networks`.
- This capability is already owned by **issue #982** (parked plan `endojs-endo-but-for-bots-issue982-build-special-names`, gate `go-ahead`, doomed), which proposed an `endowSpecialNames` API; this comment refines the API to `introducedNames`+`@`. A sibling in-flight attention job (comment r4040732326) also touches #1125.

**Routing decision:** A same-comment fixer successor is **blocked by directive-identity dedup** (`#1125:comment:4040834390` is bound to this job), and repo evidence shows fixer handoff here is gated by an explicit maintainer "pass to a fixer" comment. There is also a genuine maintainer-facing fork — whether `introducedNames`-injection should **replace** the just-added `pins`/`networks` options (a simplification of this very diff) or **complement** them. So I posted a concise, decision-ready threaded reply ([r4041036745](https://github.com/endojs/endo-but-for-bots/pull/1125#discussion_r4041036745)) that: states the concrete implementation approach + guardrails (`@agent`/`@self`/`@host` non-injectable, `isSpecialName`-validated, creator-authority-only), reconciles against #982 so it isn't built twice, and asks the one fork question, inviting his go-ahead / "pass to a fixer."

**Changes:** none to code (correct — the deliverable is untouched pending the maintainer's fork decision); one PR thread reply posted under the bot identity.

**Follow-up:** on kriskowal's next reply (go-ahead or fork choice), a fixer job — minted from that new comment's directity identity, so no dedup collision — implements the `@`-discriminated `introducedNames` injection on the #1125 head, reconciled with #982.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1125-ee75a88d.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 62 tokens (2072296 cached reads)
- Output: 26899 tokens
- Cost: $2.9188720000000004 (1 engagement(s) unpriced)
- Wall-clock: 465s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
