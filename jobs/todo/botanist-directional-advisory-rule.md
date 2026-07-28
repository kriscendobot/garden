---
role: gardener
---
# Botanist role: make the advisory rule directional, and add the one-open-PR pitfall

Garden-infra job — an explicit authorization to land role changes that a gardener may
not land under its own discretion ([self-improvement](../../skills/self-improvement/SKILL.md)).
Target: `roles/botanist/AGENT.md` on `main2` (direct push, no PR).

Source proposal: journal `inbox/liaison/unread/20260728T073516Z-b2ee8f.md`, from the
botanist engagement on https://github.com/endojs/endo-but-for-bots/pull/556
(bump `actions/cache` 4.3.0 → 5.0.5).

## Only two of that proposal's five items remain — do not redo the other three

Verified against the current role file 2026-07-28T12:40Z:

| item | status |
| --- | --- |
| 1 — `github-actions` ecosystem leg | **LANDED** (line 35 pre-flight; line 54 substitute for steps 2–4) |
| 2 — verify the pinned SHA resolves to the claimed tag | **LANDED** (line 54b, with the `git/ref/tags` call) |
| 4 — enumerate call sites before assessing | **LANDED, in a stronger form** — became a base-ref pin census with three outcomes and a `REJECT-superseded` verdict |
| **3 — the absolute advisory rule** | **OPEN — the substance of this job** |
| **5 — one-open-PR-per-dependency suppression** | **OPEN — not present anywhere in the file** |

## Item 3 — make the step-5 advisory rule DIRECTIONAL (maintainer-approved)

Step 5 currently ends (line ~55):

> A single advisory on any moved transitive version is enough to block MERGE-NOW.

Read literally, that rule **blocks upgrades that reduce net exposure**, leaving the
repo strictly worse off. The precipitating evidence from #556: the incoming
`actions/cache` v5.0.5 set carries **two** open advisories (`undici` 6.24.1, CVSS 3.7
low; `fast-xml-parser` 5.5.6, CVSS 6.1 medium), while the **outgoing** v4 set carries
**four** (three `minimatch` ReDoS plus a `form-data` CRLF injection). The absolute rule
would have blocked a strict improvement.

**Replace it with the directional form** (maintainer-approved 2026-07-28): run the
advisory check on **both sides** of the bump; an advisory on an incoming version blocks
MERGE-NOW **unless** the outgoing set carries equal-or-worse exposure **and** the
residual advisories are argued unreachable on the consumed code path.

**Maintainer's caution, which must be encoded, not just noted:** the "argued
unreachable" clause is the soft spot — it is where a rushed botanist waves a real
advisory through. Require the argument to appear **in the rendered verdict itself**,
naming each residual advisory and why it is unreachable on the consumed path. An
assertion without that reasoning is not sufficient, and the fallback when the argument
cannot be made is the blocking behavior the old rule had. Keep the comparison
**concrete**: cite both sides' advisory sets with identifiers and severities, as the
#556 engagement did.

## Item 5 — add the one-open-PR-per-dependency pitfall

Dependabot keeps **at most one open PR per dependency**, so a stale open bump
**suppresses the proposal of a newer one**. This is a security consequence, not just
staleness housekeeping: on #556, `actions/cache` v6.1.0 (2026-06-26) bundles `undici`
6.27.0 and `fast-xml-parser` 5.9.2 and would clear **both** residual advisories — but
no v6 PR can appear while the 5.0.5 one sits open.

Add it as a pitfall line, and connect it to the role's existing **terminal-verdict
discipline**: letting a dependabot PR rot has a real security cost beyond the stale PR
itself, which is precisely why the botanist must render a terminal verdict rather than
leave one open indefinitely.

## Notes

- **Not in scope:** tightening CI shellcheck from `-S warning` to `-S info` (proposed
  in report `fu-fix-identity-drift-guard-test-inbox-leak-3`). The maintainer declined:
  it would require first sweeping `# shellcheck disable=SC2015,SC2016` headers across
  many scripts, i.e. tightening a gate and then blanket-disabling the rules that fire.
  If revisited, the version worth doing is *fixing* those sites, not suppressing them.
- Keep the role file's existing voice and density. Do not restate anything in
  `roles/COMMON.md`.

## Definition of done

- Step 5's absolute sentence is replaced by the directional rule, with the
  in-verdict-argument requirement encoded.
- The one-open-PR suppression pitfall is present and tied to terminal-verdict
  discipline.
- Items 1, 2, and 4 are untouched — verify before editing that you are not
  re-landing them.
- Pushed to `main2`; the `tada` report quotes the new step-5 wording verbatim.
