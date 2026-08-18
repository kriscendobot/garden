Done. The maintainer's directive is folded into the design and the reply is posted.

## Completion report

**Job:** attention directive on kriscendobot/minion.town PR #37 (comment [5323465130](https://github.com/kriscendobot/minion.town/pull/37#issuecomment-5323465130) by kriskowal).

**Preflight:** `pr-feedback-preflight.sh` exited 2 (HINT). I corroborated: the only post-feedback "resolution" text on the PR was my own job's auto-ack reply (`5323473916`), not a peer resolution. No prior commit or reply satisfied the directive, so I proceeded and did the work.

**Directive (routed to design-doc work):** The maintainer accepts the formula-identifier local-part for the synthetic email address, **conditioned** on email addresses in general being obscured by replacement with opaque references when they materialize in the guest's pet mailbox — the mailbox instance of the Endo daemon's distributed-confinement effort (guests see only their own petnames and passable objects, never identifiers or locators). This is design-refinement on an active design PR, so I folded it into the doc directly (the same pattern as review round 1).

**What changed** — `designs/ocap-mailboxes.md`, commit `d548588` on `design/ocap-mailboxes` (pushed via rebase-CAS):
- **§ 8** — new subsection "Addresses are obscured on materialization in the guest's pet mailbox": records the conditional acceptance and specifies the inbound adapter rewrites *every* address a message carries (envelope, `From`/`To`/`Cc`/`Reply-To`, body) into the router-bound opaque handle — minting a fresh receive-side handle + petname for an unknown sender — before the message settles; scoped as distinct from the SES wire's never-rewrite-`From` obligation.
- **§ 9** — new acceptance criterion "No raw address in the mailbox."

**Reply posted:** [issue comment 5323498844](https://github.com/kriscendobot/minion.town/pull/37#issuecomment-5323498844) mapping the directive to where it landed, with the `garden-reply:5323465130` marker.

**Notes / follow-ups:** A separate design-panel round 2 (`kriscendobot-minion.town-pr37-gauntlet-panel-2`) is in `doin/` on the same PR; it races the push CAS harmlessly (isolated worktrees). No new open questions introduced — the obscuring is a resolved directive, not a deferral. Un-drafting/merge remains the maintainer's call per the designer norm.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr37-1d4d0715.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (988214 cached reads)
- Output: 14271 tokens
- Cost: $1.3707319999999998
- Wall-clock: 225s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
