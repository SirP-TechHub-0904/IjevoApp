import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-api-keys',
  imports: [CommonModule],
  template: `
    <div class="inner-page-layout">
      <!-- Header -->
      <div class="page-header">
        <div class="header-left">
          <h1 class="page-title">API Keys & Webhook Integrations</h1>
          <nav class="breadcrumb-nav">
            <ol class="breadcrumb">
              <li class="breadcrumb-item"><i class="fa-solid fa-house"></i> Home</li>
              <li class="breadcrumb-item">Settings</li>
              <li class="breadcrumb-item active">API Keys</li>
            </ol>
          </nav>
        </div>
        <div class="header-actions">
          <button class="btn btn-outline"><i class="fa-solid fa-book"></i> API Documentation</button>
          <button class="btn btn-primary"><i class="fa-solid fa-key"></i> Generate New Key</button>
        </div>
      </div>

      <!-- API Keys Table Card -->
      <div class="card">
        <div class="card-header">
          <h3 class="card-title">Active API Credentials</h3>
          <span class="badge badge-success badge-pill">Active</span>
        </div>
        <div class="table-responsive">
          <table class="xintra-table">
            <thead>
              <tr>
                <th>KEY NAME / ENVIRONMENT</th>
                <th>KEY PREFIX</th>
                <th>PERMISSIONS</th>
                <th>LAST USED</th>
                <th>CREATED</th>
                <th class="text-right">ACTIONS</th>
              </tr>
            </thead>
            <tbody>
              @for (k of keys; track k.name) {
                <tr>
                  <td>
                    <div style="display: flex; align-items: center; gap: 8px;">
                      <span class="badge" [class.badge-success]="k.env === 'Production'" [class.badge-info]="k.env === 'Sandbox'">{{ k.env }}</span>
                      <strong style="color: var(--text-main);">{{ k.name }}</strong>
                    </div>
                  </td>
                  <td><code style="background: var(--bg-subtle); padding: 4px 8px; border-radius: 4px;">{{ k.prefix }}••••••••</code></td>
                  <td><span style="font-size: 0.775rem; color: var(--text-muted);">{{ k.scope }}</span></td>
                  <td style="font-size: 0.75rem; color: var(--text-muted);">{{ k.lastUsed }}</td>
                  <td style="font-size: 0.75rem; color: var(--text-muted);">{{ k.created }}</td>
                  <td class="text-right">
                    <button class="btn btn-outline btn-sm" style="margin-right: 6px;"><i class="fa-regular fa-copy"></i> Copy</button>
                    <button class="btn btn-danger btn-sm"><i class="fa-solid fa-trash"></i></button>
                  </td>
                </tr>
              }
            </tbody>
          </table>
        </div>
      </div>

      <!-- Webhooks Card -->
      <div class="card">
        <div class="card-header">
          <h3 class="card-title">Configured Webhook Endpoints</h3>
          <button class="btn btn-outline btn-sm"><i class="fa-solid fa-plus"></i> Add Webhook</button>
        </div>
        <div class="table-responsive">
          <table class="xintra-table">
            <thead>
              <tr>
                <th>ENDPOINT URL</th>
                <th>LISTENED EVENTS</th>
                <th>DELIVERY RATE</th>
                <th>STATUS</th>
                <th class="text-right">ACTIONS</th>
              </tr>
            </thead>
            <tbody>
              @for (w of webhooks; track w.url) {
                <tr>
                  <td><code style="color: var(--primary); font-weight: 600;">{{ w.url }}</code></td>
                  <td><span class="badge badge-info">{{ w.events }}</span></td>
                  <td><strong style="color: #00D084;">{{ w.successRate }}</strong></td>
                  <td><span class="badge badge-success badge-pill">Active</span></td>
                  <td class="text-right">
                    <button class="btn btn-outline btn-sm"><i class="fa-solid fa-paper-plane"></i> Test Ping</button>
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
export class ApiKeysComponent {
  readonly keys = [
    { name: 'Core Web Platform', env: 'Production', prefix: 'ijevo_live_pk_9942a', scope: 'Full Access (Read/Write)', lastUsed: '1 min ago', created: 'Nov 01, 2026' },
    { name: 'Mobile App iOS / Android', env: 'Production', prefix: 'ijevo_live_pk_1180f', scope: 'Remittance Inflow Only', lastUsed: 'Just now', created: 'Nov 04, 2026' },
    { name: 'Staging Integration Suite', env: 'Sandbox', prefix: 'ijevo_test_pk_0029x', scope: 'Test Rail Simulation', lastUsed: '2 hours ago', created: 'Nov 10, 2026' }
  ];

  readonly webhooks = [
    { url: 'https://api.ijevo.com/webhooks/settlement-callback', events: 'transfer.completed, transfer.failed', successRate: '99.98% (24,190 delivered)' },
    { url: 'https://compliance.ijevo.com/events/aml-trigger', events: 'kyc.verified, aml.flagged', successRate: '100% (1,402 delivered)' }
  ];
}
