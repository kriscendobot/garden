// app.js — wires auth, bulletin render, and the per-message reply controls.

const $ = (sel) => document.querySelector(sel);
const el = (tag, attrs = {}, ...kids) => {
  const node = document.createElement(tag);
  for (const [k, v] of Object.entries(attrs)) {
    if (k === 'class') node.className = v;
    else if (k === 'text') node.textContent = v;
    else if (k.startsWith('on')) node.addEventListener(k.slice(2), v);
    else node.setAttribute(k, v);
  }
  for (const kid of kids) node.append(kid);
  return node;
};

// Map a failed WRITE to a legible message. Reads are unauthenticated on this
// public repo, so a 401/403/404 only ever bites on the reply commit — and it
// almost always means the token is missing, expired, or scoped to the wrong
// resource owner. A fine-grained PAT is owner-scoped and does NOT survive a repo
// transfer (see docs/bulletin/SETUP.md § 2), which is exactly the failure that
// looks like "reads fine, saves fail". Surface that plainly instead of a raw
// status. The token is never included in the message (or logged) — ever.
function saveErrorMessage(e) {
  if (e && (e.status === 401 || e.status === 403 || e.status === 404)) {
    return (
      `save rejected (HTTP ${e.status}). The token is missing, expired, or ` +
      `scoped to the wrong resource owner. A fine-grained token is owner-scoped ` +
      `and does NOT survive a repo transfer, so a token minted under a previous ` +
      `owner can no longer write here even though reads still work. Re-mint a ` +
      `token under this repo's current owner with Contents: read & write — see ` +
      `docs/bulletin/SETUP.md § 2.`
    );
  }
  return `failed: ${e.message}`;
}

// Parse the bus message format: leading `key: value` lines, a `---` fence, body.
function parseMessage(text) {
  const lines = text.split('\n');
  const fm = {};
  let i = 0;
  for (; i < lines.length; i++) {
    if (lines[i].trim() === '---') {
      i++;
      break;
    }
    const m = lines[i].match(/^([A-Za-z_][\w]*):\s*(.*)$/);
    if (m) fm[m[1]] = m[2].trim();
  }
  return { fm, body: lines.slice(i).join('\n').trim() };
}

function nowIso() {
  return new Date().toISOString().replace(/\.\d+Z$/, 'Z');
}
function msgId() {
  const stamp = nowIso().replace(/[-:]/g, '').replace(/\.\d+/, '');
  const rand = Array.from(crypto.getRandomValues(new Uint8Array(3)))
    .map((b) => b.toString(16).padStart(2, '0'))
    .join('');
  return `${stamp}-${rand}`;
}

// --- auth UI -----------------------------------------------------------------
function renderAuth() {
  const bar = $('#authbar');
  bar.innerHTML = '';
  if (GH.hasToken()) {
    bar.append(
      el('span', { class: 'ok', text: '● signed in (token present)' }),
      el('button', {
        class: 'linkbtn',
        text: 'sign out',
        onclick: () => {
          GH.clearToken();
          renderAuth();
          load();
        },
      }),
    );
    return;
  }
  const input = el('input', {
    type: 'password',
    placeholder: 'fine-grained PAT (Contents: read & write on this repo)',
    class: 'token',
  });
  bar.append(
    el('span', { class: 'muted', text: 'read-only — paste a token to reply:' }),
    input,
    el('button', {
      class: 'btn',
      text: 'Save token',
      onclick: () => {
        if (!input.value.trim()) return;
        GH.setToken(input.value);
        renderAuth();
        load();
      },
    }),
  );
  const df = GH.cfg.deviceFlow;
  if (df && df.proxyBase && df.clientId) {
    bar.append(
      el('button', {
        class: 'btn',
        text: 'Sign in with GitHub',
        onclick: deviceFlowSignIn,
      }),
    );
  }
}

