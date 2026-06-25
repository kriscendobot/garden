Inbox is empty and the scratch worktree is torn down. Work is complete.

---

## Completion report

**Job:** attention directive on endojs/endo-but-for-bots PR #231 (kriskowal: "Please propose a plan to verify this in CI, specifically on the Mac CI environment").

**Routed to:** a design-doc amendment + PR reply. The comment anchors at the design's "What works today (assumed)" list (line 116 of `designs/familiar-release.md`), so "this" is the seven unverified runtime assumptions. The natural home for the requested plan is the design itself.

**What I did:**
- Grounded the plan in the repo's real CI: the existing `familiar-release.yml` already builds + makes distributables on `macos-14` (arm64) and `macos-13` (x64), but only on `workflow_dispatch`/`familiar-v*` tags, and it never launches the artifact. So the build half on macOS exists; the runtime half is the gap.
- Pulled in the prior macOS-CI investigation (`journal/projects/endo-but-for-bots/macos-ci-flake-260.md` → public issue #260): the dominant macOS-runner failure is the corepack `repo.yarnpkg.com` DNS flake, not a test flake. Made vendoring yarn (`yarnPath`) a blocking precondition of the smoke.
- Added a **"Verifying the assumed-working chain in CI (macOS)"** section to `designs/familiar-release.md`: a three-tier plan (Tier 0 build smoke, Tier 1 headless daemon smoke driving the form path over CapTP with an in-process mock LLM gateway, Tier 2 Playwright Electron GUI launch smoke), a per-assumption assertion table, and the macOS-runner hazards (yarn DNS flake, embedded-Node arch match, Gatekeeper avoidance, flake budget). Cross-linked it from G16; bumped the metadata `Updated` and synced the `designs/README.md` row.

**Changed / pushed:** commit `cb16ebfd6` to branch `design/familiar-release` (`designs/familiar-release.md`, `designs/README.md`), as kriscendobot.

**Posted (standing authorization on this repo):**
- Inline reply on the review thread: PR #231 discussion_r3477167674.
- Top-level summary comment: PR #231 issuecomment-4803517629.

**Follow-ups for the maintainer / downstream:** the plan is specified, not implemented (this is a design PR). When approved, a builder pass implements Tier 0 + Tier 1 as the per-PR macOS gate (resolving G16), with the yarn-vendoring precondition landing first; Tier 2 and the cross-platform launch matrix are routed to followups.

Self-improvement: nothing this time.
