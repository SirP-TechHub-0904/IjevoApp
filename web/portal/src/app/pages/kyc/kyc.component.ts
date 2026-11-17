import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-kyc',
  imports: [CommonModule],
  template: `
    <div class="inner-page-layout">
      <!-- Header -->
      <div class="page-header">
        <div class="header-left">
          <h1 class="page-title">KYC & Identity Verification Queue</h1>
          <nav class="breadcrumb-nav">
            <ol class="breadcrumb">
              <li class="breadcrumb-item"><i class="fa-solid fa-house"></i> Home</li>
              <li class="breadcrumb-item">Compliance & Risk</li>
              <li class="breadcrumb-item active">KYC Verification</li>
            </ol>
          </nav>
        </div>
        <div class="header-actions">
          <button class="btn btn-outline"><i class="fa-solid fa-rotate"></i> Sync Veriff / Sumsub</button>
          <button class="btn btn-primary"><i class="fa-solid fa-check-double"></i> Batch Approve Low Risk</button>
        </div>
      </div>

      <!-- Quick Metrics -->
      <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 16px;">
        <div class="card" style="padding: 16px;">
          <span style="font-size: 0.775rem; color: var(--text-muted); font-weight: 600;">Pending Review</span>
          <h3 style="font-size: 1.4rem; font-weight: 800; color: #F59E0B; margin-top: 4px;">18 Users</h3>
          <span style="font-size: 0.725rem; color: var(--text-muted);">Avg review time: 6 mins</span>
        </div>
        <div class="card" style="padding: 16px;">
          <span style="font-size: 0.775rem; color: var(--text-muted); font-weight: 600;">Auto-Verified Today</span>
          <h3 style="font-size: 1.4rem; font-weight: 800; color: #00D084; margin-top: 4px;">412 Users</h3>
          <span style="font-size: 0.725rem; color: var(--text-muted);">94.8% pass rate</span>
        </div>
        <div class="card" style="padding: 16px;">
          <span style="font-size: 0.775rem; color: var(--text-muted); font-weight: 600;">Rejected / Flagged</span>
          <h3 style="font-size: 1.4rem; font-weight: 800; color: #EF4444; margin-top: 4px;">6 Users</h3>
          <span style="font-size: 0.725rem; color: var(--text-muted);">Expired / forged IDs</span>
        </div>
      </div>

      <!-- Verification Queue Table -->
      <div class="card">
        <div class="card-header table-card-header">
          <div class="table-header-left">
            <h3 class="card-title">Verification Submissions</h3>
            <span class="badge badge-warning badge-pill">18 In Queue</span>
          </div>
        </div>

        <div class="table-responsive">
          <table class="xintra-table">
            <thead>
              <tr>
                <th>USER / APPLICANT</th>
                <th>TARGET TIER</th>
                <th>DOCUMENT TYPE</th>
                <th>COUNTRY</th>
                <th>AI RISK SCORE</th>
                <th>SUBMITTED</th>
                <th class="text-right">DECISION</th>
              </tr>
            </thead>
            <tbody>
              @for (k of queue; track k.id) {
                <tr>
                  <td>
                    <div style="display: flex; flex-direction: column;">
                      <strong style="color: var(--text-main);">{{ k.name }}</strong>
                      <span style="font-size: 0.725rem; color: var(--text-muted);">{{ k.email }}</span>
                    </div>
                  </td>
                  <td><span class="badge badge-info">{{ k.tier }}</span></td>
                  <td>{{ k.docType }}</td>
                  <td>{{ k.country }}</td>
                  <td>
                    <span class="badge" [class.badge-success]="k.risk === 'Low (98/100)'" [class.badge-warning]="k.risk.startsWith('Medium')" [class.badge-danger]="k.risk.startsWith('High')">
                      {{ k.risk }}
                    </span>
                  </td>
                  <td style="font-size: 0.75rem; color: var(--text-muted);">{{ k.time }}</td>
                  <td class="text-right">
                    <div style="display: inline-flex; gap: 6px;">
                      <button class="btn btn-outline btn-sm"><i class="fa-solid fa-file-image"></i> Inspect</button>
                      <button class="btn btn-primary btn-sm"><i class="fa-solid fa-check"></i> Approve</button>
                      <button class="btn btn-danger btn-sm"><i class="fa-solid fa-xmark"></i> Reject</button>
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
export class KycComponent {
  readonly queue = [
    { id: 1, name: 'Tariq Al-Mansoor', email: 'tariq.m@london.co.uk', tier: 'Tier 3 (Uncapped)', docType: 'Bank Statement (Proof of Funds)', country: 'United Kingdom', risk: 'Low (98/100)', time: '8 mins ago' },
    { id: 2, name: 'Chisom Eze', email: 'chisom.eze@gmail.com', tier: 'Tier 2 (£10k/mo)', docType: 'Council Tax Bill (Address)', country: 'United Kingdom', risk: 'Low (95/100)', time: '14 mins ago' },
    { id: 3, name: 'Kwaku Appiah', email: 'kwaku.appiah@yahoo.co.uk', tier: 'Tier 1 (£2k/mo)', docType: 'UK Biometric Residence Permit', country: 'United Kingdom', risk: 'Medium (72/100)', time: '22 mins ago' },
    { id: 4, name: 'Lerato Molefe', email: 'lerato.m@consultant.ie', tier: 'Tier 2 (£10k/mo)', docType: 'Irish Driving Licence', country: 'Ireland', risk: 'Low (94/100)', time: '35 mins ago' },
    { id: 5, name: 'Oluwaseun Bakare', email: 'seun.b@techstartup.com', tier: 'Tier 3 (Uncapped)', docType: 'Payslip & Tax Return P60', country: 'United Kingdom', risk: 'High (45/100)', time: '48 mins ago' }
  ];
}
