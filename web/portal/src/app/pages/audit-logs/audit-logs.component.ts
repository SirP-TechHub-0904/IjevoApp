import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-audit-logs',
  imports: [CommonModule],
  template: `
    <div class="inner-page-layout">
      <!-- Header -->
      <div class="page-header">
        <div class="header-left">
          <h1 class="page-title">Security & Audit Event Logs</h1>
          <nav class="breadcrumb-nav">
            <ol class="breadcrumb">
              <li class="breadcrumb-item"><i class="fa-solid fa-house"></i> Home</li>
              <li class="breadcrumb-item">Settings</li>
              <li class="breadcrumb-item active">Audit Logs</li>
            </ol>
          </nav>
        </div>
        <div class="header-actions">
          <button class="btn btn-outline"><i class="fa-solid fa-filter"></i> Filter Event Type</button>
          <button class="btn btn-primary"><i class="fa-solid fa-download"></i> Export Immutable Log</button>
        </div>
      </div>

      <!-- Logs Table Card -->
      <div class="card">
        <div class="card-header table-card-header">
          <div class="table-header-left">
            <h3 class="card-title">System Activity Trail</h3>
            <span class="badge badge-success badge-pill">Protected</span>
          </div>
          <div class="table-header-right">
            <div class="search-input-wrap">
              <i class="fa-solid fa-magnifying-glass search-icon"></i>
              <input type="text" placeholder="Search actor, event, IP..." class="table-search-input">
            </div>
          </div>
        </div>

        <div class="table-responsive">
          <table class="xintra-table">
            <thead>
              <tr>
                <th>EVENT TYPE</th>
                <th>ACTOR / ADMIN</th>
                <th>IP ADDRESS & LOCATION</th>
                <th>DESCRIPTION & TARGET</th>
                <th>TIMESTAMP</th>
                <th>SEVERITY</th>
              </tr>
            </thead>
            <tbody>
              @for (l of logs; track l.id) {
                <tr>
                  <td><strong style="color: var(--text-main);">{{ l.event }}</strong></td>
                  <td>
                    <div style="display: flex; flex-direction: column;">
                      <span style="font-weight: 600;">{{ l.actor }}</span>
                      <span style="font-size: 0.725rem; color: var(--text-muted);">{{ l.role }}</span>
                    </div>
                  </td>
                  <td>
                    <div style="display: flex; flex-direction: column;">
                      <code style="font-size: 0.75rem;">{{ l.ip }}</code>
                      <span style="font-size: 0.725rem; color: var(--text-muted);">{{ l.location }}</span>
                    </div>
                  </td>
                  <td style="font-size: 0.8rem; color: var(--text-muted);">{{ l.description }}</td>
                  <td style="font-size: 0.75rem; color: var(--text-muted);">{{ l.time }}</td>
                  <td>
                    <span class="badge badge-pill" 
                      [class.badge-info]="l.severity === 'Info'"
                      [class.badge-warning]="l.severity === 'Warning'"
                      [class.badge-danger]="l.severity === 'Critical'">
                      {{ l.severity }}
                    </span>
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
export class AuditLogsComponent {
  readonly logs = [
    { id: 1, event: 'Corridor Rate Adjusted', actor: 'Alex Morgan', role: 'Super Admin', ip: '185.120.44.12', location: 'London, UK', description: 'Updated GBP/NGN FX markup margin from 0.70% to 0.65%', time: '12 mins ago', severity: 'Info' },
    { id: 2, event: 'Treasury Sweep Executed', actor: 'System Hedging Bot', role: 'Automated Bot', ip: '10.0.4.18', location: 'System Engine', description: 'Rebalanced £250,000 from ClearBank to Zenith Vault (NGN)', time: '45 mins ago', severity: 'Info' },
    { id: 3, event: 'AML Review Drafted', actor: 'Sarah Jenkins', role: 'Compliance Officer', ip: '194.88.10.5', location: 'London, UK', description: 'Filed review flag for transaction #TRX-9936', time: '2 hours ago', severity: 'Warning' },
    { id: 4, event: 'API Key Generated', actor: 'Alex Morgan', role: 'Super Admin', ip: '185.120.44.12', location: 'London, UK', description: 'Generated new live secret key for Mobile App iOS suite', time: '6 hours ago', severity: 'Warning' },
    { id: 5, event: '2FA Policy Enforced', actor: 'System Core', role: 'Security Policy', ip: '127.0.0.1', location: 'Internal', description: 'Two-factor verification enabled for all operator accounts', time: '1 day ago', severity: 'Info' }
  ];
}
