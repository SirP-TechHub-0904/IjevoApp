import { Component, signal, computed } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-transactions',
  imports: [CommonModule, FormsModule],
  template: `
    <div class="inner-page-layout">
      <!-- Header -->
      <div class="page-header">
        <div class="header-left">
          <h1 class="page-title">Master Remittance Transactions</h1>
          <nav class="breadcrumb-nav">
            <ol class="breadcrumb">
              <li class="breadcrumb-item"><i class="fa-solid fa-house"></i> Home</li>
              <li class="breadcrumb-item">Remittance Ops</li>
              <li class="breadcrumb-item active">Transactions</li>
            </ol>
          </nav>
        </div>
        <div class="header-actions">
          <button class="btn btn-outline"><i class="fa-solid fa-filter"></i> Advanced Filters</button>
          <button class="btn btn-primary"><i class="fa-solid fa-cloud-arrow-down"></i> Export Full CSV</button>
        </div>
      </div>

      <!-- Quick Metrics -->
      <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px;">
        <div class="card" style="padding: 16px;">
          <span style="font-size: 0.775rem; color: var(--text-muted); font-weight: 600;">Total Processed (30D)</span>
          <h3 style="font-size: 1.35rem; font-weight: 800; color: var(--text-main); margin-top: 4px;">28,490 Transfers</h3>
          <span style="font-size: 0.725rem; color: var(--primary); font-weight: 600;">£4,892,450.00</span>
        </div>
        <div class="card" style="padding: 16px;">
          <span style="font-size: 0.775rem; color: var(--text-muted); font-weight: 600;">Success Rate</span>
          <h3 style="font-size: 1.35rem; font-weight: 800; color: #00D084; margin-top: 4px;">99.42%</h3>
          <span style="font-size: 0.725rem; color: var(--text-muted);">28,325 Completed</span>
        </div>
        <div class="card" style="padding: 16px;">
          <span style="font-size: 0.775rem; color: var(--text-muted); font-weight: 600;">In Settlement Queue</span>
          <h3 style="font-size: 1.35rem; font-weight: 800; color: #F59E0B; margin-top: 4px;">142 Transfers</h3>
          <span style="font-size: 0.725rem; color: var(--text-muted);">£28,940.00 in-flight</span>
        </div>
        <div class="card" style="padding: 16px;">
          <span style="font-size: 0.775rem; color: var(--text-muted); font-weight: 600;">Compliance Review</span>
          <h3 style="font-size: 1.35rem; font-weight: 800; color: #EF4444; margin-top: 4px;">23 Held</h3>
          <span style="font-size: 0.725rem; color: var(--text-muted);">Requires AML sign-off</span>
        </div>
      </div>

      <!-- Transactions Table Card -->
      <div class="card">
        <div class="card-header table-card-header">
          <div class="table-header-left">
            <h3 class="card-title">Transaction Registry</h3>
            <span class="badge badge-info badge-pill">{{ filtered().length }} Records</span>
          </div>

          <div class="table-header-right">
            <div class="search-input-wrap">
              <i class="fa-solid fa-magnifying-glass search-icon"></i>
              <input type="text" placeholder="Search ID, sender, recipient..." [(ngModel)]="searchQuery" class="table-search-input">
            </div>

            <div class="status-filters">
              @for (st of ['All', 'Completed', 'Processing', 'Held']; track st) {
                <button class="filter-pill-btn" [class.active]="selectedStatus === st" (click)="selectedStatus = st">
                  {{ st }}
                </button>
              }
            </div>
          </div>
        </div>

        <div class="table-responsive">
          <table class="xintra-table">
            <thead>
              <tr>
                <th>REF ID</th>
                <th>SENDER</th>
                <th>RECIPIENT & BANK</th>
                <th>CORRIDOR</th>
                <th>AMOUNT SENT</th>
                <th>PAYOUT</th>
                <th>CLEARING RAIL</th>
                <th>STATUS</th>
                <th>DATE & TIME</th>
                <th class="text-right">ACTIONS</th>
              </tr>
            </thead>
            <tbody>
              @for (t of filtered(); track t.id) {
                <tr>
                  <td><span style="font-family: monospace; font-weight: 700; color: var(--primary);">{{ t.id }}</span></td>
                  <td>
                    <div style="display: flex; flex-direction: column;">
                      <strong style="color: var(--text-main);">{{ t.sender }}</strong>
                      <span style="font-size: 0.725rem; color: var(--text-muted);">{{ t.senderLocation }}</span>
                    </div>
                  </td>
                  <td>
                    <div style="display: flex; flex-direction: column;">
                      <strong style="color: var(--text-main);">{{ t.recipient }}</strong>
                      <span style="font-size: 0.725rem; color: var(--text-muted);">{{ t.bank }}</span>
                    </div>
                  </td>
                  <td><span class="badge badge-info">{{ t.corridor }}</span></td>
                  <td><strong style="color: var(--text-main);">{{ t.sendAmount }}</strong></td>
                  <td><strong style="color: #00D084;">{{ t.payoutAmount }}</strong></td>
                  <td><span style="font-size: 0.75rem; color: var(--text-muted);"><i class="fa-solid fa-network-wired"></i> {{ t.rail }}</span></td>
                  <td>
                    <span class="badge badge-pill" 
                      [class.badge-success]="t.status === 'Completed'"
                      [class.badge-warning]="t.status === 'Processing'"
                      [class.badge-danger]="t.status === 'Held'">
                      {{ t.status }}
                    </span>
                  </td>
                  <td style="font-size: 0.75rem; color: var(--text-muted);">{{ t.date }}</td>
                  <td class="text-right">
                    <button class="btn btn-outline" style="padding: 4px 8px; font-size: 0.75rem;"><i class="fa-solid fa-eye"></i></button>
                  </td>
                </tr>
              }
            </tbody>
          </table>
        </div>

        <div class="table-footer">
          <span class="footer-summary">Showing <strong>1 to {{ filtered().length }}</strong> of <strong>28,490</strong> transfers</span>
          <div class="pagination-controls">
            <button class="page-nav-btn disabled" disabled>Previous</button>
            <button class="page-num-btn active">1</button>
            <button class="page-num-btn">2</button>
            <button class="page-num-btn">3</button>
            <button class="page-nav-btn">Next</button>
          </div>
        </div>
      </div>
    </div>
  `
})
export class TransactionsComponent {
  searchQuery = '';
  selectedStatus = 'All';

