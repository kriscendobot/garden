// app.js — wires auth, bulletin render, and the per-message reply controls.
//
// The bulletin CONTENT (README + the maintainer-inbox messages) is baked into
// `data.js` at deploy time by the `bulletin` GitHub Actions workflow, which
// reads the live `journal2` branch and re-renders whenever journal2 changes.
// This module renders that baked snapshot for display, and uses a pasted
// fine-grained PAT only on the WRITE path (the reply commit), which re-reads the
// live message state at click time so the commit is a correct compare-and-swap
// even if the page snapshot is a few minutes stale. See DESIGN.md.

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

const DATA = window.GARDEN_BULLETIN_DATA || { readme: '', messages: [], renderedAt: '' };

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

async function submitReply({ item, fm, textarea, statusEl, btn, card }) {
  const body = textarea.value.trim();
  if (!body) {
    statusEl.textContent = 'write a reply first';
    return;
  }
  if (!GH.hasToken()) {
    statusEl.textContent = 'paste a token above to reply';
    return;
  }
  btn.disabled = true;
  statusEl.textContent = 'delivering…';
  try {
    // Re-read the LIVE message so the archive uses the current blob sha even if
    // this baked page snapshot is a few minutes stale. A 404 means it was
    // already archived since deploy.
    const live = await GH.getFile(`inbox/maintainer/unread/${item.name}`);
    if (!live) {
      btn.disabled = false;
      statusEl.innerHTML = '';
      statusEl.append(
        el('span', { class: 'muted', text: 'already archived since this page was built — refresh' }),
      );
      return;
    }
    const target = await resolveTarget(fm);
    const id = msgId();
    const replyPath = `${target.dir}/${id}.md`;
    const sha = await GH.commitReply({
      replyPath,
      replyBody: replyFileBody(target, body),
      unreadPath: `inbox/maintainer/unread/${item.name}`,
      readPath: `inbox/maintainer/read/${item.name}`,
      origSha: live.sha,
      message: `bulletin: reply to inbox/${target.to}, archive maintainer/${item.name}`,
    });
    // Baked content is static; mark this card done rather than re-fetching.
    const reply = card.querySelector('.reply');
    reply.innerHTML = '';
    reply.append(
      el('span', {
        class: 'ok',
        text: `delivered to inbox/${target.to}${
          target.kind === 'liaison' ? ' (no reply_to; routed to liaison)' : ''
        }${target.kind === 'dead' ? ' (doer gone; dead-lettered)' : ''} — commit ${sha.slice(0, 8)}, archived. The bulletin redeploys shortly.`,
      }),
    );
    card.classList.add('done');
  } catch (e) {
    btn.disabled = false;
    statusEl.innerHTML = '';
    statusEl.append(el('span', { class: 'err', text: `failed: ${e.message}` }));
  }
}

// --- render (from the CI-baked snapshot) -------------------------------------
function render() {
  const fresh = $('#freshness');
  if (fresh) {
    fresh.textContent = DATA.renderedAt
      ? `Rendered from journal2 at ${DATA.renderedAt}.`
      : '';
  }

  // Bulletin
  const bnode = $('#bulletin');
  if (DATA.readme) {
    bnode.innerHTML = Markdown.render(DATA.readme);
  } else {
    bnode.innerHTML = '<p class="err">journal2:README.md was empty at build time.</p>';
  }

  // Maintainer inbox
  const inode = $('#inbox');
  inode.innerHTML = '';
  const items = DATA.messages || [];
  if (!items.length) {
    inode.append(el('p', { class: 'muted', text: 'No unread messages to the maintainer.' }));
    return;
  }
  for (const item of items) {
    const fm = item.fm || {};
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
    const bodyNode = el('div', { class: 'msg-body' });
    bodyNode.innerHTML = Markdown.render(item.body || '');
    card.append(bodyNode);

    const textarea = el('textarea', {
      rows: '3',
      placeholder: 'Acknowledge or reply to the liaison…',
    });
    const status = el('div', { class: 'status' });
    const btn = el('button', { class: 'btn', text: 'Reply & acknowledge' });
    btn.addEventListener('click', () =>
      submitReply({ item, fm, textarea, statusEl: status, btn, card }),
    );
    card.append(
      el('div', { class: 'reply' }, textarea, el('div', { class: 'reply-actions' }, btn, status)),
    );
    inode.append(card);
  }
}

renderAuth();
$('#refresh').addEventListener('click', () => location.reload());
render();
