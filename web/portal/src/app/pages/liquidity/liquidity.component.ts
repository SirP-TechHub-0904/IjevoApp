import { Component, signal } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-liquidity',
  imports: [CommonModule],
  template: `
    <div class="inner-page-layout">
      <!-- Header -->
      <div class="page-header">
        <div class="header-left">
          <h1 class="page-title">Treasury & Liquidity Pools</h1>
          <nav class="breadcrumb-nav">
            <ol class="breadcrumb">
              <li class="breadcrumb-item"><i class="fa-solid fa-house"></i> Home</li>
              <li class="breadcrumb-item">Dashboards</li>
              <li class="breadcrumb-item active">Liquidity Pools</li>
            </ol>
          </nav>
        </div>
        <div class="header-actions">
          <button class="btn btn-outline"><i class="fa-solid fa-sliders"></i> Rebalance Thresholds</button>
          <button class="btn btn-primary"><i class="fa-solid fa-arrow-right-arrow-left"></i> Initiate Treasury Transfer</button>
        </div>
      </div>

      <!-- Vault Cards -->
      <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap: 20px;">
        @for (v of vaults; track v.currency) {
          <div class="card" style="padding: 22px;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
              <div style="display: flex; align-items: center; gap: 8px;">
                <span style="font-size: 1.4rem;">{{ v.flag }}</span>
                <div>
                  <h4 style="font-size: 0.95rem; font-weight: 700; color: var(--text-main);">{{ v.name }}</h4>
                  <span style="font-size: 0.725rem; color: var(--text-muted);">{{ v.bank }} &bull; {{ v.account }}</span>
                </div>
              </div>
              <span class="badge" [ngClass]="v.statusClass">{{ v.status }}</span>
            </div>

            <div style="margin: 16px 0;">
              <span style="font-size: 0.75rem; color: var(--text-muted);">Available Vault Balance</span>
              <h2 style="font-size: 1.55rem; font-weight: 800; color: var(--text-main); margin-top: 2px;">{{ v.balance }}</h2>
              <span style="font-size: 0.75rem; color: var(--primary); font-weight: 600;">Approx. £{{ v.gbpEquiv }}</span>
            </div>

            <div style="border-top: 1px dashed var(--border-color); padding-top: 12px; display: flex; justify-content: space-between; font-size: 0.75rem;">
              <span style="color: var(--text-muted);">Minimum Reserve: {{ v.minReserve }}</span>
              <span style="color: var(--text-main); font-weight: 700;">Buffer: {{ v.buffer }}</span>
            </div>
          </div>
        }
      </div>

      <!-- Treasury Sweep History -->
      <div class="card">
        <div class="card-header table-card-header">
          <div class="table-header-left">
            <h3 class="card-title">Recent Automated Liquidity Rebalances</h3>
            <span class="badge badge-info badge-pill">Hedging Engine Active</span>
          </div>
          <div class="table-header-right">
            <button class="btn btn-outline" style="padding: 6px 12px; font-size: 0.775rem;">
              <i class="fa-solid fa-download"></i> Export Statement
            </button>
          </div>
        </div>

        <div class="table-responsive">
          <table class="xintra-table">
            <thead>
              <tr>
                <th>SWEEP ID</th>
                <th>FROM VAULT</th>
                <th>TO LIQUIDITY POOL</th>
                <th>AMOUNT</th>
                <th>FX RATE</th>
                <th>CLEARED AT</th>
                <th>STATUS</th>
              </tr>
            </thead>
            <tbody>
              @for (s of sweeps; track s.id) {
                <tr>
                  <td><span style="font-family: monospace; font-weight: 700; color: var(--primary);">{{ s.id }}</span></td>
                  <td>{{ s.from }}</td>
                  <td>{{ s.to }}</td>
                  <td><strong style="color: var(--text-main);">{{ s.amount }}</strong></td>
                  <td>{{ s.rate }}</td>
                  <td style="color: var(--text-muted); font-size: 0.75rem;">{{ s.time }}</td>
                  <td><span class="badge badge-success badge-pill"><i class="fa-solid fa-check"></i> Cleared</span></td>
                </tr>
              }
            </tbody>
          </table>
        </div>
      </div>
    </div>
  `
})
export class LiquidityComponent {
  readonly vaults = [
    { name: 'Nigerian Naira Vault', flag: '🇳🇬', currency: 'NGN', bank: 'Zenith Bank Plc', account: '•••• 8812', balance: '₦1,850,000,000.00', gbpEquiv: '1,002,166.85', minReserve: '₦500M', buffer: '+270%', status: 'Optimal', statusClass: 'badge-success' },
    { name: 'UK Sterling Reserve', flag: '🇬🇧', currency: 'GBP', bank: 'ClearBank London', account: '•••• 1904', balance: '£1,420,500.00', gbpEquiv: '1,420,500.00', minReserve: '£500K', buffer: '+184%', status: 'Optimal', statusClass: 'badge-success' },
    { name: 'Euro Treasury Buffer', flag: '🇪🇺', currency: 'EUR', bank: 'Euronet Direct', account: '•••• 7160', balance: '€920,400.00', gbpEquiv: '778,670.00', minReserve: '€300K', buffer: '+206%', status: 'Optimal', statusClass: 'badge-success' },
    { name: 'Kenya Shilling Pool', flag: '🇰🇪', currency: 'KES', bank: 'Safaricom Escrow', account: '•••• 3391', balance: 'KSh 68,450,000.00', gbpEquiv: '406,472.00', minReserve: 'KSh 20M', buffer: '+242%', status: 'Optimal', statusClass: 'badge-success' }
  ];

  readonly sweeps = [
    { id: '#SWP-4109', from: 'ClearBank London (GBP)', to: 'Zenith Bank Treasury (NGN)', amount: '£250,000.00 (₦461.5M)', rate: '1,846.00', time: 'Today at 04:15 AM' },
    { id: '#SWP-4108', from: 'Euronet Direct (EUR)', to: 'Zenith Bank Treasury (NGN)', amount: '€180,000.00 (₦287.1M)', rate: '1,595.20', time: 'Yesterday at 11:30 PM' },
    { id: '#SWP-4107', from: 'ClearBank London (GBP)', to: 'Safaricom Escrow (KES)', amount: '£100,000.00 (KSh 16.84M)', rate: '168.40', time: 'Nov 15, 2026' },
    { id: '#SWP-4106', from: 'Barclays International (USD)', to: 'Zenith Bank Treasury (NGN)', amount: '$300,000.00 (₦444.1M)', rate: '1,480.50', time: 'Nov 14, 2026' }
  ];
}
