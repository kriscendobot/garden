## Completion report — `endo-pr3360-mirror`

Created a faithful, read-only mirror of https://github.com/endojs/endo/pull/3360 ("Improve portability of ModuleSource on the web with Babel 8") on `endojs/endo-but-for-bots`. Only that repo was written; two public repos were read. No interaction with upstream `endojs/endo`, `james-pre/endo`, or any @-mention of `james-pre`/`kriskowal`.

**What I did**
- **Frozen base** — `master-77d9d0c` already existed on `endojs/endo-but-for-bots`, pointing exactly at the PR's base `77d9d0cdf82e58e0dcf6f38fdc54798e37f0ab93`. Reused it (verified tip).
- **Mirror head branch** — In a scratch repo outside the garden root, fetched the PR's exact head `02ca139ddf0b075f11c85b2a7570cf7940067828` from `james-pre/endo` and pushed it byte-identical (no rebase/squash/edit) as `mirror/endo-pr3360-fix-process-global`. Confirmed it is exactly the 4 named commits atop `77d9d0c`, with `77d9d0c` as ancestor. (Note: the live `fix-process-global` branch has since advanced to `5398654b…`; I mirrored the exact SHA the directive named, not the moved branch tip.)
- **Draft PR** — Opened via `ensure-pr.sh` (frozen-base gate passed, no bare `gh pr create`): **endojs/endo-but-for-bots#1342** — https://github.com/endojs/endo-but-for-bots/pull/1342. Draft=true; head=`mirror/endo-pr3360-fix-process-global` (tip `02ca139`), base=`master-77d9d0c`. Title marks it a mirror citing `endojs/endo#3360`; body states it's a mirror for garden tracking, cites the fully-qualified upstream URL + base/head commit URLs, and carries the `<!-- garden-job: endo-pr3360-mirror -->` marker.

**Verification** — PR is draft, correct base/head, and the four commit SHAs on the PR match upstream byte-for-byte (`fb5f9ca0`, `3bfaad4b`, `f9fe2d27`, `02ca139d`).

**Scope** — Stopped after the mirror exists; ran no panel/gauntlet/fix-loop, per the directive.

**Follow-ups** — None required. One note for the record: the upstream branch has moved past the mirrored SHA since the 2026-09-02 directive; the mirror deliberately pins the maintainer-named commit, so it won't track further upstream changes.

Mirror PR: https://github.com/endojs/endo-but-for-bots/pull/1342
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-pr3360-mirror.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 8 on 2 host(s) (6 unmetered)
- Input: 26 tokens (678133 cached reads)
- Output: 7935 tokens
- Cost: $1.0389414999999997 (6 engagement(s) unpriced)
- Wall-clock: 313s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
