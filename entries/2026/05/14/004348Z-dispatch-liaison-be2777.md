---
ts: 2026-05-14T00:43:48Z
kind: dispatch
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/13/013320Z-dispatch-liaison-e88a31.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 223
    role: source
  - repo: endojs/endo
    pr: null
    role: target
---

Dispatching the boatman to ferry `endojs/endo-but-for-bots#223` (`@endo/bytes` package) to `endojs/endo`. Second real handoff. User confirms no upstream PR exists yet for this change.

**Source**: `endojs/endo-but-for-bots#223`, branch `feat/endo-bytes-upstream`, head `1baf237a20d42f01e5879da07197db2f567fbaad`. Title `feat(bytes): @endo/bytes package for platform-neutral byte operations (mirror of #142 for upstream)`. State OPEN, MERGEABLE, mergeStateStatus CLEAN, all 27 CI checks SUCCESS. Diff +1122/-706 across 49 files (the deletions are the consumer-migration churn the source PR explicitly stripped to keep this branch upstream-only).

**Upstream**: `endojs/endo`, target branch `master`.

**Human**: `Kris Kowal <kris@cixar.com>`.

**identity_switch_authorized: true** — explicitly authorized by the user in this dispatch.

**Framing direction from the user, reinforced from the just-landed boatman role updates**:

- The PR should not belie the existence of our bot garden. Drop the title's `(mirror of #142 for upstream)` parenthetical. Rewrite the body's bot-bookkeeping paragraphs ("Mirror of...", "This PR exists only as a preview", "Do not merge here", "the bot's `kriscendobot` identity has only `pull` access on `endojs/endo`", references to garden branches `llm` / `actual/master`, mentions of the bot's weave process or downstream consumers).
- Issue numbers in the source body need to be dropped or translated. Specifically `Refs: endojs/endo equivalent of #140 (design)` is a translate-or-drop case: there's no design issue on `endojs/endo` yet (the source PR explicitly says "A separate design document upstream-equivalent of #140 should be filed first or alongside"). Drop the line; the package's README and the PR body itself document the design rationale.
- The title needs framing for the upstream audience. Suggested: just `feat(bytes): @endo/bytes package for platform-neutral byte operations`. Match the upstream's PR template otherwise.

**Source-branch caveat for the boatman**: the source's "Upstream-relevant migrations only" parenthetical lists what was deliberately excluded (`daemon`, `cli`, `ocapn` consumer migrations). The diff already reflects that exclusion. The squash-via-diff approach used on the prior dispatch should work here too: `git diff <merge-base>..feat/endo-bytes-upstream` will produce just the `packages/bytes/` content as intended.

**Per-handoff design-issue question**: the source body says "A separate design document upstream-equivalent of #140 should be filed first or alongside." The boatman should NOT file the design issue — that's a separate engagement. If the boatman judges the upstream PR cannot be opened cleanly without it, write a `message` to liaison and stop rather than improvising. My read: the package's README documents the design rationale adequately; the PR can land without a separate issue. The boatman has discretion to disagree.

**Expected report**: upstream PR URL, upstream head SHA, attribution-verified, source PR closed-with-forward-link, journal `result` entry, `Self-improvement: ...`. If anything blocks (design-issue question or otherwise), `message`-to-liaison and stop.

Per-dispatch worktree triple to be created next via `scripts/dispatch-prepare.sh boatman ferry-bytes-223 endojs/endo-but-for-bots feat/endo-bytes-upstream` (path may have moved to `skills/dispatch-worktree/` per recent restructure; will adjust if so).
