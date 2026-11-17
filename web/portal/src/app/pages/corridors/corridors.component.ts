import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-corridors',
  imports: [CommonModule],
  template: `
    <div class="inner-page-layout">
      <!-- Header -->
      <div class="page-header">
        <div class="header-left">
          <h1 class="page-title">Corridors, FX Margins & Limits</h1>
          <nav class="breadcrumb-nav">
            <ol class="breadcrumb">
              <li class="breadcrumb-item"><i class="fa-solid fa-house"></i> Home</li>
              <li class="breadcrumb-item">Remittance Ops</li>
              <li class="breadcrumb-item active">Corridors & Rates</li>
            </ol>
          </nav>
        </div>
        <div class="header-actions">
          <button class="btn btn-outline"><i class="fa-solid fa-arrows-rotate"></i> Sync Interbank Rates</button>
          <button class="btn btn-primary"><i class="fa-solid fa-plus"></i> Add New Corridor</button>
        </div>
      </div>

      <!-- Corridor Cards Grid -->
      <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 20px;">
        @for (c of corridors; track c.pair) {
          <div class="card" style="padding: 20px;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 14px;">
              <div style="display: flex; align-items: center; gap: 10px;">
                <span style="font-size: 1.5rem;">{{ c.originFlag }}</span>
                <i class="fa-solid fa-arrow-right text-muted" style="font-size: 0.8rem;"></i>
                <span style="font-size: 1.5rem;">{{ c.destFlag }}</span>
                <div>
                  <h3 style="font-size: 1rem; font-weight: 700; color: var(--text-main); margin: 0;">{{ c.pair }}</h3>
                  <span style="font-size: 0.725rem; color: var(--text-muted);">{{ c.name }}</span>
                </div>
              </div>
              <span class="badge" [class.badge-success]="c.enabled" [class.badge-warning]="!c.enabled">
                {{ c.enabled ? 'Active' : 'Paused' }}
              </span>
            </div>

            <div style="background: var(--bg-subtle); padding: 12px 14px; border-radius: var(--radius-sm); margin-bottom: 14px;">
              <div style="display: flex; justify-content: space-between; font-size: 0.75rem; margin-bottom: 4px;">
                <span style="color: var(--text-muted);">Mid-Market Interbank</span>
                <strong style="color: var(--text-main);">{{ c.interbank }}</strong>
              </div>
              <div style="display: flex; justify-content: space-between; font-size: 0.85rem;">
                <span style="color: var(--text-muted); font-weight: 600;">Customer Offered Rate</span>
                <strong style="color: var(--primary); font-size: 1rem;">{{ c.offered }}</strong>
              </div>
              <div style="display: flex; justify-content: space-between; font-size: 0.725rem; margin-top: 4px; border-top: 1px dashed var(--border-color); padding-top: 4px;">
                <span style="color: var(--text-muted);">Hedging FX Margin</span>
                <span style="font-weight: 700; color: #D97706;">+{{ c.margin }}% Spread</span>
              </div>
            </div>

            <div style="display: flex; justify-content: space-between; font-size: 0.75rem; color: var(--text-muted); margin-bottom: 14px;">
              <span>Min: {{ c.min }}</span>
              <span>Max: {{ c.max }} / txn</span>
              <span>Fee: Free (0%)</span>
            </div>

            <div style="display: flex; gap: 8px;">
              <button class="btn btn-outline btn-sm" style="flex: 1; justify-content: center;"><i class="fa-solid fa-sliders"></i> Adjust Margin</button>
              <button class="btn btn-outline btn-sm" style="flex: 1; justify-content: center;"><i class="fa-solid fa-ban"></i> Pause</button>
            </div>
          </div>
        }
      </div>
    </div>
  `
})
export class CorridorsComponent {
  readonly corridors = [
    { pair: 'GBP ➔ NGN', name: 'UK to Nigeria (Naira)', originFlag: '🇬🇧', destFlag: '🇳🇬', interbank: '1,846.00', offered: '1,834.00', margin: '0.65', min: '£1.00', max: '£10,000.00', enabled: true },
    { pair: 'EUR ➔ NGN', name: 'Europe to Nigeria', originFlag: '🇪🇺', destFlag: '🇳🇬', interbank: '1,595.20', offered: '1,585.60', margin: '0.60', min: '€1.00', max: '€10,000.00', enabled: true },
    { pair: 'USD ➔ NGN', name: 'US to Nigeria', originFlag: '🇺🇸', destFlag: '🇳🇬', interbank: '1,480.50', offered: '1,473.10', margin: '0.50', min: '$1.00', max: '$10,000.00', enabled: true },
    { pair: 'GBP ➔ GHS', name: 'UK to Ghana (Cedi)', originFlag: '🇬🇧', destFlag: '🇬🇭', interbank: '16.65', offered: '16.55', margin: '0.60', min: '£1.00', max: '£5,000.00', enabled: true },
    { pair: 'GBP ➔ KES', name: 'UK to Kenya (Shilling)', originFlag: '🇬🇧', destFlag: '🇰🇪', interbank: '168.40', offered: '167.64', margin: '0.45', min: '£1.00', max: '£5,000.00', enabled: true },
    { pair: 'GBP ➔ ZAR', name: 'UK to South Africa (Rand)', originFlag: '🇬🇧', destFlag: '🇿🇦', interbank: '23.85', offered: '23.70', margin: '0.62', min: '£5.00', max: '£10,000.00', enabled: true }
  ];
}
