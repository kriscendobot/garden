---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr1125-23cf90c0
verdict: miss
category: security-hardening
pr: 1125
cluster: capability-hardening-attenuation
cluster_pattern: An exported client/exo capability reaches review unhardened (no interface guards, runtime-flag attenuation, ambient authority) and the locksmith/warden seats do not flag it.
review_at: 2026-09-17T18:34:02Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1125#discussion_r4040218737
identity: endojs/endo-but-for-bots#1125:comment:4040218737:retro
producing_role: builder
producing_job: unknown (commit 42bad92360 "refactor(daemon): express read-only directory as eval", 2026-09-17T08:17Z)
missed_by: locksmith, warden (code panel); no full panel ran on 42bad92360
severity: minor
grounds: |
  Paraphrase: on packages/daemon/src/directory.js the maintainer asked for a
  brief gauntlet to check whether review would have flagged the bare Far used
  for the guest-facing read-only hub (readOnlyDirectorySource) and recommended
  makeExo with an explicit interface guard.
  This is a miss, not new direction. The locksmith brief already required
  flagging an exported capability that lacks interface guards; that line came
  from this cluster's improvement (main2 37b04ec909, 2026-08-04). It did not
  bind. The primary ran the brief gauntlet blind over the real diff
  (locksmith, warden, engine-realist, purist) and got 0/4: the warden called
  the Far "properly hardened", and the locksmith read past it. Also, the Far
  arrived in 42bad92360 on 2026-09-17, after the last #1125 gauntlet panels
  (2026-09-12/13), so no panel reviewed that commit before the maintainer did.
  Checked in the world: seat-level sensing landed at main2 c7aa363e09
  (locksmith and warden briefs now name the Far to makeExo+guard shape,
  including Far inside eval/worker source strings). Pre-push prevention landed
  on 2026-09-24: prefer-endo-primitives fails any added bare Far(. The PR code
  was fixed at 9fad002ba8 (job pr1125-fix-readonly-hub-makeexo-guard). The
  primary's thread reply r4040314005 exists. PR #1125 is now closed.
