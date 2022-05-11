import std/[asyncdispatch, httpclient, json, options, strformat, strutils, tables, times]

let headers = newHttpHeaders({
    "accept": "application/json, text/plain, */*",
    "accept-language": "en-US,en;q=0.9,he;q=0.8",
    "app-agent": "web",
    "app-version": "2.0.0",
    "cache-control": "no-cache",
    "org": "stack",
    "pin-api-key": "",
    "pragma": "no-cache",
    "sec-ch-ua": "\" Not A;Brand\";v=\"99\", \"Chromium\";v=\"100\", \"Google Chrome\";v=\"100\"",
    "sec-ch-ua-mobile": "?0",
    "sec-ch-ua-platform": "",
    "sec-fetch-dest": "empty",
    "sec-fetch-mode": "cors",
    "sec-fetch-site": "same-site",
    "temp-api-key": "",
    "x-api-key": "",
    "Referer": "https://account.getstack.ca/",
    "Referrer-Policy": "strict-origin-when-cross-origin"
})

proc getMonthTransaction(year: range[2019..int.high], month: Month): Future[JsonNode] {.async.} =
  echo year, ',', month
  let
    client = newAsyncHttpClient(headers = headers)
    url = &"https://api.getstack.ca/stackStory/you?startDate={year}-{($month.int).align(2, '0')}-01"
    response = await client.get(url)
  result =
    if response.code == Http200:
      parseJson(await response.body)
    else:
      stderr.writeLine url, '\n', await response.body
      newJNull()

proc `%`*[T: tuple](o: T): JsonNode =
  ## Construct JsonNode from tuples and objects.
  result = newJObject()
  for k, v in o.fieldPairs: result[k] = %v

proc main() {.async.} =
  const fileName = "transactions.json"

  writeFile(fileName, "")

  var file: File
  try:
    if open(file, "transactions.json", fmAppend):
      for year in 2019..2022:
        for month in Month:
          let transactions = await getMonthTransaction(year, month)
          if transactions.kind == JArray and transactions.len > 0:
            for transaction in transactions:
              file.writeLine transaction["transaction"]
  except:
    echo getCurrentExceptionMsg()
  finally:
    file.close

when isMainModule:
  waitFor main()

