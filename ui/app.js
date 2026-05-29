const INFO_TEXTS = {
  rclick: 'Hold the right mouse button to rotate the camera. The script polls mouse movement and translates it into look-left/look-right keypresses. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor.',
  movelook: 'While a movement key (Forward or Backwards) is held, mouse movement will steer the camera. Useful for strafing and moving at the same time. Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
  combatArtKey: 'The key assigned to activate your current Combat Art in-game. Used by the script to trigger abilities. Make sure it matches your Sacred 2 keybind settings.',
  runeMaster: 'Adds a shortcut — Alt + Shift + Left Click — to quickly open the RuneMaster screen. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.',
};

const popup = document.getElementById('infoPopup');
const popupText = document.getElementById('popupText');

// Position and show popup near the clicked info button
function showPopup(btn) {
  const rect = btn.getBoundingClientRect();
  const key = btn.dataset.info;
  popupText.textContent = INFO_TEXTS[key] || '';
  popup.classList.add('is-active');

  // Position below the button, right-aligned to it
  const popupW = 280;
  let left = rect.right - popupW;
  let top = rect.bottom + 8;

  // Clamp to viewport
  if (left < 8) left = 8;
  if (top + 120 > window.innerHeight) top = rect.top - 120;

  popup.style.left = left + 'px';
  popup.style.top = top + 'px';
}

document.querySelectorAll('.ko-InfoIcon').forEach(btn => {
  btn.addEventListener('click', e => {
    e.stopPropagation();
    if (popup.classList.contains('is-active') && popup._source === btn) {
      popup.classList.remove('is-active');
      popup._source = null;
    } else {
      showPopup(btn);
      popup._source = btn;
    }
  });
});

document.getElementById('popupClose').addEventListener('click', () => {
  popup.classList.remove('is-active');
  popup._source = null;
});

document.addEventListener('click', () => {
  popup.classList.remove('is-active');
  popup._source = null;
});

// Key inputs: accept single lowercase letter only
document.querySelectorAll('.ko-KeyInput').forEach(input => {
  input.addEventListener('keydown', e => {
    // Allow: backspace, tab, arrows
    if (['Backspace', 'Tab', 'ArrowLeft', 'ArrowRight'].includes(e.key)) return;
    // Only accept single printable characters
    if (e.key.length === 1) {
      e.preventDefault();
      input.value = e.key.toLowerCase();
    } else {
      e.preventDefault();
    }
  });

  input.addEventListener('focus', () => input.select());
});

// Receive config from AHK and populate form fields
window.chrome.webview.addEventListener('message', e => {
  const cfg = e.data;
  const setCheck = (id, val) => { document.getElementById(id).checked = val === '1'; };
  const setVal   = (id, val) => { document.getElementById(id).value = val; };
  setCheck('rclick',     cfg.rclick);
  setCheck('movelook',   cfg.movelook);
  setVal('lookLeft',     cfg.lookLeft);
  setVal('lookRight',    cfg.lookRight);
  setVal('forward',      cfg.forward);
  setVal('backwards',    cfg.backwards);
  setVal('moveLeft',     cfg.moveLeft);
  setVal('moveRight',    cfg.moveRight);
  setVal('combatArtKey', cfg.combatArtKey);
  setCheck('runeMaster', cfg.runeMaster);
});

// Update script button
document.getElementById('btnUpdate').addEventListener('click', () => {
  const get     = id => document.getElementById(id);
  const checked = id => get(id).checked ? '1' : '0';
  const val     = id => get(id).value.trim().toLowerCase();

  const parts = [
    'rclick='       + checked('rclick'),
    'movelook='     + checked('movelook'),
    'lookLeft='     + val('lookLeft'),
    'lookRight='    + val('lookRight'),
    'forward='      + val('forward'),
    'backwards='    + val('backwards'),
    'moveLeft='     + val('moveLeft'),
    'moveRight='    + val('moveRight'),
    'combatArtKey=' + val('combatArtKey'),
    'runeMaster='   + checked('runeMaster'),
  ];

  window.chrome.webview.postMessage(parts.join('|'));
  document.getElementById('reloadModal').classList.add('is-active');
});

// Reload button
document.getElementById('btnReload').addEventListener('click', () => {
  window.chrome.webview.postMessage('reload');
});