// Optional OAuth device flow through the maintainer-deployed CORS proxy.
async function deviceFlowSignIn() {
  const df = GH.cfg.deviceFlow;
  const status = $('#authbar');
  try {
    const start = await (
      await fetch(`${df.proxyBase}/device/code`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ client_id: df.clientId, scope: 'repo' }),
      })
    ).json();
    window.open(start.verification_uri, '_blank');
    alert(`Enter code ${start.user_code} in the GitHub tab, then return here.`);
    const interval = (start.interval || 5) * 1000;
    const deadline = Date.now() + (start.expires_in || 900) * 1000;
    while (Date.now() < deadline) {
      await new Promise((r) => setTimeout(r, interval));
      const tok = await (
        await fetch(`${df.proxyBase}/device/token`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ client_id: df.clientId, device_code: start.device_code }),
        })
      ).json();
      if (tok.access_token) {
        GH.setToken(tok.access_token);
        renderAuth();
        load();
        return;
      }
      if (tok.error && tok.error !== 'authorization_pending') throw new Error(tok.error);
    }
    status.append(el('span', { class: 'err', text: ' device flow timed out' }));
  } catch (e) {
    alert(`Device flow failed: ${e.message}. Use the PAT field instead.`);
  }
}

// --- reply routing (mirrors maintainer-reply.sh + inbox-send dead-letter) -----
async function resolveTarget(fm) {
  const doer = fm.reply_to && fm.reply_to !== '?' ? fm.reply_to : null;
  if (doer && (await GH.dirExists(`inbox/${doer}`))) {
    return { kind: 'doer', dir: `inbox/${doer}/unread`, to: doer };
  }
  if (await GH.dirExists('inbox/liaison')) {
    return { kind: 'liaison', dir: 'inbox/liaison/unread', to: 'liaison' };
  }
  return { kind: 'dead', dir: 'inbox/dead', to: doer || 'liaison' };
}

function replyFileBody(target, body) {
  const sent = nowIso();
  const head = [];
  if (target.kind === 'dead') head.push(`to: ${target.to}`);
  head.push('from_host: github-pages');
  head.push('from: maintainer');
  head.push(`sent_at: ${sent}`);
  if (target.kind === 'dead') head.push(`dead_lettered_at: ${sent}`);
  head.push('---');
  return `${head.join('\n')}\n${body}\n`;
}

// An empty box is allowed: every acknowledgement OR reply moves the message
// unread -> read (kriskowal #10). Empty = mark-as-read only; non-empty = post
// the reply to its target AND mark-as-read.
async function submitReply({ item, fm, textarea, statusEl, btn }) {
  const body = textarea.value.trim();
  if (!GH.hasToken()) {
    statusEl.textContent = 'paste a token above to acknowledge';
    return;
  }
  btn.disabled = true;
  statusEl.textContent = body ? 'delivering…' : 'marking read…';
  try {
    let target = null;
    let replyPath;
    let replyBody;
    if (body) {
      target = await resolveTarget(fm);
      replyPath = `${target.dir}/${msgId()}.md`;
      replyBody = replyFileBody(target, body);
    }
    const sha = await GH.commitReply({
      replyPath,
      replyBody,
      unreadPath: `inbox/maintainer/unread/${item.name}`,
      readPath: `inbox/maintainer/read/${item.name}`,
      origSha: item.sha,
      message: body
        ? `bulletin: reply to inbox/${target.to}, archive maintainer/${item.name}`
        : `bulletin: acknowledge maintainer/${item.name} (mark read)`,
    });
    statusEl.innerHTML = '';
    statusEl.append(
      el('span', {
        class: 'ok',
        text: body
          ? `delivered to inbox/${target.to}${
              target.kind === 'liaison' ? ' (no reply_to; routed to liaison)' : ''
            }${target.kind === 'dead' ? ' (doer gone; dead-lettered)' : ''} — commit ${sha.slice(0, 8)}, archived`
          : `marked read — commit ${sha.slice(0, 8)}`,
      }),
    );
    setTimeout(load, 1200);
  } catch (e) {
    btn.disabled = false;
    statusEl.innerHTML = '';
    statusEl.append(el('span', { class: 'err', text: saveErrorMessage(e) }));
  }
}

// --- new thread to the liaison -----------------------------------------------
// A maintainer-initiated message (not a reply to an inbox item). Commits one new
// file to inbox/liaison/unread on journal2, mirroring the liaison routing the
// reply path already uses. The GitHub "new issue" link is the no-token fallback.
function newThreadBody(body) {
  const sent = nowIso();
  return (
    [
      'from_host: github-pages',
      'from: maintainer',
      `sent_at: ${sent}`,
      '---',
    ].join('\n') + `\n${body}\n`
  );
}

