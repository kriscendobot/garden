All three deliverables are confirmed complete and the audit report is delivered to the maintainer inbox. The job is done.

---

## Completion report

**Job:** `fix-minion-town-pr180-ocap-key-audit-20261017` — audit PR #180's control-plane keys against the §7 ocap ruling, record the ruling, regroup the commits.

### What I found / did

A prior claimant of this job had already landed two of the three deliverables; I independently verified the audit against the actual code, confirmed the prior work is correct, and delivered the audit report.

**1. Audit (the core verification) — done; no code fix required.**
I read the full control plane (`control-keys.ts`, `control.ts`, `git-caplet.ts`, `guest-control.ts`, `guest-tools.ts`, `root-host-socket.ts`) and classified every secret against the maintainer's identity-vs-object test. Verdict: **no identity-shaped secret is reachable by a guest or caplet.**
- Guest-reachable secrets are all object-designating: the minted capability-URL (one partition at one attenuation); the retention key even *stays inside the guest's `open` formula and is never returned to the agent*.
- Identity-shaped / broad secrets stay host-side: the **root secret** lives only in the two server processes; **facet keys** are closed over by each partition exo; the **owner credential** is derived host-side and injected as caplet-formula env, never reachable by the guest; the **/hello proof** authorizes nothing.
- **One flagged case:** the owner credential (`HMAC(root,"git-control-owner\0"+owner)`) is the closest call — object-designating as classified (authorizes only `create` on one owner's quota-bounded allocator, reaches no existing partition), but readable as identity-shaped since the route is parameterized by an owner header. It is *not* guest-reachable either way, so there is no live leak; fixing it *if* read as identity-shaped is a redesign (per-caplet keying / allocator object), so I **reported rather than rewrote**, per the job's "stop and report if the fix is a redesign."

**2. §7 ruling recorded** — PR #203 (`design/git-remote-s7-bearer-identity-test`, draft, base `main-945aaaa`) adds the identity-vs-object test to `designs/git-remote-capability.md` §7 plus the classification table, and qualifies the two "not a bearer token" lines to "not an identity-shaped bearer token." Content verified correct against my independent audit.

**3. #180 regrouped** — head `design/git-remote-endo-binding` is a clean 7-commit reviewable sequence (caps → loopback control plane → caplet → lock → endo binding → deploy secret → docs), all commits share one authored timestamp (retcon signature), net-diff invariant, MERGEABLE, left **DRAFT** (un-drafting still waits on the #178 gauntlet, as required).

**4. Audit table reported to the maintainer inbox** via `message-user.sh` (coalescing entry `msg-...-eb1200049286`).

### Changes
- No garden `main2` changes (this job mutates the minion.town project repo and its design doc, carried by PR #203; nothing belongs on `main2`).
- No new code commits needed on #180 — audit confirmed the implementation already meets §7.

### Follow-ups for the maintainer
- Confirm the **owner-credential classification** (object-designating vs identity-shaped). If identity-shaped, the §12 redesign (per-caplet keying / first-class allocator capability) becomes a follow-on job. PR #203 already flags this as provisional pending your answer.
- #180 remains draft pending the #178 gauntlet; PR #203 (the design ruling) is a draft answer-surface awaiting your confirmation.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-minion-town-pr180-ocap-key-audit-20261017.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 176 tokens (7893398 cached reads)
- Output: 57680 tokens
- Cost: $6.666143
- Wall-clock: 1526s
- Model(s): claude-opus-5-5 ×1, claude-opus-4-8 ×2

<!-- garden-usage-end -->
