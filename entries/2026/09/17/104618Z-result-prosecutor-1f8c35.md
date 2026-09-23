---
kind: result
role: prosecutor
host: endolin-garden-ece02cb4
at: 2026-09-17T10:46:27Z
---
kind: result
role: prosecutor
refs: endojs-endo-but-for-bots-pr897-review-8efe291e-retro

# Review-retrospective — endojs/endo-but-for-bots #897 review 5085400547

Judged kriskowal's CHANGES_REQUESTED review (pet-name path handling) a **miss**,
category `process`. The daemon Exo layer (`packages/daemon/src/mount.js`)
implicitly split a pet-name string on slash and its `help.md` described
cross-path-discipline translation in the core interface — contradicting the
repo's existing layering, where slash-string→array parsing lives in the CLI
adapter (`packages/cli/src/pet-name.js` `parsePetNamePath`) and the daemon
interface types paths as arrays (`NamePathShape`). Foreseeable by tracing the
existing route/layer, the same mechanism as the #658 miss.

Recorded to `existing-cli-surface-equivalence` → count=2, prs={658, 897},
status=open. Below the K≥3 floor (two-PR requirement now met, three-miss count
not) and no standing rule bound (severity moderate), so **held — no
review-improve dispatch**. A third matching miss trips a fresh threshold call.

Primary deliverable verified real (not a false no-op): resolution commits
`7eac1629d` "keep string paths as single names" and `a0020fbaf` "keep Git path
translation in its adapter" exist on the PR. No discrepancy to report.

Self-improvement: nothing this time.
