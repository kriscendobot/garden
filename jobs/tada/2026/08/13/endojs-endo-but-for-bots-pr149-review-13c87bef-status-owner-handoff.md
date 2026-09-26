Disposition: 5 - migrate only the durable prompt/history into the garden journal.

Freshly observed refs:

- `origin/llm`: [`a54c3adbebf18fd837770d467433e480de498e8d`](https://github.com/endojs/endo-but-for-bots/commit/a54c3adbebf18fd837770d467433e480de498e8d)
- [Pull request 149](https://github.com/endojs/endo-but-for-bots/pull/149) head: [`e0c8accb3235a340ce2b4e4307138429a7d1e5f3`](https://github.com/endojs/endo-but-for-bots/commit/e0c8accb3235a340ce2b4e4307138429a7d1e5f3)
- Feature commit: [`e3ba306f21d3947e789dec95646a05d989c577d3`](https://github.com/endojs/endo-but-for-bots/commit/e3ba306f21d3947e789dec95646a05d989c577d3)

I fetched `origin/journal2` and read all three discovery reports directly with `git show`. Their scopes are consistent: the deployment report identifies this handoff, while the Genie-core and sandbox reports introduce no conflicting implementation or destination.

The pull-request implementation runs [`endo invite owner` at host level](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/packages/genie/scripts/bottle.sh#L611-L623), writes the locator to [`PENDING_OWNER_INVITE`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/packages/genie/scripts/bottle.sh#L465), polls the textual inbox, and [removes the marker after detecting an externally named sender](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/packages/genie/scripts/bottle.sh#L656-L684).

Current `origin/llm` retains the underlying [`invite`](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/cli/src/commands/invite.js#L6-L13), [`accept`](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/cli/src/commands/accept.js#L14-L25), and [`inbox --follow`](https://github.com/endojs/endo-but-for-bots/blob/a54c3adbebf18fd837770d467433e480de498e8d/packages/cli/src/commands/inbox.js#L11-L16) primitives, but contains neither the bottle scripts nor `PENDING_OWNER_INVITE`, as shown by the current [`packages/genie` tree](https://github.com/endojs/endo-but-for-bots/tree/a54c3adbebf18fd837770d467433e480de498e8d/packages/genie).

The shell should not be integrated into Lal, Fae, or Agentry. Ownership transfer and host readiness are deployment concerns outside those packages, and the prototype's completion test is not a reliable acceptance signal: it matches any reverse-locatable external message, including stale or unrelated mail, while acceptance without a subsequent message can wait forever. The locator is also written without requesting restrictive file permissions. Finally, the script mentions `--no-wait` but never parses it, despite the associated TADA marking that option complete.

The journal migration should preserve:

- Host-level invitation versus child-guest invitation.
- A durable, restart-visible pending-ownership marker.
- Rerun and stale-invitation semantics.
- Cleanup only after structured confirmation tied to the specific invitation or owner.
- Atomic, restrictive storage for the bearer locator.
- The unchecked acceptance and rerun scenarios from [`TADA/81_genie_bottle_phase0_shell.md`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/TADA/81_genie_bottle_phase0_shell.md#L192-L229).

The durable source history is [`PLAN/genie_in_bottle.md`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/PLAN/genie_in_bottle.md#L290-L381), the Phase-0 TADA above, and the owner-edge account in [`TADA/10_genie_self.md`](https://github.com/endojs/endo-but-for-bots/blob/e0c8accb3235a340ce2b4e4307138429a7d1e5f3/TADA/10_genie_self.md#L200-L213). The Genie-specific invoke/evoke shell and contradictory completed checkboxes should remain only as experiment history.

Static evidence: `bash -n` passed on the pull-request-head script. Runtime handoff was not verified; no live daemon or second-host acceptance was exercised. No project files, commits, branches, or GitHub state were modified.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr149-review-13c87bef-status-owner-handoff.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 313s

<!-- garden-usage-end -->
