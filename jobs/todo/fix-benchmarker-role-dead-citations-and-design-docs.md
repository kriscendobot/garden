---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
## Grounding
Self-improvement finding raised across rounds 2, 3, and 4 of the
`kriscendobot/minion.town#52` panel, reported to `role/liaison` on
2026-08-24 by the benchmarker seat and left unrouted until now. Two
confirmed defects in `roles/jurors/benchmarker/AGENT.md`:

### 1. Three dead citation paths
§ Skills links `skills/benchmark-comparative-report/SKILL.md`, and
§ Operating norms' "Cite the rule" names both that same path and
`roles/scout/AGENT.md` § When dispatched as the standing rules every
benchmarker finding must cite. Confirmed absent from `skills/`, `roles/`,
and `references/` — both exist only under `v1/skills/benchmark-comparative-report/`
and `v1/roles/scout/`, the retired v1 library (not auto-loaded, not meant
to be cited by a live v2 role). The seat currently has no citable standing
rule, so every finding falls back to `[proposed-rule: ...]` — which defeats
the cite-or-propose discipline for this seat specifically: a finding that
*should* enforce an existing rule reads as novel instead.

**Resolve one of two ways** (use judgment on which; the finding does not
mandate a choice):
- Port `v1/skills/benchmark-comparative-report/SKILL.md` and
  `v1/roles/scout/AGENT.md` forward into the live `skills/`/`roles/` tree
  (translated per the v1→v2 migration norms in the root CLAUDE.md, not a
  blind copy — check whether `scout` as a role still makes sense standalone
  in v2's gardener-fleet model, or whether its executor function now lives
  elsewhere).
- Or rewrite § Cite the rule (and the § Skills link) against a rule that
  actually exists in the live library today, if porting scout/the report
  skill forward is not warranted.

### 2. § Operating norms omits design documents from the primary surface
"Primary surface" enumerates review threads, the PR body, and commit
messages — not design documents touched by the diff. On
`kriscendobot/minion.town#52`, the strongest optimization claim (declining
the § 3.2 directory watch as "redundant" on an unmeasured, misattributed
cost premise) lived in `designs/weblet-ocap-synthesis.md`, landed in the
diff, where an unverified rationale now outlives the PR that introduced it.

Add "design documents added or modified by the diff" to the § Operating
norms primary-surface bullet.

### 3. Smaller, same file
The disposition ladder assumes a populated discussion surface. On a fresh
PR with zero review threads, the only surfaces are the PR body, the commit
messages, and (per item 2) the diff's design docs. Say so explicitly in the
role file so each dispatched seat doesn't have to re-infer it.

## Ask
Edit `roles/jurors/benchmarker/AGENT.md` to resolve all three items above.
Small, self-contained role-file fix; no code changes expected unless you
choose the "port scout + benchmark-comparative-report forward" branch of
item 1, in which case scope the port itself narrowly (translate, don't
blind-copy, per the root CLAUDE.md v1→v2 migration norms).
