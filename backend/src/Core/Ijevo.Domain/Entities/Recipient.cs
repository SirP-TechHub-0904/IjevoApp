using Ijevo.Domain.Enums;

namespace Ijevo.Domain.Entities;

public class Recipient
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public Guid UserId { get; set; }
    public User User { get; set; } = null!;

    public string FullName { get; set; } = string.Empty;
    public string DestinationCountryCode { get; set; } = string.Empty; // e.g. "NG", "KE", "GH"
    public string DestinationCurrency { get; set; } = string.Empty;    // e.g. "NGN", "KES"
    public PayoutMethodType PayoutMethod { get; set; }

    // Bank Details (PII - Encrypted in database)
    public string? BankCode { get; set; }
    public string? BankName { get; set; }
    public string? AccountNumber { get; set; }

    // Mobile Money Details (if applicable)
    public string? MobileMoneyOperator { get; set; } // e.g. "MTN", "M-PESA"
    public string? MobileNumber { get; set; }

    public DateTime CreatedAtUtc { get; set; } = DateTime.UtcNow;
}
