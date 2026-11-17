import { Component, signal } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-overview',
  imports: [CommonModule],
  template: `
    <div class="inner-page-layout">
      <!-- Header -->
      <div class="page-header">
        <div class="header-left">
          <h1 class="page-title">Remittance Operations Overview</h1>
          <nav class="breadcrumb-nav">
            <ol class="breadcrumb">
              <li class="breadcrumb-item"><i class="fa-solid fa-house"></i> Home</li>
              <li class="breadcrumb-item">Dashboards</li>
              <li class="breadcrumb-item active">Overview</li>
            </ol>
          </nav>
        </div>
        <div class="header-actions">
          <button class="btn btn-outline"><i class="fa-solid fa-rotate"></i> Refresh Feed</button>
          <button class="btn btn-primary"><i class="fa-solid fa-file-invoice"></i> Daily Audit Report</button>
        </div>
      </div>

      <!-- Quick Metrics -->
      <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 20px;">
        <div class="card" style="padding: 20px;">
          <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
            <span style="font-size: 0.85rem; color: var(--text-muted); font-weight: 600;">Today's Inflow</span>
            <span class="badge badge-success"><i class="fa-solid fa-arrow-up"></i> +18.4%</span>
          </div>
          <h2 style="font-size: 1.6rem; font-weight: 800; color: var(--text-main); margin-bottom: 4px;">£482,910.00</h2>
          <span style="font-size: 0.75rem; color: var(--text-muted);">2,419 successful payouts today</span>
        </div>

        <div class="card" style="padding: 20px;">
          <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
            <span style="font-size: 0.85rem; color: var(--text-muted); font-weight: 600;">Liquidity In-Flight</span>
            <span class="badge badge-info">Safe</span>
          </div>
          <h2 style="font-size: 1.6rem; font-weight: 800; color: var(--text-main); margin-bottom: 4px;">£1,842,000</h2>
          <span style="font-size: 0.75rem; color: var(--text-muted);">Across 4 international clearing pools</span>
        </div>

        <div class="card" style="padding: 20px;">
          <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
            <span style="font-size: 0.85rem; color: var(--text-muted); font-weight: 600;">Active Payout Corridors</span>
            <span class="badge badge-success">100% Up</span>
          </div>
          <h2 style="font-size: 1.6rem; font-weight: 800; color: var(--text-main); margin-bottom: 4px;">12 Live</h2>
          <span style="font-size: 0.75rem; color: var(--text-muted);">UK, EU, US ➔ NG, GH, KE, ZA, RW</span>
        </div>

        <div class="card" style="padding: 20px;">
          <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
            <span style="font-size: 0.85rem; color: var(--text-muted); font-weight: 600;">Settlement SLA</span>
            <span class="badge badge-success">38s Avg</span>
          </div>
          <h2 style="font-size: 1.6rem; font-weight: 800; color: var(--text-main); margin-bottom: 4px;">99.82%</h2>
          <span style="font-size: 0.75rem; color: var(--text-muted);">Instant delivery under 60 seconds</span>
        </div>
      </div>

      <!-- Corridor Operations Grid -->
      <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 20px;" class="overview-grid">
        <div class="card">
          <div class="card-header">
            <div>
              <h3 class="card-title">Live Settlement Rails Health</h3>
              <p style="font-size: 0.775rem; color: var(--text-muted); margin-top: 2px;">Direct bank and mobile wallet API latency & response time</p>
            </div>
            <span class="badge badge-success badge-pill">All Systems Active</span>
          </div>
          <div class="card-body" style="padding: 0;">
            <div class="table-responsive">
              <table class="xintra-table">
                <thead>
                  <tr>
                    <th>GATEWAY RAIL</th>
                    <th>DESTINATION</th>
                    <th>LATENCY</th>
                    <th>SUCCESS RATE</th>
                    <th>DAILY VOLUME</th>
                    <th>STATUS</th>
                  </tr>
                </thead>
                <tbody>
                  @for (r of rails; track r.name) {
                    <tr>
                      <td><strong style="color: var(--text-main);">{{ r.name }}</strong></td>
                      <td>{{ r.country }}</td>
                      <td><span style="color: var(--primary); font-weight: 700;">{{ r.latency }}</span></td>
                      <td>{{ r.success }}</td>
                      <td>{{ r.volume }}</td>
                      <td><span class="badge badge-success badge-pill">{{ r.status }}</span></td>
                    </tr>
                  }
                </tbody>
              </table>
            </div>
          </div>
        </div>

        <div class="card">
          <div class="card-header">
            <h3 class="card-title">Liquidity Utilization</h3>
            <span class="badge badge-info">Realtime</span>
          </div>
          <div class="card-body" style="display: flex; flex-direction: column; gap: 16px;">
            @for (c of liquidityPools; track c.name) {
              <div>
                <div style="display: flex; justify-content: space-between; font-size: 0.825rem; margin-bottom: 6px;">
                  <span style="font-weight: 600; color: var(--text-main);">{{ c.name }}</span>
                  <span style="font-weight: 700; color: var(--text-main);">{{ c.amount }}</span>
                </div>
                <div style="height: 6px; background: var(--bg-subtle); border-radius: 9999px; overflow: hidden;">
                  <div [style.width.%]="c.percent" [style.background-color]="c.color" style="height: 100%; border-radius: 9999px;"></div>
                </div>
                <div style="display: flex; justify-content: space-between; font-size: 0.725rem; color: var(--text-muted); margin-top: 4px;">
                  <span>Buffer: {{ c.percent }}% utilized</span>
                  <span>Target: {{ c.target }}</span>
                </div>
              </div>
            }
          </div>
        </div>
      </div>
    </div>
  `
})
export class OverviewComponent {
  readonly rails = [
    { name: 'UK Faster Payments', country: 'United Kingdom', latency: '22ms', success: '99.98%', volume: '£1.42M', status: 'Operational' },
    { name: 'NIBSS Instant Rail', country: 'Nigeria', latency: '84ms', success: '99.85%', volume: '£2.10M', status: 'Operational' },
    { name: 'SEPA TIPS Instant', country: 'Eurozone', latency: '112ms', success: '99.90%', volume: '€680K', status: 'Operational' },
    { name: 'Safaricom M-Pesa B2C', country: 'Kenya', latency: '38ms', success: '100%', volume: 'KSh 74M', status: 'Operational' },
    { name: 'GhIPSS MoMo Clearing', country: 'Ghana', latency: '92ms', success: '99.60%', volume: 'GH₵3.8M', status: 'Operational' }
  ];

  readonly liquidityPools = [
    { name: 'Zenith Bank Treasury (NGN)', amount: '₦1,850,000,000', percent: 68, color: '#00D084', target: '₦2.5B' },
    { name: 'ClearBank London (GBP)', amount: '£1,420,000', percent: 54, color: '#3B82F6', target: '£2.0M' },
    { name: 'Euronet Vault (EUR)', amount: '€920,000', percent: 42, color: '#8B5CF6', target: '€1.5M' },
    { name: 'Safaricom Escrow (KES)', amount: 'KSh 68,000,000', percent: 76, color: '#F59E0B', target: 'KSh 90M' }
  ];
}
