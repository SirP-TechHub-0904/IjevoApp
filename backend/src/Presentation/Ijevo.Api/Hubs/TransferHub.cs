using Microsoft.AspNetCore.SignalR;

namespace Ijevo.Api.Hubs;

public interface ITransferClient
{
    Task OnTransferStatusUpdated(string referenceNumber, string newStatus, string? note);
    Task OnKycStatusUpdated(string status, string? reason);
    Task OnWalletBalanceUpdated(string currency, decimal newBalance);
}

public class TransferHub : Hub<ITransferClient>
{
    public async Task JoinTransferGroup(string referenceNumber)
    {
        await Groups.AddToGroupAsync(Context.ConnectionId, $"transfer-{referenceNumber}");
    }

    public async Task LeaveTransferGroup(string referenceNumber)
    {
        await Groups.RemoveFromGroupAsync(Context.ConnectionId, $"transfer-{referenceNumber}");
    }

    public async Task JoinUserGroup(string userId)
    {
        await Groups.AddToGroupAsync(Context.ConnectionId, $"user-{userId}");
    }
}
