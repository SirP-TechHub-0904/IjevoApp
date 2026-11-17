import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-senders',
  imports: [CommonModule],
  template: `
    <div class="inner-page-layout">
      <!-- Header -->
      <div class="page-header">
        <div class="header-left">
          <h1 class="page-title">Sender Customer Accounts</h1>
          <nav class="breadcrumb-nav">
            <ol class="breadcrumb">
              <li class="breadcrumb-item"><i class="fa-solid fa-house"></i> Home</li>
              <li class="breadcrumb-item">Customers</li>
              <li class="breadcrumb-item active">Senders</li>
            </ol>
          </nav>
        </div>
        <div class="header-actions">
          <button class="btn btn-outline"><i class="fa-solid fa-download"></i> Export Senders</button>
          <button class="btn btn-primary"><i class="fa-solid fa-user-plus"></i> Invite Customer</button>
        </div>
      </div>

      <!-- Senders Table -->
      <div class="card">
        <div class="card-header table-card-header">
          <div class="table-header-left">
            <h3 class="card-title">Active Senders Directory</h3>
            <span class="badge badge-info badge-pill">12,840 Total</span>
          </div>
          <div class="table-header-right">
            <div class="search-input-wrap">
              <i class="fa-solid fa-magnifying-glass search-icon"></i>
              <input type="text" placeholder="Search name, email, phone..." class="table-search-input">
            </div>
          </div>
        </div>

        <div class="table-responsive">
          <table class="xintra-table">
            <thead>
              <tr>
                <th>CUSTOMER NAME</th>
                <th>CONTACT EMAIL & TEL</th>
                <th>ORIGIN COUNTRY</th>
                <th>KYC TIER</th>
                <th>TOTAL SENT</th>
                <th>TRANSFERS</th>
                <th>STATUS</th>
                <th class="text-right">ACTIONS</th>
              </tr>
            </thead>
            <tbody>
              @for (s of senders; track s.id) {
                <tr>
                  <td>
                    <div style="display: flex; align-items: center; gap: 10px;">
                      <img [src]="s.avatar" alt="" style="width: 32px; height: 32px; border-radius: 9999px; object-fit: cover;">
                      <strong style="color: var(--text-main);">{{ s.name }}</strong>
                    </div>
                  </td>
                  <td>
                    <div style="display: flex; flex-direction: column;">
                      <span>{{ s.email }}</span>
                      <span style="font-size: 0.725rem; color: var(--text-muted);">{{ s.phone }}</span>
                    </div>
                  </td>
                  <td>{{ s.country }}</td>
                  <td><span class="badge badge-success">{{ s.tier }}</span></td>
                  <td><strong style="color: var(--text-main);">{{ s.totalVolume }}</strong></td>
                  <td><span class="badge badge-info">{{ s.txnCount }} txns</span></td>
                  <td>
                    <span class="badge badge-pill" [class.badge-success]="s.status === 'Active'" [class.badge-warning]="s.status === 'Pending KYC'">
                      {{ s.status }}
                    </span>
                  </td>
                  <td class="text-right">
                    <button class="btn btn-outline btn-sm"><i class="fa-solid fa-user-gear"></i> Manage</button>
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
export class SendersComponent {
  readonly senders = [
    { id: 1, name: 'Chioma Adebayo', avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=80&auto=format&fit=crop&q=80', email: 'chioma.a@london.co.uk', phone: '+44 7700 900123', country: '🇬🇧 United Kingdom', tier: 'Tier 3 (Uncapped)', totalVolume: '£24,800.00', txnCount: 38, status: 'Active' },
    { id: 2, name: 'David Mensah', avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=80&auto=format&fit=crop&q=80', email: 'mensah.d@manchester.org', phone: '+44 7700 900456', country: '🇬🇧 United Kingdom', tier: 'Tier 2 (£10k/mo)', totalVolume: '£12,450.00', txnCount: 24, status: 'Active' },
    { id: 3, name: 'Samuel Okafor', avatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=80&auto=format&fit=crop&q=80', email: 'samuel.ok@dublin.ie', phone: '+353 87 123 4567', country: '🇮🇪 Ireland (EU)', tier: 'Tier 2 (£10k/mo)', totalVolume: '€8,900.00', txnCount: 16, status: 'Active' },
    { id: 4, name: 'Faith Mwangi', avatar: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=80&auto=format&fit=crop&q=80', email: 'faith.m@birmingham.ac.uk', phone: '+44 7700 900789', country: '🇬🇧 United Kingdom', tier: 'Tier 1 (£2k/mo)', totalVolume: '£1,850.00', txnCount: 6, status: 'Active' },
    { id: 5, name: 'Grace Osei', avatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=80&auto=format&fit=crop&q=80', email: 'grace.osei@glasgow.gov.uk', phone: '+44 7700 900331', country: '🇬🇧 United Kingdom', tier: 'Tier 2 (£10k/mo)', totalVolume: '£6,200.00', txnCount: 19, status: 'Active' }
  ];
}
