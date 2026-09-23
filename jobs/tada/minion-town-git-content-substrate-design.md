Inbox is clear. The design is delivered as a draft PR on the correct base.

## Completion report — `minion-town-git-content-substrate-design`

**What I did.** Wrote `designs/git-content-substrate.md` in `kriscendobot/minion.town` and opened it as **draft PR [kriscendobot/minion.town#39](https://github.com/kriscendobot/minion.town/pull/39)** against `main`, following the repo's own design-doc conventions (`# Design:` title, bold Status/Mandate/Grounded-against/Companions header block, numbered sections, a validated mermaid diagram) and the project's rule of engagement that designs land as reviewed PRs, not direct commits.

**Grounding (reconciled against the live, landed stack, not the job's stale premises).** Two of the job's "open questions to check before assuming a clean path" turned out to be **already resolved**, and I built on that rather than around it:
- The **namespace/TLS-collision blocker** the prior increment hit is gone: weblets now serve at `<hash>.ocap.site` on a **dedicated registrable domain** with a **DNS-01 wildcard certificate** (`designs/ocap-site-weblet-isolation.md`; increments 1–4 all merged, PR #25/#26/#27). `*.weblet.minion.town` is read-only compat.
- Because the DNS-01 wildcard covers every `*.ocap.site` name at zero per-host cost, a **stable, mutable-content named origin** — exactly what a git-tracked weblet needs — is now cheap, which is the architectural hinge of the design.

**The design.** A git commit's tree projects one-for-one onto the existing CAS manifest, so the content plane is reused **unchanged**; the new machinery is only (a) a git→CAS projector, (b) a separate on-box syncer that re-points a **source-named mutable vhost record** when the branch advances, and (c) a one-branch cache-policy discriminant (`revalidate` instead of `immutable`) for mutable origins. It formally answers `weblet-gateway.md`'s Open Question 1 ("does a weblet have a name distinct from its value?") *yes, for the git-source-named kind*.

**Every framing question answered in-doc:** sync = polling from an isolated `weblet-git-sync` service, no webhook in v1 (§ 4); a **hard content-vs-code boundary** with explicit non-authorization of server-side execution, drawn against the garden's monitoring-safety-constraint (§ 6); public-repos-only with the registry as the recorded trust decision, private = no (§ 7); coexist-not-replace vs the deploy pipeline (§ 8); rides the resolved `*.ocap.site` edge unchanged, powers fail-closed (§ 9). Plus a build decomposition (§ 10) and five open questions (§ 11).

**What changed.** One new file (`designs/git-content-substrate.md`), committed under the bot identity on `design/git-content-substrate`, "spec only, no live change" in the subject. Mermaid validated (renders clean). Draft PR #39. No production change.

**Follow-ups.** The Companion `minion-town-vitals-weblet-design` (next in the orchestration) is the first consumer — it should register `journal2` as a source and provide the branch-side renderer; I cited it as forthcoming since it isn't posted yet. Natural next step after review un-drafts #39: a follow-on orchestration parking the G1–G3 build increments (§ 10, halt-on-failure).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-git-content-substrate-design.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 35 tokens (2089180 cached reads)
- Output: 37772 tokens
- Cost: $3.4412730000000002
- Wall-clock: 583s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
