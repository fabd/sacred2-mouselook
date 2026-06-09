/**
 * T-Energy Checkbox Custom Element.
 * Rendered directly in the Light DOM without Shadow DOM, allowing global CSS scope.
 */
class TEnergyCheckbox extends HTMLElement {
  static get observedAttributes() {
    return ["checked", "disabled", "label"];
  }

  constructor() {
    super();
  }

  connectedCallback() {
    this.render();
    this.setupEventListeners();
    this.syncState();
  }

  render() {
    const checkedAttr = this.hasAttribute("checked") ? "checked" : "";
    const disabledAttr = this.hasAttribute("disabled") ? "disabled" : "";
    const labelText = this.getAttribute("label") || "";

    this.innerHTML = `
      <label class="${disabledAttr ? "t-energy-disabled" : ""}">
        <input type="checkbox" class="t-energy-input" ${checkedAttr} ${disabledAttr}>
        <span class="t-energy-checkbox">
          <span class="t-energy-inner">
            <svg class="t-energy-checkmark" viewBox="0 0 24 24">
              <polyline points="20 6 9 17 4 12"></polyline>
            </svg>
          </span>
        </span>
      </label>
    `;
  }

  setupEventListeners() {
    const input = this.querySelector(".t-energy-input");
    if (input) {
      input.addEventListener("change", (e) => {
        const isChecked = e.target.checked;
        if (isChecked) {
          this.setAttribute("checked", "");
        } else {
          this.removeAttribute("checked");
        }
        // Dispatch dynamic change event for applications to intercept
        this.dispatchEvent(
          new CustomEvent("change", {
            detail: { checked: isChecked },
            bubbles: true,
            composed: true,
          })
        );
      });
    }
  }

  syncState() {
    const input = this.querySelector(".t-energy-input");
    if (input) {
      input.checked = this.hasAttribute("checked");
      input.disabled = this.hasAttribute("disabled");
    }
  }

  attributeChangedCallback(name, oldValue, newValue) {
    const input = this.querySelector(".t-energy-input");
    const container = this.querySelector(".t-energy-container");
    const labelTextEl = this.querySelector(".t-energy-text");

    if (!input) return;

    if (name === "checked") {
      input.checked = newValue !== null;
    } else if (name === "disabled") {
      const isDisabled = newValue !== null;
      input.disabled = isDisabled;
      if (container) {
        if (isDisabled) {
          container.classList.add("t-energy-disabled");
        } else {
          container.classList.remove("t-energy-disabled");
        }
      }
    }
  }

  /* Properties API getters and setters */
  get checked() {
    return this.hasAttribute("checked");
  }

  set checked(val) {
    if (val) this.setAttribute("checked", "");
    else this.removeAttribute("checked");
  }

  get disabled() {
    return this.hasAttribute("disabled");
  }

  set disabled(val) {
    if (val) this.setAttribute("disabled", "");
    else this.removeAttribute("disabled");
  }

  get label() {
    return this.getAttribute("label") || "";
  }

  set label(val) {
    this.setAttribute("label", val);
  }
}

/**
 * <cool-button label="Reload" height="40"></cool-button>
 *   label  : text shown on the middle sprite
 *   height : rendered art height in px (sets --scale: calc(height / 104));
 *            omit to use the CSS default (60px)
 */
class CoolButton extends HTMLElement {
  static get observedAttributes() {
    return ["label", "height"];
  }

  connectedCallback() {
    this.render();
  }

  attributeChangedCallback() {
    if (this.isConnected) this.render();
  }

  render() {
    const label = this.getAttribute("label") || "";
    const height = this.getAttribute("height");
    if (height) {
      this.style.setProperty("--scale", `calc(${parseFloat(height)} / 104)`);
    }
    this.classList.add("ko-UpdateBtn");
    this.innerHTML = `
      <span class="ko-UpdateBtn-left"></span>
      <span class="ko-UpdateBtn-mid">${label}</span>
      <span class="ko-UpdateBtn-right"></span>
    `;
  }
}

customElements.define("cool-button", CoolButton);

customElements.define("t-energy-checkbox", TEnergyCheckbox);
