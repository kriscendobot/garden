**PR #360 has been overtaken. The gauntlet should not start.**

Deciding question: Is PR #360's design still needed now that the final `designs/familiar-release.md` is on `llm`, and does that merged design leave room for the packaging lanes and pre-release E2E workflow this PR proposes?

Answer: no on both counts.

Evidence:
- **PR facts:** It is open, not a draft and mergeable. Base is the frozen `llm-b1c3f4d`, head is `83e2a8031`. It changes three files under `designs/` (`README.md` plus two new design docs). It was opened 2026-05-22 and its head has not moved since.
- **The parent design changed after this PR was written.** PR #231 merged into `llm` on 2026-08-31, after six panel rounds. The final `familiar-release.md` records the maintainer's 2026-05-19 decisions, and they contradict this PR's main choices:
  - **Windows (G3):** out of scope for the first release. #360 designs a Windows `.exe` lane built with the NSIS installer and signed with an EV certificate.
  - **macOS signing and notarization (G2):** deferred for the first release. #360 signs and notarizes every lane.
  - **Linux (G4):** ships the existing `.zip`, with Flatpak chosen for followups and other formats deferred. #360 adds `.deb` and `.rpm`.
  - **Platform list (Open question 4):** macOS arm64, macOS x64 and Linux x64 only.
- **The parent now covers the E2E plan itself.** Its section "Verifying the assumed-working chain in CI (macOS)" lays out three verification tiers, a Playwright Electron runner, a mock LLM gateway, platform coverage, and how Tier 2 rides the release workflow plus a nightly schedule. That replaces #360's `familiar-pre-release-e2e.md` and its separate `familiar-pre-release.yml` workflow.
- **Neither of #360's design files exists on `llm`.** Nothing else built on them, so closing the PR orphans nothing.
- **The last panel blocked it.** The 2026-09-27 gauntlet panel review (a request-changes verdict) found `familiar-release.md` missing from this PR's frozen base, so its links and G-item citations break. Rebasing would fix the links but not the conflicting scope.
- **Related PRs:** #231 and #316 merged, issue #229 is closed, #318 and #322 are still open. Nothing that is still alive depends on #360.

Option: close as superseded

If the signing, Windows and deb/rpm lanes are wanted later, they should be new designs written once the maintainer reopens those deferred items. Regenerating this PR against the current parent would not get there.

Nothing was changed: no commits, pushes or PR edits.

<!-- gauntlet-stage-result: viability=overtaken -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr360-gauntlet-20261007-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (298678 cached reads)
- Output: 2916 tokens
- Cost: $0.5282716
- Wall-clock: 46s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
