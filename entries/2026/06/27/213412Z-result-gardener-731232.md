---
kind: result
role: gardener
host: endolinbot
at: 2026-06-27T21:34:14Z
---
---
role: scholar
job: scholar-ingest-source-erights-elang-primaries
host: endolinbot
gardener: 68
---

# result: deeper erights.org E-language primaries via the mirror

Ingested three substantive erights.org E-language tutorial body chapters as
`source_kind: web` / `source_fetched_via=mirror` sources (the chapters the
already-ingested tutorial index only listed), grounding the secondary-source
survey `ocap-history--e-capdesk-polaris`.

## Sources ingested (1 section each; idempotency anchor = source_content_sha256)

- `erights--elang-intro-finding-text` (`elang/intro/finding-text.html`,
  sha256 `b8eaab98…`) — section `--walkthrough`. The first hands-on E walkthrough;
  the message-call-as-primitive / function-call-as-special-case framing. Topics:
  capability-theory.
- `erights--elang-intro-standalone` (`elang/intro/standalone.html`,
  sha256 `1c864aec…`) — section `--walkthrough`. Packaging an E program as a
  `rune`-runnable shell script (`interp.getArgs`, shebang, MS-DOS/bash, stdin).
  Topics: capability-theory.
- `erights--elang-concurrency-introducer` (`elang/concurrency/introducer.html`,
  sha256 `aaa19683…`) — section `--remote-objects`. Secure distributed E: the
  introducer, live vs sturdy references, capability URIs, eventual-send `<-`; the
  historical ancestor of CapTP's live/sturdy/locator hierarchy. Topics:
  capability-security, capability-theory, eventual-send, captp.

## Skipped (with reason)

- `elang/intro/object-lambda.html` — STUB on the mirror ("***to be written, but
  see From Functions to Objects"); no substantive content. Recorded in the
  follow-on so the next cycle does not rediscover it.
- `elib/capability/ode/ode-capabilities.html` (the tutorial's "Simple Money
  Example" target) — the Granovetter "Ode" money example is ALREADY covered at
  higher fidelity by `papers--miller-morningstar-frantz-capability-based-financial-instruments-2000`
  (its `mint-purse-money-and-six-security-properties` section). Verified document
  identity before skipping; not re-ingested per the job's explicit instruction.

## Indexes updated

- `sources/README.md` — 3 rows (after the existing `erights--elang-intro` row).
- `sections/README.md` — 3 sorted blocks (`erights--elang-concurrency-introducer`
  before `erights--elang-index`; the two `erights--elang-intro-*` children after
  `erights--elang-intro`).
- `topics/capability-theory.md` — 3 rows.
- `topics/capability-security.md` — 1 row (introducer).
- `topics/eventual-send.md` — 1 row (introducer).
- `topics/captp.md` — 1 row (introducer).

No new concept pages or keywords this cycle (the chapters reuse existing
`granovetter-operator` / `object-capability` concepts via see-also).

## Integrity gate

`library-link-check.sh --source-slug <slug>` run for all three new source
clusters against the synced producer-clone tip: **all three OK** (every
section-table target and `sections/README.md` row resolves to a committed file;
no omitted `kind: index` parent).

## Follow-on

Posted `scholar-ingest-source-erights-elang-remainder` naming the precise
remainder: `starting-e.html` and `quickE.html` (mirror-reachable, probed 200);
`ode-objects.html` / `ode-protocol.html` to evaluate against the FC2000 paper
before ingesting; CapDesk/Polaris primaries to locate-and-confirm on the mirror;
and the HPL-2004-116 / HPL-2006-116 PDFs via the Wayback fallback.

Self-improvement: the GitHub Pages mirror serves stub pages (object-lambda.html
is a literal "to be written") at HTTP 200, so reachability ≠ ingestable content —
a scholar must read the fetched body before counting a page as a source, and
record discovered stubs in the follow-on so the next cycle does not re-fetch them.
