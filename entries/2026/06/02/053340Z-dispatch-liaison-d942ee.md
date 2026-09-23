---
ts: 2026-06-02T05:33:40Z
kind: dispatch
role: liaison
repo: endojs/endo
project: endo
refs: []
---

Dispatched boatman (dispatch-root `dispatches/boatman--d942ee`) for a **first-time, multi-author** ferry of endojs/endo-but-for-bots#387 to endojs/endo.

Source: endojs/endo-but-for-bots#387, branch `fix-benchmark-wget-engines-master`, head `dceb649b3`, 3 commits, frozen base `master-814dfa1`, DRAFT. "fix(benchmark): install xs/v8 via direct download instead of esvu", Refs #3289. This is the esvu-**replacement** approach (direct curl download); supersedes the earlier esvu-**retry** approach that was ferried to endo#3291 and is now **CLOSED**. So this is a first-time ferry opening a NEW upstream PR, not a re-ferry.

Per-commit attribution (maintainer-verified this session via GitHub-profile lookup):
- `0784dc3eb fix(benchmark): install xs/v8 via direct download, drop esvu` — substantive work by external contributor 0xPatrick (principal `0xpatrickdev`; the source carries his **bot** identity `0xPatrick's Bot <patchrick@0xpatrick.dev>`). **Preserve his credit**: author `0xPatrick <patrick@0xpatrick.dev>` (the personal identity he authored the equivalent commit cda0782e9 / endo-but-for-bots#386 under), committer `Kris Kowal <kriskowal@kriskowal.com>`. The maintainer verified this author line explicitly.
- `6884ae242 chore: Update yarn.lock` and `dceb649b3 chore(benchmark): rename .bench-engines cache to .engines` — endolinbot chores; normalize author+committer to `Kris Kowal <kriskowal@kriskowal.com>`.

This is the multi-author salvage pattern from `skills/pr-handoff/SKILL.md` § Multi-author case: do NOT `--reset-author` the 0xPatrick commit; preserve its author, take Kris Kowal as committer. Asymmetry (author preserved, committer kriskowal) is intentional and correct.

Upstream: endojs/endo, base `master` (live tip `c49fb048b`). Issue #3289 is OPEN; preserve a `Refs #3289` (the fix is one of several; not necessarily `Fixes`). Open the upstream PR DRAFT (source is draft). `identity_switch_authorized: true`. No prior Mirror cross-link on #387; boatman creates garden-side and hands upstream-side to steward.

Expected report: new upstream PR URL + number, branch + head SHA, per-commit attribution verification (0xPatrick author preserved on the substantive commit, kriskowal committer; chores fully kriskowal; trailers empty), CI status, garden-side cross-link comment ID.
