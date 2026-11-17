import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-referrals',
  imports: [CommonModule],
  template: `
    <div class="inner-page-layout">
      <!-- Header -->
      <div class="page-header">
        <div class="header-left">
          <h1 class="page-title">Refer & Earn Program Management</h1>
          <nav class="breadcrumb-nav">
            <ol class="breadcrumb">
              <li class="breadcrumb-item"><i class="fa-solid fa-house"></i> Home</li>
              <li class="breadcrumb-item">Customers</li>
              <li class="breadcrumb-item active">Refer & Earn</li>
            </ol>
          </nav>
        </div>
        <div class="header-actions">
          <button class="btn btn-outline"><i class="fa-solid fa-sliders"></i> Adjust Bonus (£25)</button>
          <button class="btn btn-primary"><i class="fa-solid fa-money-bill-wave"></i> Process Pending Rewards</button>
        </div>
      </div>

      <!-- Quick Metrics -->
      <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 16px;">
        <div class="card" style="padding: 18px;">
          <span style="font-size: 0.775rem; color: var(--text-muted); font-weight: 600;">Total Referral Volume</span>
          <h3 style="font-size: 1.4rem; font-weight: 800; color: var(--text-main); margin-top: 4px;">£682,400.00</h3>
          <span style="font-size: 0.725rem; color: var(--primary); font-weight: 600;">14% of overall monthly volume</span>
        </div>
        <div class="card" style="padding: 18px;">
          <span style="font-size: 0.775rem; color: var(--text-muted); font-weight: 600;">Successful Invites</span>
          <h3 style="font-size: 1.4rem; font-weight: 800; color: #3B82F6; margin-top: 4px;">3,410 Users</h3>
          <span style="font-size: 0.725rem; color: var(--text-muted);">68.2% conversion rate</span>
        </div>
        <div class="card" style="padding: 18px;">
          <span style="font-size: 0.775rem; color: var(--text-muted); font-weight: 600;">Rewards Distributed</span>
          <h3 style="font-size: 1.4rem; font-weight: 800; color: #00D084; margin-top: 4px;">£85,250.00</h3>
          <span style="font-size: 0.725rem; color: var(--text-muted);">Credited to sender fee credits</span>
        </div>
        <div class="card" style="padding: 18px;">
          <span style="font-size: 0.775rem; color: var(--text-muted); font-weight: 600;">Pending Approval</span>
          <h3 style="font-size: 1.4rem; font-weight: 800; color: #F59E0B; margin-top: 4px;">£3,750.00</h3>
          <span style="font-size: 0.725rem; color: var(--text-muted);">150 first transfers cleared</span>
        </div>
      </div>

      <!-- Top Advocates Table -->
      <div class="card">
        <div class="card-header table-card-header">
          <div class="table-header-left">
            <h3 class="card-title">Top Referral Advocates</h3>
          </div>
        </div>

        <div class="table-responsive">
          <table class="xintra-table">
            <thead>
              <tr>
                <th>ADVOCATE NAME</th>
                <th>REFERRAL CODE</th>
                <th>FRIENDS INVITED</th>
                <th>ACTIVE TRANSACTING</th>
                <th>REWARD EARNED</th>
                <th>STATUS</th>
                <th class="text-right">ACTION</th>
              </tr>
            </thead>
            <tbody>
              @for (r of advocates; track r.code) {
                <tr>
                  <td><strong style="color: var(--text-main);">{{ r.name }}</strong></td>
                  <td><span style="font-family: monospace; font-weight: 700; color: var(--primary);">{{ r.code }}</span></td>
                  <td>{{ r.invited }} friends</td>
                  <td><span class="badge badge-success">{{ r.converted }} converted</span></td>
                  <td><strong style="color: #00D084;">{{ r.rewards }}</strong></td>
                  <td><span class="badge badge-success badge-pill">Active Advocate</span></td>
                  <td class="text-right">
                    <button class="btn btn-outline btn-sm">View Referees</button>
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
export class ReferralsComponent {
  readonly advocates = [
    { name: 'Dr. Chidi Okonkwo', code: 'CHIDI25', invited: 84, converted: 72, rewards: '£1,800.00' },
    { name: 'Abimbola Davies', code: 'BIMBO50', invited: 62, converted: 54, rewards: '£1,350.00' },
    { name: 'Emmanuel Asante', code: 'ASANTE20', invited: 45, converted: 38, rewards: '£950.00' },
    { name: 'Grace Njoroge', code: 'GRACEK', invited: 39, converted: 31, rewards: '£775.00' },
    { name: 'Olumide Fashola', code: 'LUMIDE9', invited: 28, converted: 24, rewards: '£600.00' }
  ];
}
