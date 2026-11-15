namespace Ijevo.Domain.Enums;

public enum TransferStatus
{
    Draft = 0,
    PendingPayment = 1,
    PaymentProcessing = 2,
    PaymentReceived = 3,
    Disbursing = 4,
    Completed = 5,
    Failed = 6,
    Cancelled = 7,
    Refunded = 8
}
