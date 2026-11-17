import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-batches',
  imports: [CommonModule],
  template: `
    <div class="inner-page-layout">
      <!-- Header -->
      <div class="page-header">
        <div class="header-left">
          <h1 class="page-title">Settlement Batches & Liquidity Queues</h1>
          <nav class="breadcrumb-nav">
            <ol class="breadcrumb">
              <li class="breadcrumb-item"><i class="fa-solid fa-house"></i> Home</li>
              <li class="breadcrumb-item">Remittance Ops</li>
              <li class="breadcrumb-item active">Settlement Batches</li>
            </ol>
          </nav>
        </div>
        <div class="header-actions">
          <button class="btn btn-outline"><i class="fa-solid fa-rotate"></i> Sync Rails</button>
          <button class="btn btn-primary"><i class="fa-solid fa-paper-plane"></i> Force Release Batch</button>
        </div>
      </div>

      <!-- Batch Overview Cards -->
      <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 20px;">
        <div class="card" style="padding: 20px;">
          <span style="font-size: 0.775rem; color: var(--text-muted); font-weight: 600;">Active Processing Queue</span>
          <h3 style="font-size: 1.4rem; font-weight: 800; color: var(--text-main); margin-top: 4px;">4 Batches Running</h3>
          <span style="font-size: 0.725rem; color: var(--primary); font-weight: 600;">1,240 transfers clearing</span>
        </div>
        <div class="card" style="padding: 20px;">
          <span style="font-size: 0.775rem; color: var(--text-muted); font-weight: 600;">Next Scheduled Cut-Off</span>
          <h3 style="font-size: 1.4rem; font-weight: 800; color: #3B82F6; margin-top: 4px;">In 14 Minutes</h3>
          <span style="font-size: 0.725rem; color: var(--text-muted);">Nigeria NIBSS 07:00 Batch</span>
        </div>
        <div class="card" style="padding: 20px;">
          <span style="font-size: 0.775rem; color: var(--text-muted); font-weight: 600;">Settled Today (24H)</span>
          <h3 style="font-size: 1.4rem; font-weight: 800; color: #00D084; margin-top: 4px;">£482,910.00</h3>
          <span style="font-size: 0.725rem; color: var(--text-muted);">18 batches cleared successfully</span>
        </div>
      </div>

      <!-- Batches Table -->
      <div class="card">
        <div class="card-header table-card-header">
          <div class="table-header-left">
            <h3 class="card-title">Settlement Queue Timeline</h3>
            <span class="badge badge-success badge-pill">Realtime Engine</span>
          </div>
        </div>

        <div class="table-responsive">
          <table class="xintra-table">
            <thead>
              <tr>
                <th>BATCH REFERENCE</th>
                <th>PAYMENT RAIL / PARTNER</th>
                <th>DESTINATION</th>
                <th>TRANSACTIONS</th>
                <th>TOTAL AMOUNT</th>
                <th>TRIGGER TIME</th>
                <th>STATUS</th>
                <th class="text-right">ACTION</th>
              </tr>
            </thead>
            <tbody>
              @for (b of batches; track b.id) {
                <tr>
                  <td><span style="font-family: monospace; font-weight: 700; color: var(--primary);">{{ b.id }}</span></td>
                  <td><strong>{{ b.rail }}</strong></td>
                  <td>{{ b.destination }}</td>
                  <td><span class="badge badge-info">{{ b.count }} txns</span></td>
                  <td><strong style="color: var(--text-main);">{{ b.total }}</strong></td>
                  <td style="font-size: 0.75rem; color: var(--text-muted);">{{ b.time }}</td>
                  <td>
                    <span class="badge badge-pill" 
                      [class.badge-success]="b.status === 'Completed'"
                      [class.badge-warning]="b.status === 'Processing'"
                      [class.badge-info]="b.status === 'Scheduled'">
                      {{ b.status }}
                    </span>
                  </td>
                  <td class="text-right">
                    <button class="btn btn-outline" style="padding: 4px 8px; font-size: 0.75rem;">View Logs</button>
                  </td>
                </tr>
              }
            </tbody>
          </table>
        </div>
      </div>
    </div>
  `
})
export class BatchesComponent {
  readonly batches = [
    { id: '#BAT-20261117-06', rail: 'NIBSS Instant Direct', destination: 'Nigeria (NGN)', count: 480, total: '₦440,160,000.00 (£240k)', time: '06:00 AM (Just now)', status: 'Processing' },
    { id: '#BAT-20261117-05', rail: 'Safaricom M-Pesa B2C', destination: 'Kenya (KES)', count: 185, total: 'KSh 14,240,000.00 (£84k)', time: '05:30 AM', status: 'Completed' },
    { id: '#BAT-20261117-04', rail: 'MTN & Vodafone GhIPSS', destination: 'Ghana (GHS)', count: 210, total: 'GH₵1,450,000.00 (£87k)', time: '05:00 AM', status: 'Completed' },
    { id: '#BAT-20261117-03', rail: 'NIBSS Instant Direct', destination: 'Nigeria (NGN)', count: 520, total: '₦476,840,000.00 (£260k)', time: '04:00 AM', status: 'Completed' },
    { id: '#BAT-20261117-02', rail: 'BankServAfrica EFT', destination: 'South Africa (ZAR)', count: 45, total: 'R 840,000.00 (£35k)', time: '03:00 AM', status: 'Completed' },
    { id: '#BAT-20261117-07', rail: 'NIBSS Instant Direct', destination: 'Nigeria (NGN)', count: 320, total: '₦293,440,000.00 (£160k)', time: '07:00 AM (In 14m)', status: 'Scheduled' }
  ];
}
