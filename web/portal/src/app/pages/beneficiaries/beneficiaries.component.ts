import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-beneficiaries',
  imports: [CommonModule],
  template: `
    <div class="inner-page-layout">
      <!-- Header -->
      <div class="page-header">
        <div class="header-left">
          <h1 class="page-title">Beneficiaries & Recipient Wallets</h1>
          <nav class="breadcrumb-nav">
            <ol class="breadcrumb">
              <li class="breadcrumb-item"><i class="fa-solid fa-house"></i> Home</li>
              <li class="breadcrumb-item">Customers</li>
              <li class="breadcrumb-item active">Beneficiaries</li>
            </ol>
          </nav>
        </div>
        <div class="header-actions">
          <button class="btn btn-outline"><i class="fa-solid fa-download"></i> Export Registry</button>
          <button class="btn btn-primary"><i class="fa-solid fa-shield-check"></i> Run Name-Enquiry Batch</button>
        </div>
      </div>

      <!-- Beneficiaries Table -->
      <div class="card">
        <div class="card-header table-card-header">
          <div class="table-header-left">
            <h3 class="card-title">Recipient Directory</h3>
            <span class="badge badge-info badge-pill">24,190 Total</span>
          </div>
          <div class="table-header-right">
            <div class="search-input-wrap">
              <i class="fa-solid fa-magnifying-glass search-icon"></i>
              <input type="text" placeholder="Search account number, name..." class="table-search-input">
            </div>
          </div>
        </div>

        <div class="table-responsive">
          <table class="xintra-table">
            <thead>
              <tr>
                <th>BENEFICIARY NAME</th>
                <th>DESTINATION BANK / WALLET</th>
                <th>ACCOUNT / PHONE</th>
                <th>COUNTRY</th>
                <th>LINKED SENDER</th>
                <th>VERIFIED BY RAIL</th>
                <th class="text-right">ACTION</th>
              </tr>
            </thead>
            <tbody>
              @for (b of beneficiaries; track b.id) {
                <tr>
                  <td><strong style="color: var(--text-main);">{{ b.name }}</strong></td>
                  <td>{{ b.bank }}</td>
                  <td><span style="font-family: monospace; font-weight: 600;">{{ b.account }}</span></td>
                  <td>{{ b.country }}</td>
                  <td>{{ b.sender }}</td>
                  <td>
                    <span class="badge badge-success badge-pill">
                      <i class="fa-solid fa-check"></i> {{ b.verification }}
                    </span>
                  </td>
                  <td class="text-right">
                    <button class="btn btn-outline btn-sm"><i class="fa-solid fa-clock-rotate-left"></i> History</button>
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
export class BeneficiariesComponent {
  readonly beneficiaries = [
    { id: 1, name: 'Emeka Adebayo', bank: 'Access Bank Plc', account: '0123456789', country: '🇳🇬 Nigeria (NGN)', sender: 'Chioma Adebayo', verification: 'NIBSS Verified' },
    { id: 2, name: 'Kwame Mensah', bank: 'MTN Mobile Money', account: '+233 24 123 4567', country: '🇬🇭 Ghana (GHS)', sender: 'David Mensah', verification: 'GhIPSS Verified' },
    { id: 3, name: 'John Mwangi', bank: 'Safaricom M-Pesa', account: '+254 712 345678', country: '🇰🇪 Kenya (KES)', sender: 'Faith Mwangi', verification: 'Daraja Verified' },
    { id: 4, name: 'Chinedu Okafor', bank: 'Guaranty Trust Bank (GTBank)', account: '0234567890', country: '🇳🇬 Nigeria (NGN)', sender: 'Samuel Okafor', verification: 'NIBSS Verified' },
    { id: 5, name: 'Akosua Osei', bank: 'Vodafone Cash', account: '+233 20 987 6543', country: '🇬🇭 Ghana (GHS)', sender: 'Grace Osei', verification: 'GhIPSS Verified' }
  ];
}
