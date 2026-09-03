/opt/homebrew/Library/Homebrew/cmd/shellenv.sh: line 18: /bin/ps: Operation not permitted
/Users/yangmizhao/.rvm/scripts/rvm:29: operation not permitted: ps
# Objective-C Nil Message Safety Demo

A small macOS command-line project based on a real API boundary problem: a backend can return a valid value, JSON `null`, a missing field, or even the wrong type. The demo normalizes those values before application code uses them.

It deliberately avoids a global `NSNull` category that swallows unknown selectors. Silent forwarding may stop one crash while hiding a broken API contract elsewhere.

## Requirements

- macOS
- Xcode Command Line Tools (`xcode-select --install` if they are not installed)

## Run

```bash
git clone https://github.com/2252408699/objc-nil-message-safety-demo.git
cd objc-nil-message-safety-demo
make run
```

The program exits with code `0` after five checks pass. It covers a valid order, an `NSNull` email, malformed container and number types, and a safe message sent to `nil`.

## Clean

```bash
make clean
```

## What the example demonstrates

- Messaging `nil` is valid in Objective-C for the ordinary scalar/object cases shown here.
- `NSNull` is a real object, not `nil`; unsupported selectors still raise an exception.
- Untrusted JSON should be validated once at the boundary.
- Explicit fallbacks make data quality problems observable and testable.

This sample is intentionally Foundation-only so it can be compiled and run without creating an Xcode project.
