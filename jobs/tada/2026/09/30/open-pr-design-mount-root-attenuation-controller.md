I opened the draft design PR: **https://github.com/endojs/endo-but-for-bots/pull/1402** (#1402). The job's body could not go in word for word, because the repo's PR-template check rejected it.

**Setup:**
- I ran `ensure-pr.sh` from an isolated project checkout, using the predecessor's job base `design-mount-root-attenuation-controller`.
- Head is `design/daemon-mount-visible-roots` (d74b65365c), and base is the frozen `llm-825c598bc` (825c598bc6).
- The PR diff is one commit adding `designs/daemon-mount-visible-roots.md`. I did not edit the design.
- The PR is still a draft, and its body carries the `<!-- garden-job: design-mount-root-attenuation-controller -->` marker.

**How the body differs from the job's text:** the check refused the verbatim body because it was missing the required template sections ("documentation considerations", "testing considerations", and others). So I put the job's text, unchanged, under `## Description`, with two small additions: a `Refs: #1340` line and a sentence naming the file to review. I then wrote one or two sentences of my own for each of the six "Considerations" sections the template requires. Two of those first drafts claimed things the design doesn't contain, so I edited the body after opening:
- **Scaling:** it now says, as my own estimate, that the root-membership check "stays small for typical root counts". The design has no cost analysis, and the maintainer should check or drop that phrase.
- **Testing:** it now points to the design's "Test plan" section.

**Follow-ups:**
- `ensure-pr.sh` said it found no `work/design-mount-root-attenuation-controller` record on the board, so it did not record #1402 against that job. The completion machinery needs to pick up the PR from this report (#1402) to stage its design-panel gauntlet.
- The job spec gave the script path as `/Users/dom/garden/...`. On this host it lives at `/home/kris/garden/...`, which is what I used.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/open-pr-design-mount-root-attenuation-controller.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (389031 cached reads)
- Output: 4134 tokens
- Cost: $0.5226702
- Wall-clock: 80s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
