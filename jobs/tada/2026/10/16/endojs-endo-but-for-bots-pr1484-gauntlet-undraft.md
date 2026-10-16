## Report: un-draft endojs/endo-but-for-bots#1484

I un-drafted PR #1484 ("design: HTTPS fragment locators replacing endo://"). It is now ready for review at the head the panel passed.

**Head check before un-drafting:** the PR was OPEN, still a draft, and its head was exactly `a908c2902afa3bb730f7e4fa76100bbefad1600d`, the commit the panel passed. So I ran `gh pr ready`.

**Check after:** `isDraft` is false and the head is unchanged at `a908c2902afa3bb730f7e4fa76100bbefad1600d`.

**Advisory appellate pass:** I ran a quick Sonnet `claude -p` review of the 719-line diff. It is advisory only, so it did not block the un-draft, and I have not acted on any of it. Points worth the maintainer's attention:
- **Possible secret leaks:**
  - The capture page might keep the secret in history: on failure it calls `location.replace` instead of erasing it.
  - It might also expose the secret through the `familiar:adopt#…` hand-off or a `localStorage` record.
- **Base origin not restricted:** `setLocatorBase` accepts any `https:` origin, even though the text promises a "fixed, allowlisted base".
- **Parser gaps:**
  - The bare form never checks the path against the `type` value.
  - Based links with a query, a prefix path, or no trailing slash fall through to a generic failure.
  - Nobody has checked that a fragment with 16 encoded `at` hints fits the 4096-character cap.
- **Redaction test vs. diagnostics:** the test may contradict the allowed 8-hex peer fingerprint in error messages.
- **Weak references:** the RFC 9110 redirect-inheritance claim is unchecked, and the source article was never found (open question 8).
- **README bookkeeping:** the counts may be off by one, and the section-header context looks inconsistent.
- **Nine open questions:** the reviewer said this needs the `<!-- garden-design-open-questions -->` marker. That marker is a garden-repo convention and probably doesn't apply to endo-but-for-bots, so treat this point as low-signal.

**Follow-ups:** none posted. The appellate points are for the maintainer's review, now that the PR is out of draft.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1484-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (168483 cached reads)
- Output: 1565 tokens
- Cost: $0.3958686
- Wall-clock: 47s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
