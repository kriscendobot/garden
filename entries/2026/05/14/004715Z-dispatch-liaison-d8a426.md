---
ts: 2026-05-14T00:47:15Z
kind: dispatch
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/14/004700Z-dispatch-liaison-c5d710.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 228
    role: source
  - repo: endojs/endo
    pr: null
    role: target
---

Dispatching the boatman to replicate `endojs/endo-but-for-bots#228` (uniform `SECURITY.md` + CI check) on `endojs/endo`. Concurrent with the #223 and #75 dispatches above.

**Source**: `endojs/endo-but-for-bots#228`, branch `chore/security-md-uniformity`, head `5dc745be20f9f26dabb34e370595f13ae351fb33`. State **MERGED** (already merged into the bot's `llm` base branch). Diff +557/-8 across 19 files.

**Important**: this PR has `state: MERGED` on the bot side — the changes are part of `llm` history now. The boatman extracts the diff from history, NOT from an open-PR snapshot. The `git diff <merge-base of llm and chore/security-md-uniformity>..chore/security-md-uniformity` approach still works on a merged source.

**Source title**: `ci: enforce uniform SECURITY.md across packages` — already framed for an upstream audience. Keep as-is.

**Source body framing notes**:
- `Refs: #75` is a fork-only ref (the bot-side #75, separately being ferried in the concurrent dispatch above). Drop it; do not translate. The upstream PR stands on its own.
- The "Surfaced from PR #75 review feedback:" quoted block is bot-internal context. Rewrite as plain prose ("Surfaced from prior review feedback") without the PR # reference, or drop entirely.
- The "Newly-added (previously missing)" list enumerates bot-side packages: `chat-network-view`, `conversation-tree`, `demo`, `fae`, `familiar`, `genie`, `inventory-graph`, `jaine`, `markmdown`, `platform`, `relay-server`, `sandbox`, `whylip`. **None of these packages exist on `endojs/endo`.** They are bot-fork additions. Drop the entire "Newly-added" list from the upstream body and from the diff itself; the upstream PR should align SECURITY.md only across packages that exist on `endojs/endo`.
- The "Divergent packages reconciled: `bytes`, `hex`, `panic`, `immutable-arraybuffer`" list also needs filtering. `bytes` does not yet exist upstream (it is the subject of the concurrent #223 dispatch). Filter to packages present on `endojs/endo:master` at handoff time.

**Substantive editorial work for the boatman**: the diff likely needs filtering. After computing `git diff <merge-base>..chore/security-md-uniformity`, the boatman should:
1. List touched paths.
2. For each `packages/<name>/SECURITY.md` path, check whether `packages/<name>/` exists on `upstream/master`. Drop the file from the diff if not.
3. Apply the filtered diff onto a fresh branch off `upstream/master`.
4. Verify the final stat: should be the canonical SECURITY.md added to packages that exist upstream + missing it, plus `scripts/check-security-md.sh`, plus the CI workflow change.
5. Rewrite the body's reconciled/newly-added lists to reflect what actually applies upstream (or drop them entirely; the high-level rationale and the script-and-CI explanation suffice).

**Mirroring note**: same shape as #75. Garden source mirrors a feature already in the bot's tree; upstream PR is the human-authored landing.

**Upstream**: `endojs/endo`, target branch `master`.

**Human**: `Kris Kowal <kris@cixar.com>`.

**identity_switch_authorized: true** — explicitly authorized by the user in this dispatch.

**Expected report**: upstream PR URL, head SHA, attribution-verified, source PR forward-link comment, journal `result` entry, list of bot-only packages dropped from the diff, `Self-improvement: ...`. If the package-existence filtering produces something unrecognizable from the source PR's intent (e.g., the diff comes out empty after filtering), `message`-to-liaison and stop.

Per-dispatch worktree triple to be created via `skills/dispatch-worktree/dispatch-prepare.sh boatman replicate-security-md-228 endojs/endo-but-for-bots chore/security-md-uniformity`.
