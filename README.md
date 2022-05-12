# Stacker
A CLI tool to interact with the API for the Stack Mastercard at [getstack.ca](https://getstack.ca)

## Installation
```console
$ nimble install https://github.com/ynfle/stacker
```

## Usage
Requires 3 API keys to be ENV variables
1. `STACK_PIN_API_KEY`
2. `STACK_TEMP_API_KEY`
3. `STACK_X_API_KEY`

These can be found by inspecting the request on the "Actiivty" page of the stack website (once logged in) with the request `you?startDate...`

```console
$ stacker
```

By default, `transactions.json` is save to the OSes native cache directory under `stacker/transactions.json` (See [`getCacheDir`](https://nim-lang.github.io/Nim/os.html#getCacheDir))

