type
  Transaction* = object
    isBillSplit: bool
    lastFourDigits: int
    transactionDate: string
    transactionAmount: float
    cardType: CardType
    provinceShortName: string
    countryName: string
    transactionDirection: TransactionDirection
    externalId: string
    countryCode: string
    merchantName: string
    transactorName: string
    fxAmount: float
    fxRate: float
    fxCurrencyName: string
    city: string
    transactionType: TransactionType
    interactive: bool
    messageType: int
    transactionId: string
    transactionCategory: TransactionCategory
    i2cDescription: I2CDescription
    transactionStatus: TransactionStatus

  CardType* = enum
    PHYSICAL, VIRUTAL

  TransactionDirection* = enum
    CREDIT, DEBIT

  TransactionType* = enum
    CASH_WITHDRAWAL,
    E_TRANSFER_LOAD,
    E_TRANSFER_REQUEST,
    FOREX_FEE_REIMBURSEMENT,
    OTHER,
    PURCHASE,
    REFUND,
    SEND_MONEY,
    SEND_MONEY_REFUND

  TransactionCategory* = enum
    CASH_WITHDRAWAL,
    E_TRANSFER_DEPOSIT,
    GENERAL,
    P2P,
    PURCHASE,
    REFUND

  TransactionStatus* = enum
    PENDING,
    POSTED

