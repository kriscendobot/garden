This PR clearly meets the directive's "do not wedge" escape conditions. I'm invoking that path rather than attempting the rebase.

**Assessment summary:**
- **PR #303** is OPEN, targets `master` (never had a frozen base — zero `base_ref_changed` events), authored by kriscendobot, title *"chore(workspace): break devDependency cycles via synthetic test packages (mirror of llm Cuts 1-5, refs #206)"* — self-declared **mirror** of `llm` branch work.
- **Long-idle:** last head commit and last activity both **2026-05-20**, ~8 weeks stale as of today (2026-07-17).
- **Severely drifted + conflicting:** GitHub reports `mergeable: CONFLICTING`; the head is **6 ahead / 226 behind** the current `endo-but-for-bots` master.

Rebasing 6 mirror commits across 226 commits of drift, with GitHub already reporting a conflict, is unambiguously "a conflict beyond a focused weave." Both escape conditions in the directive (long-idle **and** stale mirror; conflict beyond a focused weave) are satisfied, so I did **not** rebase, force-push, edit the PR base, or touch the fork master.

---

**Completion report**

Job: `ebfb-retire-master-pr-303` (weaver) — retire the `master` base for endojs/endo-but-for-bots#303 under the 2026-07-16 directive.

What I did:
- Confirmed PR #303 remains **open** and targets **`master`** directly (no prior frozen base).
- Gathered state: author kriscendobot, `mergeable: CONFLICTING`, head `feat/break-devdep-cycles-master`, last activity 2026-05-20.
- Measured divergence: **6 ahead / 226 behind** master (`status: diverged`); title marks it a **mirror of llm Cuts 1-5** (refs #206).
- Recorded reference tips for the maintainer: `endo-but-for-bots` master = `fcbb540ed` (2026-07-15); upstream `endojs/endo` master = `46d4edf31` (2026-07-17).

What changed: **nothing.** No rebase, no force-push, no base edit, no fork-master mutation, no git commits. Sweep deliberately not wedged.

Why (condition for maintainer follow-up): PR #303 is a **long-idle stale mirror** (~8 weeks untouched, self-described mirror of the `llm` branch) and is **CONFLICTING at 226 commits of drift** — well beyond a focused weave. Per the directive, this is recorded rather than force-driven.

Suggested maintainer follow-ups (pick one):
1. **Close/abandon** — the llm-branch work it mirrors has almost certainly landed; verify Cuts 1–5 are present on `llm`/`master` and close #303 as superseded.
2. **Re-drive as a fresh mirror** — if the content is still wanted on `master`, re-cut it from the current `llm` state rather than salvaging this 226-behind branch.
3. If a retire-master reflection is still desired here despite the drift, authorize a **fixer/weave with full conflict-resolution scope** (not a focused weave); the base SHA should come from upstream `endojs/endo` master (`46d4edf31`) per the directive.

Follow-ups for me: none — job complete under the escape clause.
