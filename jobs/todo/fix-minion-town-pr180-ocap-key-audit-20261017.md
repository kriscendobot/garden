---
role: fixer
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
# kriscendobot/minion.town PR #180: audit the control-plane keys against the ocap test, record the §7 ruling, regroup the commits

Context: the convergence investigation (journal tada `investigate-minion-town-pr180-convergence-20261017`, inbox message 20261017T063344Z-21dfcc) found the panel converged (round 17 pass) but the churn sits in the loopback HTTP control plane's key layer, which the decomplector seat read as contradicting §7 of the parent design (PR #41: write authority is a capability object, "not a bearer token"). **Maintainer ruling (kriskowal, 2026-10-17): bearer tokens are coherent with object capabilities. The test is whether the token refers to an identity or to a specific object that represents the designated authority.** Identity-shaped tokens (ambient or master authority) violate §7; tokens designating one specific object, attenuated to it, do not.

PR: https://github.com/kriscendobot/minion.town/pull/180 (draft; un-drafting waits on the #178 gauntlet, https://github.com/kriscendobot/minion.town/pull/178).

Do:
1. **Audit** every key/secret in the control plane and every place a guest or caplet can obtain one. Classify each as object-designating (attenuated to one partition or capability) or identity-shaped (master, ambient, or granting more than the one object). Include rotation, the `/hello` check, open-by-id, and the mint-cap paths. Fix any identity-shaped one found, or stop and report it if the fix is a redesign. No new rounds of hardening beyond that.
2. **Record the ruling** in the parent design's §7 (a PR to the design in the minion.town repo, or an edit on #180 if that is where §7 lives), stating the identity-vs-object test and how #180's keys meet it.
3. **Regroup** #180's 28 commits into a reviewable sequence (retcon discipline; net diff invariant), force-push the head, and leave it DRAFT; do not un-draft ahead of #178.
Report the audit table to the maintainer inbox.

<!-- garden-reaped: 0 -->
