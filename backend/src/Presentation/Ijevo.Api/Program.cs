using Hangfire;
using Hangfire.SqlServer;
using Ijevo.Api.Hubs;
using Ijevo.Infrastructure.Data;
using Ijevo.Shared.Security;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

// 1. Core Services & Security
builder.Services.AddSingleton<IAesEncryptionService>(sp =>
{
    var configKey = builder.Configuration["Security:AesKey"] ?? string.Empty;
    return new AesEncryptionService(configKey);
});

// 2. Database Context (MSSQL)
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection") 
    ?? "Server=(localdb)\\mssqllocaldb;Database=IjevoDb;Trusted_Connection=True;MultipleActiveResultSets=true;TrustServerCertificate=True";

builder.Services.AddDbContext<IjevoDbContext>((sp, options) =>
{
    options.UseSqlServer(connectionString);
});

// 3. SignalR WebSockets (Instant Real-time Sync)
builder.Services.AddSignalR();

// 4. Hangfire Background Job Queue (Email Pool & Auto-retries)
builder.Services.AddHangfire(configuration => configuration
    .SetDataCompatibilityLevel(CompatibilityLevel.Version_180)
    .UseSimpleAssemblyNameTypeSerializer()
    .UseRecommendedSerializerSettings()
    .UseSqlServerStorage(connectionString, new SqlServerStorageOptions
    {
        CommandBatchMaxTimeout = TimeSpan.FromMinutes(5),
        SlidingInvisibilityTimeout = TimeSpan.FromMinutes(5),
        QueuePollInterval = TimeSpan.Zero,
        UseRecommendedIsolationLevel = true,
        DisableGlobalLocks = true
    }));

builder.Services.AddHangfireServer();

// 5. CORS for Flutter, Angular Admin & Website
builder.Services.AddCors(options =>
{
    options.AddPolicy("IjevoCorsPolicy", policy =>
    {
        policy.WithOrigins(
                "http://localhost:4200", // Angular Admin
                "http://localhost:4300", // Angular Website
                "http://localhost:3000"
            )
            .AllowAnyHeader()
            .AllowAnyMethod()
            .AllowCredentials(); // Required for SignalR WebSockets
    });
});

builder.Services.AddControllers();
builder.Services.AddOpenApi();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.UseHttpsRedirection();
app.UseCors("IjevoCorsPolicy");

// 6. Realtime SignalR Endpoint
app.MapHub<TransferHub>("/hubs/transfers");

// 7. Hangfire Background Dashboard
app.MapHangfireDashboard("/hangfire");

// 8. Health & Info Endpoint
app.MapGet("/api/health", () => Results.Ok(new
{
    status = "Healthy",
    service = "Ijevo Remittance Engine",
    version = "1.0.0",
    engine = ".NET 9",
    timestamp = DateTime.UtcNow
}));

app.Run();
