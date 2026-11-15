namespace Ijevo.Domain.Entities;

public class Quote
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public string SourceCurrency { get; set; } = "GBP";
    public string DestinationCurrency { get; set; } = "NGN";
    
    public decimal SourceAmount { get; set; }
    public decimal DestinationAmount { get; set; }
    
    public decimal MarketExchangeRate { get; set; }
    public decimal AppliedExchangeRate { get; set; }
    public decimal SpreadPercentage { get; set; }
    public decimal TransferFee { get; set; } = 0.00m;

    public DateTime ExpiresAtUtc { get; set; }
    public bool IsUsed { get; set; } = false;
    public DateTime CreatedAtUtc { get; set; } = DateTime.UtcNow;
}
