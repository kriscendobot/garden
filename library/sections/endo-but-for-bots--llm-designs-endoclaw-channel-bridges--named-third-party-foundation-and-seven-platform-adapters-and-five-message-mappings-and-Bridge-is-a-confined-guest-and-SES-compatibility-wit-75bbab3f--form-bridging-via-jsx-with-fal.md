---
title: §Form-bridging via JSX with §fallback-to-text-prompt
source-slug: endo-but-for-bots--llm-designs-endoclaw-channel-bridges
section-id: named-third-party-foundation-and-seven-platform-adapters-and-five-message-mappings-and-Bridge-is-a-confined-guest-and-SES-compatibility-with-three-fallback-paths-and-state-is-Endo-native
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-channel-bridges.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/endoclaw-channel-bridges.md
total-lines: 183
status: Not Started (Parent: endoclaw)
ingest-cycle: 232
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-endoclaw-channel-bridges--named-third-party-foundation-and-seven-platform-adapters-and-five-message-mappings-and-Bridge-is-a-confined-guest-and-SES-compatibility-with-three-fallback-paths-and-state-is-Endo-native
---

```tsx
const renderForm = (fields) => (
  <Card>
    <Section>
      {fields.map(f => (
        <TextInput label={f.label} placeholder={f.example} id={f.name} />
      ))}
    </Section>
    <Actions>
      <Button action="submit">Submit</Button>
    </Actions>
  </Card>
);
```

§Endo-form-fields-render-as-platform-cards on Slack/Teams + §fallback-to-text-prompt-listing-the-fields-with-structured-reply on Telegram/GitHub.

§Borrowable-pattern: §design-the-rich-representation-and-name-the-text-fallback for §platforms-with-limited-rendering. §The-design-rejects-lowest-common-denominator (which would deny the rich form to Slack); §but-also-rejects-platform-specific-implementations (which would multiply the work); §the-JSX-abstraction-IS-the-compromise.

§Sibling to cycle 220's §three-mode-address-filtering with §default-is-the-safe-mode — both designs §named-modes-with-fallback-discipline.
