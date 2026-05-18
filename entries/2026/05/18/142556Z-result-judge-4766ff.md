---
ts: 2026-05-18T14:25:56Z
kind: result
role: judge
host: endolinbot
short_id: 4766ff
dispatch_root: dispatches/judge--fd13fc
repo: endojs/endo-but-for-bots
branch: feat/cbors-package
base: llm
pr_number: 288
project: endo-but-for-bots
---

# Judge on PR #288 (@endo/cbors framing package)

Code-panel (16 seats) round on `feat/cbors-package@8b951d998` (cleaner head).
Panel execution: **in-band-fallback** (no `Agent` / `Task` tool in scope; each
seat written one at a time against its primary surface per
`roles/judge/AGENT.md` § In-band fallback).
Panel kind: **code-panel**.

## Verdict counts

- Must fix before merge: **0**
- Should fix in this PR: **0** (one contingent should-fix from the packager
  seat on `yarn.lock` commit separation; the cleaner had already shaped
  the head, so the contingent reduces to clean)
- Out of scope / follow-up: **3** (design / impl drift on `types.d.ts`;
  deep-import surface stability; sibling layout divergence with netstring)

Each of the sixteen seats returned **approve**.

## CI status

- At panel-start (on cleaner head `8b951d998`): fully green across all 25
  required check runs.
- At un-draft: still fully green; no new runs triggered between panel and
  un-draft (no commits pushed by the judge).

## Submission

The aggregated body (roughly 2 400 words across the sixteen per-seat blocks
plus aggregation) submitted as `gh pr review 288 --comment` because the
authenticated identity (`kriscendobot`) is also the PR's author; GitHub
blocks `--approve` and `--request-changes` on a self-authored PR. The
review carries the explicit per-seat verdicts and the aggregation's
must-fix / should-fix / out-of-scope partition. Submitted review id:
`PRR_kwDORRE4FM8AAAABAPToyg`.

## Fixer rounds

None. The panel terminated on the first round.

## Final PR state

- `gh pr ready 288 --repo endojs/endo-but-for-bots` ran successfully.
- `isDraft: false`, `state: OPEN`, `reviewDecision: ""` (the panel review
  is `COMMENTED` rather than `APPROVED` / `CHANGES_REQUESTED` because of
  the self-authored fallback above; the maintainer's review is the next
  venue).
- The maintainer's review queue is the next venue.

## Notes for downstream

- Wire-protocol correctness (the dispatch's explicit attention area) was
  verified by the `wire-watcher` seat against RFC 8949 §§ 3, 3.4.5.1, and
  4.2. The `tag-24 wire bytes match the design specimen` test (line 245
  of `test/cbors.test.js`) confirms the design and the implementation
  agree byte-for-byte on the wire. Recorded for the merged-PR feedback
  watch.
- Capability discipline (the dispatch's second attention area): no
  ambient authority, every named export hardened, `TAG_24_PREFIX`
  hardened at declaration, writer returns `harden({ ... })` for its
  iterator. `locksmith` and `warden` seats both clean.
- API ergonomics (the dispatch's third attention area): the `ergonomist`
  seat is on the **design** panel, not the code panel; the code panel's
  `curator` and `stylist` seats covered the API-surface dimension
  instead. Both clean.
- Saboteur sweep on the writer side (the dispatch's fourth attention
  area): adversarial inputs including zero-length chunks, non-array
  `messageChunks`, `maxMessageLength: 0`, concurrent `writer.next`
  without await, and reentrancy. All handled correctly. The chunked +
  buffer-ownership convention from the README is verified by the
  test harness's `array.push(value.slice())` posture.
- Package shape (the dispatch's fifth attention area): the `packager`
  seat noted the sibling layout divergence with netstring (`src/` vs
  flat) as intentional per modern endo packaging norms; the exports map
  and the `files` field are consistent with the chosen layout.

## Self-improvement

Nothing this time. The in-band-fallback procedure on `roles/judge/AGENT.md`
§ In-band fallback covered the dispatch's needs without amendment; the
explicit dispatch-prompt note about the anti-bail pattern (run the panel
first, snapshot CI, write the result entry before terminating) was the
load-bearing operational guidance for this dispatch and was followed in
that order.
