The background CI wait is stopped (killed, rc 143). Everything is confirmed. Writing the completion report.

---

## Completion report — endojs/endo-but-for-bots#322 gauntlet FIX round 1

**What I did:** Applied the panel round-1 (request-changes) must-fix and should-fix items to the design PR (docs-only: `designs/familiar-flatpak-pipeline.md` + `designs/README.md`), committed, and pushed as a follow-up commit to the PR head `feat/familiar-flatpak-pipeline` (now at `1fc3996ab`) via `safe-push-pr-head.sh` (advance mode, clean fast-forward over `efe14f625`).

**Changes applied (per seat):**
- **critic / skeptic (must-fix — captp socket):** `@endo/where`'s `whereEndoSock` resolves under `$XDG_RUNTIME_DIR/endo`, not `$XDG_STATE_HOME`. Added `--filesystem=xdg-run/endo:create` to the manifest JSON and the finish-args table (with the "Flatpak auto-binds only `xdg-run/app/<app-id>`" rationale); corrected the Testing smoke-pass claim; updated Open Question 2 and the Known Gaps TODO to reflect the now-covered runtime root.
- **ergonomist (must-fix — wiring contradiction):** reconciled the Build Script prose with the diagram + CI yaml (standalone step, not wired into `make-distributables.mjs`).
- **ergonomist (should-fix — naming):** renamed `flatpak-build.mjs`/`step:flatpak` → `build-flatpak.mjs`/`step:build-flatpak` (verb-first sibling convention) throughout.
- **pedant / copyeditor (must-fix — mermaid):** `&rarr;` → ASCII `->`.
- **copyeditor / novice (must-fix — "signed"):** reworded Problem + Pipeline-Shape framing to "unsigned, integrity-checkable" with a forward pointer to § Signing Posture.
- **copyeditor / novice (should-fix):** expanded MVR → "Minimum Viable Release" and glossed the `G<N>` citation codes on first use.
- **decomplector (should-fix):** added an intentional-no-`continue-on-error` marker comment at the CI step + reworded the "absence" framing; split the speculative `pulseaudio`/`Notifications`/`secrets` grants out of the manifest into their feature followups.
- **skeptic (should-fix):** added the replacement-is-easier argument (GUI install, `flatpak` prerequisite named as a failure mode); removed the "maintainer's implicit assumption" attribution of the BaseApp choice.
- **pedant (should-fix):** parallel construction in the Release-Blocking Policy bullets; table header `Permission | Rationale`.
- **notes:** Phase-2 deliverable now lists the README end-user-install update; CI yaml gained the validation + sandbox-assertion steps the policy references; refreshed the `designs/README.md` totals justification (11→12 files).

I reverted a stray `packages/hex-test/package.json` change (a side effect of the failed dependency install) so only the two intended files ship.

**CI outcome — blocked, not green:** The pushed head is `mergeable=CONFLICTING`/`DIRTY` against base `llm`. The conflict is in `designs/README.md` and is **pre-existing base drift** — the prior head `efe14f625` (before my fix) already conflicts, because `llm`'s `designs/README.md` moved on over the ~3 months since this PR was opened (2026-05-20). GitHub does not run `pull_request` CI on an unmergeable PR, so **zero** `test`/`lint` checks attach to my push and none will (verified: no workflow runs for `1fc3996ab`). This is deterministically equivalent to the `ci-wait-merge` rc 4 (empty rollup) outcome, so I stopped the bounded wait rather than burn the full hour to reach the same conclusion.

**Follow-up (surfaced to the liaison/maintainer via message-user):** the gauntlet cannot reach green from another fix round — it needs a **weave endojs/endo-but-for-bots#322** (rebase the head onto current `llm`, resolve the `designs/README.md` index conflict) before CI can attach. The must-fix items are already applied, so re-posting the fix stage alone would loop.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr322-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 150 tokens (7424777 cached reads)
- Output: 45703 tokens
- Cost: $6.336820499999998
- Wall-clock: 1289s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
