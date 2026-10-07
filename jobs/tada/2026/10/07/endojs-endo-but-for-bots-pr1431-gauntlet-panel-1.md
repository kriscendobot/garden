Panel round 1 on endojs/endo-but-for-bots#1431 came back **must-fix**, and I posted the aggregate as a review on the PR.

**How it ran:**
- **Checkout:** I made an isolated checkout of the PR head (`endojs/design/hardened-text-codecs-encapsulation` at `45c49139f2`) with `ensure-project-worktree.sh`.
- **Panel:** `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 1431 fda1ff5…` ran against the PR's `baseRefOid` (base `llm-fda1ff5`) rather than a possibly stale `origin/` ref. It exited 0 with disposition `design-panel single-round — must-fix`.
- **Seats:** the design panel used critic, skeptic, decomplector, ergonomist, novice, pedant, copyeditor, orthographer and thesaurus. The ownership-map pre-pass flagged the diff, so the decomplector lens was forced on.
- **Review:** `gh pr review --request-changes` was refused because the bot can't request changes on its own PR, so it went up as a COMMENTED review (2026-10-07T22:55:12Z). It carries the "must-fix" header and the full round-1 aggregate.

Before posting, the gh wrapper also refused the body: a juror had written a bare `#1349` in a comment that also names `endojs/endo`. I rewrote those mentions as `endojs/endo-but-for-bots#1349`. One of them was inside a juror's quote of the PR text, so that quote no longer matches the PR word for word.

**Main must-fix and should-fix findings for the fix loop:**
- **Reachability not shown (skeptic, must-fix):** the claim that the host constructor is unreachable "on every engine" doesn't say how it is checked: a full graph walk, or only `.constructor`. The design also doesn't discuss the mutation of host instances created before `lockdown()`.
- **Other WebIDL constructors left out (decomplector):** the root cause is stated for WebIDL constructors in general, but the fix covers only the codecs. `URL` and `URLSearchParams` are already permitted and would hit the same Chromium-before-138 failure. They should be listed or explicitly deferred.
- **Existing mechanism not reused (decomplector):** the `tameUrlConstructor` / `addIntrinsics` path already does this. The design changes the global object at import time instead, which is what forces the extra idempotency and XS module-load requirements. It should reuse that path or say why it can't.
- **Missing compatibility and test coverage (skeptic, critic):** the Compatibility section doesn't cover constructor-identity breaks or `toString`/`[native code]` differences. Tests are missing for subclassing, Node's `util.TextDecoder`, and applying the change twice on XS. The retirement condition needs a concrete trigger and a tracking issue.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1431-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (695412 cached reads)
- Output: 4257 tokens
- Cost: $0.6617424000000001
- Wall-clock: 176s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
