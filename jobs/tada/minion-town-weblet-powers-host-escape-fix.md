CI is green. The job is complete.

## Completion report

**Job:** `minion-town-weblet-powers-host-escape-fix` — security fix for the confirmed privilege escalation traced by peer job `ebfb-guest-unconfined-from-tree`.

**Root cause (confirmed at deployed main `37252bc`):** the weblet powers plane (`src/endo/gateway/powers-plane.ts`) resolved a caller-supplied `powers` reference against the gateway's **own daemon top Host** (`E(daemonHost).lookup(powers)`) and presented the result as the public, unauthenticated `*.ocap.site` CapTP bootstrap. A name resolving to a Host (`@self`, `@host`, or a host-shaped formula id) therefore handed host authority — arbitrary code execution on the daemon's host — to any visitor. The daemon Guest facet is correct; the escape was entirely gateway-side.

**Fix (two layers, at the trust seam rather than a `@self` blocklist):**
- **Publish (fail-fast):** `assertValidPowers` (`publish.ts`) now rejects any `@`-prefixed powers reference — the whole class of daemon agent special names — before the charge or any interning.
- **Serve (load-bearing):** `assertNotHostShaped` in `powers-plane.ts` probes the resolved object's `__getMethodNames__` surface and refuses a host-shaped one (policy-close `4012`), failing closed on an unverifiable surface. Because every serve re-resolves and re-checks, this **neutralizes already-stored hostile/stale records without a data migration**, and catches host-shaped formula ids that no syntactic check can.

I evaluated the preferred "resolve in the guest's scope" approach and documented (in the PR) why it is insufficient alone — a guest can still name `@host` and reach objects by formula id — so the resolved-surface guard is the necessary containment.

**Tests added:** guest cannot publish host-reaching powers (`@self` + others, interns nothing); gateway refuses to serve a host-shaped bootstrap from a pre-existing record (powers id not `@`-prefixed, so only the serve guard catches it); positive controls for legitimate publish and serve. Full suite **227 passed**, typecheck clean.

**Delivered:** PR **kriscendobot/minion.town#44** (branch `security/weblet-powers-host-escape`), CI **green** (typecheck + vitest). Repo is private; commit/PR describe the class of defect without a step-by-step exploit recipe. Sent a pointer to the peer investigation job's inbox.

**Not done (deliberately):** no production change and no deploy — containment and deploy are the maintainer's calls, per the job spec.

**Follow-ups (in PR, not performed):** optional store-hygiene sweep to drop/quarantine pre-existing host-shaped records (not required — the serve guard already refuses them); optional tightening to an explicit allowlist of guest-scoped powers forms.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-weblet-powers-host-escape-fix.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 125 tokens (7629796 cached reads)
- Output: 49371 tokens
- Cost: $6.5521530000000014
- Wall-clock: 886s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
