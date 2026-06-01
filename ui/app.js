const INFO_TEXTS = {
  "mlook-rmb":
    "<b>Hold the right mouse button to rotate the camera</b>. When holding the right mouse button, the turn left/right keys will strafe instead (move left/right). Classic MMO controls. <b>NOTE!</b> You will have to use Shift + RMB to eat runes or equip items.",
  "mlook-hybrid":
    "<b>Mouselook is active while running</b> (forward or backwards). While running the turn left/right keys will strafe instead. Great to relax your hands/wrists (no need to hold the right mouse button).",
  "key-combat-art":
    "If set, this key will trigger your selected combat art (same as clicking right mouse button). Useful if Quickcast is off and you use Classic Mouselook. Recommended key: f. Leave this empty to turn it off.",
  "rune-master":
    "Adds a shortcut — Alt + Shift + Left Click — to quickly open the RuneMaster screen. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.",
  "key-vanity-cam":
    "Activates a vanity camera (like in Skyrim). Nice to show off your character! Press shortcut again (or the ESC key) to toggle off.",
};

const popup = document.getElementById("infoPopup");
const popupText = document.getElementById("popupText");

// Position and show popup near the clicked info button
function showPopup(btn) {
  const rect = btn.getBoundingClientRect();
  const key = btn.dataset.info;
  popupText.innerHTML = INFO_TEXTS[key] || "";
  popup.classList.add("is-active");

  // Position below the button, right-aligned to it
  const popupW = 280;
  let left = rect.right - popupW;
  let top = rect.bottom + 8;

  // Clamp to viewport
  if (left < 8) left = 8;
  if (top + 120 > window.innerHeight) top = rect.top - 120;

  popup.style.left = left + "px";
  popup.style.top = top + "px";
}

document.querySelectorAll(".ko-InfoIcon").forEach((btn) => {
  btn.addEventListener("click", (e) => {
    e.stopPropagation();
    if (popup.classList.contains("is-active") && popup._source === btn) {
      popup.classList.remove("is-active");
      popup._source = null;
    } else {
      showPopup(btn);
      popup._source = btn;
    }
  });
});

document.getElementById("popupClose").addEventListener("click", () => {
  popup.classList.remove("is-active");
  popup._source = null;
});

document.addEventListener("click", () => {
  popup.classList.remove("is-active");
  popup._source = null;
});

document.querySelectorAll(".ko-KeyInput").forEach((input) => {
  input.addEventListener("focus", () => input.select());
});

// Receive config from AHK and populate form fields
window.chrome.webview.addEventListener("message", (e) => {
  const cfg = e.data;
  const setCheck = (id, val) => {
    document.getElementById(id).checked = val === "1";
  };
  const setVal = (id, val) => {
    document.getElementById(id).value = val;
  };
  setCheck("mlook-rmb", cfg["mlook-rmb"]);
  setCheck("mlook-hybrid", cfg["mlook-hybrid"]);
  setVal("key-look-left", cfg["key-look-left"]);
  setVal("key-look-right", cfg["key-look-right"]);
  setVal("key-forward", cfg["key-forward"]);
  setVal("key-backwards", cfg["key-backwards"]);
  setVal("key-move-left", cfg["key-move-left"]);
  setVal("key-move-right", cfg["key-move-right"]);
  setVal("key-combat-art", cfg["key-combat-art"]);
  setVal("key-vanity-cam", cfg["key-vanity-cam"]);
  setCheck("rune-master", cfg["rune-master"]);
});

// Update script button
document.getElementById("btnUpdate").addEventListener("click", () => {
  const get = (id) => document.getElementById(id);
  const checked = (id) => (get(id).checked ? "1" : "0");
  const val = (id) => get(id).value.trim();

  window.chrome.webview.postMessage({
    type: "save-settings",
    "mlook-rmb": checked("mlook-rmb"),
    "mlook-hybrid": checked("mlook-hybrid"),
    "key-look-left": val("key-look-left"),
    "key-look-right": val("key-look-right"),
    "key-forward": val("key-forward"),
    "key-backwards": val("key-backwards"),
    "key-move-left": val("key-move-left"),
    "key-move-right": val("key-move-right"),
    "key-combat-art": val("key-combat-art"),
    "key-vanity-cam": val("key-vanity-cam"),
    "rune-master": checked("rune-master"),
  });
  document.getElementById("reloadModal").classList.add("is-active");
});

// Reload button
document.getElementById("btnReload").addEventListener("click", () => {
  window.chrome.webview.postMessage({ type: "reload-ahk" });
});
