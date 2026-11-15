using Ijevo.Domain.Enums;

namespace Ijevo.Domain.Entities;

public class Transfer
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public string ReferenceNumber { get; set; } = string.Empty; // e.g. "IJV-202611-9842"
    
    public Guid UserId { get; set; }
    public User User { get; set; } = null!;

    public Guid RecipientId { get; set; }
    public Recipient Recipient { get; set; } = null!;

    public Guid QuoteId { get; set; }
    public Quote Quote { get; set; } = null!;

    public decimal SendAmount { get; set; }
    public string SendCurrency { get; set; } = "GBP";

    public decimal PayoutAmount { get; set; }
    public string PayoutCurrency { get; set; } = "NGN";

    public decimal GrossProfitGbp { get; set; } // Financial tracking
    public TransferStatus Status { get; set; } = TransferStatus.Draft;

    // Payment Collection (Inbound - Plaid / Stripe)
    public PaymentMethodType PaymentMethod { get; set; }
    public string? PaymentIntentId { get; set; } // Stripe PaymentIntent or Plaid PaymentId
    public string? PaymentReference { get; set; }

    // Payout Disbursement (Outbound - Flutterwave / Thunes)
    public string? PayoutProviderId { get; set; } // Flutterwave transfer ID
    public string? PayoutProviderReference { get; set; }
    public string? FailureReason { get; set; }

    public DateTime CreatedAtUtc { get; set; } = DateTime.UtcNow;
    public DateTime? PaidAtUtc { get; set; }
    public DateTime? DisbursedAtUtc { get; set; }
}