  readonly items = [
    { id: '#TRX-9941', sender: 'Babatunde Adeyemi', senderLocation: 'London, UK', recipient: 'Funmilayo Adeyemi', bank: 'Zenith Bank •••• 9921', corridor: 'GBP ➔ NGN', sendAmount: '£750.00', payoutAmount: '₦1,375,500.00', rail: 'NIBSS Instant', status: 'Completed', date: 'Today, 06:14' },
    { id: '#TRX-9940', sender: 'Kofi Mensah', senderLocation: 'Manchester, UK', recipient: 'Abena Mensah', bank: 'MTN Mobile Money •••• 4120', corridor: 'GBP ➔ GHS', sendAmount: '£300.00', payoutAmount: 'GH₵4,980.00', rail: 'MTN MoMo Rail', status: 'Completed', date: 'Today, 05:58' },
    { id: '#TRX-9939', sender: 'Wanjiku Mwangi', senderLocation: 'Birmingham, UK', recipient: 'Kamau Mwangi', bank: 'M-Pesa Kenya •••• 8819', corridor: 'GBP ➔ KES', sendAmount: '£450.00', payoutAmount: 'KSh 75,780.00', rail: 'Safaricom Direct', status: 'Completed', date: 'Today, 05:42' },
    { id: '#TRX-9938', sender: 'Chukwuma Obi', senderLocation: 'Dublin, Ireland', recipient: 'Ngozi Obi', bank: 'Access Bank •••• 3341', corridor: 'EUR ➔ NGN', sendAmount: '€500.00', payoutAmount: '₦792,500.00', rail: 'NIBSS Instant', status: 'Processing', date: 'Today, 05:25' },
    { id: '#TRX-9937', sender: 'Olusegun Adeleke', senderLocation: 'Leeds, UK', recipient: 'Folake Adeleke', bank: 'GTBank Plc •••• 1109', corridor: 'GBP ➔ NGN', sendAmount: '£1,500.00', payoutAmount: '₦2,751,000.00', rail: 'NIBSS Instant', status: 'Completed', date: 'Today, 04:50' },
    { id: '#TRX-9936', sender: 'Thabo Mbeki', senderLocation: 'London, UK', recipient: 'Zola Mbeki', bank: 'Standard Bank •••• 6620', corridor: 'GBP ➔ ZAR', sendAmount: '£900.00', payoutAmount: 'R 21,330.00', rail: 'BankServAfrica', status: 'Held', date: 'Today, 04:12' },
    { id: '#TRX-9935', sender: 'Aisha Lawal', senderLocation: 'Edinburgh, UK', recipient: 'Musa Lawal', bank: 'First Bank of Nigeria •••• 4402', corridor: 'GBP ➔ NGN', sendAmount: '£250.00', payoutAmount: '₦458,500.00', rail: 'NIBSS Instant', status: 'Completed', date: 'Today, 03:40' }
  ];

  filtered() {
    return this.items.filter(item => {
      const matchSt = this.selectedStatus === 'All' || item.status === this.selectedStatus;
      const q = this.searchQuery.toLowerCase().trim();
      const matchQ = !q || item.id.toLowerCase().includes(q) || item.sender.toLowerCase().includes(q) || item.recipient.toLowerCase().includes(q);
      return matchSt && matchQ;
    });
  }
}
