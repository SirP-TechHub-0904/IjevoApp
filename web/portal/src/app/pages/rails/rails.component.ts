import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-rails',
  imports: [CommonModule],
  template: `
    <div class="inner-page-layout">
      <!-- Header -->
      <div class="page-header">
        <div class="header-left">
          <h1 class="page-title">Clearing Rails & Gateway Integrations</h1>
          <nav class="breadcrumb-nav">
            <ol class="breadcrumb">
              <li class="breadcrumb-item"><i class="fa-solid fa-house"></i> Home</li>
              <li class="breadcrumb-item">Remittance Ops</li>
              <li class="breadcrumb-item active">Clearing Rails</li>
            </ol>
          </nav>
        </div>
        <div class="header-actions">
          <button class="btn btn-outline"><i class="fa-solid fa-vial"></i> Run Diagnostics</button>
          <button class="btn btn-primary"><i class="fa-solid fa-plus"></i> Connect Gateway</button>
        </div>
      </div>

      <!-- Rail Cards -->
      <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px;">
        @for (r of rails; track r.name) {
          <div class="card" style="padding: 20px;">
            <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 12px;">
              <div>
                <h3 style="font-size: 1rem; font-weight: 700; color: var(--text-main); margin-bottom: 2px;">{{ r.name }}</h3>
                <span style="font-size: 0.75rem; color: var(--text-muted);">{{ r.provider }} &bull; {{ r.corridor }}</span>
              </div>
              <span class="badge badge-success badge-pill"><i class="fa-solid fa-circle" style="font-size: 8px;"></i> {{ r.status }}</span>
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin: 16px 0;">
              <div style="background: var(--bg-subtle); padding: 10px; border-radius: var(--radius-sm);">
                <span style="font-size: 0.7rem; color: var(--text-muted); display: block;">Latency</span>
                <strong style="color: var(--primary); font-size: 1.1rem;">{{ r.latency }}</strong>
              </div>
              <div style="background: var(--bg-subtle); padding: 10px; border-radius: var(--radius-sm);">
                <span style="font-size: 0.7rem; color: var(--text-muted); display: block;">Uptime SLA</span>
                <strong style="color: var(--text-main); font-size: 1.1rem;">{{ r.uptime }}</strong>
              </div>
            </div>

            <div style="border-top: 1px dashed var(--border-color); padding-top: 12px; display: flex; justify-content: space-between; font-size: 0.75rem; color: var(--text-muted);">
              <span>Failover: {{ r.failover }}</span>
              <span>Daily Volume: {{ r.volume }}</span>
            </div>
          </div>
        }
      </div>
    </div>
  `
})
export class RailsComponent {
  readonly rails = [
    { name: 'UK Faster Payments Service', provider: 'ClearBank API', corridor: 'GBP Inflow', latency: '22ms', uptime: '100%', failover: 'Modulr UK Rail', volume: '£1.42M', status: 'Operational' },
    { name: 'NIBSS Instant Payment (NIP)', provider: 'Paystack & Direct NIBSS', corridor: 'NGN Direct Payout', latency: '84ms', uptime: '99.85%', failover: 'Flutterwave Backup', volume: '£2.10M', status: 'Operational' },
    { name: 'SEPA TIPS Instant', provider: 'Banking Circle EU', corridor: 'EUR Inflow/Payout', latency: '112ms', uptime: '99.90%', failover: 'Euronet SEPA', volume: '€680K', status: 'Operational' },
    { name: 'Safaricom M-Pesa B2C', provider: 'Safaricom Daraja API', corridor: 'KES Mobile Wallet', latency: '38ms', uptime: '100%', failover: 'Equity Bank Rail', volume: 'KSh 74M', status: 'Operational' },
    { name: 'GhIPSS Instant Pay & MoMo', provider: 'Hubtel Ghana', corridor: 'GHS Bank & Mobile', latency: '92ms', uptime: '99.60%', failover: 'Zeepay Rail', volume: 'GH₵3.8M', status: 'Operational' }
  ];
}
