using Ijevo.Domain.Enums;

namespace Ijevo.Domain.Entities;

public class User
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public string Email { get; set; } = string.Empty;
    public string FirstName { get; set; } = string.Empty;
    public string LastName { get; set; } = string.Empty;
    
    // PII - Encrypted in database
    public string PhoneNumber { get; set; } = string.Empty;
    public string? IdentificationNumber { get; set; }

    public KycStatus KycStatus { get; set; } = KycStatus.Unverified;
    public string CountryOfResidence { get; set; } = "GB"; // e.g. GB, US
    public DateTime CreatedAtUtc { get; set; } = DateTime.UtcNow;

    public ICollection<Wallet> Wallets { get; set; } = new List<Wallet>();
    public ICollection<Recipient> Recipients { get; set; } = new List<Recipient>();
    public ICollection<Transfer> Transfers { get; set; } = new List<Transfer>();
}
