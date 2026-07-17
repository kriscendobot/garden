Implemented and pushed `269bea5` to `kriscendobot/chrome-native-function-caller-arguments-repro:main`.

Added Playwright browser harness, `test:browsers`, lockfile, raw JSON artifact, and README matrix. Ran Chromium 149, Firefox 151, and WebKit 26.5: all fixtures had absent own `arguments`/`caller` properties and remained callable. Chrome/Edge channels were not installed and are documented.

Verified with `npm test` and `npm run test:browsers`.

Self-improvement: nothing this time.
