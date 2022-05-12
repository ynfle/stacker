import std/[asyncdispatch, httpclient, json, options, os, strformat, strutils, tables, times]

proc getMonthTransaction(year: range[2019..int.high], month: Month): Future[JsonNode] {.async.} =
  let
    headers = newHttpHeaders({
      "accept": "application/json, text/plain, */*",
      "accept-language": "en-US,en;q=0.9,he;q=0.8",
      "app-agent": "web",
      "app-version": "2.0.0",
      "cache-control": "no-cache",
      "org": "stack",
      "pin-api-key": getEnv("STACK_PIN_API_KEY"),
      "pragma": "no-cache",
      "sec-ch-ua": "\" Not A;Brand\";v=\"99\", \"Chromium\";v=\"100\", \"Google Chrome\";v=\"100\"",
      "sec-ch-ua-mobile": "?0",
      "sec-ch-ua-platform": "",
      "sec-fetch-dest": "empty",
      "sec-fetch-mode": "cors",
      "sec-fetch-site": "same-site",
      "temp-api-key": getEnv("STACK_TEMP_API_KEY"),
      "x-api-key": getEnv("STACK_X_API_KEY"),
      "Referer": "https://account.getstack.ca/",
      "Referrer-Policy": "strict-origin-when-cross-origin"
    })
    client = newAsyncHttpClient(headers = headers)
    url = &"https://api.getstack.ca/stackStory/you?startDate={year}-{($month.int).align(2, '0')}-01"
    response = await client.get(url)

  result =
    if response.code == Http200:
      parseJson(await response.body)
    else:
      echo await response.body
      newJNull()

proc `%`*[T: tuple](o: T): JsonNode =
  ## Construct JsonNode from tuples and objects.
  result = newJObject()
  for k, v in o.fieldPairs: result[k] = %v

proc main*() {.async.} =
  const
    fileName = "transactions.json"
  let
    cacheDir = block:
      let dir = getCacheDir("stacker")
      discard dir.existsOrCreateDir
      dir
    cacheFile = cacheDir / fileName

  writeFile(fileName, "")

  var file: File
  try:
    if open(file, cacheFile, fmAppend):
      for year in 2019..2022:
        for month in Month:
          let transactions = await getMonthTransaction(year, month)
          if transactions.kind == JArray and transactions.len > 0:
            for transaction in transactions:
              file.writeLine transaction["transaction"]
  except:
    echo getCurrentExceptionMsg()
    quit(QuitFailure)
  finally:
    file.close

when isMainModule:
  waitFor main()

