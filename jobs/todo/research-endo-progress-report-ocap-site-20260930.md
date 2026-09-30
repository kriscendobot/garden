---
role: researcher
requires: host=endolin-garden2-5bcdff64
handler-timeout: 7200
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Roll up an Endo progress report and publish it as an HTML ocap.site clip

Analogous to `research-quarterly-completions-report-ocap-site-20260929`
(published at
https://fbx2igid4iixr7kt2lzo7nx3qlynzsjqbwqmqircue4a3h5axwma.ocap.site/), but
that report was about the garden's own operational throughput (job
completions). **This one is about Endo itself** — the product the garden
fleet exists to advance ("the machine the machine was built to build"). Do
not just re-slice the same completions data; this needs real synthesis of
what actually shipped in the product, not a job-count rollup.

## Scope

Primary subject: `endojs/endo-but-for-bots` (`llm` for designs, `master` for
implementations — see `journal/projects/endo-but-for-bots/README.md` § Rules
of engagement for the branch model). Cover the same window as the prior
report for comparability: 2026-06-24 through today. Where directly relevant,
note downstream/embedded impact — the IronHorse Rust VM port lives inside
this same repo (`rust/engine/ironhorse-262/`) and counts as in-scope; treat
`kriscendobot/minion.town` as Endo's flagship deployment/consumer and mention
it only where it demonstrates an Endo capability landing in the real world
(the EndoGuest invite/accept pairing, the git-remote capability), not as its
own subject.

## Sources to synthesize, not just enumerate

1. **The roadmap itself:** `designs/README.md` on `origin/llm` — the live,
   actively-groomed milestone table (M1 through M11) and its per-design
   "Recently added or revised" narrative. Read the milestone table for
   current status (as of this writing: M1/M2 Complete, M3 first-incomplete)
   and describe what moved during the report window, not just the current
   snapshot.
2. **What actually shipped vs. what was only proposed.** Walk merged PRs on
   both `master` (implementations) and `llm` (designs) over the window. A
   design PR proposes; only a merged implementation PR ships a capability —
   keep that distinction sharp in the writing. Group shipped capabilities
   thematically (e.g., daemon/CapTP networking, guest/agent capabilities,
   package registry & tooling, IronHorse/Rust VM engine progress) rather
   than as a flat chronological PR list.
3. **`journal/projects/endo-but-for-bots/` and `journal/projects/endo/`** for
   narrative context and arcs the garden's own journal has already tracked
   (the OCapN-over-Noise transport work, the npm-via-CAS registry proxy, the
   EndoGuest invite/accept + registry-migration saga, the git-remote
   capability, IronHorse test262 ratchet progress) — cite these as grounding
   for the narrative, cross-checked against actual merged commits, not taken
   on faith.
4. `jobs/tada/` completions naming this repo are supporting evidence for
   what happened and when, not the primary source — this report is about
   product capability, not garden throughput.

## Render and publish

Same shape as the prior report: a single self-contained HTML page (inline
CSS, no external assets — the clip's CSP is same-origin only, see
`skills/minion-town-clip-publishing/SKILL.md`), leading with a short
narrative summary of where Endo stands and what moved this window, then the
milestone-status table, then the thematically-grouped shipped-capability
sections, then a "notable" callouts section for the few most significant
items. Publish via `mcp__minion-town__publish` as a clip (`skills/minion-town-clip-publishing/SKILL.md`)
and report the resulting `<hash>.ocap.site` URL plainly in your completion
report and via `scripts/jobs/message-user.sh <this-job-base>` to the
maintainer inbox.