async function submitThread({ textarea, statusEl, btn }) {
  const body = textarea.value.trim();
  if (!body) {
    statusEl.textContent = 'write a message first';
    return;
  }
  if (!GH.hasToken()) {
    statusEl.textContent = 'paste a token above, or use the issue link →';
    return;
  }
  btn.disabled = true;
  statusEl.textContent = 'posting…';
  try {
    const id = msgId();
    const sha = await GH.commitReply({
      replyPath: `inbox/liaison/unread/${id}.md`,
      replyBody: newThreadBody(body),
      message: 'bulletin: new maintainer thread to inbox/liaison',
    });
    textarea.value = '';
    statusEl.innerHTML = '';
    statusEl.append(
      el('span', {
        class: 'ok',
        text: `posted to inbox/liaison — commit ${sha.slice(0, 8)}`,
      }),
    );
  } catch (e) {
    statusEl.innerHTML = '';
    statusEl.append(el('span', { class: 'err', text: saveErrorMessage(e) }));
  } finally {
    btn.disabled = false;
  }
}

function renderCompose() {
  const link = $('#new-issue-link');
  link.href = `https://github.com/${GH.cfg.owner}/${GH.cfg.repo}/issues/new`;
  const textarea = $('#compose-body');
  const btn = $('#compose-send');
  const status = $('#compose-status');
  btn.addEventListener('click', () =>
    submitThread({ textarea, statusEl: status, btn }),
  );
}

// --- render ------------------------------------------------------------------
async function load() {
  // Bulletin
  const bnode = $('#bulletin');
  try {
    const readme = await GH.getFile('README.md');
    if (readme) {
      bnode.innerHTML = Markdown.render(readme.text);
    } else {
      bnode.innerHTML = '<p class="err">journal2:README.md not found.</p>';
    }
  } catch (e) {
    bnode.innerHTML = `<p class="err">Could not load bulletin: ${e.message}</p>`;
  }

  // Maintainer inbox
  const inode = $('#inbox');
  inode.innerHTML = '<p class="muted">loading messages…</p>';
  try {
    const items = (await GH.listDir('inbox/maintainer/unread')).filter(
      (it) => it.type === 'file' && it.name.endsWith('.md') && it.name !== '.gitkeep',
    );
    inode.innerHTML = '';
    let rendered = 0;
    for (const item of items) {
      // A listed unread file can vanish between the directory listing and this
      // fetch — it was almost certainly just archived (unread -> read) by a
      // concurrent reply, or the Contents API transiently 404'd. getFile returns
      // null in that case (or throws on an unexpected failure); either way SKIP
      // the item so one missing file never aborts the whole inbox render.
      let file;
      try {
        file = await GH.getFile(`inbox/maintainer/unread/${item.name}`);
      } catch (e) {
        console.warn(`bulletin: skipping unread/${item.name} (fetch failed): ${e.message}`);
        continue;
      }
      if (!file) continue;
      const { fm, body } = parseMessage(file.text);
      rendered++;
      const card = el('div', { class: 'msg' });
      const from = fm.from || 'unknown';
      const replyTo = fm.reply_to && fm.reply_to !== '?' ? fm.reply_to : '(none → liaison)';
      card.append(
        el(
          'div',
          { class: 'msg-head' },
          el('code', { text: item.name.replace(/\.md$/, '') }),
          el('span', { class: 'muted', text: ` from ${from} · reply_to ${replyTo}` }),
        ),
      );
      card.append(el('div', { class: 'msg-body' }));
      card.lastChild.innerHTML = Markdown.render(body);

      const textarea = el('textarea', {
        rows: '3',
        placeholder: 'Acknowledge or reply to the liaison…',
      });
      const status = el('div', { class: 'status' });
      const btn = el('button', { class: 'btn', text: 'Reply & acknowledge' });
      btn.addEventListener('click', () =>
        submitReply({ item, fm, textarea, statusEl: status, btn }),
      );
      card.append(
        el('div', { class: 'reply' }, textarea, el('div', { class: 'reply-actions' }, btn, status)),
      );
      inode.append(card);
    }
    if (!rendered) {
      inode.append(el('p', { class: 'muted', text: 'No unread messages to the maintainer.' }));
    }
  } catch (e) {
    inode.innerHTML = `<p class="err">Could not load inbox: ${e.message}</p>`;
  }
}

renderAuth();
renderCompose();
$('#refresh').addEventListener('click', load);
load();
