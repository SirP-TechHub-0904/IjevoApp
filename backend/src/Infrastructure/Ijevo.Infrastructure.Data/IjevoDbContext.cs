using Ijevo.Domain.Entities;
using Ijevo.Shared.Security;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;

namespace Ijevo.Infrastructure.Data;

public class IjevoDbContext : DbContext
{
    private readonly IAesEncryptionService? _encryptionService;

    public IjevoDbContext(DbContextOptions<IjevoDbContext> options, IAesEncryptionService? encryptionService = null)
        : base(options)
    {
        _encryptionService = encryptionService;
    }

    public DbSet<User> Users => Set<User>();
    public DbSet<Recipient> Recipients => Set<Recipient>();
    public DbSet<Quote> Quotes => Set<Quote>();
    public DbSet<Transfer> Transfers => Set<Transfer>();
    public DbSet<Wallet> Wallets => Set<Wallet>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // If encryption service is available, apply encryption converter to PII columns
        if (_encryptionService != null)
        {
            var encryptConverter = new ValueConverter<string, string>(
                v => _encryptionService.Encrypt(v),
                v => _encryptionService.Decrypt(v)
            );

            var encryptNullableConverter = new ValueConverter<string?, string?>(
                v => v == null ? null : _encryptionService.Encrypt(v),
                v => v == null ? null : _encryptionService.Decrypt(v)
            );

            // Encrypt user sensitive info
            modelBuilder.Entity<User>(builder =>
            {
                builder.Property(u => u.PhoneNumber).HasConversion(encryptConverter);
                builder.Property(u => u.IdentificationNumber).HasConversion(encryptNullableConverter);
            });

            // Encrypt recipient sensitive bank info
            modelBuilder.Entity<Recipient>(builder =>
            {
                builder.Property(r => r.AccountNumber).HasConversion(encryptNullableConverter);
                builder.Property(r => r.MobileNumber).HasConversion(encryptNullableConverter);
            });
        }

        // User Configuration
        modelBuilder.Entity<User>(builder =>
        {
            builder.HasKey(u => u.Id);
            builder.HasIndex(u => u.Email).IsUnique();
            builder.Property(u => u.Email).HasMaxLength(256).IsRequired();
            builder.Property(u => u.FirstName).HasMaxLength(100);
            builder.Property(u => u.LastName).HasMaxLength(100);
        });

        // Recipient Configuration
        modelBuilder.Entity<Recipient>(builder =>
        {
            builder.HasKey(r => r.Id);
            builder.Property(r => r.FullName).HasMaxLength(200).IsRequired();
            builder.Property(r => r.DestinationCountryCode).HasMaxLength(3).IsRequired();
            builder.Property(r => r.DestinationCurrency).HasMaxLength(3).IsRequired();
        });

        // Transfer Configuration
        modelBuilder.Entity<Transfer>(builder =>
        {
            builder.HasKey(t => t.Id);
            builder.HasIndex(t => t.ReferenceNumber).IsUnique();
            builder.Property(t => t.ReferenceNumber).HasMaxLength(50).IsRequired();
            builder.Property(t => t.SendAmount).HasPrecision(18, 4);
            builder.Property(t => t.PayoutAmount).HasPrecision(18, 4);
            builder.Property(t => t.GrossProfitGbp).HasPrecision(18, 4);
            builder.Property(t => t.SendCurrency).HasMaxLength(3).IsRequired();
            builder.Property(t => t.PayoutCurrency).HasMaxLength(3).IsRequired();
        });

        // Quote Configuration
        modelBuilder.Entity<Quote>(builder =>
        {
            builder.HasKey(q => q.Id);
            builder.Property(q => q.SourceAmount).HasPrecision(18, 4);
            builder.Property(q => q.DestinationAmount).HasPrecision(18, 4);
            builder.Property(q => q.MarketExchangeRate).HasPrecision(18, 6);
            builder.Property(q => q.AppliedExchangeRate).HasPrecision(18, 6);
            builder.Property(q => q.SpreadPercentage).HasPrecision(5, 2);
            builder.Property(q => q.TransferFee).HasPrecision(18, 4);
        });

        // Wallet Configuration
        modelBuilder.Entity<Wallet>(builder =>
        {
            builder.HasKey(w => w.Id);
            builder.HasIndex(w => new { w.UserId, w.Currency }).IsUnique();
            builder.Property(w => w.Currency).HasMaxLength(3).IsRequired();
            builder.Property(w => w.Balance).HasPrecision(18, 4);
        });
    }
}

public class IjevoDbContextFactory : IDesignTimeDbContextFactory<IjevoDbContext>
{
    public IjevoDbContext CreateDbContext(string[] args)
    {
        var optionsBuilder = new DbContextOptionsBuilder<IjevoDbContext>();
        optionsBuilder.UseSqlServer("Server=(localdb)\\mssqllocaldb;Database=IjevoDb_Design;Trusted_Connection=True;TrustServerCertificate=True");
        
        // Pass a dummy 32-byte key for EF Core design-time migrations tooling
        var dummyKey = Convert.ToBase64String(new byte[32]);
        return new IjevoDbContext(optionsBuilder.Options, new AesEncryptionService(dummyKey));
    }
}
