---
kind: result
role: gardener
host: endolinbot2
at: 2026-07-01T03:17:08Z
---
project: endo-but-for-bots
prs: [475]
issues: [584]

Attention directive on endojs/endo-but-for-bots PR #475: erights asked (review comment r3503047272, anchored to `.changeset/byte-array-hex-codecs.md`) whether incompatible producer-side protocol changes should bump a version number, whether protocols should do semver-style negotiation the way code linkage uses `yarn.lock`/`package.json`, and what industry best practice is for protocol version changes. He explicitly directed: "none of these protocol version questions need to be resolved for this PR to make progress. Please move this question to a separate issue on endo-but-for-bots."

Action (erights has full maintainer authority; the directive is self-authorizing on this repo, which also carries the standing comment/cross-reference authorization):

- Opened tracking issue endojs/endo-but-for-bots#584 capturing the concrete case (new byteArray codec shapes across capdata/smallcaps/encode-passable/marshal-justin, and the consumers-before-producers deploy-sequencing rule), erights' four questions verbatim, and his `@kriskowal @gibson042 @mhofman` attention list.
- Replied on the review thread (pull/475#discussion_r3503058379) linking #584 and confirming the PR is not blocked.
- Added a +1 reactji ack on the original comment.

PR #475 itself needs no code change from this directive; the versioning discussion now lives in #584.
