namespace Ijevo.Domain.Entities;

public class Wallet
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public Guid UserId { get; set; }
    public User User { get; set; } = null!;

    public string Currency { get; set; } = "GBP"; // GBP, NGN, KES, USD
    public decimal Balance { get; set; } = 0.00m;
    public bool IsActive { get; set; } = true;
    public DateTime UpdatedAtUtc { get; set; } = DateTime.UtcNow;
}
