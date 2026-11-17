import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-aml',
  imports: [CommonModule],
  template: `
    <div class="inner-page-layout">
      <!-- Header -->
      <div class="page-header">
        <div class="header-left">
          <h1 class="page-title">AML, PEP & Sanctions Screening</h1>
          <nav class="breadcrumb-nav">
            <ol class="breadcrumb">
              <li class="breadcrumb-item"><i class="fa-solid fa-house"></i> Home</li>
              <li class="breadcrumb-item">Compliance & Risk</li>
              <li class="breadcrumb-item active">AML Screening</li>
            </ol>
          </nav>
        </div>
        <div class="header-actions">
          <button class="btn btn-outline"><i class="fa-solid fa-rotate"></i> Sync Sanctions List</button>
          <button class="btn btn-danger"><i class="fa-solid fa-flag"></i> File SAR to NCA</button>
        </div>
      </div>

      <!-- AML Status Overview -->
      <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 16px;">
        <div class="card" style="padding: 18px;">
          <span style="font-size: 0.775rem; color: var(--text-muted); font-weight: 600;">Active Sanctions Lists</span>
          <h3 style="font-size: 1.4rem; font-weight: 800; color: var(--text-main); margin-top: 4px;">4 Feeds Active</h3>
          <span style="font-size: 0.725rem; color: #00D084; font-weight: 600;">OFAC, UK HMT, EU, UN Consolidated</span>
        </div>
        <div class="card" style="padding: 18px;">
          <span style="font-size: 0.775rem; color: var(--text-muted); font-weight: 600;">Screened Today</span>
          <h3 style="font-size: 1.4rem; font-weight: 800; color: #3B82F6; margin-top: 4px;">4,890 Checks</h3>
          <span style="font-size: 0.725rem; color: var(--text-muted);">Real-time sender & beneficiary check</span>
        </div>
        <div class="card" style="padding: 18px;">
          <span style="font-size: 0.775rem; color: var(--text-muted); font-weight: 600;">Flagged Velocity Hits</span>
          <h3 style="font-size: 1.4rem; font-weight: 800; color: #F59E0B; margin-top: 4px;">2 Potential Structuring</h3>
          <span style="font-size: 0.725rem; color: var(--text-muted);">Multiple micro-transfers < 24h</span>
        </div>
      </div>

      <!-- AML Alerts Table -->
      <div class="card">
        <div class="card-header table-card-header">
          <div class="table-header-left">
            <h3 class="card-title">Active Screening Alerts</h3>
          </div>
        </div>

        <div class="table-responsive">
          <table class="xintra-table">
            <thead>
              <tr>
                <th>CASE ID</th>
                <th>ENTITY SCREENED</th>
                <th>ALERT CATEGORY</th>
                <th>MATCH SCORE</th>
                <th>DETAILS & REASON</th>
                <th>TRIGGER TIME</th>
                <th class="text-right">DISPOSITION</th>
              </tr>
            </thead>
            <tbody>
              @for (a of alerts; track a.id) {
                <tr>
                  <td><span style="font-family: monospace; font-weight: 700; color: #EF4444;">{{ a.id }}</span></td>
                  <td>
                    <div style="display: flex; flex-direction: column;">
                      <strong style="color: var(--text-main);">{{ a.name }}</strong>
                      <span style="font-size: 0.725rem; color: var(--text-muted);">Role: {{ a.role }}</span>
                    </div>
                  </td>
                  <td><span class="badge" [ngClass]="a.badgeClass">{{ a.category }}</span></td>
                  <td><strong>{{ a.matchScore }}</strong></td>
                  <td style="font-size: 0.775rem; color: var(--text-muted);">{{ a.details }}</td>
                  <td style="font-size: 0.75rem; color: var(--text-muted);">{{ a.time }}</td>
                  <td class="text-right">
                    <div style="display: inline-flex; gap: 6px;">
                      <button class="btn btn-outline btn-sm"><i class="fa-solid fa-check"></i> False Positive</button>
                      <button class="btn btn-danger btn-sm"><i class="fa-solid fa-lock"></i> Freeze Account</button>
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
export class AmlComponent {
  readonly alerts = [
    { id: '#AML-902', name: 'Alhaji Musa Danjuma', role: 'Beneficiary (Nigeria)', category: 'PEP Match', matchScore: '92% LexisNexis', details: 'Relative of designated state commissioner (Kaduna)', time: '20 mins ago', badgeClass: 'badge-warning' },
    { id: '#AML-901', name: 'Viktor K.', role: 'Sender (UK)', category: 'Sanctions Sound-Alike', matchScore: '86% Fuzzy Match', details: 'Name similar to UK HMT designated individual', time: '1 hour ago', badgeClass: 'badge-danger' },
    { id: '#AML-900', name: 'Emeka Chukwudi', role: 'Sender (UK)', category: 'Velocity Spike', matchScore: 'High Risk', details: '8 transfers of £950 sent within 3 hours to different recipients', time: '3 hours ago', badgeClass: 'badge-warning' }
  ];
}
