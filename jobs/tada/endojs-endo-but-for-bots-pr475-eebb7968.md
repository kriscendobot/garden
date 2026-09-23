All work complete. No `main2` code changes were needed — this was an attention/routing directive.

---

## Completion report

**Job:** attention directive on endojs/endo-but-for-bots PR #475 (erights review comment r3503047272).

**What the directive was:** erights (full maintainer authority) asked a protocol-versioning question — should incompatible producer-side protocol changes bump a version number, should protocols do semver-style negotiation the way code linkage uses `yarn.lock`/`package.json`, and what's the industry best practice — then explicitly instructed: *"none of these protocol version questions need to be resolved for this PR to make progress. Please move this question to a separate issue on endo-but-for-bots."*

**Authorization:** endo-but-for-bots carries standing comment/cross-reference authorization, and a maintainer-authority (erights) lifecycle directive is self-authorizing on this repo. No inbox routing needed.

**What I did:**
- Confirmed no existing protocol-version issue (the nearby #573/#574 cover the separate view-span question).
- Read the anchored changeset (`.changeset/byte-array-hex-codecs.md`) to ground the issue in the concrete case: new `byteArray` encodings across capdata/smallcaps/encode-passable/marshal-justin, with a "consumers must ship the new decoder before producers emit" deploy-sequencing rule.
- **Opened tracking issue [endojs/endo-but-for-bots#584](https://github.com/endojs/endo-but-for-bots/issues/584)** capturing the concrete case, erights' four questions verbatim, and his `@kriskowal @gibson042 @mhofman` attention list.
- **Replied on the review thread** ([pull/475#discussion_r3503058379](https://github.com/endojs/endo-but-for-bots/pull/475#discussion_r3503058379)) linking #584 and confirming the PR is not blocked.
- Added a 👍 reactji ack on the original comment (reply is the substantive response; reactji is garnish).
- Journaled a `result` entry (`031706Z-result-gardener-381dd2.md`) recording the outward-facing artifacts.

**What changed:** No code / no `main2` commits — PR #475 needs no change from this directive; the versioning discussion now lives in #584.

**Follow-ups:** #584 is open for the maintainers to discuss protocol versioning/negotiation policy; not owned by this job.

**Self-improvement:** nothing this time — the standing authorizations and the "erights has full maintainer authority" rule already covered the self-authorizing issue-open + reply path cleanly.
