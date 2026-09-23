---
section: streamReply-and-streamSend-with-stream-formula-and-CapTP-rides-method-calls
source: endo-but-for-bots--llm-designs-daemon-message-streaming
topics: [daemon, captp]
status: current
title: The §StreamWriter and §StreamReader interfaces
parent: endo-but-for-bots--llm-designs-daemon-message-streaming--streamReply-and-streamSend-with-stream-formula-and-CapTP-rides-method-calls
---

The §StreamWriter interface (sender side):

```js
/**
 * @typedef {object} StreamWriter
 * @prop {(text: string) => Promise<void>} append
 *   Append a text fragment to the stream.
 * @prop {(phase: string) => Promise<void>} setPhase
 *   Update the current phase label (e.g. "thinking" → "responding").
 * @prop {() => Promise<void>} end
 *   Finalise the stream.  The message becomes immutable.
 * @prop {(reason: string) => Promise<void>} abort
 *   Abort the stream with an error reason.
 */
```

The §StreamReader (recipient side) is an *async iterable of
StreamEvent objects*:

```js
/**
 * @typedef {object} StreamEvent
 * @prop {'append' | 'phase' | 'end' | 'abort'} type
 * @prop {string} [text]   - For 'append' events.
 * @prop {string} [phase]  - For 'phase' events.
 * @prop {string} [reason] - For 'abort' events.
 */

for await (const event of message.stream) {
  switch (event.type) {
    case 'append': process.stdout.write(event.text); break;
    case 'phase':  showStatus(event.phase);          break;
    case 'end':                                       break;
    case 'abort':  showError(event.reason);          break;
  }
}
```

The §four-event-type taxonomy: `append` / `phase` / `end` /
`abort`. Each event carries only the fields relevant to its
type.
