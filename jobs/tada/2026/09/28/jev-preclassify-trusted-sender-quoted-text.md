I wrote the design and pushed it to `main2` (1c21ccef30b). It has three questions only the maintainer can decide, so I also opened draft PR [kriscendobot/garden#115](https://github.com/kriscendobot/garden/pull/115) as the place to answer them. Nothing from the earlier attempt had been committed or recorded, so this was a clean start.

**The problem.** The comment, mention, and issue-inbox watchers check who wrote a comment but not what it says. Untrusted text reaches an agent in two ways:
1. **The excerpt:** each posted job body includes the first 280 bytes of the comment, which lands in the claiming worker's prompt unconditionally.
2. **The re-fetch:** the job tells the worker to re-read the comment itself, and no script sits between that read and the model.

**What the design proposes:**
- **Where:** a new helper, `classify-quoted-text.sh`, runs inside the three watchers after the sender check and before the job is posted. That is the only point where plain code sees the full text before any model does.
- **What gets classified:** only the parts the sender marked as someone else's words (blockquotes, code fences, `<details>`), and only for injection. A maintainer's directive is an instruction to the bot on purpose, so classifying the whole comment would flag ordinary directives. Most comments have no quoted parts, so they make no call at all.
- **What happens on a flag:** the job still posts, but without the 280-byte excerpt and with a warning banner. The flag is logged to `jev-quoted/<GARDEN>.jsonl` in the journal. Nothing blocks.
- **Cost:** well under a dollar a month. The real cost is a later 👀 acknowledgment, so the check gets a 10-second limit. A timeout or missing credential is noted as "unclassified", and the watcher never blocks on it.
- **The allowlists:** unchanged. The classifier can never let an untrusted sender through.

**Open questions in the PR:**
1. Should a flag from a mention sender who is trusted only through endojs/Agoric membership block the job instead of just annotating it?
2. Does the 2026-09-28 Jev authorization cover sending this comment text to TypeSafe? The earlier Muster approval explicitly excluded PR-comment monitoring. If not, the fallback is to drop the excerpt from every job and use no classifier.
3. Is classifying only the marked quotes enough, given that a paste without quote marks gets no check?

**Changes:**
- New `designs/jev-trusted-sender-quoted-text.md`.
- `skills/foreign-content-preclassification/SKILL.md` now links to it instead of the placeholder "tracked by its own follow-on job".

**PR and follow-ups:** the PR is based on a frozen snapshot of `main2` (`main2-c604371`), carries the open-questions marker, and is left draft. Nothing is built yet. Once the questions are answered, a build job would add the helper, an injection-only mode for `classify-foreign-content.sh`, the four job-body changes, and the tests listed in the design.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/jev-preclassify-trusted-sender-quoted-text.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 30 tokens (1012837 cached reads)
- Output: 11606 tokens
- Cost: $1.0493033999999999 (1 engagement(s) unpriced)
- Wall-clock: 162s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
