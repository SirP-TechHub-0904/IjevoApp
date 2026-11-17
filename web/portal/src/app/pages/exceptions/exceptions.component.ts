import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-exceptions',
  imports: [CommonModule],
  template: `
    <div class="inner-page-layout">
      <!-- Header -->
      <div class="page-header">
        <div class="header-left">
          <h1 class="page-title">Payout Exceptions & Review Desk</h1>
          <nav class="breadcrumb-nav">
            <ol class="breadcrumb">
              <li class="breadcrumb-item"><i class="fa-solid fa-house"></i> Home</li>
              <li class="breadcrumb-item">Remittance Ops</li>
              <li class="breadcrumb-item active">Exceptions</li>
            </ol>
          </nav>
        </div>
        <div class="header-actions">
          <button class="btn btn-outline"><i class="fa-solid fa-rotate"></i> Retry All Eligible</button>
          <button class="btn btn-danger"><i class="fa-solid fa-ban"></i> Bulk Refund</button>
        </div>
      </div>

      <!-- Alert Banner -->
      <div class="card" style="padding: 16px 20px; border-left: 4px solid #EF4444; background: rgba(239, 68, 68, 0.04);">
        <div style="display: flex; align-items: center; justify-content: space-between; flex-wrap: gap: 12px;">
          <div style="display: flex; align-items: center; gap: 12px;">
            <i class="fa-solid fa-triangle-exclamation" style="font-size: 1.25rem; color: #EF4444;"></i>
            <div>
              <strong style="color: var(--text-main); font-size: 0.9rem;">5 Exceptions Require Manual Intervention</strong>
              <p style="font-size: 0.775rem; color: var(--text-muted); margin: 0;">3 Account verification mismatches and 2 partner gateway timeout rejects.</p>
            </div>
          </div>
          <span class="badge badge-danger badge-pill">Action Needed</span>
        </div>
      </div>

      <!-- Exceptions Table -->
      <div class="card">
        <div class="card-header table-card-header">
          <div class="table-header-left">
            <h3 class="card-title">Pending Exception Queue</h3>
          </div>
        </div>

        <div class="table-responsive">
          <table class="xintra-table">
            <thead>
              <tr>
                <th>TXN REF</th>
                <th>SENDER</th>
                <th>BENEFICIARY DETAILS</th>
                <th>CORRIDOR</th>
                <th>AMOUNT</th>
                <th>ERROR REASON</th>
                <th>ATTEMPTS</th>
                <th class="text-right">RESOLVE ACTIONS</th>
              </tr>
            </thead>
            <tbody>
              @for (e of exceptions; track e.id) {
                <tr>
                  <td><span style="font-family: monospace; font-weight: 700; color: #EF4444;">{{ e.id }}</span></td>
                  <td><strong>{{ e.sender }}</strong></td>
                  <td>
                    <div style="display: flex; flex-direction: column;">
                      <span style="font-weight: 600; color: var(--text-main);">{{ e.recipient }}</span>
                      <span style="font-size: 0.725rem; color: var(--text-muted);">{{ e.details }}</span>
                    </div>
                  </td>
                  <td><span class="badge badge-info">{{ e.corridor }}</span></td>
                  <td><strong style="color: var(--text-main);">{{ e.amount }}</strong></td>
                  <td>
                    <span class="badge badge-danger">
                      <i class="fa-solid fa-circle-exclamation"></i> {{ e.reason }}
                    </span>
                  </td>
                  <td><span style="font-size: 0.75rem; color: var(--text-muted);">{{ e.retries }}/3 Retries</span></td>
                  <td class="text-right">
                    <div style="display: inline-flex; gap: 6px;">
                      <button class="btn btn-outline btn-sm"><i class="fa-solid fa-arrow-rotate-right"></i> Retry</button>
                      <button class="btn btn-primary btn-sm"><i class="fa-solid fa-pen"></i> Edit Acct</button>
                      <button class="btn btn-danger btn-sm"><i class="fa-solid fa-rotate-left"></i> Refund</button>
                    </div>
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
export class ExceptionsComponent {
  readonly exceptions = [
    { id: '#EXC-8812', sender: 'Kehinde Balogun', recipient: 'Tunde Balogun', details: 'Access Bank •••• 9912', corridor: 'GBP ➔ NGN', amount: '£450.00', reason: 'Account Name Mismatch (BVN mismatch)', retries: 2 },
    { id: '#EXC-8811', sender: 'Kwabena Darko', recipient: 'Kojo Darko', details: 'MTN Mobile Money •••• 5510', corridor: 'GBP ➔ GHS', amount: '£200.00', reason: 'Recipient Wallet Limit Exceeded', retries: 1 },
    { id: '#EXC-8810', sender: 'Mercy Kimani', recipient: 'Geoffrey Kimani', details: 'M-Pesa Kenya •••• 7731', corridor: 'USD ➔ KES', amount: '$350.00', reason: 'Telco API Timeout (HTTP 504)', retries: 3 },
    { id: '#EXC-8809', sender: 'Emeka Nwosu', recipient: 'Ifeanyi Nwosu', details: 'Zenith Bank •••• 0041', corridor: 'EUR ➔ NGN', amount: '€600.00', reason: 'Invalid NUBAN Account Number', retries: 1 },
    { id: '#EXC-8808', sender: 'Sipho Zulu', recipient: 'Nonhle Zulu', details: 'Nedbank •••• 2291', corridor: 'GBP ➔ ZAR', amount: '£300.00', reason: 'Branch Code Deprecated', retries: 2 }
  ];
}
