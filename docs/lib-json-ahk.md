## thqby's JSON

Library to parse JSON.

### How to use it

```ahk
#Include lib\JSON.ahk

; === Parsing JSON ===
obj := JSON.Parse(jsonString)           ; returns Map / Array by default

; You can control output type:
obj := JSON.Parse(jsonString, true)     ; true = return as Map (recommended)
obj := JSON.Parse(jsonString, false)    ; false = return as Object (classic)

; Stringify : AHK object → JSON string (Sending back to WebView)
jsonStr := JSON.Stringify(obj)

; With formatting (pretty print)
jsonStr := JSON.Stringify(obj, 4)       ; 4 = indent with 4 spaces
```
