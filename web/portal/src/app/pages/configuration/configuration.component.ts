import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-configuration',
  imports: [CommonModule, FormsModule],
  template: `
    <div class="inner-page-layout">
      <!-- Header -->
      <div class="page-header">
        <div class="header-left">
          <h1 class="page-title">Portal Configuration & System Rules</h1>
          <nav class="breadcrumb-nav">
            <ol class="breadcrumb">
              <li class="breadcrumb-item"><i class="fa-solid fa-house"></i> Home</li>
              <li class="breadcrumb-item">Settings</li>
              <li class="breadcrumb-item active">Configuration</li>
            </ol>
          </nav>
        </div>
        <div class="header-actions">
          <button class="btn btn-outline"><i class="fa-solid fa-rotate-left"></i> Revert Defaults</button>
          <button class="btn btn-primary" (click)="save()"><i class="fa-solid fa-floppy-disk"></i> Save Configuration</button>
        </div>
      </div>

      <!-- Settings Cards Grid -->
      <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(340px, 1fr)); gap: 20px;">
        <!-- Card 1: Clearing & Hedging -->
        <div class="card" style="padding: 22px;">
          <h3 class="card-title" style="margin-bottom: 6px;">Automated FX Hedging & Clearing</h3>
          <p style="font-size: 0.775rem; color: var(--text-muted); margin-bottom: 20px;">Control automated liquidity sweeps and real-time market rate hedging.</p>

          <div style="display: flex; flex-direction: column; gap: 16px;">
            <div style="display: flex; justify-content: space-between; align-items: center;">
              <div>
                <strong style="font-size: 0.85rem; color: var(--text-main); display: block;">Automated Mid-Market Locking</strong>
                <span style="font-size: 0.725rem; color: var(--text-muted);">Lock liquidity provider rates upon customer initiation</span>
              </div>
              <input type="checkbox" [(ngModel)]="autoHedging" style="width: 20px; height: 20px; accent-color: var(--primary);">
            </div>

            <div style="display: flex; justify-content: space-between; align-items: center;">
              <div>
                <strong style="font-size: 0.85rem; color: var(--text-main); display: block;">Instant Rail Auto-Settlement</strong>
                <span style="font-size: 0.725rem; color: var(--text-muted);">Automatically route < £5,000 transfers through FPS/NIBSS</span>
              </div>
              <input type="checkbox" [(ngModel)]="autoSettlement" style="width: 20px; height: 20px; accent-color: var(--primary);">
            </div>

            <div style="display: flex; justify-content: space-between; align-items: center;">
              <div>
                <strong style="font-size: 0.85rem; color: var(--text-main); display: block;">Smart Gateway Failover</strong>
                <span style="font-size: 0.725rem; color: var(--text-muted);">Auto-switch to secondary rail if latency exceeds 500ms</span>
              </div>
              <input type="checkbox" [(ngModel)]="smartFailover" style="width: 20px; height: 20px; accent-color: var(--primary);">
            </div>
          </div>
        </div>

        <!-- Card 2: Compliance & Velocity Limits -->
        <div class="card" style="padding: 22px;">
          <h3 class="card-title" style="margin-bottom: 6px;">Compliance Velocity Limits</h3>
          <p style="font-size: 0.775rem; color: var(--text-muted); margin-bottom: 20px;">Global thresholds for anti-money laundering and KYC steps.</p>

          <div style="display: flex; flex-direction: column; gap: 14px;">
            <div>
              <label style="font-size: 0.775rem; font-weight: 600; color: var(--text-muted); display: block; margin-bottom: 6px;">Tier 1 KYC Monthly Threshold</label>
              <input type="text" [(ngModel)]="tier1Limit" style="width: 100%; padding: 8px 12px; background: var(--bg-subtle); border: 1px solid var(--border-color); border-radius: var(--radius-sm); font-size: 0.85rem;">
            </div>

            <div>
              <label style="font-size: 0.775rem; font-weight: 600; color: var(--text-muted); display: block; margin-bottom: 6px;">Tier 2 Proof of Address Threshold</label>
              <input type="text" [(ngModel)]="tier2Limit" style="width: 100%; padding: 8px 12px; background: var(--bg-subtle); border: 1px solid var(--border-color); border-radius: var(--radius-sm); font-size: 0.85rem;">
            </div>

            <div>
              <label style="font-size: 0.775rem; font-weight: 600; color: var(--text-muted); display: block; margin-bottom: 6px;">Single Transfer Unapproved Hard Cap</label>
              <input type="text" [(ngModel)]="singleCap" style="width: 100%; padding: 8px 12px; background: var(--bg-subtle); border: 1px solid var(--border-color); border-radius: var(--radius-sm); font-size: 0.85rem;">
            </div>
          </div>
        </div>

        <!-- Card 3: Security & Maintenance -->
        <div class="card" style="padding: 22px;">
          <h3 class="card-title" style="margin-bottom: 6px;">System Security & Maintenance</h3>
          <p style="font-size: 0.775rem; color: var(--text-muted); margin-bottom: 20px;">Operator session rules and portal maintenance window controls.</p>

          <div style="display: flex; flex-direction: column; gap: 16px;">
            <div style="display: flex; justify-content: space-between; align-items: center;">
              <div>
                <strong style="font-size: 0.85rem; color: var(--text-main); display: block;">Enforce Mandatory 2FA</strong>
                <span style="font-size: 0.725rem; color: var(--text-muted);">Require TOTP authenticator for all staff</span>
              </div>
              <input type="checkbox" [(ngModel)]="enforce2FA" style="width: 20px; height: 20px; accent-color: var(--primary);">
            </div>

            <div style="display: flex; justify-content: space-between; align-items: center;">
              <div>
                <strong style="font-size: 0.85rem; color: #EF4444; display: block;">Portal Maintenance Mode</strong>
                <span style="font-size: 0.725rem; color: var(--text-muted);">Pause non-admin access during scheduled upgrades</span>
              </div>
              <input type="checkbox" [(ngModel)]="maintenanceMode" style="width: 20px; height: 20px; accent-color: #EF4444;">
            </div>

            <div style="padding-top: 10px; border-top: 1px dashed var(--border-color);">
              <span style="font-size: 0.75rem; color: var(--text-muted);">Core API Health Check Endpoint:</span>
              <code style="display: block; font-size: 0.75rem; color: var(--primary); margin-top: 4px;">https://api.ijevo.com/health/liveness</code>
            </div>
          </div>
        </div>
      </div>
    </div>
  `
})
export class ConfigurationComponent {
  autoHedging = true;
  autoSettlement = true;
  smartFailover = true;

  tier1Limit = '£2,000.00 / month';
  tier2Limit = '£10,000.00 / month';
  singleCap = '£5,000.00 / transfer';

  enforce2FA = true;
  maintenanceMode = false;

  save() {
    alert('Configuration saved successfully across all active nodes.');
  }
}
