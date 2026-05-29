**Best way: `window.chrome.webview.postMessage()` + `WebMessageReceived`**

This is the cleanest and most recommended method when using **WebViewToo** (or any WebView2 wrapper in AHK v2).

### 1. In your HTML/JavaScript (the form)

```html
<form id="settingsForm">
    <input type="text" id="username" value="John">
    <input type="checkbox" id="darkMode" checked>
    <select id="theme">
        <option value="light">Light</option>
        <option value="dark" selected>Dark</option>
    </select>
    <!-- ... more fields -->
    
    <button type="button" onclick="submitSettings()">Save Settings</button>
</form>

<script>
function submitSettings() {
    const settings = {
        username: document.getElementById('username').value,
        darkMode: document.getElementById('darkMode').checked,
        theme: document.getElementById('theme').value,
        // ... all your other settings
        timestamp: Date.now()
    };

    // Send to AHK
    window.chrome.webview.postMessage(settings);           // Object (recommended)
    // or
    // window.chrome.webview.postMessage(JSON.stringify(settings));
}
</script>
```

### 2. In your AHK script (WebViewToo)


On the AHK side, the `WebMessageReceived` callback receives **two parameters**:

```ahk
WebMessageReceived(wv, args)   ; ← args is a WebView2.WebMessageReceivedEventArgs object
```

Correct way to handle it:

```ahk
wv.WebMessageReceived := WebMessageReceived

WebMessageReceived(wv, args) {
    ; Get the raw JSON string sent from JS
    jsonStr := args.WebMessageAsJson
    
    ; Or try to get it as string (if JS used postMessage with a primitive/string)
    ; stringVal := args.TryGetWebMessageAsString()
    
    try {
        settings := JSON.Parse(jsonStr)   ; Use thqby's JSON
        
        ; Now you have a proper AHK object
        MsgBox "Username: " settings.username "`nTheme: " settings.theme
        
        SaveSettings(settings)
    }
    catch Error as e {
        MsgBox "Failed to parse message: " e.Message "`nRaw: " jsonStr
    }
}
```

### Pro tips:

1. Always send an **object** (not a string) when possible — WebView2 handles the JSON conversion.
2. You can send multiple types of messages by adding a `type` field:
   ```js
   window.chrome.webview.postMessage({type: "saveSettings", data: settings})
   ```
